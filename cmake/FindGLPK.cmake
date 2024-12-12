#[[
This file is a part of LEMON, a generic C++ optimization library.

Copyright (C) 2003-2021
Egervary Jeno Kombinatorikus Optimalizalasi Kutatocsoport
(Egervary Research Group on Combinatorial Optimization, EGRES).

Permission to use, modify and distribute this software is granted
provided that this copyright notice appears in all copies. For
precise terms see the accompanying LICENSE file.

This software is provided "AS IS" with no warranty of any kind,
express or implied, and with no claim as to its suitability for any
purpose.
]]

#[[
This file finds the necessary components for the GLPK solver.
]]

set(GLPK_ROOT_DIR
    ""
    CACHE PATH "GLPK root directory")

set(GLPK_REGKEY "[HKEY_LOCAL_MACHINE\\SOFTWARE\\GnuWin32\\Glpk;InstallPath]")
get_filename_component(GLPK_ROOT_PATH ${GLPK_REGKEY} ABSOLUTE)

find_path(
  GLPK_INCLUDE_DIR glpk.h
  PATHS ${GLPK_REGKEY}/include
  HINTS ${GLPK_ROOT_DIR}/include)

find_library(
  GLPK_LIBRARY glpk
  PATHS ${GLPK_REGKEY}/lib
  HINTS ${GLPK_ROOT_DIR}/lib)

if(GLPK_INCLUDE_DIR AND GLPK_LIBRARY)
  file(READ ${GLPK_INCLUDE_DIR}/glpk.h GLPK_GLPK_H)

  string(REGEX MATCH "define[ ]+GLP_MAJOR_VERSION[ ]+[0-9]+"
               GLPK_MAJOR_VERSION_LINE "${GLPK_GLPK_H}")
  string(REGEX REPLACE "define[ ]+GLP_MAJOR_VERSION[ ]+([0-9]+)" "\\1"
                       GLPK_VERSION_MAJOR "${GLPK_MAJOR_VERSION_LINE}")

  string(REGEX MATCH "define[ ]+GLP_MINOR_VERSION[ ]+[0-9]+"
               GLPK_MINOR_VERSION_LINE "${GLPK_GLPK_H}")
  string(REGEX REPLACE "define[ ]+GLP_MINOR_VERSION[ ]+([0-9]+)" "\\1"
                       GLPK_VERSION_MINOR "${GLPK_MINOR_VERSION_LINE}")

  set(GLPK_VERSION_STRING "${GLPK_VERSION_MAJOR}.${GLPK_VERSION_MINOR}")

  if(GLPK_FIND_VERSION)
    if(GLPK_FIND_VERSION_COUNT GREATER 2)
      message(SEND_ERROR "unexpected version string")
    endif(GLPK_FIND_VERSION_COUNT GREATER 2)

    math(EXPR GLPK_REQUESTED_VERSION
         "${GLPK_FIND_VERSION_MAJOR}*100 + ${GLPK_FIND_VERSION_MINOR}")
    math(EXPR GLPK_FOUND_VERSION
         "${GLPK_VERSION_MAJOR}*100 + ${GLPK_VERSION_MINOR}")

    if(GLPK_FOUND_VERSION LESS GLPK_REQUESTED_VERSION)
      set(GLPK_PROPER_VERSION_FOUND FALSE)
    else(GLPK_FOUND_VERSION LESS GLPK_REQUESTED_VERSION)
      set(GLPK_PROPER_VERSION_FOUND TRUE)
    endif(GLPK_FOUND_VERSION LESS GLPK_REQUESTED_VERSION)
  else(GLPK_FIND_VERSION)
    set(GLPK_PROPER_VERSION_FOUND TRUE)
  endif(GLPK_FIND_VERSION)
endif(GLPK_INCLUDE_DIR AND GLPK_LIBRARY)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(GLPK DEFAULT_MSG GLPK_LIBRARY
                                  GLPK_INCLUDE_DIR GLPK_PROPER_VERSION_FOUND)

if(GLPK_FOUND)
  set(GLPK_INCLUDE_DIRS ${GLPK_INCLUDE_DIR})
  set(GLPK_LIBRARIES ${GLPK_LIBRARY})
  set(GLPK_BIN_DIR ${GLPK_ROOT_PATH}/bin)
endif(GLPK_FOUND)

mark_as_advanced(GLPK_LIBRARY GLPK_INCLUDE_DIR GLPK_BIN_DIR)
