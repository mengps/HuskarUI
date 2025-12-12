cmake_minimum_required(VERSION 3.16)

set(HUSKARUI_VERSION_MAJOR 0)
set(HUSKARUI_VERSION_MINOR 5)
set(HUSKARUI_VERSION_PATCH 2)
set(HUSKARUI_VERSION_TWEAK 0)
set(HUSKARUI_VERSION ${HUSKARUI_VERSION_MAJOR}.${HUSKARUI_VERSION_MINOR}.${HUSKARUI_VERSION_PATCH}.${HUSKARUI_VERSION_TWEAK})

message(STATUS "Configuring HuskarUI::Basic Version: ${HUSKARUI_VERSION}")

project(HuskarUIBasic VERSION ${HUSKARUI_VERSION} LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD 17)

#Add HuskarUIHelper
include(${CMAKE_CURRENT_SOURCE_DIR}/../.cmake/HuskarUIHelper.cmake)

find_package(Qt6 6.5 COMPONENTS Quick QuickTemplates2 ShaderTools REQUIRED)
qt_standard_project_setup(REQUIRES 6.5)

#Determine if there is a private module present
set(QT_HAS_PRIVATE_MODULES FALSE)
if(Qt6_VERSION VERSION_GREATER "6.10.0")
    find_package(Qt6 6.10 COMPONENTS QuickPrivate QuickTemplates2Private REQUIRED)
    if(Qt6QuickPrivate_FOUND AND Qt6QuickTemplates2Private_FOUND)
        set(QT_HAS_PRIVATE_MODULES TRUE)
    endif()
else()
    get_target_property(QT_HAS_QUICK_PRIVATE Qt6::Quick _qt_module_has_private_headers)
    get_target_property(QT_HAS_QUICKTEMPLATES_PRIVATE Qt6::QuickTemplates2 _qt_module_has_private_headers)
    if(QT_HAS_QUICK_PRIVATE AND QT_HAS_QUICKTEMPLATES_PRIVATE)
        set(QT_HAS_PRIVATE_MODULES TRUE)
    endif()
endif()

#Set header output dir.
if(NOT HUSKARUI_HEADER_OUTPUT_DIRECTORY)
    set(HUSKARUI_HEADER_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/HuskarUI/include)
endif()

#Set library output dir.
if(NOT HUSKARUI_LIBRARY_OUTPUT_DIRECTORY)
    set(HUSKARUI_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/HuskarUI)
endif()

#Set plugin output dir.
if(NOT HUSKARUI_PLUGIN_OUTPUT_DIRECTORY)
    set(HUSKARUI_PLUGIN_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/HuskarUI/qml/HuskarUI/Basic)
endif()

#Set install dir.
if(INSTALL_HUSKARUI_IN_DEFAULT_LOCATION)
    set(CMAKE_INSTALL_PREFIX "${Qt6_DIR}/../../../" CACHE PATH "" FORCE)
elseif(HUSKARUI_INSTALL_DIRECTORY)
    set(CMAKE_INSTALL_PREFIX "${HUSKARUI_INSTALL_DIRECTORY}" CACHE PATH "" FORCE)
endif()

message(STATUS "The Qt has private module: ${QT_HAS_PRIVATE_MODULES}")
message(STATUS "The HuskarUI header output dir: ${HUSKARUI_HEADER_OUTPUT_DIRECTORY}")
message(STATUS "The HuskarUI library output dir: ${HUSKARUI_LIBRARY_OUTPUT_DIRECTORY}/bin|lib")
message(STATUS "The HuskarUI plugin output dir: ${HUSKARUI_PLUGIN_OUTPUT_DIRECTORY}")
message(STATUS "The HuskarUI install dir: ${CMAKE_INSTALL_PREFIX}")

if(BUILD_HUSKARUI_STATIC_LIBRARY)
    set(PLUGIN_NAME HuskarUIBasicPlugin)
    qt_add_library(${PROJECT_NAME} STATIC)
