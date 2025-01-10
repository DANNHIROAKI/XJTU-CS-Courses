#include "cachelab.h"
#include <unistd.h>
#include <getopt.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <limits.h>

typedef struct {
    int valid;
    int tag;
    int timestamp;
} CacheLine;

typedef struct {
    int set_count;
    int lines_per_set;
    int block_size;
    CacheLine** lines;
} Cache;

typedef struct {
    int hit_count;
    int miss_count;
    int eviction_count;
    int verbose;
    char trace_file[1000];
    Cache* cache;
} CacheSimulator;

void initialize_cache(CacheSimulator* sim, int set_bits, int lines_per_set, int block_bits);
void free_cache(CacheSimulator* sim);
void handle_cache_miss(CacheSimulator* sim, int tag, int set_index);
void increment_timestamp(CacheSimulator* sim, int set_index);
void free_cache_lines(CacheSimulator* sim);
void free_cache_components(CacheSimulator* sim);
int get_line_index(CacheSimulator* sim, int set_index, int tag);
int find_least_recently_used_line(CacheSimulator* sim, int set_index);
int find_empty_line(CacheSimulator* sim, int set_index);
void update_cache_line(CacheSimulator* sim, int line_index, int set_index, int tag);
void process_cache_operation(CacheSimulator* sim, int tag, int set_index);
void read_trace(CacheSimulator* sim, int set_bits, int lines_per_set, int block_bits);
void allocate_cache_lines(CacheSimulator* sim, int set_count, int lines_per_set);
void initialize_cache_lines(CacheSimulator* sim, int set_count, int lines_per_set);
void create_cache_object(CacheSimulator* sim, int set_count, int lines_per_set, int block_size);
void print_usage();
void print_help();
void handle_cache_hit(CacheSimulator* sim, int line_index, int set_index, int tag);
int main(int argc, char* argv[]);
/////////////////////////////////////////////////////


/////////////////////////////////////////////////////
void allocate_cache_lines(CacheSimulator* sim, int set_count, int lines_per_set) {
    sim->cache->lines = (CacheLine**)malloc(sizeof(CacheLine) * set_count);
    for (int i = 0; i < set_count; i++) {
        sim->cache->lines[i] = (CacheLine*)malloc(sizeof(CacheLine) * lines_per_set);
    }
}
void initialize_cache_lines(CacheSimulator* sim, int set_count, int lines_per_set) {
    for (int i = 0; i < set_count; i++) {
        for (int j = 0; j < lines_per_set; j++) {
            sim->cache->lines[i][j].valid = 0;
            sim->cache->lines[i][j].tag = -1;
            sim->cache->lines[i][j].timestamp = 0;
        }
    }
}
void create_cache_object(CacheSimulator* sim, int set_count, int lines_per_set, int block_size) {
    sim->cache = (Cache*)malloc(sizeof(Cache));
    sim->cache->set_count = set_count;
    sim->cache->lines_per_set = lines_per_set;
    sim->cache->block_size = block_size;
}
void initialize_cache(CacheSimulator* sim, int set_bits, int lines_per_set, int block_bits) {
    int set_count = 1 << set_bits;
    int block_size = 1 << block_bits;
    create_cache_object(sim, set_count, lines_per_set, block_size);
    allocate_cache_lines(sim, set_count, lines_per_set);
    initialize_cache_lines(sim, set_count, lines_per_set);
}
/////////////////////////////////////////////////////


/////////////////////////////////////////////////////
void free_cache_lines(CacheSimulator* sim) {
    int set_count = sim->cache->set_count;
    for (int i = 0; i < set_count; ++i) {
        if (sim->cache->lines[i]) {
            free(sim->cache->lines[i]);
            sim->cache->lines[i] = NULL;
        }
    }
}
void free_cache_components(CacheSimulator* sim) {
    if (sim->cache->lines) {
        free(sim->cache->lines);
        sim->cache->lines = NULL;
    }
    if (sim->cache) {
        free(sim->cache);
        sim->cache = NULL;
    }
}
void free_cache(CacheSimulator* sim) {
    free_cache_lines(sim);
    free_cache_components(sim);
}
/////////////////////////////////////////////////////


/////////////////////////////////////////////////////
int get_line_index(CacheSimulator* sim, int set_index, int tag) {
    CacheLine* current_line = NULL;
    int lines_per_set = sim->cache->lines_per_set;
    int i = 0;

    for (i = 0; i < lines_per_set; ++i) {
        current_line = &sim->cache->lines[set_index][i];

        if (current_line->valid && current_line->tag == tag) {
            break;
        }
    }
    return i == lines_per_set ? -1 : i;
}
/////////////////////////////////////////////////////


/////////////////////////////////////////////////////
int find_least_recently_used_line(CacheSimulator* sim, int set_index) {
    int lines_per_set = sim->cache->lines_per_set;
    int least_recently_used_line = 0;
    int max_timestamp = sim->cache->lines[set_index][0].timestamp;

    for (int i = 1; i < lines_per_set; ++i) {
        if (sim->cache->lines[set_index][i].timestamp > max_timestamp) {
            max_timestamp = sim->cache->lines[set_index][i].timestamp;
            least_recently_used_line = i;
        }
    }

    return least_recently_used_line;
}
/////////////////////////////////////////////////////


