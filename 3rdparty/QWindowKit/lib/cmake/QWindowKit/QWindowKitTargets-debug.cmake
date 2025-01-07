#----------------------------------------------------------------
# Generated CMake target import file for configuration "Debug".
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "QWindowKit::Core" for configuration "Debug"
set_property(TARGET QWindowKit::Core APPEND PROPERTY IMPORTED_CONFIGURATIONS DEBUG)
set_target_properties(QWindowKit::Core PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_DEBUG "CXX"
  IMPORTED_LOCATION_DEBUG "${_IMPORT_PREFIX}/lib/QWKCored.lib"
  )

list(APPEND _cmake_import_check_targets QWindowKit::Core )
list(APPEND _cmake_import_check_files_for_QWindowKit::Core "${_IMPORT_PREFIX}/lib/QWKCored.lib" )

# Import target "QWindowKit::Quick" for configuration "Debug"
set_property(TARGET QWindowKit::Quick APPEND PROPERTY IMPORTED_CONFIGURATIONS DEBUG)
set_target_properties(QWindowKit::Quick PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_DEBUG "CXX"
  IMPORTED_LOCATION_DEBUG "${_IMPORT_PREFIX}/lib/QWKQuickd.lib"
  )

list(APPEND _cmake_import_check_targets QWindowKit::Quick )
list(APPEND _cmake_import_check_files_for_QWindowKit::Quick "${_IMPORT_PREFIX}/lib/QWKQuickd.lib" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