else()
    set(PLUGIN_NAME huskaruibasicplugin)
    qt_add_library(${PROJECT_NAME} SHARED)
endif()

#Default is desktop platform
if(NOT DEFINED BUILD_HUSKARUI_ON_DESKTOP_PLATFORM)
    set(BUILD_HUSKARUI_ON_DESKTOP_PLATFORM ON)
endif()

#Add windows RC
set(HUSKARUI_RC_FILE "")
if(WIN32)
    set(HUSKARUI_RC_FILE ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}_Resource.rc)
    set(RC_NAME "")
    if(BUILD_HUSKARUI_STATIC_LIBRARY)
        set(RC_NAME "${PROJECT_NAME}.lib")
    else()
        set(RC_NAME "${PROJECT_NAME}.dll")
    endif()
    hus_add_win_rc(${PROJECT_NAME}
        COMMENTS "Modern UI-Kit for Qml { Design reference Ant-d }"
        NAME ${RC_NAME}
        COMPANY "HuskarUI"
        DESCRIPTION "https://github.com/mengps/HuskarUI"
        VERSION "${PROJECT_VERSION}"
        COPYRIGHT "Copyright (C) 2025 mengps. All rights reserved."
        OUTPUT_FILE "${HUSKARUI_RC_FILE}"
    )
endif()

if(QT_KNOWN_POLICY_QTP0004)
    qt_policy(SET QTP0004 NEW)
endif()

qt_add_qml_module(${PROJECT_NAME}
    URI "HuskarUI.Basic"
    VERSION 1.0
    DESIGNER_SUPPORTED
    PLUGIN_TARGET ${PLUGIN_NAME}
    OUTPUT_TARGETS HUSKARUI_QML_OUTPUT_TARGETS #Export for static lib
    #NO_GENERATE_PLUGIN_SOURCE
    RESOURCE_PREFIX "/"
    TYPEINFO "plugins.qmltypes"
    OUTPUT_DIRECTORY ${HUSKARUI_PLUGIN_OUTPUT_DIRECTORY}
    QML_FILES
        imports/HusButton.qml imports/HusButtonBlock.qml
        imports/HusIconButton.qml
        imports/HusCaptionButton.qml
        imports/HusTourFocus.qml imports/HusTourStep.qml
        imports/HusIconText.qml
        imports/HusCopyableText.qml
        imports/HusCaptionBar.qml
        imports/HusWindow.qml
        imports/HusMenu.qml
        imports/HusDivider.qml
        imports/HusEmpty.qml
        imports/HusSwitch.qml
        imports/HusScrollBar.qml
        imports/HusResizeMouseArea.qml
        imports/HusMoveMouseArea.qml
        imports/HusAcrylic.qml
        imports/HusSlider.qml
        imports/HusTabView.qml
        imports/HusToolTip.qml
        imports/HusSelect.qml
        imports/HusInput.qml
        imports/HusOTPInput.qml
        imports/HusRate.qml
        imports/HusRadio.qml imports/HusRadioBlock.qml
        imports/HusCheckBox.qml
        imports/HusDrawer.qml
        imports/HusCollapse.qml
        imports/HusAvatar.qml
        imports/HusCard.qml
        imports/HusPagination.qml
        imports/HusPopup.qml
        imports/HusTimeline.qml
        imports/HusTag.qml
        imports/HusTableView.qml
        imports/HusMessage.qml
        imports/HusAutoComplete.qml
        imports/HusText.qml
        imports/HusProgress.qml
        imports/HusBadge.qml
        imports/HusCarousel.qml
        imports/HusSwitchEffect.qml
        imports/HusContextMenu.qml
        imports/HusBreadcrumb.qml
        imports/HusInputNumber.qml imports/HusInputInteger.qml
        imports/HusImage.qml imports/HusAnimatedImage.qml imports/HusImagePreview.qml
        imports/HusMultiSelect.qml
        imports/HusDateTimePicker.qml
        imports/HusShadow.qml
        imports/HusNotification.qml
        imports/HusPopconfirm.qml
        imports/HusPopover.qml
        imports/HusModal.qml
        imports/HusTextArea.qml
        imports/HusSpin.qml
        imports/HusCheckerBoard.qml
        imports/HusColorPickerPanel.qml imports/HusColorPicker.qml
    SOURCES
        $<$<BOOL:${WIN32}>:${HUSKARUI_RC_FILE}>
        cpp/husglobal.h
        cpp/husdefinitions.h
        #cpp/huskaruiplugin.cpp
        cpp/husapp.h cpp/husapp.cpp
        cpp/theme/hustheme.h cpp/theme/hustheme.cpp cpp/theme/hustheme_p.h
        cpp/theme/husthemefunctions.h cpp/theme/husthemefunctions.cpp
        cpp/theme/huscolorgenerator.h cpp/theme/huscolorgenerator.cpp
        cpp/theme/hussizegenerator.h cpp/theme/hussizegenerator.cpp
        cpp/theme/husradiusgenerator.h cpp/theme/husradiusgenerator.cpp
        cpp/theme/hussystemthemehelper.h cpp/theme/hussystemthemehelper.cpp
        cpp/utils/husapi.h cpp/utils/husapi.cpp
        cpp/utils/husasynchasher.h cpp/utils/husasynchasher.cpp
        cpp/controls/huswindowagent.h cpp/controls/huswindowagent.cpp
        cpp/controls/husiconfont.h cpp/controls/husiconfont.cpp
        cpp/controls/husrectangle.h cpp/controls/husrectangle.cpp
        cpp/controls/huswatermark.h cpp/controls/huswatermark.cpp
        cpp/controls/husqrcode.h cpp/controls/husqrcode.cpp
        # QR-Code-generator
        ${CMAKE_CURRENT_SOURCE_DIR}/../3rdparty/QR-Code-generator/cpp/qrcodegen.hpp
        ${CMAKE_CURRENT_SOURCE_DIR}/../3rdparty/QR-Code-generator/cpp/qrcodegen.cpp
)

