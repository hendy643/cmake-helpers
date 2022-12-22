include_guard(GLOBAL)

function(CopyConfigFileToDist FILE_NAME)
    get_filename_component(NAMEONLY ${FILE_NAME} NAME)
    add_custom_command(
            TARGET ${PROJECT_NAME}  POST_BUILD
            COMMAND ${CMAKE_COMMAND} -E copy
            ${FILE_NAME}
            ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${NAMEONLY})
endfunction()