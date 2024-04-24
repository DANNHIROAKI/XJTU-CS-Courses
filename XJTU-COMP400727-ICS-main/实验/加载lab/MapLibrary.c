#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include <elf.h>
#include <unistd.h> //for getpagesize
#include <sys/mman.h>
#include <fcntl.h>

#include "Link.h"
#include "LoaderInternal.h"

#define ALIGN_DOWN(base, size) ((base) & -((__typeof__(base))(size)))
#define ALIGN_UP(base, size) ALIGN_DOWN((base) + (size)-1, (size))

static const char *sys_path[] = {
    "/usr/lib/x86_64-linux-gnu/",
    "/lib/x86_64-linux-gnu/",
    ""
};

static const char *fake_so[] = {
    "libc.so.6",
    "ld-linux.so.2",
    ""
};

static void setup_hash(LinkMap *l)
{
    uint32_t *hash;

    /* borrowed from dl-lookup.c:_dl_setup_hash */
    Elf32_Word *hash32 = (Elf32_Word *)l->dynInfo[DT_GNU_HASH]->d_un.d_ptr;
    l->l_nbuckets = *hash32++;
    Elf32_Word symbias = *hash32++;
    Elf32_Word bitmask_nwords = *hash32++;

    l->l_gnu_bitmask_idxbits = bitmask_nwords - 1;
    l->l_gnu_shift = *hash32++;

    l->l_gnu_bitmask = (Elf64_Addr *)hash32;
    hash32 += 64 / 32 * bitmask_nwords;

    l->l_gnu_buckets = hash32;
    hash32 += l->l_nbuckets;
    l->l_gnu_chain_zero = hash32 - symbias;
}

static void fill_info(LinkMap *lib)
{
    Elf64_Dyn *dyn = lib->dyn;
    Elf64_Dyn **dyn_info = lib->dynInfo;

    while (dyn->d_tag != DT_NULL)
    {
        /*
        if(dyn->d_tag == DT_RELAENT){
            fprintf(stderr,"RELAENT : %d\n",dyn->d_un.d_val);
        }
        if(dyn->d_tag == DT_RELASZ){
            fprintf(stderr,"RELASZ : %d\n",dyn->d_un.d_val);
        }
        if(dyn->d_tag == DT_RELACOUNT_){
            fprintf(stderr,"RELACOUNT : %d\n",dyn->d_un.d_val);
        }
        */
        if ((Elf64_Xword)dyn->d_tag < DT_NUM)
            dyn_info[dyn->d_tag] = dyn;
        else if ((Elf64_Xword)dyn->d_tag == DT_RELACOUNT_)
            dyn_info[DT_RELACOUNT] = dyn;
        else if ((Elf64_Xword)dyn->d_tag == DT_GNU_HASH_)
            dyn_info[DT_GNU_HASH] = dyn;
        ++dyn;
    }
    #define rebase(tag)                             \
        do                                          \
        {                                           \
            if (dyn_info[tag])                          \
                dyn_info[tag]->d_un.d_ptr += lib->addr; \
        } while (0)
    rebase(DT_SYMTAB);
    rebase(DT_STRTAB);
    rebase(DT_RELA);
    rebase(DT_JMPREL);
    rebase(DT_GNU_HASH); //DT_GNU_HASH
    rebase(DT_PLTGOT);
    rebase(DT_INIT);
    rebase(DT_INIT_ARRAY);
}


Elf64_Phdr* LoadProgramHeader(int fileDescriptor, Elf64_Off offset) {
    Elf64_Phdr* currentProgramHeader = malloc(sizeof(Elf64_Phdr));
    pread(fileDescriptor, currentProgramHeader, sizeof(Elf64_Phdr), offset);
    return currentProgramHeader;
}

void DetermineLibraryPath(char* destinationPath, const char* libraryPath) {
    sprintf(destinationPath, libraryPath[0] == '.' ? "%s" : "./test_lib/%s", libraryPath);
}

int max(int numberA, int numberB) {
    return numberA > numberB ? numberA : numberB;
}