qt_add_resources(${PROJECT_NAME} "theme"
    PREFIX "/HuskarUI"
    OUTPUT_TARGETS HUSKARUI_THEME_OUTPUT_TARGETS #Export for static lib
    FILES
        resources/theme/Index.json
        resources/theme/HusButton.json
        resources/theme/HusCaptionButton.json
        resources/theme/HusTour.json
        resources/theme/HusIconText.json
        resources/theme/HusCopyableText.json
        resources/theme/HusMenu.json
        resources/theme/HusDivider.json
        resources/theme/HusEmpty.json
        resources/theme/HusSwitch.json
        resources/theme/HusScrollBar.json
        resources/theme/HusSlider.json
        resources/theme/HusTabView.json
        resources/theme/HusToolTip.json
        resources/theme/HusSelect.json
        resources/theme/HusMultiSelect.json
        resources/theme/HusInput.json
        resources/theme/HusRate.json
        resources/theme/HusRadio.json
        resources/theme/HusCheckBox.json
        resources/theme/HusDrawer.json
        resources/theme/HusCollapse.json
        resources/theme/HusCard.json
        resources/theme/HusPagination.json
        resources/theme/HusPopup.json
        resources/theme/HusTimeline.json
        resources/theme/HusTag.json
        resources/theme/HusTableView.json
        resources/theme/HusMessage.json
        resources/theme/HusAutoComplete.json
        resources/theme/HusProgress.json
        resources/theme/HusCarousel.json
        resources/theme/HusBreadcrumb.json
        resources/theme/HusImage.json
        resources/theme/HusDateTimePicker.json
        resources/theme/HusNotification.json
        resources/theme/HusPopconfirm.json
        resources/theme/HusPopover.json
        resources/theme/HusModal.json
        resources/theme/HusTextArea.json
        resources/theme/HusSpin.json
        resources/theme/HusColorPicker.json
)

