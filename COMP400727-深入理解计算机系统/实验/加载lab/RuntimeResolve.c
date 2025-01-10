#include <elf.h>
#include <stdlib.h>
#include <stdio.h>

#include "Link.h"
#include "LoaderInternal.h"

Elf64_Addr __attribute__((visibility ("hidden"))) 
runtimeResolve(LinkMap *linkMapLibrary, Elf64_Word relocationEntry)
{
    printf("Resolving address for entry %u\n", relocationEntry);

    typedef struct {
        Elf64_Sym *symbolTable;
        Elf64_Rela *functionRelocation;
        int relocationSize;
        char *stringTable;
        Elf64_Addr *globalOffsetTable;
    } RuntimeResolveData;

    RuntimeResolveData *runtimeResolveData = (RuntimeResolveData*)malloc(sizeof(RuntimeResolveData));
    runtimeResolveData->symbolTable = NULL;
    runtimeResolveData->functionRelocation = NULL;
    runtimeResolveData->relocationSize = 0;
    runtimeResolveData->stringTable = NULL;
    runtimeResolveData->globalOffsetTable = NULL;

    int typeArray[] = {DT_SYMTAB, DT_JMPREL, DT_PLTRELSZ, DT_STRTAB};
    for (int i=0; i<4; ++i) {
        switch (typeArray[i]) {
            case DT_SYMTAB:
                runtimeResolveData->symbolTable = (typeof(runtimeResolveData->symbolTable))linkMapLibrary->dynInfo[DT_SYMTAB]->d_un.d_ptr;
                break;
            case DT_JMPREL:
                runtimeResolveData->functionRelocation = (typeof(runtimeResolveData->functionRelocation))linkMapLibrary->dynInfo[DT_JMPREL]->d_un.d_ptr;
                runtimeResolveData->functionRelocation += relocationEntry;
                break;
            case DT_PLTRELSZ:
                runtimeResolveData->relocationSize = linkMapLibrary->dynInfo[DT_PLTRELSZ]->d_un.d_val/sizeof(Elf64_Rela);
                break;
            case DT_STRTAB:
                runtimeResolveData->stringTable = (char*)linkMapLibrary->dynInfo[DT_STRTAB]->d_un.d_ptr;
                break;
        }
    }

    runtimeResolveData->globalOffsetTable = (void*)(linkMapLibrary->addr + runtimeResolveData->functionRelocation->r_offset);

    int counter = 0;
    while (counter < linkMapLibrary->depcnt) {
        uint64_t temporaryResult = (uint64_t)symbolLookup(linkMapLibrary->dep[counter],runtimeResolveData->stringTable + runtimeResolveData->symbolTable[runtimeResolveData->functionRelocation->r_info>>32].st_name);
        if (temporaryResult != 0) {
            *(runtimeResolveData->globalOffsetTable) = temporaryResult + runtimeResolveData->functionRelocation->r_addend;
            break;
        }
        counter++;
    }

    Elf64_Addr returnAddress = *(runtimeResolveData->globalOffsetTable);
    free(runtimeResolveData);
    return returnAddress;
}
