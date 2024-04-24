#include <stdlib.h>
#include <stdio.h>
#include <elf.h>
#include <stdint.h>
#include <string.h>

#include "Link.h"
#include "LoaderInternal.h"

#include <stdlib.h>
#include <stdio.h>
#include <elf.h>
#include <stdint.h>

#include "Link.h"
#include "LoaderInternal.h"

typedef struct {
    Elf64_Dyn **dynamicInformation;
    Elf64_Rela *relocationEntries;
    int relocationCount;
    void (*initializer)();
    void (**initializerArray)();
    int initializerArraySize;
    char *stringTable;
    Elf64_Sym *symbolTable;
} DynamicData;

DynamicData* initializeDynamicData(LinkMap *linkMapPointer) {
    DynamicData *dynamicData = (DynamicData*)malloc(sizeof(DynamicData));

    dynamicData->dynamicInformation = linkMapPointer->dynInfo;
    dynamicData->relocationEntries = NULL;
    dynamicData->relocationCount = 0;
    dynamicData->initializer = NULL;
    dynamicData->initializerArray = NULL;
    dynamicData->initializerArraySize = 0;
    dynamicData->stringTable = NULL;
    dynamicData->symbolTable = NULL;

    return dynamicData;
}

void processRelocation(LinkMap *linkMapPointer, DynamicData *dynamicData) {
    int counter = 0;
    while (counter < dynamicData->relocationCount) {
        *(uint64_t*)(linkMapPointer->addr+(dynamicData->relocationEntries)->r_offset)=linkMapPointer->addr+(dynamicData->relocationEntries)->r_addend;
        counter++;
        (dynamicData->relocationEntries)++;
    }
}

void* symbolLookupWithDependencies(LinkMap *linkMapPointer, DynamicData *dynamicData) {
    void* symbolPointer = NULL;
    int dependencyCounter = 0;
    while (dependencyCounter < linkMapPointer->depcnt) {
        symbolPointer = symbolLookup(linkMapPointer->dep[dependencyCounter], dynamicData->stringTable + dynamicData->symbolTable[ELF64_R_SYM((dynamicData->relocationEntries)->r_info)].st_name);
        if (symbolPointer != NULL) {
            break;
        }
        dependencyCounter++;
    }
    return symbolPointer;
}

void processSymbols(LinkMap *linkMapPointer, DynamicData *dynamicData) {
    int symbolCounter = 0;
    int symbolsToProcess = dynamicData->dynamicInformation[DT_RELASZ]->d_un.d_val/dynamicData->dynamicInformation[DT_RELAENT]->d_un.d_val - dynamicData->relocationCount;
    while (symbolCounter < symbolsToProcess) {
        if(ELF64_ST_BIND(dynamicData->symbolTable[ELF64_R_SYM((dynamicData->relocationEntries)->r_info)].st_info) == STB_WEAK) {
            symbolCounter++;
            (dynamicData->relocationEntries)++;
            continue;
        }

        void *symbolPointer = symbolLookupWithDependencies(linkMapPointer, dynamicData);

        if (symbolPointer == NULL) {
            symbolPointer = symbolLookup(linkMapPointer, dynamicData->stringTable + dynamicData->symbolTable[ELF64_R_SYM((dynamicData->relocationEntries)->r_info)].st_name);
        }
        *(uint64_t*)(linkMapPointer->addr+(dynamicData->relocationEntries)->r_offset) = (uint64_t)symbolPointer+(dynamicData->relocationEntries)->r_addend;        
        symbolCounter++;
        (dynamicData->relocationEntries)++;
    }
}

void InitLibrary(LinkMap *linkMapPointer)
{
    DynamicData *dynamicData = initializeDynamicData(linkMapPointer);
    int typeArray[] = {DT_RELA, DT_RELACOUNT, DT_INIT, DT_INIT_ARRAY, DT_INIT_ARRAYSZ, DT_STRTAB, DT_SYMTAB};
    for (int i=0; i<7; ++i) {
        switch (typeArray[i]) {
            case DT_RELA:
                if(dynamicData->dynamicInformation[DT_RELA])
                    dynamicData->relocationEntries=(Elf64_Rela*)dynamicData->dynamicInformation[DT_RELA]->d_un.d_ptr;
                break;
            case DT_RELACOUNT:
                if(dynamicData->dynamicInformation[DT_RELACOUNT])
                    dynamicData->relocationCount=dynamicData->dynamicInformation[DT_RELACOUNT]->d_un.d_val;
                break;
            case DT_INIT:
                if(dynamicData->dynamicInformation[DT_INIT])
                    dynamicData->initializer=(typeof(dynamicData->initializer))dynamicData->dynamicInformation[DT_INIT]->d_un.d_ptr;
                break;
            case DT_INIT_ARRAY:
                if(dynamicData->dynamicInformation[DT_INIT_ARRAY])
                    dynamicData->initializerArray=(typeof(dynamicData->initializerArray))dynamicData->dynamicInformation[DT_INIT_ARRAY]->d_un.d_ptr;
                break;
            case DT_INIT_ARRAYSZ:
                if(dynamicData->dynamicInformation[DT_INIT_ARRAYSZ])
                    dynamicData->initializerArraySize=dynamicData->dynamicInformation[DT_INIT_ARRAYSZ]->d_un.d_val/sizeof(void*);
                break;
            case DT_STRTAB:
                if(dynamicData->dynamicInformation[DT_STRTAB])
                    dynamicData->stringTable = (char*)dynamicData->dynamicInformation[DT_STRTAB]->d_un.d_ptr;
                break;
            case DT_SYMTAB:
                if(dynamicData->dynamicInformation[DT_SYMTAB])
                    dynamicData->symbolTable = (typeof(dynamicData->symbolTable))dynamicData->dynamicInformation[DT_SYMTAB]->d_un.d_ptr;
                break;
        }
    }

    processRelocation(linkMapPointer, dynamicData);
    
    if(dynamicData->dynamicInformation[DT_RELASZ]&&dynamicData->dynamicInformation[DT_RELAENT]) {
        processSymbols(linkMapPointer, dynamicData);
    }

    if(dynamicData->initializer) dynamicData->initializer();
    int i = 0;
    while (i<dynamicData->initializerArraySize) {
        dynamicData->initializerArray[i]();
        i++;
    }
    free(dynamicData); 
}
