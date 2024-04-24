/* DO NOT MODIFY */
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "Loader.h"
#include "LoaderInternal.h"

void *OpenLibrary(const char *libpath, int mode)
{
    LinkMap *new = MapLibrary(libpath);

    RelocLibrary(new, mode);

    InitLibrary(new);

    return new;
}
