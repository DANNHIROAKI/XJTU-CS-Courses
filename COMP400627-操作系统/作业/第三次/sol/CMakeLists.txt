cmake_minimum_required(VERSION 3.10)
project(BufferProcess)              

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED True)

include_directories(${CMAKE_CURRENT_SOURCE_DIR})

set(SOURCES 
    semaphore.c
    get_process.c
    copy_process.c
    put_process.c
    main.c
)

set(HEADERS 
    semaphore.h
)

add_executable(BufferProcess ${SOURCES} ${HEADERS})

