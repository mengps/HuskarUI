cmake_minimum_required(VERSION 3.16)

set(DELEGATEUI_VERSION 0.2.8.0)

message(STATUS "Configuring DelegateUI Version: ${DELEGATEUI_VERSION}")

project(DelegateUI VERSION ${DELEGATEUI_VERSION} LANGUAGES CXX)

#Add DeleagteUIHelper
include(${CMAKE_CURRENT_LIST_DIR}/../.cmake/DelegateUIHelper.cmake)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD 17)

find_package(Qt6 6.5 COMPONENTS Quick ShaderTools REQUIRED)
qt_standard_project_setup(REQUIRES 6.5)

#Set plugin output dir
set(DELEGATEUI_LIBRARY_OUTPUT_DIRECTORY "" CACHE PATH "DelegateUI library output dir.")
set(DELEGATEUI_PLUGIN_OUTPUT_DIRECTORY "" CACHE PATH "DelegateUI plugin output dir.")
if(NOT DELEGATEUI_PLUGIN_OUTPUT_DIRECTORY)
    set(DELEGATEUI_LIBRARY_OUTPUT_DIRECTORY ${Qt6_DIR}/../../../)
    set(DELEGATEUI_PLUGIN_OUTPUT_DIRECTORY ${Qt6_DIR}/../../../qml/DelegateUI)
    if(BUILD_DELEGATEUI_STATIC_LIBRARY)
        set(DELEGATEUI_PLUGIN_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/DelegateUI)
    endif()
endif()

if(BUILD_DELEGATEUI_STATIC_LIBRARY)
    set(PLUGIN_NAME "")
    qt_add_library(${PROJECT_NAME} STATIC)
else()
    set(PLUGIN_NAME delegateuiplugin)
    qt_add_library(${PROJECT_NAME} SHARED)
endif()

set(DELEGATEUI_RC_FILE "")
if(WIN32)
    set(DELEGATEUI_RC_FILE ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}_Resource.rc)
    set(RC_NAME "")
    if(BUILD_DELEGATEUI_STATIC_LIBRARY)
        set(RC_NAME "${PROJECT_NAME}.lib")
    else()
        set(RC_NAME "${PROJECT_NAME}.dll")
    endif()
    del_add_win_rc(${PROJECT_NAME}
        COMMENTS "Modern UI-Kit for Qml { Design reference Ant-d }"
        NAME ${RC_NAME}
        COMPANY "DelegateUI"
        DESCRIPTION "https://github.com/mengps/DelegateUI"
        VERSION "${PROJECT_VERSION}"
        COPYRIGHT "Copyright (C) 2025 mengps. All rights reserved."
        OUTPUT_FILE "${DELEGATEUI_RC_FILE}"
    )
endif()

qt_add_qml_module(${PROJECT_NAME}
    URI DelegateUI
    VERSION 1.0
    DESIGNER_SUPPORTED
    PLUGIN_TARGET ${PLUGIN_NAME}
    #NO_GENERATE_PLUGIN_SOURCE
    RESOURCE_PREFIX "/"
    TYPEINFO "plugins.qmltypes"
    OUTPUT_DIRECTORY ${DELEGATEUI_PLUGIN_OUTPUT_DIRECTORY}
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
        imports/DelegateUI/Controls/DelSelect.qml
        imports/DelegateUI/Controls/DelInput.qml
        imports/DelegateUI/Controls/DelOTPInput.qml
        imports/DelegateUI/Controls/DelRate.qml
        imports/DelegateUI/Controls/DelRadio.qml
        imports/DelegateUI/Controls/DelRadioBlock.qml
        imports/DelegateUI/Controls/DelCheckBox.qml
        imports/DelegateUI/Controls/DelTimePicker.qml
        imports/DelegateUI/Controls/DelDrawer.qml
        imports/DelegateUI/Controls/DelCollapse.qml
        imports/DelegateUI/Controls/DelAvatar.qml
        imports/DelegateUI/Controls/DelCard.qml
        imports/DelegateUI/Controls/DelPagination.qml
        imports/DelegateUI/Controls/DelPopup.qml
        imports/DelegateUI/Controls/DelTimeline.qml
        imports/DelegateUI/Controls/DelTag.qml
        imports/DelegateUI/Controls/DelTableView.qml
        imports/DelegateUI/Controls/DelMessage.qml
        imports/DelegateUI/Controls/DelAutoComplete.qml
        imports/DelegateUI/Controls/DelText.qml
        imports/DelegateUI/Controls/DelDatePicker.qml
    SOURCES
        $<$<BOOL:${WIN32}>:${DELEGATEUI_RC_FILE}>
        cpp/delglobal.h
        cpp/deldefinitions.h
        #cpp/delegateuiplugin.cpp
        cpp/delapp.h cpp/delapp.cpp
        cpp/theme/deltheme.h cpp/theme/deltheme.cpp cpp/theme/deltheme_p.h
        cpp/theme/delthemefunctions.h cpp/theme/delthemefunctions.cpp
        cpp/theme/delcolorgenerator.h cpp/theme/delcolorgenerator.cpp
        cpp/theme/delsystemthemehelper.h cpp/theme/delsystemthemehelper.cpp
        cpp/theme/delsizegenerator.h cpp/theme/delsizegenerator.cpp
        cpp/utils/delapi.h cpp/utils/delapi.cpp
        cpp/utils/delasynchasher.h cpp/utils/delasynchasher.cpp
        cpp/controls/delwindowagent.h cpp/controls/delwindowagent.cpp
        cpp/controls/deliconfont.h cpp/controls/deliconfont.cpp
        cpp/controls/delrectangle.h cpp/controls/delrectangle.cpp
        cpp/controls/delwatermark.h cpp/controls/delwatermark.cpp
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
        theme/DelSelect.json
        theme/DelInput.json
        theme/DelRate.json
        theme/DelRadio.json
        theme/DelCheckBox.json
        theme/DelTimePicker.json
        theme/DelDrawer.json
        theme/DelCollapse.json
        theme/DelCard.json
        theme/DelPagination.json
        theme/DelPopup.json
        theme/DelTimeline.json
        theme/DelTag.json
        theme/DelTableView.json
        theme/DelMessage.json
        theme/DelAutoComplete.json
        theme/DelDatePicker.json
)

