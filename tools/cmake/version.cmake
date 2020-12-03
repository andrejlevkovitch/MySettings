# use git tag as version
# XXX version don't change if no one need for rebuild

find_package(Git REQUIRED)
execute_process(
  COMMAND           ${GIT_EXECUTABLE} describe --tags
  RESULT_VARIABLE   IS_OK
  OUTPUT_VARIABLE   PROJECT_TAG
  WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}
  )

if(NOT IS_OK EQUAL 0)
  execute_process(
    COMMAND           ${GIT_EXECUTABLE} rev-parse --short HEAD
    OUTPUT_VARIABLE   PROJECT_TAG
    WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}
    )
endif()

STRING(STRIP ${PROJECT_TAG} PROJECT_VERSION)
