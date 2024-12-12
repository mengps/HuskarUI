<div align=center>
<img width=64 src="resources/delegateui_icon.svg">

# 「 DelegateUI 」 Modern UI for Qml 

Ant Design component library for Qt QML

If you need Qt5 impl [DelegateUI for Qt5](https://github.com/mengps/QmlControls)

</div>

<div align=center>

![win-badge] [![Issues][issues-image]][issues-url]

English | [中文](./README-zh_CN.md)

</div>

[win-badge]: https://img.shields.io/badge/Windows-passing-brightgreen?style=flat-square

[issues-image]: https://flat.badgen.net/github/label-issues/mengps/DelegateUI/open
[issues-url]: https://github.com/mengps/DelegateUI/issues

<div align=center>

## 🌈 Gallery Preview

<img width=800 height=500 src="preview/light.png">
<img width=800 height=500 src="preview/dark.png">

</div>

## ✨ Features

- 📦 A set of high-quality Qml components out of the box.
- 🎨 Powerful theme customization system.

## 🔨 How to Build

- Clone
```auto
git clone --recursive https://github.com/mengps/DelegateUI.git
```
- Build
```cmake
cd DelegateUI
cmake -S . -B build 
cmake --build build --config Release --target all --parallel
```
- Install
```cmake
cmake --intall --prefix <install_dir>
```

## 💓 LICENSE

Use `MIT LICENSE`

## 🌇 Environment

Windows 11, Qt 6.7.3