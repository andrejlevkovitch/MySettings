# doxygen.cmake

find_package(Doxygen)

if(DOXYGEN_FOUND)
  set(DOXYGEN_DOXYFILE_ENCODING "UTF-8")
  set(DOXYGEN_PROJECT_NAME "\"${PROJECT_NAME}\"")
  set(DOXYGEN_PROJECT_NUMBER "${PROJECT_VERSION}")
  set(DOXYGEN_PROJECT_BRIEF "${PROJECT_NAME}")
  set(DOXYGEN_PROJECT_LOGO "")
  set(DOXYGEN_OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/documentation")
  set(DOXYGEN_FILE_PATTERNS *.c *.cc *.cxx *.cpp *.c++ *.h *.hh *.hpp)
  set(DOXYGEN_RECURSIVE "YES")
  set(DOXYGEN_OPTIMIZE_OUTPUT_FOR_C "YES")
  set(DOXYGEN_CPP_CLI_SUPPORT "YES")
  set(DOXYGEN_CASE_SENSE_NAMES "NO")
  set(DOXYGEN_EXCLUDE_PATTERNS "*/build*/*" "*/test*/*" "*/example*/*" "*/third_party*/*" "*/third-party*/*")
  set(DOXYGEN_GENERATE_LATEX "NO")

  doxygen_add_docs(${PROJECT_NAME}_doxygen ${CMAKE_CURRENT_SOURCE_DIR}
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    COMMENT "generate doxygen documentation by cmake"
    )
endif()
