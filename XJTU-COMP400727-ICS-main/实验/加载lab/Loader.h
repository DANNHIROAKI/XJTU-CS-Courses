/*
 *  Public header for users to include
 */

#ifndef _LOADER_H
#define _LOADER_H

#define BIND_NOW 0
#define LAZY_BIND 1

// counterpart of dlopen
extern void *OpenLibrary(const char *name, int mode);
// counterpart of dlsym
extern void *FindSymbol(void *lib, const char *symname);

#endif /* Loader.h */
