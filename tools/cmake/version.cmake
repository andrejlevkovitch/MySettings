# use git tag as version
# XXX version don't change if no one need for rebuild

find_package(Git REQUIRED)
execute_process(
  COMMAND ${GIT_EXECUTABLE} describe --tags
  RESULT_VARIABLE IS_OK
  OUTPUT_VARIABLE PROJECT_TAG
  )

if(NOT IS_OK EQUAL 0)
  execute_process(
    COMMAND ${GIT_EXECUTABLE} rev-parse --short HEAD
    OUTPUT_VARIABLE PROJECT_TAG
    )
endif()

STRING(STRIP ${PROJECT_TAG} PROJECT_VERSION)
