#----------------------------------------------------------------
# Generated CMake target import file for configuration "Release".
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "QWindowKit::Core" for configuration "Release"
set_property(TARGET QWindowKit::Core APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(QWindowKit::Core PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "CXX"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/QWKCore.lib"
  )

list(APPEND _cmake_import_check_targets QWindowKit::Core )
list(APPEND _cmake_import_check_files_for_QWindowKit::Core "${_IMPORT_PREFIX}/lib/QWKCore.lib" )

# Import target "QWindowKit::Quick" for configuration "Release"
set_property(TARGET QWindowKit::Quick APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(QWindowKit::Quick PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "CXX"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/QWKQuick.lib"
  )

list(APPEND _cmake_import_check_targets QWindowKit::Quick )
list(APPEND _cmake_import_check_files_for_QWindowKit::Quick "${_IMPORT_PREFIX}/lib/QWKQuick.lib" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