qt_add_resources(${PROJECT_NAME} "resources"
    PREFIX "/DelegateUI"
    FILES
        "../resources/font/DelegateUI-Icons.ttf"
)

qt_add_shaders(${PROJECT_NAME} "delegateui_shaders"
    PREFIX "/DelegateUI"
    FILES
        shaders/deltour.frag
        shaders/delrate.frag
)

# DelegateUI library output dir
set_target_properties(${PROJECT_NAME} PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY ${DELEGATEUI_LIBRARY_OUTPUT_DIRECTORY}/bin
    LIBRARY_OUTPUT_DIRECTORY ${DELEGATEUI_LIBRARY_OUTPUT_DIRECTORY}/lib
    ARCHIVE_OUTPUT_DIRECTORY ${DELEGATEUI_LIBRARY_OUTPUT_DIRECTORY}/lib
)

if(MINGW)
    set_target_properties(${PROJECT_NAME} PROPERTIES PREFIX "")
    target_compile_options(${PROJECT_NAME} PRIVATE -Wa,-mbig-obj)
elseif(MSVC)
    set_target_properties(${PROJECT_NAME} PROPERTIES DEBUG_POSTFIX "d")
    target_compile_options(${PROJECT_NAME} PRIVATE $<$<CXX_COMPILER_ID:MSVC>:/utf-8;/Zi>)
endif()

target_compile_definitions(${PROJECT_NAME} PRIVATE
    BUILD_DELEGATEUI_LIB
    DELEGATEUI_LIBRARY_VERSION="${DELEGATEUI_VERSION}"
    $<$<BOOL:${BUILD_DELEGATEUI_STATIC_LIBRARY}>:BUILD_DELEGATEUI_STATIC_LIBRARY>
    $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>
)

target_link_libraries(${PROJECT_NAME} PRIVATE
    Qt6::Quick
    Qt6::QuickPrivate
    QWKCore
    QWKQuick
)

target_include_directories(${PROJECT_NAME} PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/cpp/theme
    ${CMAKE_CURRENT_SOURCE_DIR}/cpp/controls
    ${CMAKE_CURRENT_SOURCE_DIR}/cpp/utils
)

install(TARGETS ${PROJECT_NAME}
    RUNTIME DESTINATION ${CMAKE_INSTALL_PREFIX}/DelegateUI/bin
    ARCHIVE DESTINATION ${CMAKE_INSTALL_PREFIX}/DelegateUI/lib
    LIBRARY DESTINATION ${CMAKE_INSTALL_PREFIX}/DelegateUI/lib
)

install(
    FILES cpp/delglobal.h cpp/delapp.h cpp/deldefinitions.h
    DESTINATION ${CMAKE_INSTALL_PREFIX}/DelegateUI/include
)

install(
    DIRECTORY cpp/controls cpp/theme cpp/utils
    DESTINATION ${CMAKE_INSTALL_PREFIX}/DelegateUI/include
    FILES_MATCHING PATTERN "*.h"
    PATTERN "*_p.h" EXCLUDE
)

install(
    DIRECTORY ${DELEGATEUI_PLUGIN_OUTPUT_DIRECTORY} DESTINATION ${CMAKE_INSTALL_PREFIX}/DelegateUI/imports
)
