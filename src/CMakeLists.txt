cmake_minimum_required(VERSION 3.16)

set(HUSKARUI_VERSION_MAJOR 0)
set(HUSKARUI_VERSION_MINOR 5)
set(HUSKARUI_VERSION_PATCH 0)
set(HUSKARUI_VERSION_TWEAK 0)
set(HUSKARUI_VERSION ${HUSKARUI_VERSION_MAJOR}.${HUSKARUI_VERSION_MINOR}.${HUSKARUI_VERSION_PATCH}.${HUSKARUI_VERSION_TWEAK})

message(STATUS "Configuring HuskarUI::Basic Version: ${HUSKARUI_VERSION}")

project(HuskarUIBasic VERSION ${HUSKARUI_VERSION} LANGUAGES CXX)

#Add HuskarUIHelper
include(${CMAKE_CURRENT_SOURCE_DIR}/../.cmake/HuskarUIHelper.cmake)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD 17)

find_package(Qt6 6.5 COMPONENTS Quick QuickTemplates2 ShaderTools REQUIRED)
qt_standard_project_setup(REQUIRES 6.5)

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
if(NOT HUSKARUI_INSTALL_DIRECTORY)
    if(INSTALL_HUSKARUI_IN_DEFAULT_LOCATION)
        set(HUSKARUI_INSTALL_DIRECTORY ${Qt6_DIR}/../../../)
    else()
        set(HUSKARUI_INSTALL_DIRECTORY ${CMAKE_INSTALL_PREFIX})
    endif()
endif()

message(STATUS "The HuskarUI header output dir: ${HUSKARUI_HEADER_OUTPUT_DIRECTORY}")
message(STATUS "The HuskarUI library output dir: ${HUSKARUI_LIBRARY_OUTPUT_DIRECTORY}/bin|lib")
message(STATUS "The HuskarUI plugin output dir: ${HUSKARUI_PLUGIN_OUTPUT_DIRECTORY}")
message(STATUS "The HuskarUI install dir: ${HUSKARUI_INSTALL_DIRECTORY}")

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

qt_add_qml_module(${PROJECT_NAME}
    URI "HuskarUI.Basic"
    VERSION 1.0
    DESIGNER_SUPPORTED
    PLUGIN_TARGET ${PLUGIN_NAME}
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
        imports/HusInputNumber.qml
        imports/HusImage.qml
        imports/HusImagePreview.qml
        imports/HusMultiSelect.qml
        imports/HusDateTimePicker.qml
        imports/HusShadow.qml
        imports/HusNotification.qml
        imports/HusPopconfirm.qml
        imports/HusPopover.qml
        imports/HusModal.qml
        imports/HusTextArea.qml
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
    FILES
        theme/Index.json
        theme/HusButton.json
        theme/HusCaptionButton.json
        theme/HusTour.json
        theme/HusIconText.json
        theme/HusCopyableText.json
        theme/HusMenu.json
        theme/HusDivider.json
        theme/HusEmpty.json
        theme/HusSwitch.json
        theme/HusScrollBar.json
        theme/HusSlider.json
        theme/HusTabView.json
        theme/HusToolTip.json
        theme/HusSelect.json
        theme/HusMultiSelect.json
        theme/HusInput.json
        theme/HusRate.json
        theme/HusRadio.json
        theme/HusCheckBox.json
        theme/HusDrawer.json
        theme/HusCollapse.json
        theme/HusCard.json
        theme/HusPagination.json
        theme/HusPopup.json
        theme/HusTimeline.json
        theme/HusTag.json
        theme/HusTableView.json
        theme/HusMessage.json
        theme/HusAutoComplete.json
        theme/HusProgress.json
        theme/HusCarousel.json
        theme/HusBreadcrumb.json
        theme/HusImage.json
        theme/HusDateTimePicker.json
        theme/HusNotification.json
        theme/HusPopconfirm.json
        theme/HusPopover.json
        theme/HusModal.json
        theme/HusTextArea.json
)

qt_add_resources(${PROJECT_NAME} "resources"
    PREFIX "/HuskarUI"
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
    FILES
        shaders/husrate.frag
)

