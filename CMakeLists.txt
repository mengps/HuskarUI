cmake_minimum_required(VERSION 3.16)

project(HuskarUI_Solution)

option(BUILD_HUSKARUI_GALLERY "Build HuskarUI Gallery." ON)
option(BUILD_HUSKARUI_STATIC_LIBRARY "Build HuskarUI as a static library." OFF)

#Build QWindowKit
set(QWINDOWKIT_BUILD_STATIC ON)
set(QWINDOWKIT_BUILD_WIDGETS OFF)
set(QWINDOWKIT_BUILD_QUICK ON)
set(QWINDOWKIT_INSTALL OFF)
add_subdirectory(3rdparty/qwindowkit)

set(CMAKE_INSTALL_PREFIX ${CMAKE_CURRENT_SOURCE_DIR})
add_subdirectory(src)

if(BUILD_HUSKARUI_GALLERY)
    add_subdirectory(gallery)
endif()
