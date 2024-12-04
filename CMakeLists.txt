cmake_minimum_required(VERSION 3.20)

project(DelegateUI_Solution)

option(BUILD_DELEGATEUI_EXAMPLE "Build DelegateUI demo applications." ON)
option(BUILD_DELEGATEUI_STATIC_LIBRARY "Build DelegateUI as a static library." OFF)

add_subdirectory(src)

if (BUILD_DELEGATEUI_EXAMPLE)
    add_subdirectory(example)
endif()