qt_add_resources(${PROJECT_NAME} "resources"
    PREFIX "/HuskarUI"
    OUTPUT_TARGETS HUSKARUI_RES_OUTPUT_TARGETS #Export for static lib
    FILES
        resources/images/empty-default.svg
        resources/images/empty-simple.svg
        resources/images/hblinds.png
        resources/images/heart.png
        resources/images/smoke.png
        resources/images/star.png
        resources/images/stripes.png
        resources/font/HuskarUI-Icons.ttf
)

qt_add_shaders(${PROJECT_NAME} "shaders"
    PREFIX "/HuskarUI"
    OUTPUT_TARGETS HUSKARUI_SHADERS_OUTPUT_TARGETS #Export for static lib
    FILES
        shaders/husrate.frag
)

# HuskarUI library output dir
set_target_properties(${PROJECT_NAME} PROPERTIES
    EXPORT_NAME "Basic"
    VERSION ${HUSKARUI_VERSION}
    SOVERSION ${HUSKARUI_VERSION_MAJOR}.${HUSKARUI_VERSION_MINOR}
    RUNTIME_OUTPUT_DIRECTORY ${HUSKARUI_LIBRARY_OUTPUT_DIRECTORY}/bin
    LIBRARY_OUTPUT_DIRECTORY ${HUSKARUI_LIBRARY_OUTPUT_DIRECTORY}/lib
    ARCHIVE_OUTPUT_DIRECTORY ${HUSKARUI_LIBRARY_OUTPUT_DIRECTORY}/lib
)

if(MINGW)
    set_target_properties(${PROJECT_NAME} PROPERTIES PREFIX "d")
    target_compile_options(${PROJECT_NAME} PRIVATE -Wa,-mbig-obj)
elseif(MSVC)
    set_target_properties(${PROJECT_NAME} PROPERTIES DEBUG_POSTFIX "d")
    target_compile_options(${PROJECT_NAME} PRIVATE $<$<CXX_COMPILER_ID:MSVC>:/utf-8;/Zi>)
endif()

target_compile_definitions(${PROJECT_NAME} PRIVATE
    BUILD_HUSKARUI_LIB
    HUSKARUI_LIBRARY_VERSION="${HUSKARUI_VERSION}"
    $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>
    $<$<BOOL:${BUILD_HUSKARUI_STATIC_LIBRARY}>:BUILD_HUSKARUI_STATIC_LIBRARY>
    $<$<BOOL:${BUILD_HUSKARUI_ON_DESKTOP_PLATFORM}>:BUILD_HUSKARUI_ON_DESKTOP_PLATFORM>
)

target_link_libraries(${PROJECT_NAME} PRIVATE
    Qt6::Quick
    Qt6::QuickPrivate
    Qt6::QuickTemplates2Private
    $<$<BOOL:${BUILD_HUSKARUI_ON_DESKTOP_PLATFORM}>:QWKCore>
    $<$<BOOL:${BUILD_HUSKARUI_ON_DESKTOP_PLATFORM}>:QWKQuick>
)

include(GNUInstallDirs)
set(INCLUDE_INSTALL_DIR ${CMAKE_INSTALL_INCLUDEDIR}) # include
set(LIB_INSTALL_DIR ${CMAKE_INSTALL_LIBDIR}) # lib
set(BIN_INSTALL_DIR ${CMAKE_INSTALL_BINDIR}) # bin
set(QML_INSTALL_DIR "qml") # qml
set(OBJ_INSTALL_DIR "obj") # obj
set(HUSKARUI_QML_INSTALL_DIR "${QML_INSTALL_DIR}/HuskarUI")
set(HUSKARUI_CONFIG_INSTALL_DIR "${LIB_INSTALL_DIR}/cmake/HuskarUI")

target_include_directories(${PROJECT_NAME} PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/cpp>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/cpp/theme>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/cpp/controls>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/cpp/utils>
    $<INSTALL_INTERFACE:${INCLUDE_INSTALL_DIR}>
    $<INSTALL_INTERFACE:${INCLUDE_INSTALL_DIR}/HuskarUI>
)

