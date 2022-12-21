message("-- Setting sane directories")
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/dist/${CMAKE_SYSTEM_NAME}/${CMAKE_BUILD_TYPE}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/dist/${CMAKE_SYSTEM_NAME}/${CMAKE_BUILD_TYPE}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/dist/${CMAKE_SYSTEM_NAME}/${CMAKE_BUILD_TYPE}/bin)

message("---- Static Lib Dir: CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_ARCHIVE_OUTPUT_DIRECTORY}")
message("---- Shared Lib Dir: CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}")
message("---- Binary Dir: CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}")

if(EXISTS "./res")
    message("Resource directory found")
    set(CMAKE_RESOURCES_OUTPUT_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/res)
    file(GLOB_RECURSE CMAKE_RESOURCES "res/*")
    file(COPY ${CMAKE_RESOURCES} DESTINATION ${CMAKE_RESOURCES_OUTPUT_DIRECTORY})
    message("---- Resource Dir: CMAKE_RESOURCES_OUTPUT_DIRECTORY ${CMAKE_RESOURCES_OUTPUT_DIRECTORY}")
else()
    message("---- Resource Dir: N/A")
endif()