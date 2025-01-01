cmake_minimum_required(VERSION 3.16)

project(Gallery VERSION 1.0 LANGUAGES CXX)

find_package(Qt6 6.5 COMPONENTS Quick REQUIRED)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD 17)

qt_add_executable(${PROJECT_NAME})
qt_add_qml_module(${PROJECT_NAME}
    URI Gallery
    VERSION 1.0
    RESOURCE_PREFIX "/"
    QML_FILES
        qml/Examples/General/ExpButton.qml
        qml/Examples/General/ExpIconButton.qml
        qml/Examples/General/ExpCaptionButton.qml
        qml/Examples/General/ExpIconText.qml
        qml/Examples/DataEntry/ExpSwitch.qml
        qml/Examples/DataEntry/ExpSlider.qml
        qml/Examples/DataDisplay/ExpTourFocus.qml
        qml/Examples/DataDisplay/ExpTourStep.qml
        qml/Examples/DataDisplay/ExpTabView.qml
        qml/Examples/Navigation/ExpMenu.qml
        qml/Examples/Navigation/ExpScrollBar.qml
        qml/Examples/Layout/ExpDivider.qml
        qml/Examples/Theme/ExpTheme.qml
        qml/Controls/CodeBox.qml
        qml/Controls/Description.qml
        qml/Controls/CodeRunner.qml
        qml/Gallery.qml
        qml/HomePage.qml
        qml/SettingsPage.qml
    SOURCES
        cpp/customtheme.h cpp/customtheme.cpp
        cpp/main.cpp
    RESOURCES
)

qt_add_shaders(${PROJECT_NAME} "shaders"
    PREFIX "/Gallery"
    FILES
        shaders/effect1.vert
        shaders/effect1.frag
)

target_include_directories(${PROJECT_NAME} PRIVATE
    cpp
)

target_link_libraries(${PROJECT_NAME} PRIVATE Qt6::Quick DelegateUIPlugin)

if (BUILD_DELEGATEUI_STATIC_LIBRARY)
    target_compile_definitions(${PROJECT_NAME} PRIVATE BUILD_DELEGATEUI_STATIC_LIBRARY)
endif()
