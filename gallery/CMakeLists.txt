cmake_minimum_required(VERSION 3.16)

set(DELEGATEUI_VERSION 0.2.1.0)

project(Gallery VERSION ${DELEGATEUI_VERSION} LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD 17)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/bin/${CMAKE_BUILD_TYPE})

find_package(Qt6 6.5 COMPONENTS Quick REQUIRED)
qt_standard_project_setup(REQUIRES 6.5)

#Add DeleagteUIHelper
include(${CMAKE_CURRENT_LIST_DIR}/../.cmake/DelegateUIHelper.cmake)

set(GALLERY_RC_FILE "")
if (WIN32)
    set(GALLERY_RC_FILE ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}_Resource.rc)
    del_add_win_rc(${PROJECT_NAME}
        COMMENTS "DelegateUI Gallery"
        NAME "${PROJECT_NAME}.exe"
        COMPANY "DelegateUI"
        DESCRIPTION ""
        VERSION "${PROJECT_VERSION}"
        COPYRIGHT "Copyright (C) 2025 mengps. All rights reserved."
        ICONS ../resources/delegateui_icon.ico
        OUTPUT_FILE "${GALLERY_RC_FILE}"
    )
endif()

qt_add_executable(${PROJECT_NAME})
qt_add_qml_module(${PROJECT_NAME}
    URI Gallery
    VERSION 1.0
    OUTPUT_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
    RESOURCE_PREFIX "/"
    QML_FILES
        qml/Examples/General/ExpWindow.qml
        qml/Examples/General/ExpButton.qml
        qml/Examples/General/ExpIconButton.qml
        qml/Examples/General/ExpCaptionButton.qml
        qml/Examples/General/ExpIconText.qml
        qml/Examples/General/ExpCopyableText.qml
        qml/Examples/General/ExpRectangle.qml
        qml/Examples/DataEntry/ExpSwitch.qml
        qml/Examples/DataEntry/ExpSlider.qml
        qml/Examples/DataEntry/ExpSelect.qml
        qml/Examples/DataEntry/ExpInput.qml
        qml/Examples/DataEntry/ExpOTPInput.qml
        qml/Examples/DataEntry/ExpRate.qml
        qml/Examples/DataEntry/ExpRadio.qml
        qml/Examples/DataEntry/ExpRadioBlock.qml
        qml/Examples/DataEntry/ExpCheckBox.qml
        qml/Examples/DataEntry/ExpTimePicker.qml
        qml/Examples/DataDisplay/ExpToolTip.qml
        qml/Examples/DataDisplay/ExpTourFocus.qml
        qml/Examples/DataDisplay/ExpTourStep.qml
        qml/Examples/DataDisplay/ExpTabView.qml
        qml/Examples/DataDisplay/ExpCollapse.qml
        qml/Examples/DataDisplay/ExpAvatar.qml
        qml/Examples/DataDisplay/ExpCard.qml
        qml/Examples/Navigation/ExpMenu.qml
        qml/Examples/Navigation/ExpScrollBar.qml
        qml/Examples/Navigation/ExpPagination.qml
        qml/Examples/Layout/ExpDivider.qml
        qml/Examples/Effect/ExpAcrylic.qml
        qml/Examples/Feedback/ExpWatermark.qml
        qml/Examples/Feedback/ExpDrawer.qml
        qml/Examples/Utils/ExpAsyncHasher.qml
        qml/Examples/Theme/ExpTheme.qml
        qml/Controls/CodeBox.qml
        qml/Controls/Description.qml
        qml/Controls/CodeRunner.qml
        qml/Gallery.qml
        qml/HomePage.qml
        qml/AboutPage.qml
        qml/SettingsPage.qml
    SOURCES
        $<$<BOOL:${WIN32}>:${GALLERY_RC_FILE}>
        cpp/customtheme.h cpp/customtheme.cpp
        cpp/main.cpp
    RESOURCES
        ../UpdateLists.json
)

qt_add_shaders(${PROJECT_NAME} "shaders"
    PREFIX "/Gallery"
    FILES
        shaders/effect1.vert
        shaders/effect1.frag
        shaders/effect2.vert
        shaders/effect2.frag
)

set_target_properties(${PROJECT_NAME} PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER delegateui.com
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_include_directories(${PROJECT_NAME} PRIVATE
    cpp
)

target_link_libraries(${PROJECT_NAME} PRIVATE 
    Qt6::Quick
    DelegateUI
)

if (BUILD_DELEGATEUI_STATIC_LIBRARY)
    target_compile_definitions(${PROJECT_NAME} PRIVATE BUILD_DELEGATEUI_STATIC_LIBRARY)
endif()

# Deploy Script
if(CMAKE_BUILD_TYPE MATCHES "Release")
    if(APPLE)
        find_program(QT_DEPLOY_QT NAMES macdeployqt)
        add_custom_target(Script-DeployRelease
                COMMAND ${CMAKE_COMMAND} -E remove_directory ${CMAKE_SOURCE_DIR}/package
                COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_RUNTIME_OUTPUT_DIRECTORY} ${CMAKE_SOURCE_DIR}/package
                COMMAND ${QT_DEPLOY_QT} ${CMAKE_SOURCE_DIR}/package/${PROJECT_NAME}.app -qmldir=${CMAKE_CURRENT_LIST_DIR}
                COMMENT "MacOs Deploying Qt Dependencies After Build........."
                SOURCES ${CMAKE_CURRENT_SOURCE_DIR}/CMakeLists.txt
                WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
        )
        add_dependencies(Script-DeployRelease ${PROJECT_NAME})
    endif()
    if(WIN32)
        find_program(QT_DEPLOY_QT NAMES windeployqt)
        add_custom_target(Script-DeployRelease
                COMMAND ${CMAKE_COMMAND} -E remove_directory ${CMAKE_SOURCE_DIR}/package
                COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_RUNTIME_OUTPUT_DIRECTORY} ${CMAKE_SOURCE_DIR}/package
                COMMAND ${CMAKE_COMMAND} -E rm -f "${CMAKE_SOURCE_DIR}/package/${PROJECT_NAME}.qmltypes"
                COMMAND ${CMAKE_COMMAND} -E rm -f "${CMAKE_SOURCE_DIR}/package/${PROJECT_NAME}_qml_module_dir_map.qrc"
                COMMAND ${CMAKE_COMMAND} -E rm -f "${CMAKE_SOURCE_DIR}/package/qmldir"
                COMMAND ${CMAKE_COMMAND} -E copy ${Qt6_DIR}/../../../bin/DelegateUI.dll ${CMAKE_SOURCE_DIR}/package
                COMMAND ${QT_DEPLOY_QT} --qmldir=${CMAKE_CURRENT_LIST_DIR} --plugindir=${CMAKE_SOURCE_DIR}/package/plugins --no-translations --compiler-runtime ${CMAKE_SOURCE_DIR}/package/${PROJECT_NAME}.exe
                COMMENT "Windows Deploying Qt Dependencies After Build........."
                SOURCES ${CMAKE_CURRENT_SOURCE_DIR}/CMakeLists.txt
                WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
        )
        add_dependencies(Script-DeployRelease ${PROJECT_NAME})
    endif()
endif()
