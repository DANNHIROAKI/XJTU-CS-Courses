/*
 *  Internal data structure to store the information of an
 *  opened shared library. A simulation of glibc's link_map.
 *  Refer to include/link.h for a more comprehensive implementation.
 */
#ifndef _LINKMAP_H
#define _LINKMAP_H 1

#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <elf.h>

#include "../util/shim.h"

/* Prevent unreadable *_NEW, instead we redefine it to fit in array */
#define OS_SPECIFIC_FLAG 2
#define DT_RELACOUNT_ 0x6ffffff9
#define DT_GNU_HASH_  0x6ffffef5
#undef DT_RELACOUNT
#undef DT_GNU_HASH
#define DT_RELACOUNT (DT_NUM)
#define DT_GNU_HASH (DT_NUM + 1)

/* DO NOT MODIFY ANYTHING ABOVE */

typedef struct linkMap
{
    // base address of the library
    uint64_t addr;
    // name of the library
    const char *name;
    // absolute address of dynamic segment
    Elf64_Dyn *dyn;
    // a copy of dynamic segement, leave it alone
    Elf64_Dyn *dynInfo[DT_NUM + OS_SPECIFIC_FLAG];
    // if we need the original dlopen to correctly handle this library
    int fake;
    void *fakeHandle;

    // elements used by ELF's bloom filter
    // if you are interested in how glibc search symbols, check:
    // https://blogs.oracle.com/solaris/post/gnu-hash-elf-sections
    uint32_t l_nbuckets;
    Elf32_Word l_gnu_bitmask_idxbits;
    Elf32_Word l_gnu_shift;
    const Elf64_Addr *l_gnu_bitmask;
    const Elf32_Word *l_gnu_buckets;
    const Elf32_Word *l_gnu_chain_zero;

    /* Do not modify anything above */
    /* Your code here */
    size_t depcnt;
    struct linkMap **dep;
} LinkMap;

#endif /* Link.h */