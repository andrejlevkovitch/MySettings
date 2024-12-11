include(FetchContent)

function(FindOrFetch name fetch_link)
  if(TARGET ${name})
    message(WARNING "use high level ${name} target")
  else()
    find_package(${name} QUIET)
    if (${name}_FOUND)
      message(STATUS "Found ${name}")
    else()
      message(WARNING "${name} was not found, try to fetch it from: ${fetch_link}")
      string(REGEX MATCH "\/([^/]*)$" src_dir ${fetch_link})
      FetchContent_Declare(${name}
        GIT_REPOSITORY ${fetch_link}
        SOURCE_DIR ${FETCHCONTENT_BASE_DIR}/${src_dir}
        )
      FetchContent_MakeAvailable(${name})
    endif()
  endif()
endfunction()