# HuskarUI library output dir
set_target_properties(${PROJECT_NAME} PROPERTIES
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

target_include_directories(${PROJECT_NAME} PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/cpp/theme
    ${CMAKE_CURRENT_SOURCE_DIR}/cpp/controls
    ${CMAKE_CURRENT_SOURCE_DIR}/cpp/utils
)

#Gen HuskarUI/include
if(HUSKARUI_HEADER_OUTPUT_DIRECTORY)
    file(COPY cpp/husglobal.h cpp/husapp.h cpp/husdefinitions.h cpp/controls cpp/theme cpp/utils
        DESTINATION ${HUSKARUI_HEADER_OUTPUT_DIRECTORY}/HuskarUI
        FILES_MATCHING PATTERN "*.h"
        PATTERN "*_p.h" EXCLUDE
    )
endif()

# 生成 CMake 配置文件
set(HUSKARUI_CMAKE_CONFIG_DIR ${HUSKARUI_LIBRARY_OUTPUT_DIRECTORY}/lib/cmake)
file(MAKE_DIRECTORY ${HUSKARUI_CMAKE_CONFIG_DIR})

# 配置 HuskarUIConfig.cmake
configure_file(
    ${CMAKE_CURRENT_SOURCE_DIR}/../.cmake/HuskarUIConfig.cmake.in
    ${HUSKARUI_CMAKE_CONFIG_DIR}/HuskarUIConfig.cmake
    @ONLY
)

# 配置 HuskarUIConfigVersion.cmake
configure_file(
    ${CMAKE_CURRENT_SOURCE_DIR}/../.cmake/HuskarUIConfigVersion.cmake.in
    ${HUSKARUI_CMAKE_CONFIG_DIR}/HuskarUIConfigVersion.cmake
    @ONLY
)

# 配置 HuskarUITargets.cmake
configure_file(
    ${CMAKE_CURRENT_SOURCE_DIR}/../.cmake/HuskarUITargets.cmake.in
    ${HUSKARUI_CMAKE_CONFIG_DIR}/HuskarUITargets.cmake
    @ONLY
)

# 生成 HuskarUITargets-*.cmake 文件（用于不同配置）
if(CMAKE_CONFIGURATION_TYPES)
    # 多配置生成器（如 Visual Studio）
    foreach(config ${CMAKE_CONFIGURATION_TYPES})
        string(TOUPPER ${config} config_upper)
        configure_file(
            ${CMAKE_CURRENT_SOURCE_DIR}/../.cmake/HuskarUITargets.cmake.in
            ${HUSKARUI_CMAKE_CONFIG_DIR}/HuskarUITargets-${config}.cmake
            @ONLY
        )
    endforeach()
else()
    # 单配置生成器
    if(CMAKE_BUILD_TYPE)
        configure_file(
            ${CMAKE_CURRENT_SOURCE_DIR}/../.cmake/HuskarUITargets.cmake.in
            ${HUSKARUI_CMAKE_CONFIG_DIR}/HuskarUITargets-${CMAKE_BUILD_TYPE}.cmake
            @ONLY
        )
    else()
        configure_file(
            ${CMAKE_CURRENT_SOURCE_DIR}/../.cmake/HuskarUITargets.cmake.in
            ${HUSKARUI_CMAKE_CONFIG_DIR}/HuskarUITargets-Release.cmake
            @ONLY
        )
    endif()
endif()

install(TARGETS ${PROJECT_NAME}
    RUNTIME DESTINATION ${HUSKARUI_INSTALL_DIRECTORY}/bin
    ARCHIVE DESTINATION ${HUSKARUI_INSTALL_DIRECTORY}/lib
    LIBRARY DESTINATION ${HUSKARUI_INSTALL_DIRECTORY}/lib
)

install(
    FILES cpp/husglobal.h cpp/husapp.h cpp/husdefinitions.h
    DESTINATION ${HUSKARUI_INSTALL_DIRECTORY}/include/HuskarUI
)

install(
    DIRECTORY cpp/controls cpp/theme cpp/utils
    DESTINATION ${HUSKARUI_INSTALL_DIRECTORY}/include/HuskarUI
    FILES_MATCHING PATTERN "*.h"
    PATTERN "*_p.h" EXCLUDE
)

install(
    DIRECTORY ${HUSKARUI_PLUGIN_OUTPUT_DIRECTORY}/imports
    DESTINATION ${HUSKARUI_INSTALL_DIRECTORY}/qml/HuskarUI/Basic
)

install(
    FILES
        ${HUSKARUI_PLUGIN_OUTPUT_DIRECTORY}/qmldir
        ${HUSKARUI_PLUGIN_OUTPUT_DIRECTORY}/plugins.qmltypes
        ${HUSKARUI_PLUGIN_OUTPUT_DIRECTORY}/HuskarUIBasic_qml_module_dir_map.qrc
    DESTINATION ${HUSKARUI_INSTALL_DIRECTORY}/qml/HuskarUI/Basic
)

if(WIN32)
    if(CMAKE_GENERATOR MATCHES "Visual Studio [0-9]+ [0-9]+")
        if(MSVC)
            install(
                FILES ${HUSKARUI_PLUGIN_OUTPUT_DIRECTORY}/Release/huskaruibasicplugin.lib
                DESTINATION ${HUSKARUI_INSTALL_DIRECTORY}/qml/HuskarUI/Basic
                CONFIGURATIONS Release
            )

            install(
                FILES ${HUSKARUI_PLUGIN_OUTPUT_DIRECTORY}/Debug/huskaruibasicplugin.lib
                DESTINATION ${HUSKARUI_INSTALL_DIRECTORY}/qml/HuskarUI/Basic
                CONFIGURATIONS Debug
            )
        endif()
        if(NOT BUILD_HUSKARUI_STATIC_LIBRARY)
            install(
                FILES ${CMAKE_CURRENT_BINARY_DIR}/Release/huskaruibasicplugin.dll
                DESTINATION ${HUSKARUI_INSTALL_DIRECTORY}/qml/HuskarUI/Basic
                CONFIGURATIONS Release
            )

            install(
                FILES ${CMAKE_CURRENT_BINARY_DIR}/huskaruibasicplugin.dll
                DESTINATION ${HUSKARUI_INSTALL_DIRECTORY}/qml/HuskarUI/Basic
                CONFIGURATIONS Debug
                RENAME huskaruibasicplugind.dll
            )
        endif()
    else()
        if(MSVC)
            install(
                FILES ${HUSKARUI_PLUGIN_OUTPUT_DIRECTORY}/huskaruibasicplugin.lib
                DESTINATION ${HUSKARUI_INSTALL_DIRECTORY}/qml/HuskarUI/Basic
                CONFIGURATIONS Release
            )

            install(
                FILES ${HUSKARUI_PLUGIN_OUTPUT_DIRECTORY}/huskaruibasicplugin.lib
                DESTINATION ${HUSKARUI_INSTALL_DIRECTORY}/qml/HuskarUI/Basic
                CONFIGURATIONS Debug
            )
        endif()
        if(NOT BUILD_HUSKARUI_STATIC_LIBRARY)
            install(
                FILES ${HUSKARUI_PLUGIN_OUTPUT_DIRECTORY}/huskaruibasicplugin.dll
                DESTINATION ${HUSKARUI_INSTALL_DIRECTORY}/qml/HuskarUI/Basic
                CONFIGURATIONS Release
            )

            install(
                FILES ${HUSKARUI_PLUGIN_OUTPUT_DIRECTORY}/huskaruibasicplugin.dll
                DESTINATION ${HUSKARUI_INSTALL_DIRECTORY}/qml/HuskarUI/Basic
                CONFIGURATIONS Debug
                RENAME huskaruibasicplugind.dll
            )
        endif()
    endif()
endif()


# 安装 CMake 配置文件
install(
    FILES ${HUSKARUI_CMAKE_CONFIG_DIR}/HuskarUIConfig.cmake
          ${HUSKARUI_CMAKE_CONFIG_DIR}/HuskarUIConfigVersion.cmake
          ${HUSKARUI_CMAKE_CONFIG_DIR}/HuskarUITargets.cmake
    DESTINATION ${HUSKARUI_INSTALL_DIRECTORY}/lib/cmake/HuskarUI
)

# 安装不同配置的 HuskarUITargets-*.cmake 文件
if(CMAKE_CONFIGURATION_TYPES)
    foreach(config ${CMAKE_CONFIGURATION_TYPES})
        install(
            FILES ${HUSKARUI_CMAKE_CONFIG_DIR}/HuskarUITargets-${config}.cmake
            DESTINATION ${HUSKARUI_INSTALL_DIRECTORY}/lib/cmake/HuskarUI
        )
    endforeach()
else()
    if(CMAKE_BUILD_TYPE)
        install(
            FILES ${HUSKARUI_CMAKE_CONFIG_DIR}/HuskarUITargets-${CMAKE_BUILD_TYPE}.cmake
            DESTINATION ${HUSKARUI_INSTALL_DIRECTORY}/lib/cmake/HuskarUI
        )
    else()
        install(
            FILES ${HUSKARUI_CMAKE_CONFIG_DIR}/HuskarUITargets-Release.cmake
            DESTINATION ${HUSKARUI_INSTALL_DIRECTORY}/lib/cmake/HuskarUI
        )
    endif()
endif()