void* MapLibrary(const char* libraryPath) {
    LinkMap* libraryMap = calloc(1, sizeof(LinkMap));
    libraryMap->name = libraryPath;

    if (!strcmp(libraryPath, "libc.so.6")) {
        libraryMap->fake = 1;
        libraryMap->fakeHandle = (void*)-1;
        return libraryMap;
    }

    char trueLibraryPath[100];
    DetermineLibraryPath(trueLibraryPath, libraryPath);

    int fileDescriptor = open(trueLibraryPath, O_RDONLY);
    if (fileDescriptor < 0) {
        printf("Error in library opening: %s\n", libraryPath);
                exit(EXIT_FAILURE);
    }

    Elf64_Ehdr elfHeader;
    int headerSize=sizeof(Elf64_Ehdr);
    pread(fileDescriptor, &elfHeader, headerSize, 0);
    const int pageSize = getpagesize();

    int maxPageSize = 0;
    Elf64_Addr firstProgramHeaderAddress = 0;
    int programHeaderIndex = 0;

    while (programHeaderIndex < elfHeader.e_phnum) {
        Elf64_Phdr* currentProgramHeader = LoadProgramHeader(fileDescriptor, elfHeader.e_phoff + programHeaderIndex++ * sizeof(Elf64_Phdr));
        firstProgramHeaderAddress = (!programHeaderIndex) ? currentProgramHeader->p_vaddr : firstProgramHeaderAddress;
        size_t nextPage = (currentProgramHeader->p_type == PT_LOAD || currentProgramHeader->p_type == PT_DYNAMIC) ? ALIGN_UP(currentProgramHeader->p_vaddr - firstProgramHeaderAddress + currentProgramHeader->p_memsz - 1, pageSize) : 0;
        maxPageSize = max(nextPage, maxPageSize);
        free(currentProgramHeader);
    }

    if (firstProgramHeaderAddress != 0) {
        fprintf(stderr, "fir not 0\n");
        abort();
    }

    void* mappedAddress = NULL;
    int isFirstLoad = 1;
    programHeaderIndex = 0;

    while (programHeaderIndex < elfHeader.e_phnum) {
        Elf64_Phdr* currentProgramHeader = LoadProgramHeader(fileDescriptor, elfHeader.e_phoff + programHeaderIndex++ * sizeof(Elf64_Phdr));
        int protectionFlags = 0;
        if (currentProgramHeader->p_flags & PF_R) {
            protectionFlags |= PROT_READ;
        }
        if (currentProgramHeader->p_flags & PF_X) {
            protectionFlags |= PROT_EXEC;
        }
        if (currentProgramHeader->p_flags & PF_W) {
            protectionFlags |= PROT_WRITE;
        }
        int offsetDifference = currentProgramHeader->p_offset - ALIGN_DOWN(currentProgramHeader->p_offset, pageSize);

        int alignedOffset=ALIGN_DOWN(currentProgramHeader->p_offset, pageSize);
        int alignedMemorySize=ALIGN_UP(currentProgramHeader->p_memsz + offsetDifference, pageSize);
        void* nextMappedAddress=mappedAddress + currentProgramHeader->p_vaddr - firstProgramHeaderAddress - offsetDifference;
        switch (currentProgramHeader->p_type) {
        case PT_LOAD:
            switch (isFirstLoad) {
            case 1: {
                mappedAddress = mmap(NULL, maxPageSize, protectionFlags, MAP_PRIVATE, fileDescriptor, alignedOffset);
                libraryMap->addr = (uint64_t)mappedAddress + offsetDifference;
                isFirstLoad = 0;
                break;
            }
            case 0: {
                mmap(nextMappedAddress,alignedMemorySize,protectionFlags, MAP_PRIVATE | MAP_FIXED, fileDescriptor, alignedOffset);
                break;
            }
            }
            break;
        }

        free(currentProgramHeader);
    }

    programHeaderIndex = 0;
    while (programHeaderIndex < elfHeader.e_phnum) {
        Elf64_Phdr* currentProgramHeader = LoadProgramHeader(fileDescriptor, elfHeader.e_phoff + programHeaderIndex++ * sizeof(Elf64_Phdr));
        if (currentProgramHeader->p_type == PT_DYNAMIC) {
            libraryMap->dyn = mappedAddress + currentProgramHeader->p_vaddr - firstProgramHeaderAddress;
            break;
        }
        free(currentProgramHeader);
    }

    fill_info(libraryMap);
    setup_hash(libraryMap);
    char* stringTable = (char*)libraryMap->dynInfo[DT_STRTAB]->d_un.d_ptr;
    int dependencyCount = 0;
    Elf64_Dyn* dynamicSection = libraryMap->dyn;
    while (dynamicSection->d_tag != DT_NULL) {
        dependencyCount += (dynamicSection->d_tag == DT_NEEDED);
        dynamicSection++;
    }
    libraryMap->depcnt = dependencyCount;

    if (dependencyCount > 0) {
        libraryMap->dep = calloc(dependencyCount + 10, sizeof(LinkMap*));
    }

    dynamicSection = libraryMap->dyn;
    int currentDependency = 0;
    while (dynamicSection->d_tag != DT_NULL) {
        if (dynamicSection->d_tag == DT_NEEDED) {
            libraryMap->dep[currentDependency] = MapLibrary(stringTable + dynamicSection->d_un.d_val);
            currentDependency++;
        }
        dynamicSection++;
    }
    return libraryMap;
}