/////////////////////////////////////////////////////
int find_empty_line(CacheSimulator* sim, int set_index) {
    int i;
    CacheLine *line;
    for (i = 0, line = sim->cache->lines[set_index]; i < sim->cache->lines_per_set; ++i, ++line) {
        if (line->valid == 0) {
            return i;
        }
    }
    return -1;
}
/////////////////////////////////////////////////////


/////////////////////////////////////////////////////
void update_cache_line(CacheSimulator* sim, int line_index, int set_index, int tag) {
    CacheLine *line = &(sim->cache->lines[set_index][line_index]);
    line->valid = 1;
    line->tag = tag;
    for (CacheLine *p = sim->cache->lines[set_index], *end = sim->cache->lines[set_index] + sim->cache->lines_per_set; p != end; ++p) {
        if (p->valid == 1) {
            ++p->timestamp;
        }
    }
    line->timestamp = 0;
}
/////////////////////////////////////////////////////


/////////////////////////////////////////////////////
void increment_timestamp(CacheSimulator* sim, int set_index) {
    for (int i = 0; i < sim->cache->lines_per_set; i++) {
        if (sim->cache->lines[set_index][i].valid == 1)
            sim->cache->lines[set_index][i].timestamp++;
    }
}
void handle_cache_miss(CacheSimulator* sim, int tag, int set_index) {
    sim->miss_count++;
    if (sim->verbose)
        printf("miss ");
    int empty_line_index = find_empty_line(sim, set_index);
    if (empty_line_index == -1) {
        sim->eviction_count++;
        if (sim->verbose) printf("eviction");
        empty_line_index = find_least_recently_used_line(sim, set_index);
    }
    update_cache_line(sim, empty_line_index, set_index, tag);
}
void handle_cache_hit(CacheSimulator* sim, int line_index, int set_index, int tag) {
    sim->hit_count++;
    if (sim->verbose)
        printf("hit ");
    update_cache_line(sim, line_index, set_index, tag);
}
void process_cache_operation(CacheSimulator* sim, int tag, int set_index) {
    int line_index = get_line_index(sim, set_index, tag);
    if (line_index == -1) {
        handle_cache_miss(sim, tag, set_index);
    }
    else {
        handle_cache_hit(sim, line_index, set_index, tag);
    }
    increment_timestamp(sim, set_index);
}
/////////////////////////////////////////////////////


/////////////////////////////////////////////////////
void read_trace(CacheSimulator* sim, int set_bits, int lines_per_set, int block_bits) {
    FILE* trace_file;
    trace_file = fopen(sim->trace_file, "r");
    if (trace_file == NULL) {
        exit(-1);
    }
    char identifier;
    unsigned address;
    int size;
    while (fscanf(trace_file, " %c %x,%d", &identifier, &address, &size) > 0) {
        int set_1=0;
        int set_2=0;
        int set_3=0;
        set_1=set_bits + block_bits;
        int tag = address >> (set_1);
        set_2=address >> block_bits;
        set_3=8 * sizeof(unsigned) - set_bits;
        int set_index = (set_2) & ((unsigned)(-1) >> (set_3));
        if (identifier == 'M') {
            process_cache_operation(sim, tag, set_index);
            process_cache_operation(sim, tag, set_index);
        }
        else if (identifier == 'L') {
            process_cache_operation(sim, tag, set_index);
        }
        else if (identifier == 'S') {
            process_cache_operation(sim, tag, set_index);
        }
    }
    fclose(trace_file);
}

/////////////////////////////////////////////////////


/////////////////////////////////////////////////////
void print_help() {
    printf("Usage: ./csim-ref [-hv] -s <num> -E <num> -b <num> -t <file>\n");
    printf("Options:\n");
    printf("-h\tPrint this help message.\n");
    printf("-v\tOptional verbose flag.\n");
    printf("-s <num>\tNumber of set index bits.\n");
    printf("-E <num>\tNumber of lines per set.\n");
    printf("-b <num>\tNumber of block offset bits.\n");
    printf("-t <file>\tTrace file.\n\n");
    printf("Examples:\n");
    printf("linux> ./csim -s 4 -E 1 -b 4 -t traces/yi.trace\n");
    printf("linux> ./csim -v -s 8 -E 2 -b 4 -t traces/yi.trace\n");
}
void print_usage() {
    printf("** A Cache Simulator\n");
    print_help();
}
/////////////////////////////////////////////////////


/////////////////////////////////////////////////////
int main(int argc, char* argv[]) {
    int set_bits = 0, lines_per_set = 0, block_bits = 0;
    CacheSimulator sim;
    memset(&sim, 0, sizeof(CacheSimulator));
    int opt;
    char* optstring = "hvs:E:b:t:";
    while ((opt = getopt(argc, argv, optstring)) != -1) {
        if (opt == 'h') {
            print_usage();
            exit(0);
        } else if (opt == 'v') {
            sim.verbose = 1;
        } else if (opt == 's') {
            set_bits = atoi(optarg);
        } else if (opt == 'E') {
            lines_per_set = atoi(optarg);
        } else if (opt == 'b') {
            block_bits = atoi(optarg);
        } else if (opt == 't') {
            strcpy(sim.trace_file, optarg);
        } else {
            print_usage();
            exit(-1);
        }
    }
    initialize_cache(&sim, set_bits, lines_per_set, block_bits);
    read_trace(&sim, set_bits, lines_per_set, block_bits);
    free_cache(&sim);
    printSummary(sim.hit_count, sim.miss_count, sim.eviction_count);
    return 0;
}
/////////////////////////////////////////////////////