cmake_minimum_required(VERSION 3.18)
#####################################################
# User Variables
#####################################################
set(TOOLCHAIN_YEAR "2020")
set(TOOLCHAIN_MONTH "10")
set(TOOLCHAIN_Q_NUMBER "4")

#####################################################
# Aquire Toolchain - DO NOT EDIT
#####################################################


#message("GCC Version: ${TOOLCHAIN_YEAR}-${TOOLCHAIN_MONTH}-${TOOLCHAIN_Q_NUMBER}")
set(TOOLCHAIN_TMP_DIR "${CMAKE_CURRENT_SOURCE_DIR}/toolchain")
set(TOOLCHAIN_ROOT "${TOOLCHAIN_TMP_DIR}/MinGWroot")

# set(TOOLCHAIN_TARGET_VERSION "${TOOLCHAIN_MONTH}-${TOOLCHAIN_YEAR}-q${TOOLCHAIN_Q_NUMBER}")
# set(TOOLCHAIN_TARGET_VERSION_LONG "${TOOLCHAIN_TARGET_VERSION}-major")

# if (WIN32)
#     set(TOOLCHAIN_OS_VERSION "win32")
#     set(TOOLCHAIN_ARCH_EXT "zip")
# elseif(LINUX)
#     set(TOOLCHAIN_ARCH_EXT "tar.bz2")
#     set(TOOLCHAIN_OS_VERSION "x86_64-linux")
# elseif(UNIX AND APPLE)
#     set(TOOLCHAIN_ARCH_EXT "tar.bz2")
#     set(TOOLCHAIN_OS_VERSION "mac")
# ENDIF()

if(NOT IS_DIRECTORY "${TOOLCHAIN_TMP_DIR}")
    file(MAKE_DIRECTORY ${TOOLCHAIN_TMP_DIR})
endif()

if(NOT IS_DIRECTORY "${TOOLCHAIN_ROOT}")
   #file(DOWNLOAD "https://downloads.sourceforge.net/project/mingw-w64/Toolchains%20targetting%20Win64/Personal%20Builds/mingw-builds/8.1.0/threads-win32/sjlj/x86_64-8.1.0-release-win32-sjlj-rt_v6-rev0.7z?ts=gAAAAABiYpAFEYMPnhLRvKUehJf97QdkVOU6d_y0f2yC7Xa8dDn3lEv9D5MejjFU69SzEFLzd-b8lw5tkyR0CIzmM0Foso4NRA%3D%3D&use_mirror=netix&r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fmingw-w64%2Ffiles%2FToolchains%2520targetting%2520Win64%2FPersonal%2520Builds%2Fmingw-builds%2F8.1.0%2Fthreads-win32%2Fsjlj%2Fx86_64-8.1.0-release-win32-sjlj-rt_v6-rev0.7z%2Fdownload" "${TOOLCHAIN_TMP_DIR}/MingGW.7z")
    file(DOWNLOAD "https://downloads.sourceforge.net/project/mingw-w64/Toolchains%20targetting%20Win64/Personal%20Builds/mingw-builds/8.1.0/threads-posix/sjlj/x86_64-8.1.0-release-posix-sjlj-rt_v6-rev0.7z?ts=gAAAAABiaBhmH2h18EWQnfh5QWdwgm93iauMinSugoZL20DsZeEd198cEsOH0pUjg5jhaqKQE6FEEywAgPuW3r3o-k9OzihcMA%3D%3D&r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fmingw-w64%2Ffiles%2FToolchains%2520targetting%2520Win64%2FPersonal%2520Builds%2Fmingw-builds%2F8.1.0%2Fthreads-posix%2Fsjlj%2Fx86_64-8.1.0-release-posix-sjlj-rt_v6-rev0.7z%2Fdownload" "${TOOLCHAIN_TMP_DIR}/MingGW.7z")
    file(ARCHIVE_EXTRACT INPUT "${TOOLCHAIN_TMP_DIR}/MingGW.7z" DESTINATION "${TOOLCHAIN_ROOT}")
endif()




#####################################################
# set ARM specific variables - DO NOT EDIT
#####################################################

set(CMAKE_SYSTEM_NAME Windows)
set(CMAKE_SYSTEM_PROCESSOR AMD64)
#set(CMAKE_GENERATOR_PLATFORM x64)

set(TOOLCHAIN mingw64)
if(NOT DEFINED TOOLCHAIN_PREFIX)
    set(TOOLCHAIN_PREFIX "${TOOLCHAIN_ROOT}/mingw64")
    string(REPLACE "\\" "/" TOOLCHAIN_PREFIX ${TOOLCHAIN_PREFIX})
endif()
set(TOOLCHAIN_BIN_DIR ${TOOLCHAIN_PREFIX}/bin)
set(TOOLCHAIN_INC_DIR ${TOOLCHAIN_PREFIX}/include)
set(TOOLCHAIN_LIB_DIR ${TOOLCHAIN_PREFIX}/lib)

