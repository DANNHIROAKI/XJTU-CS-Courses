#include "halfedge.h"

#include <iostream>
#include <set>
#include <map>
#include <vector>
#include <string>

#include <Eigen/Core>
#include <Eigen/Dense>
#include <spdlog/spdlog.h>

using Eigen::Matrix3f;
using Eigen::Matrix4f;
using Eigen::Vector3f;
using Eigen::Vector4f;
using std::optional;
using std::set;
using std::size_t;
using std::string;
using std::unordered_map;
using std::vector;

HalfedgeMesh::EdgeRecord::EdgeRecord(unordered_map<Vertex*, Matrix4f>& vertex_quadrics, Edge* e)
    : edge(e)
{
    (void)vertex_quadrics;
    optimal_pos = Vector3f(0.0f, 0.0f, 0.0f);
    cost        = 0.0f;
}

bool operator<(const HalfedgeMesh::EdgeRecord& a, const HalfedgeMesh::EdgeRecord& b)
{
    return a.cost < b.cost;
}

optional<Edge*> HalfedgeMesh::flip_edge(Edge* e) {
    if (!e || e->on_boundary()) {
        return std::nullopt; // 不能翻转边界上的边
    }

    Halfedge* halfedges[6] = { e->halfedge, e->halfedge->inv, nullptr, nullptr, nullptr, nullptr };
    halfedges[2] = halfedges[0]->next;
    halfedges[3] = halfedges[2]->next;
    halfedges[4] = halfedges[1]->next;
    halfedges[5] = halfedges[4]->next;

    Vertex* vertices[4] = { halfedges[0]->from, halfedges[1]->from, halfedges[3]->from, halfedges[5]->from };

    Halfedge* newHalfedges[2] = { halfedges[0], halfedges[1] };
    Face* faces[2] = { newHalfedges[0]->face, newHalfedges[1]->face };

    // 更新新半边的连接关系
    newHalfedges[0]->next = halfedges[3];
    newHalfedges[0]->prev = halfedges[4];
    newHalfedges[0]->from = vertices[3];
    newHalfedges[0]->face = faces[0];

    newHalfedges[1]->next = halfedges[5];
    newHalfedges[1]->prev = halfedges[2];
    newHalfedges[1]->from = vertices[2];
    newHalfedges[1]->face = faces[1];

    // 更新其他半边和面片的连接关系
    halfedges[3]->prev = newHalfedges[0];
    halfedges[3]->next = halfedges[4];
    halfedges[3]->face = faces[0];

    halfedges[4]->prev = halfedges[3];
    halfedges[4]->next = newHalfedges[0];
    halfedges[4]->face = faces[0];

    halfedges[5]->prev = newHalfedges[1];
    halfedges[5]->next = halfedges[2];
    halfedges[5]->face = faces[1];

    halfedges[2]->prev = halfedges[5];
    halfedges[2]->next = newHalfedges[1];
    halfedges[2]->face = faces[1];

    // 更新顶点和面的半边指针
    for (int i = 0; i < 4; ++i) {
        vertices[i]->halfedge = halfedges[i + 1];
    }
    faces[0]->halfedge = newHalfedges[0];
    faces[1]->halfedge = newHalfedges[1];

    return e;
}

