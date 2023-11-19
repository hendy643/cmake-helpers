include_guard(GLOBAL)

find_program(CPPCHECK 
    "C:\\Program Files\\Cppcheck\\cppcheck.exe"
    "~/scoop/shims/cppcheck.exe"
)
if(CMAKE_BUILD_TYPE MATCHES "Release")
if(CPPCHECK)
  message("-- cppcheck enabled: ${CPPCHECK}")
  set(CMAKE_C_CPPCHECK ${CPPCHECK})
  set(CMAKE_CXX_CPPCHECK ${CPPCHECK})
  string(TIMESTAMP SIEM_TIMESTAMP)
  list(
    APPEND CMAKE_C_CPPCHECK 
        "--enable=warning"
        "--inconclusive"
        "--force" 
        "--inline-suppr"
        "--output-file=${CMAKE_CURRENT_SOURCE_DIR}/dist/${CMAKE_SYSTEM_NAME}/${CMAKE_BUILD_TYPE}/cppcheck/results_${SIEM_TIMESTAMP}.txt"
        "--suppressions-list=${CMAKE_CURRENT_SOURCE_DIR}/CppCheckSuppressions.txt"
)
  list(
    APPEND CMAKE_CXX_CPPCHECK 
        "--enable=warning"
        "--inconclusive"
        "--force" 
        "--inline-suppr"
        "--output-file=${CMAKE_CURRENT_SOURCE_DIR}/dist/${CMAKE_SYSTEM_NAME}/${CMAKE_BUILD_TYPE}/cppcheck/results_${SIEM_TIMESTAMP}.txt"
        "--suppressions-list=${CMAKE_CURRENT_SOURCE_DIR}/CppCheckSuppressions.txt"
)
else()
  message(SEND_ERROR "cppcheck requested but executable not found")
endif()
else()
	set(CPPCHECK "")
	message("Non-Release Build Detected. Disabling CPPCHECK")
endif()
