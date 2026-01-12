cmake_minimum_required(VERSION 3.16)

project(HuskarUI_Solution)

option(BUILD_HUSKARUI_GALLERY "Build HuskarUI Gallery." ON)
option(BUILD_HUSKARUI_STATIC_LIBRARY "Build HuskarUI as a static library." OFF)
option(BUILD_HUSKARUI_ON_DESKTOP_PLATFORM "Build HuskarUI on desktop platform (mobile platform set OFF)." ON)
option(INSTALL_HUSKARUI_IN_DEFAULT_LOCATION "Install HuskarUI in default location[QtSDK Dir]." ON)

#Set HuskarUI output dir
set(HUSKARUI_HEADER_OUTPUT_DIRECTORY "" CACHE PATH "HuskarUI header output dir.")
set(HUSKARUI_LIBRARY_OUTPUT_DIRECTORY "" CACHE PATH "HuskarUI library output dir.")
set(HUSKARUI_PLUGIN_OUTPUT_DIRECTORY "" CACHE PATH "HuskarUI plugin output dir (Must end with [HuskarUI/Basic]).")
set(HUSKARUI_INSTALL_DIRECTORY "" CACHE PATH "HuskarUI install dir.")

set(QT_SILENCE_MISSING_DEPENDENCY_TARGET_WARNING ON)

set(MACOS FALSE)
if(APPLE)
    if(CMAKE_SYSTEM_NAME STREQUAL "Darwin")
        set(MACOS TRUE)
    else()
        set(MACOS FALSE)
    endif()
endif()

if(WIN32 OR MACOS OR LINUX)
    set(BUILD_HUSKARUI_ON_DESKTOP_PLATFORM ON)
else()
    set(BUILD_HUSKARUI_ON_DESKTOP_PLATFORM OFF)
endif()

#Build QWindowKit
if(BUILD_HUSKARUI_ON_DESKTOP_PLATFORM)
    set(QWINDOWKIT_BUILD_STATIC ON)
    set(QWINDOWKIT_BUILD_WIDGETS OFF)
    set(QWINDOWKIT_BUILD_QUICK ON)
    set(QWINDOWKIT_INSTALL OFF)
    add_subdirectory(3rdparty/qwindowkit)
endif()

set(HUSKARUI_VERSION_MAJOR 0)
set(HUSKARUI_VERSION_MINOR 5)
set(HUSKARUI_VERSION_PATCH 5)
set(HUSKARUI_VERSION_TWEAK 0)
set(HUSKARUI_VERSION ${HUSKARUI_VERSION_MAJOR}.${HUSKARUI_VERSION_MINOR}.${HUSKARUI_VERSION_PATCH}.${HUSKARUI_VERSION_TWEAK})

message(STATUS "Configuring HuskarUI Version: ${HUSKARUI_VERSION}")

if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
    set(CMAKE_INSTALL_PREFIX "${CMAKE_CURRENT_SOURCE_DIR}/HuskarUI" CACHE PATH "" FORCE)
endif()
add_subdirectory(src_impl)
add_subdirectory(src)

if(BUILD_HUSKARUI_GALLERY)
    add_subdirectory(gallery)
endif()
