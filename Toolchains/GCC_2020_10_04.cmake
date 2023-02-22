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
message("GCC Version: ${TOOLCHAIN_YEAR}-${TOOLCHAIN_MONTH}-${TOOLCHAIN_Q_NUMBER}")
set(TOOLCHAIN_TMP_DIR "${CMAKE_CURRENT_SOURCE_DIR}/toolchain")
set(TOOLCHAIN_ROOT "${TOOLCHAIN_TMP_DIR}/root")

set(TOOLCHAIN_TARGET_VERSION "${TOOLCHAIN_MONTH}-${TOOLCHAIN_YEAR}-q${TOOLCHAIN_Q_NUMBER}")
set(TOOLCHAIN_TARGET_VERSION_LONG "${TOOLCHAIN_TARGET_VERSION}-major")

if (WIN32)
    set(TOOLCHAIN_OS_VERSION "win32")
    set(TOOLCHAIN_ARCH_EXT "zip")
elseif(LINUX)
    set(TOOLCHAIN_ARCH_EXT "tar.bz2")
    set(TOOLCHAIN_OS_VERSION "x86_64-linux")
elseif(UNIX AND APPLE)
    set(TOOLCHAIN_ARCH_EXT "tar.bz2")
    set(TOOLCHAIN_OS_VERSION "mac")
ENDIF()

if(NOT IS_DIRECTORY "${TOOLCHAIN_TMP_DIR}")
    file(MAKE_DIRECTORY ${TOOLCHAIN_TMP_DIR})
endif()

if(NOT IS_DIRECTORY "${TOOLCHAIN_ROOT}")
    file(DOWNLOAD "https://developer.arm.com/-/media/Files/downloads/gnu-rm/${TOOLCHAIN_MONTH}-${TOOLCHAIN_YEAR}q${TOOLCHAIN_Q_NUMBER}/gcc-arm-none-eabi-${TOOLCHAIN_TARGET_VERSION_LONG}-${TOOLCHAIN_OS_VERSION}.${TOOLCHAIN_ARCH_EXT}" "${TOOLCHAIN_TMP_DIR}/toolchain.${TOOLCHAIN_ARCH_EXT}")
    file(ARCHIVE_EXTRACT INPUT "${TOOLCHAIN_TMP_DIR}/toolchain.${TOOLCHAIN_ARCH_EXT}" DESTINATION "${TOOLCHAIN_ROOT}")
endif()

#####################################################
# set ARM specific variables - DO NOT EDIT
#####################################################

set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)

set(CMAKE_CROSSCOMPILING 1)

set(TOOLCHAIN arm-none-eabi)
if(NOT DEFINED TOOLCHAIN_PREFIX)
    set(TOOLCHAIN_PREFIX "${TOOLCHAIN_ROOT}/gcc-${TOOLCHAIN}-${TOOLCHAIN_TARGET_VERSION_LONG}")
    string(REPLACE "\\" "/" TOOLCHAIN_PREFIX ${TOOLCHAIN_PREFIX})
endif()
set(TOOLCHAIN_BIN_DIR ${TOOLCHAIN_PREFIX}/bin)
set(TOOLCHAIN_INC_DIR ${TOOLCHAIN_PREFIX}/${TOOLCHAIN}/include)
set(TOOLCHAIN_LIB_DIR ${TOOLCHAIN_PREFIX}/${TOOLCHAIN}/lib)

set(CMAKE_SYSROOT ${TOOLCHAIN_PREFIX}/arm-none-eabi)
# Set system depended extensions
if(WIN32)
    set(TOOLCHAIN_EXT ".exe" )
else()
    set(TOOLCHAIN_EXT "" )
endif()

set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)
#set(OBJECT_GEN_FLAGS "-O0 -mthumb -fno-builtin -Wall -ffunction-sections -fdata-sections -fomit-frame-pointer -mabi=aapcs") // Wall removed temp
set(OBJECT_GEN_FLAGS "-O0 -mthumb -fno-builtin -ffunction-sections -fdata-sections -fomit-frame-pointer -mabi=aapcs")

