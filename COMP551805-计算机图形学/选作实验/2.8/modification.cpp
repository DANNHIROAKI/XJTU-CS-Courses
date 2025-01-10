void HalfedgeMesh::loop_subdivide()
{
    optional<HalfedgeMeshFailure> check_result = validate();
    if (check_result.has_value()) {
        return;
    }
    logger->info("subdivide object {} (ID: {}) with Loop Subdivision strategy", object.name,
                 object.id);
    logger->info("original mesh: {} vertices, {} faces in total", vertices.size, faces.size);

    // Compute new positions for all the vertices in the input mesh
    Vertex* v = vertices.head;
    while (v != nullptr) {
        v->is_new = false;
        size_t n = v->degree();
        double u;
        if (n == 3) {
            u = 3.0 / 16.0;
        } else {
            u = 3.0 / 8.0 / double(n);
        }
        double u_ias = (1.0 - double(n) * u);
        auto pre_pos = u_ias * v->pos;
        auto delta_pos = u * n * v->neighborhood_center();
        v->new_pos = pre_pos + delta_pos;
        v = v->next_node;
    }

    // Next, compute the subdivided vertex positions associated with edges
    Edge* e = edges.head;
    while (e != nullptr) {
        e->is_new = false;

        // Calculate the contribution of the edge's center
        auto edgeCenterContribution = 3.0 / 8.0 * 2.0 * e->center();

        // Calculate the contribution of adjacent vertices separately
        auto adjacentVertex1Contribution = 1.0 / 8.0 * e->halfedge->next->next->from->pos;
        auto adjacentVertex2Contribution = 1.0 / 8.0 * e->halfedge->inv->next->next->from->pos;

        // Sum up contributions to get new position
        e->new_pos = edgeCenterContribution + adjacentVertex1Contribution + adjacentVertex2Contribution;

        e = e->next_node;
    }


    // Split every edge in the mesh
    size_t n = edges.size;
    e = edges.head;
    while (n) {
        Vertex* v = split_edge(e).value();
        v->new_pos = e->new_pos;
        e = e->next_node;
        --n;
    }

    // Flip any new edge that connects an old and new vertex
    e = edges.head;
    auto new_or_not = e->halfedge->from->is_new ^ e->halfedge->inv->from->is_new;
    while (e != nullptr) {
        if (e->is_new && new_or_not) {
            flip_edge(e);
        }
        e = e->next_node;
    }

    // Copy new vertex positions
    v = vertices.head;
    while (v != nullptr) {
        v->pos = v->new_pos;
        v = v->next_node;
    }

    global_inconsistent = true;
    logger->info("subdivided mesh: {} vertices, {} faces in total", vertices.size, faces.size);
    logger->info("Loop Subdivision done");
    logger->info("");
    validate();
}