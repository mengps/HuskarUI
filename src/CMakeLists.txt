cmake_minimum_required(VERSION 3.16)

set(DELEGATEUI_VERSION 0.1.1)

option(BUILD_DELEGATEUI_STATIC_LIBRARY "Build DelegateUI as a static library." OFF)

if(BUILD_DELEGATEUI_STATIC_LIBRARY)
    project(DelegateUI VERSION ${DELEGATEUI_VERSION} LANGUAGES CXX)
else()
    project(DelegateUIPlugin VERSION ${DELEGATEUI_VERSION} LANGUAGES CXX)
endif()

#Add DeleagteUIHelper
include(${CMAKE_CURRENT_LIST_DIR}/../.cmake/DelegateUIHelper.cmake)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD 17)

find_package(Qt6 6.5 COMPONENTS Quick ShaderTools REQUIRED)

#Add QWindowKit
set(QWindowKit_DIR ../3rdparty/QWindowKit/lib/cmake/QWindowKit)
find_package(QWindowKit COMPONENTS Core Quick QuickPrivate REQUIRED)

set(DELEGATEUI_QML_OUTPUT_DIRECTORY "" CACHE PATH "DelegateUI plugin output dir.")
if(NOT DELEGATEUI_QML_OUTPUT_DIRECTORY)
    set(DELEGATEUI_QML_OUTPUT_DIRECTORY ${Qt6_DIR}/../../../qml/DelegateUI)
    if(BUILD_DELEGATEUI_STATIC_LIBRARY)
        set(DELEGATEUI_QML_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/../DelegateUI)
    endif()
endif()

if(BUILD_DELEGATEUI_STATIC_LIBRARY)
    set(PLUGIN_NAME "")
    qt_add_library(${PROJECT_NAME} STATIC)
else()
    set(PLUGIN_NAME ${PROJECT_NAME})
    qt_add_library(${PROJECT_NAME} SHARED)
endif()

set(DELEGATEUI_RC_FILE "")
if (WIN32)
    set(DELEGATEUI_RC_FILE ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}_Resource.rc)
    del_add_win_rc(${PROJECT_NAME}
        COMMENTS "Modern UI-Kit for Qml { Design reference Ant-d }"
        NAME "${PROJECT_NAME}.dll"
        COMPANY "DelegateUI"
        DESCRIPTION "https://github.com/mengps/DelegateUI"
        VERSION "${PROJECT_VERSION}"
        COPYRIGHT "Copyright (C) 2025 mengps. All rights reserved."
        OUTPUT_FILE "${DELEGATEUI_RC_FILE}"
    )
    message(${DELEGATEUI_RC_FILE})
endif()

qt_add_qml_module(${PROJECT_NAME}
    URI DelegateUI
    VERSION 1.0
    PLUGIN_TARGET ${PLUGIN_NAME}
    RESOURCE_PREFIX "/"
    TYPEINFO "plugins.qmltypes"
    OUTPUT_DIRECTORY ${DELEGATEUI_QML_OUTPUT_DIRECTORY}
    QML_FILES
        imports/DelegateUI/Controls/DelButton.qml
        imports/DelegateUI/Controls/DelIconButton.qml
        imports/DelegateUI/Controls/DelCaptionButton.qml
        imports/DelegateUI/Controls/DelTourFocus.qml imports/DelegateUI/Controls/DelTourStep.qml
        imports/DelegateUI/Controls/DelIconText.qml
        imports/DelegateUI/Controls/DelCopyableText.qml
        imports/DelegateUI/Controls/DelCaptionBar.qml
        imports/DelegateUI/Controls/DelWindow.qml
        imports/DelegateUI/Controls/DelMenu.qml
        imports/DelegateUI/Controls/DelDivider.qml
        imports/DelegateUI/Controls/DelSwitch.qml
        imports/DelegateUI/Controls/DelScrollBar.qml
        imports/DelegateUI/Controls/DelResizeMouseArea.qml
        imports/DelegateUI/Controls/DelMoveMouseArea.qml
        imports/DelegateUI/Controls/DelAcrylic.qml
        imports/DelegateUI/Controls/DelSlider.qml
        imports/DelegateUI/Controls/DelTabView.qml
        imports/DelegateUI/Controls/DelToolTip.qml
    SOURCES
        $<$<BOOL:${WIN32}>:${DELEGATEUI_RC_FILE}>
        cpp/delglobal.h
        cpp/deldefinitions.h
        cpp/delapp.h cpp/delapp.cpp
        cpp/utils/delapi.h cpp/utils/delapi.cpp
        cpp/theme/deltheme.h cpp/theme/deltheme.cpp cpp/theme/deltheme_p.h
        cpp/theme/delthemefunctions.h cpp/theme/delthemefunctions.cpp
        cpp/theme/delcolorgenerator.h cpp/theme/delcolorgenerator.cpp
        cpp/theme/delsystemthemehelper.h cpp/theme/delsystemthemehelper.cpp
        cpp/theme/delsizegenerator.h cpp/theme/delsizegenerator.cpp
        cpp/controls/deliconfont.h cpp/controls/deliconfont.cpp
        cpp/controls/delwindowagent.h cpp/controls/delwindowagent.cpp
        cpp/controls/delrectangle.h cpp/controls/delrectangle.cpp
)

qt_add_resources(${PROJECT_NAME} "resources"
    PREFIX "/DelegateUI"
    FILES
        "../resources/font/DelegateUI-Icons.ttf"
)

qt_add_resources(${PROJECT_NAME} "theme"
    PREFIX "/DelegateUI"
    FILES
        theme/Index.json
        theme/DelButton.json
        theme/DelCaptionButton.json
        theme/DelTour.json
        theme/DelIconText.json
        theme/DelCopyableText.json
        theme/DelMenu.json
        theme/DelDivider.json
        theme/DelSwitch.json
        theme/DelScrollBar.json
        theme/DelSlider.json
        theme/DelTabView.json
        theme/DelToolTip.json
)

qt_add_shaders(${PROJECT_NAME} "delegateui_shaders"
    PREFIX "/DelegateUI"
    FILES
        shaders/deltour.frag
)

target_compile_definitions(${PROJECT_NAME} PRIVATE
    BUILD_DELEGATEUI_LIB
    $<$<BOOL:${BUILD_DELEGATEUI_STATIC_LIBRARY}>:BUILD_DELEGATEUI_STATIC_LIBRARY>
    $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>
)

target_compile_options(${PROJECT_NAME} PRIVATE
    $<$<CXX_COMPILER_ID:MSVC>:/utf-8;/Zi>
)

target_link_libraries(${PROJECT_NAME} PRIVATE
    Qt6::Quick
    Qt6::QuickPrivate
    QWindowKit::Quick
)

target_include_directories(${PROJECT_NAME} PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/cpp/controls
    ${CMAKE_CURRENT_SOURCE_DIR}/cpp/theme
    ${CMAKE_CURRENT_SOURCE_DIR}/cpp/utils
)

install(DIRECTORY ${DELEGATEUI_QML_OUTPUT_DIRECTORY} DESTINATION ${CMAKE_INSTALL_PREFIX}/imports)
