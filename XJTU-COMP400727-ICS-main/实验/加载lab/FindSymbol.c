#include <stdlib.h>
#include <elf.h>
#include <string.h>

#include "Link.h"
#include "Loader.h"
#include "LoaderInternal.h"

void *FindSymbol(void *library, const char *symname)
{
    return symbolLookup((LinkMap *)library, symname);
}
