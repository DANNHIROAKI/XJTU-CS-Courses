/*
 *  Private header for functions to be shared among modules
 */
#ifndef _LOADER_PRI_H
#define _LOADER_PRI_H

#include "Link.h"

void *MapLibrary(const char *name);
void RelocLibrary(LinkMap *l, int mode);
void InitLibrary(LinkMap *l);
void *symbolLookup(LinkMap *dep, const char *name);
void trampoline(void);

#endif /* LoaderInternal.h */