set(CMAKE_C_FLAGS   "${OBJECT_GEN_FLAGS} " CACHE INTERNAL "C Compiler options")
#set(CMAKE_CXX_FLAGS "${OBJECT_GEN_FLAGS} " CACHE INTERNAL "C++ Compiler options")
set(CMAKE_ASM_FLAGS "${OBJECT_GEN_FLAGS} -x assembler-with-cpp " CACHE INTERNAL "ASM Compiler options")


# -Wl,--gc-sections     Perform the dead code elimination.
# --specs=nano.specs    Link with newlib-nano.
# --specs=nosys.specs   No syscalls, provide empty implementations for the POSIX system calls.
set(CMAKE_EXE_LINKER_FLAGS "-Wl,--gc-sections --specs=nano.specs --specs=nosys.specs -mthumb -mabi=aapcs -Wl,-Map=${CMAKE_PROJECT_NAME}.map" CACHE INTERNAL "Linker options")

#---------------------------------------------------------------------------------------
# Set debug/release build configuration Options
#---------------------------------------------------------------------------------------

# Options for DEBUG build
# -Og   Enables optimizations that do not interfere with debugging.
# -g    Produce debugging information in the operating system’s native format.
set(CMAKE_C_FLAGS_DEBUG "-Og -g -w" CACHE INTERNAL "C Compiler options for debug build type")
#set(CMAKE_CXX_FLAGS_DEBUG "-Og -g" CACHE INTERNAL "C++ Compiler options for debug build type")
set(CMAKE_ASM_FLAGS_DEBUG "-g -w" CACHE INTERNAL "ASM Compiler options for debug build type")
set(CMAKE_EXE_LINKER_FLAGS_DEBUG "" CACHE INTERNAL "Linker options for debug build type")

# Options for RELEASE build
# -Os   Optimize for size. -Os enables all -O2 optimizations.
# -flto Runs the standard link-time optimizer.
set(CMAKE_C_FLAGS_RELEASE "-Os -flto" CACHE INTERNAL "C Compiler options for release build type")
#set(CMAKE_CXX_FLAGS_RELEASE "-Os -flto" CACHE INTERNAL "C++ Compiler options for release build type")
set(CMAKE_ASM_FLAGS_RELEASE "" CACHE INTERNAL "ASM Compiler options for release build type")
set(CMAKE_EXE_LINKER_FLAGS_RELEASE "-flto --warn-once" CACHE INTERNAL "Linker options for release build type")


#---------------------------------------------------------------------------------------
# Set compilers
#---------------------------------------------------------------------------------------
set(CMAKE_C_COMPILER ${TOOLCHAIN_BIN_DIR}/${TOOLCHAIN}-gcc${TOOLCHAIN_EXT} CACHE INTERNAL "C Compiler")
set(CMAKE_CXX_COMPILER ${TOOLCHAIN_BIN_DIR}/${TOOLCHAIN}-g++${TOOLCHAIN_EXT} CACHE INTERNAL "C++ Compiler")
set(CMAKE_ASM_COMPILER ${TOOLCHAIN_BIN_DIR}/${TOOLCHAIN}-gcc${TOOLCHAIN_EXT} CACHE INTERNAL "ASM Compiler")

set(CMAKE_FIND_ROOT_PATH ${TOOLCHAIN_PREFIX}/${${TOOLCHAIN}} ${CMAKE_PREFIX_PATH})
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

set(LINKER_SCRIPT "${CMAKE_CURRENT_SOURCE_DIR}/cmake/linker/M4ExtRamRom_GCC.ld")

if(NOT DEFINED LINKER_SCRIPT)
    message(FATAL_ERROR "No linker script defined")
endif(NOT DEFINED LINKER_SCRIPT)
message("Linker script: ${LINKER_SCRIPT}")

set(OBJECT_GEN_FLAGS "-mcpu=cortex-m4 -mfpu=fpv4-sp-d16 -mfloat-abi=softfp")

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${OBJECT_GEN_FLAGS}" CACHE INTERNAL "C Compiler options")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${OBJECT_GEN_FLAGS}" CACHE INTERNAL "C++ Compiler options")
set(CMAKE_ASM_FLAGS "${CMAKE_ASM_FLAGS} ${OBJECT_GEN_FLAGS}" CACHE INTERNAL "ASM Compiler options")


# Linker flags
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -T${LINKER_SCRIPT}" CACHE INTERNAL "Linker options")

# EXPORT compiler commands for debugging - TODO Remove when no longer needed
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
