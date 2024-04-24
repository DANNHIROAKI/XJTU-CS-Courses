#include <dlfcn.h> //turn to dlsym for help at fake load object
#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <elf.h>
#include <link.h>
#include <string.h>

#include "Link.h"

// glibc version to hash a symbol
static uint_fast32_t
dl_new_hash(const char *s)
{
    uint_fast32_t h = 5381;
    for (unsigned char c = *s; c != '\0'; c = *++s)
        h = h * 33 + c;
    return h & 0xffffffff;
}

// find symbol `name` inside the symbol table of `dep`
void *symbolLookup(LinkMap *dep, const char *name)
{
   // fprintf(stderr,"trying to look symbol %s in %s\n", name, dep->name);
    if(dep->fake)
    {
        if(dep->fakeHandle!=(void*)-1)
            return dlsym(dep->fakeHandle,name);
        void *handle = dlopen(dep->name, RTLD_LAZY);
        if(!handle)
        {
            fprintf(stderr, "relocLibrary error: cannot dlopen a fake object named %s", dep->name);
            abort();
        }
        dep->fakeHandle = handle;
        return dlsym(handle, name);
    }

    Elf64_Sym *symtab = (Elf64_Sym *)dep->dynInfo[DT_SYMTAB]->d_un.d_ptr;
    const char *strtab = (const char *)dep->dynInfo[DT_STRTAB]->d_un.d_ptr;

    uint_fast32_t new_hash = dl_new_hash(name);
    Elf64_Sym *sym;
    const Elf64_Addr *bitmask = dep->l_gnu_bitmask;
    uint32_t symidx;
    Elf64_Addr bitmask_word = bitmask[(new_hash / __ELF_NATIVE_CLASS) & dep->l_gnu_bitmask_idxbits];
    unsigned int hashbit1 = new_hash & (__ELF_NATIVE_CLASS - 1);
    unsigned int hashbit2 = ((new_hash >> dep->l_gnu_shift) & (__ELF_NATIVE_CLASS - 1));
    if ((bitmask_word >> hashbit1) & (bitmask_word >> hashbit2) & 1)
    {
        Elf32_Word bucket = dep->l_gnu_buckets[new_hash % dep->l_nbuckets];
        if (bucket != 0)
        {
            const Elf32_Word *hasharr = &dep->l_gnu_chain_zero[bucket];
            do
            {
                if (((*hasharr ^ new_hash) >> 1) == 0)
                {
                    symidx = hasharr - dep->l_gnu_chain_zero;
                    /* now, symtab[symidx] is the current symbol.
                       Hash table has done its job */
                    const char *symname = strtab + symtab[symidx].st_name;
                    if (!strcmp(symname, name))
                    {    
                        Elf64_Sym *s = &symtab[symidx];
                        // return the real address of found symbol
                        return (void *)(s->st_value + dep->addr);
                    }
                }
            } while ((*hasharr++ & 1u) == 0);
        }
    }
    return NULL; //not this dependency
}




extern void trampoline(void);

void* lookupAndFindResult(LinkMap* lib, char* str, Elf64_Rela* frel, Elf64_Sym* sym) {
    void* found = NULL;
    for (int dependencyIndex = 0; dependencyIndex < lib->depcnt && !found; ++dependencyIndex) {
        void* tmp = symbolLookup(lib->dep[dependencyIndex], &str[sym[ELF64_R_SYM(frel->r_info)].st_name]);
        switch (tmp != NULL) {
            case 1:
                found = tmp + frel->r_addend;
                break;
            default:
                break;
        }
    }
    return found;
}


extern void trampoline(void);

void RelocLibrary(LinkMap *lib, int mode)
{
    if(strcmp(lib->name,"lib.so.6")==0)
        return;
    int dependencyCounter = 0;
    while(dependencyCounter < lib->depcnt){
        RelocLibrary(lib->dep[dependencyCounter], mode);
        ++dependencyCounter;
    }

    Elf64_Sym* symbolTable = lib->dynInfo[DT_SYMTAB] 
                     ? (typeof(symbolTable))lib->dynInfo[DT_SYMTAB]->d_un.d_ptr 
                     : NULL;

    Elf64_Rela* functionRelocation = lib->dynInfo[DT_JMPREL] 
                       ? (typeof(functionRelocation))lib->dynInfo[DT_JMPREL]->d_un.d_ptr 
                       : NULL;

    int relocationSize = lib->dynInfo[DT_PLTRELSZ] 
                 ? lib->dynInfo[DT_PLTRELSZ]->d_un.d_val / sizeof(Elf64_Rela) 
                 : 0;

    char* stringTable = lib->dynInfo[DT_STRTAB] 
                 ? (char*)lib->dynInfo[DT_STRTAB]->d_un.d_ptr 
                 : NULL;
                 
    int relocationCounter = 0;
    while(relocationCounter<relocationSize){
        if(ELF64_R_TYPE(functionRelocation->r_info)!=R_X86_64_JUMP_SLOT){
            ++relocationCounter;
            ++functionRelocation;
            continue;
        }
        Elf64_Addr *globalOffsetTable=(void*)(lib->addr+functionRelocation->r_offset);
        if(mode == RTLD_LAZY){
            *globalOffsetTable += lib->addr;
            ++relocationCounter;
            ++functionRelocation;
            continue;
        }
        void *result = lookupAndFindResult(lib, stringTable, functionRelocation, symbolTable);
        if(result == NULL){
            fprintf(stderr,"symbol not found");
            abort();
        }
        uint64_t* temporaryAddress = (uint64_t*)(lib->addr + functionRelocation->r_offset);
        *temporaryAddress = (uint64_t)result;
        ++relocationCounter;
        ++functionRelocation;
    }
   
    uint64_t* globalOffsetTable = NULL;
    int globalOffsetTableStatus = 0; // 0: uninitialized, 1: initialized but NULL, 2: initialized and not NULL

    if (lib->dynInfo[DT_PLTGOT]) {
        globalOffsetTable = (typeof(globalOffsetTable))lib->dynInfo[DT_PLTGOT]->d_un.d_ptr;
        globalOffsetTableStatus = globalOffsetTable ? 2 : 1;
    }

    switch(globalOffsetTableStatus) {
        case 2:
            globalOffsetTable[1] = (uint64_t)lib;
            globalOffsetTable[2] = (uint64_t)&trampoline;
            break;
        case 1:
            // Handle the case where globalOffsetTable is NULL but was attempted to be initialized, if needed.
            break;
        case 0:
        default:
            // Handle the case where globalOffsetTable was not attempted to be initialized, if needed.
            break;
    }
}
