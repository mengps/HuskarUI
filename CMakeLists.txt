cmake_minimum_required(VERSION 3.20)

project(DelegateUI_Solution)

option(BUILD_DELEGATEUI_GALLERY "Build DelegateUI Gallery." ON)
option(BUILD_DELEGATEUI_STATIC_LIBRARY "Build DelegateUI as a static library." OFF)

set(CMAKE_INSTALL_PREFIX ${CMAKE_CURRENT_SOURCE_DIR})

add_subdirectory(src)

if (BUILD_DELEGATEUI_GALLERY)
    add_subdirectory(gallery)
endif()
