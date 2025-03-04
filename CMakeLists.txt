cmake_minimum_required(VERSION 3.16)

project(DelegateUI_Solution)

option(BUILD_DELEGATEUI_GALLERY "Build DelegateUI Gallery." ON)
option(BUILD_DELEGATEUI_STATIC_LIBRARY "Build DelegateUI as a static library." OFF)

#Build QWindowKit
set(QWINDOWKIT_BUILD_STATIC ON)
set(QWINDOWKIT_BUILD_WIDGETS OFF)
set(QWINDOWKIT_BUILD_QUICK ON)
set(QWINDOWKIT_INSTALL OFF)
add_subdirectory(3rdparty/qwindowkit)

set(CMAKE_INSTALL_PREFIX ${CMAKE_CURRENT_SOURCE_DIR})
add_subdirectory(src)

if(BUILD_DELEGATEUI_GALLERY)
    add_subdirectory(gallery)
endif()