set(CMAKE_SYSROOT ${TOOLCHAIN_PREFIX}/)
# Set system depended extensions
if(WIN32)
    set(TOOLCHAIN_EXT ".exe" )
else()
    set(TOOLCHAIN_EXT "" )
endif()


set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)
#set(OBJECT_GEN_FLAGS "-O0 -mthumb -fno-builtin -Wall -ffunction-sections -fdata-sections -fomit-frame-pointer -mabi=aapcs") // Wall removed temp
#set(OBJECT_GEN_FLAGS "-O0 -ffunction-sections -fdata-sections -fomit-frame-pointer")
set(OBJECT_GEN_FLAGS "-O0 -fcommon")
set(CMAKE_C_FLAGS   "${OBJECT_GEN_FLAGS} " CACHE INTERNAL "C Compiler options")
set(CMAKE_CXX_FLAGS "${OBJECT_GEN_FLAGS} " CACHE INTERNAL "C++ Compiler options")
set(CMAKE_ASM_FLAGS "${OBJECT_GEN_FLAGS} -x assembler-with-cpp " CACHE INTERNAL "ASM Compiler options")


# -Wl,--gc-sections     Perform the dead code elimination.
# --specs=nano.specs    Link with newlib-nano.
# --specs=nosys.specs   No syscalls, provide empty implementations for the POSIX system calls.
#set(CMAKE_EXE_LINKER_FLAGS "" CACHE INTERNAL "Linker options")
# if (NOT APPLE)
#     set(CMAKE_EXE_LINKER_FLAGS "\
#         -static-libgcc \
#         -static-libstdc++")
# endif()
#---------------------------------------------------------------------------------------
# Set debug/release build configuration Options
#---------------------------------------------------------------------------------------

# Options for DEBUG build
# -Og   Enables optimizations that do not interfere with debugging.
# -g    Produce debugging information in the operating system’s native format.
set(CMAKE_C_FLAGS_DEBUG "-Og -g -w" CACHE INTERNAL "C Compiler options for debug build type")
set(CMAKE_CXX_FLAGS_DEBUG "-Og -g" CACHE INTERNAL "C++ Compiler options for debug build type")
set(CMAKE_ASM_FLAGS_DEBUG "-g -w" CACHE INTERNAL "ASM Compiler options for debug build type")
set(CMAKE_EXE_LINKER_FLAGS_DEBUG "" CACHE INTERNAL "Linker options for debug build type")

# Options for RELEASE build
# -Os   Optimize for size. -Os enables all -O2 optimizations.
# -flto Runs the standard link-time optimizer.
set(CMAKE_C_FLAGS_RELEASE "-Os -flto" CACHE INTERNAL "C Compiler options for release build type")
set(CMAKE_CXX_FLAGS_RELEASE "-Os -flto" CACHE INTERNAL "C++ Compiler options for release build type")
set(CMAKE_ASM_FLAGS_RELEASE "" CACHE INTERNAL "ASM Compiler options for release build type")
set(CMAKE_EXE_LINKER_FLAGS_RELEASE "-flto --warn-once" CACHE INTERNAL "Linker options for release build type")


#---------------------------------------------------------------------------------------
# Set compilers
#---------------------------------------------------------------------------------------
set(CMAKE_C_COMPILER ${TOOLCHAIN_BIN_DIR}/x86_64-w64-mingw32-gcc${TOOLCHAIN_EXT} CACHE INTERNAL "C Compiler")
set(CMAKE_CXX_COMPILER ${TOOLCHAIN_BIN_DIR}/x86_64-w64-mingw32-g++${TOOLCHAIN_EXT} CACHE INTERNAL "C++ Compiler")
set(CMAKE_ASM_COMPILER ${TOOLCHAIN_BIN_DIR}/x86_64-w64-mingw32-gcc${TOOLCHAIN_EXT} CACHE INTERNAL "ASM Compiler")

set(CMAKE_FIND_ROOT_PATH ${TOOLCHAIN_PREFIX}/${${TOOLCHAIN}} ${CMAKE_PREFIX_PATH})
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)


#set(OBJECT_GEN_FLAGS "-mcpu=cortex-m4 -mfpu=fpv4-sp-d16 -mfloat-abi=hard")

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${OBJECT_GEN_FLAGS}" CACHE INTERNAL "C Compiler options")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${OBJECT_GEN_FLAGS}" CACHE INTERNAL "C++ Compiler options")
set(CMAKE_ASM_FLAGS "${CMAKE_ASM_FLAGS} ${OBJECT_GEN_FLAGS}" CACHE INTERNAL "ASM Compiler options")


# Linker flags
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS}" CACHE INTERNAL "Linker options")

set(CMAKE_BUILD_PARALLEL_LEVEL 9)

# EXPORT compiler commands for debugging - TODO Remove when no longer needed
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