#Gen HuskarUI/include
if(HUSKARUI_HEADER_OUTPUT_DIRECTORY)
    file(COPY cpp/husglobal.h cpp/husapp.h cpp/husdefinitions.h cpp/controls cpp/theme cpp/utils
        DESTINATION ${HUSKARUI_HEADER_OUTPUT_DIRECTORY}/HuskarUI
        FILES_MATCHING PATTERN "*.h"
        PATTERN "*_p.h" EXCLUDE
    )
endif()

#Set CMake config output dir
set(HUSKARUI_CMAKE_CONFIG_DIR ${HUSKARUI_LIBRARY_OUTPUT_DIRECTORY}/lib/cmake)

include(CMakePackageConfigHelpers)

#Generate HuskarUI package config file
configure_package_config_file(
    ${CMAKE_CURRENT_SOURCE_DIR}/../.cmake/HuskarUIConfig.cmake.in
    ${HUSKARUI_CMAKE_CONFIG_DIR}/HuskarUIConfig.cmake
    PATH_VARS INCLUDE_INSTALL_DIR LIB_INSTALL_DIR QML_INSTALL_DIR
    INSTALL_DESTINATION ${HUSKARUI_CONFIG_INSTALL_DIR}
)

#Generate HuskarUI package version file
write_basic_package_version_file(
    ${HUSKARUI_CMAKE_CONFIG_DIR}/HuskarUIConfigVersion.cmake
    VERSION ${HUSKARUI_VERSION}
    COMPATIBILITY SameMinorVersion #Require target lib must has same Major and Minor version
)

install(TARGETS ${PROJECT_NAME}
    EXPORT HuskarUITargets
    RUNTIME DESTINATION ${BIN_INSTALL_DIR}
    ARCHIVE DESTINATION ${LIB_INSTALL_DIR}
    LIBRARY DESTINATION ${LIB_INSTALL_DIR}
)

install(TARGETS ${PLUGIN_NAME}
    EXPORT HuskarUITargets
    RUNTIME DESTINATION ${HUSKARUI_QML_INSTALL_DIR}/Basic
    ARCHIVE DESTINATION ${HUSKARUI_QML_INSTALL_DIR}/Basic
    LIBRARY DESTINATION ${HUSKARUI_QML_INSTALL_DIR}/Basic
)

if(BUILD_HUSKARUI_STATIC_LIBRARY)
    install(
        TARGETS ${HUSKARUI_QML_OUTPUT_TARGETS} ${HUSKARUI_THEME_OUTPUT_TARGETS}
                ${HUSKARUI_RES_OUTPUT_TARGETS} ${HUSKARUI_SHADERS_OUTPUT_TARGETS}
        EXPORT HuskarUITargets
        RUNTIME DESTINATION ${BIN_INSTALL_DIR}
        ARCHIVE DESTINATION ${LIB_INSTALL_DIR}
        LIBRARY DESTINATION ${LIB_INSTALL_DIR}
        OBJECTS DESTINATION ${OBJ_INSTALL_DIR}
    )
endif()

install(
    DIRECTORY ${HUSKARUI_HEADER_OUTPUT_DIRECTORY}/HuskarUI
    DESTINATION ${INCLUDE_INSTALL_DIR}
)

install(
    DIRECTORY ${HUSKARUI_PLUGIN_OUTPUT_DIRECTORY}
    DESTINATION ${HUSKARUI_QML_INSTALL_DIR}
)

install(
    FILES ${HUSKARUI_CMAKE_CONFIG_DIR}/HuskarUIConfig.cmake
          ${HUSKARUI_CMAKE_CONFIG_DIR}/HuskarUIConfigVersion.cmake
    DESTINATION ${HUSKARUI_CONFIG_INSTALL_DIR}
)

#Generate and install HuskarUI targets file
install(
    EXPORT HuskarUITargets
    FILE HuskarUITargets.cmake
    NAMESPACE HuskarUI::
    DESTINATION ${HUSKARUI_CONFIG_INSTALL_DIR}
)