optional<Vertex*> HalfedgeMesh::split_edge(Edge* e) {
    if (!e) {
        spdlog::info("[split_edge] Error: Edge is null.");
        return std::nullopt;
    }
    
    //Halfedge*      h_1_2,h_2_1,h_2_3,h_3_1,h_1_4,h_4_2,h_1_n,h_2_n,h_n_3,h_3_n,h_n_2,h_n_1,h_n_4,h_4_n;
    //Halfedge* h[]={h_1_2,h_2_1,h_2_3,h_3_1,h_1_4,h_4_2,h_1_n,h_2_n,h_n_3,h_3_n,h_n_2,h_n_1,h_n_4,h_4_n};
    Halfedge* h[15];
    h[0] = e->halfedge;
    h[1] = h[0]->inv;
    h[2] = h[0]->next;
    h[3] = h[2]->next;
    h[4] = h[1]->next;
    h[5] = h[4]->next;
    h[6] = h[0];
    h[7] = h[1];
    for(int i=8;i<=13;i++)
    {
        h[i] = new_halfedge();
    }


    //Vertex*       v1,v2,v3,v4;
    //Vertex* v[4]={v1,v2,v3,v4};
    Vertex* v[4];
    v[0]=h[0]->from;
    for(int i=1;i<=3;i++)
    {
        v[i]=h[2*i-1]->from;
    }

    //Face*       f1_n_3,f2_n_4,fn_2_3,fn_1_4;
    //Face* f[4]={f1_n_3,f2_n_4,fn_2_3,fn_1_4};
    Face* f[4];
    f[0] = h[6]->face;
    f[1] = h[7]->face;
    f[2] = new_face();
    f[3] = new_face();

    //Edge*       e1,e2,e3,e4;
    //Edge* E[4]={e1,e2,e3,e4};
    Edge* E[4];
    E[0] = e;
    for(int i=1;i<=3;i++)
    {
        E[i]=new_edge();
    }

    Vertex* vnew = new_vertex();

    h[3]->set_neighbors(h[6],h[8],h[3]->inv,v[2],h[3]->edge,f[0]);
    h[2]->set_neighbors(h[9],h[10],h[2]->inv,v[1],h[2]->edge,f[2]);
    h[4]->set_neighbors(h[13],h[11],h[4]->inv,v[0],h[4]->edge,f[3]);
    h[5]->set_neighbors(h[7],h[12],h[5]->inv,v[3],h[5]->edge,f[1]);

    h[6]->set_neighbors(h[8],h[3],h[11],v[0],E[0],f[0]);
    h[11]->set_neighbors(h[4],h[13],h[6],vnew,E[0],f[3]);

    h[8]->set_neighbors(h[3],h[6],h[9],vnew,E[1],f[0]);
    h[9]->set_neighbors(h[10],h[2],h[8],v[2],E[1],f[2]);

    h[10]->set_neighbors(h[2],h[9],h[7],vnew,E[2],f[2]);
    h[7]->set_neighbors(h[12],h[5],h[10],v[1],E[2],f[1]);

    h[13]->set_neighbors(h[11],h[4],h[12],v[3],E[3],f[3]);
    h[12]->set_neighbors(h[5],h[7],h[13],vnew,E[3],f[1]);

    v[0]->halfedge = h[6];
    v[1]->halfedge = h[7];
    v[2]->halfedge = h[9];
    v[3]->halfedge = h[13];
    vnew->halfedge = h[8];
    vnew->pos = vnew->neighborhood_center();
    vnew->is_new = true;

    f[0]->halfedge = h[6];
    f[2]->halfedge = h[9];
    f[3]->halfedge = h[13];
    f[1]->halfedge = h[12];

    E[0]->halfedge = h[6];
    E[1]->halfedge = h[9];
    E[2]->halfedge = h[7];
    E[3]->halfedge = h[13];

    std::cout<<vnew->id<<std::endl;

    return vnew;
}

optional<Vertex*> HalfedgeMesh::collapse_edge(Edge* e)
{
    if (!e) {
        return std::nullopt;
    }

    //Halfedge*      h_1_2,h_2_1,h_2_3,h_3_1,h_1_4,h_4_2,h_1_n,h_2_n,h_n_3,h_3_n,h_n_2,h_n_1,h_n_4,h_4_n,h_1_3,h_3_2,h_4_1,h_2_4;
    //Halfedge* h[]={h_1_2,h_2_1,h_2_3,h_3_1,h_1_4,h_4_2,h_1_n,h_2_n,h_n_3,h_3_n,h_n_2,h_n_1,h_n_4,h_4_n,h_1_3,h_3_2,h_4_1,h_2_4};
    Halfedge* h[20];
    h[0] = e->halfedge;
    h[1] = h[0]->inv;
    h[2] = h[0]->next;
    h[3] = h[2]->next;
    h[4] = h[1]->next;
    h[5] = h[4]->next;
    h[14] = h[3]->inv;
    h[15] = h[2]->inv;
    h[16] = h[4]->inv;
    h[17] = h[5]->inv;
    h[14]->inv = h[15];
    h[15]->inv = h[14];
    h[16]->inv = h[17];
    h[17]->inv = h[16];

    //Vertex*       v1,v2,v3,v4;
    //Vertex* v[4]={v1,v2,v3,v4};
    Vertex* v[4];
    v[0] = h[0]->from;
    v[1] = h[1]->from;
    v[2] = h[3]->from;
    v[3] = h[5]->from;

    //Face*       f1,f2;
    //Face* F[2]={f1,f2};
    Face* F[2];
    F[0] = h[0]->face;
    F[1] = h[1]->face;

    //Edge*        e1_3,e3_2,e4_1,e2_4;
    //Edge* ee[4]={e1_3,e3_2,e4_1,e2_4};
    Edge* ee[4];
    for(int i=0;i<=3;i++)
    {
        ee[i] = h[i+14]->edge;
    }


    Halfedge* H = v[1]->halfedge;
    do {
        //Vertex* neighbor = h->inv->from;
        H->from = v[0];
        H = H->inv->next;
        //std::cout<<1<<endl;
    } while (H != v[1]->halfedge);

    h[15]->edge = ee[0];
    h[16]->edge = ee[3];

    v[0]->halfedge = h[14];
    v[2]->halfedge = h[15];
    v[3]->halfedge = h[16];

    v[0]->pos = v[0]->neighborhood_center();
    v[2]->pos = v[2]->neighborhood_center();
    v[3]->pos = v[3]->neighborhood_center();

    for(int i=0;i<=5;i++)
    {
        erase(h[i]);
    }

    erase(e);
    for(int i=0;i<=1;i++)
    {
        erase(F[i]);
        erase(ee[i]);
    }
    
    erase(v[1]);

    return v[0];
}





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







