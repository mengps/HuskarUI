cmake_minimum_required(VERSION 3.16)

project(Gallery VERSION 0.1.4.0 LANGUAGES CXX)

find_package(Qt6 6.5 COMPONENTS Quick REQUIRED)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD 17)

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
        qml/Examples/DataDisplay/ExpToolTip.qml
        qml/Examples/DataDisplay/ExpTourFocus.qml
        qml/Examples/DataDisplay/ExpTourStep.qml
        qml/Examples/DataDisplay/ExpTabView.qml
        qml/Examples/Navigation/ExpMenu.qml
        qml/Examples/Navigation/ExpScrollBar.qml
        qml/Examples/Layout/ExpDivider.qml
        qml/Examples/Effect/ExpAcrylic.qml
        qml/Examples/Feedback/ExpWatermark.qml
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

target_link_libraries(${PROJECT_NAME} PRIVATE Qt6::Quick DelegateUIPlugin)

if (BUILD_DELEGATEUI_STATIC_LIBRARY)
    target_compile_definitions(${PROJECT_NAME} PRIVATE BUILD_DELEGATEUI_STATIC_LIBRARY)
endif()