void HalfedgeMesh::simplify()
{
    optional<HalfedgeMeshFailure> check_result = validate();
    if (check_result.has_value()) {
        return;
    }
    logger->info("simplify object {} (ID: {})", object.name, object.id);
    logger->info("original mesh: {} vertices, {} faces", vertices.size, faces.size);
    unordered_map<Vertex*, Matrix4f> vertex_quadrics;
    unordered_map<Face*, Matrix4f> face_quadrics;
    unordered_map<Edge*, EdgeRecord> edge_records;
    set<EdgeRecord> edge_queue;

    // Compute initial quadrics for each face by simply writing the plane equation
    // for the face in homogeneous coordinates. These quadrics should be stored
    // in face_quadrics

    // -> Compute an initial quadric for each vertex as the sum of the quadrics
    //    associated with the incident faces, storing it in vertex_quadrics

    // -> Build a priority queue of edges according to their quadric error cost,
    //    i.e., by building an Edge_Record for each edge and sticking it in the
    //    queue. You may want to use the above PQueue<Edge_Record> for this.

    // -> Until we reach the target edge budget, collapse the best edge. Remember
    //    to remove from the queue any edge that touches the collapsing edge
    //    BEFORE it gets collapsed, and add back into the queue any edge touching
    //    the collapsed vertex AFTER it's been collapsed. Also remember to assign
    //    a quadric to the collapsed vertex, and to pop the collapsed edge off the
    //    top of the queue.

    logger->info("simplified mesh: {} vertices, {} faces", vertices.size, faces.size);
    logger->info("simplification done\n");
    global_inconsistent = true;
    validate();
}

void HalfedgeMesh::isotropic_remesh()
{
    optional<HalfedgeMeshFailure> check_result = validate();
    if (check_result.has_value()) {
        return;
    }
    logger->info("remesh the object {} (ID: {}) with strategy Isotropic Remeshing", object.name,
                 object.id);
    logger->info("original mesh: {} vertices, {} faces", vertices.size, faces.size);
    // Compute the mean edge length.

    // Repeat the four main steps for 5 or 6 iterations
    // -> Split edges much longer than the target length (being careful about
    //    how the loop is written!)
    // -> Collapse edges much shorter than the target length.  Here we need to
    //    be EXTRA careful about advancing the loop, because many edges may have
    //    been destroyed by a collapse (which ones?)
    // -> Now flip each edge if it improves vertex degree
    // -> Finally, apply some tangential smoothing to the vertex positions
    static const size_t iteration_limit = 5;
    set<Edge*> selected_edges;
    for (size_t i = 0; i != iteration_limit; ++i) {
        // Split long edges.

        // Collapse short edges.

        // Flip edges.

        // Vertex averaging.
    }
    logger->info("remeshed mesh: {} vertices, {} faces\n", vertices.size, faces.size);
    global_inconsistent = true;
    validate();
}
