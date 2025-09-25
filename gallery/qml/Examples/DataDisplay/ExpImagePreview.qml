import QtQuick
import QtQuick.Controls.Basic
import HuskarUI.Basic

import '../../Controls'

Flickable {
    contentHeight: column.height
    ScrollBar.vertical: HusScrollBar { }

    Column {
        id: column
        width: parent.width - 15
        spacing: 30

        Description {
            desc: qsTr(`
# HusImagePreview 图片预览\n
用于预览的图片的基本工具，提供常用的图片变换(平移/缩放/翻转/旋转)操作。\n
* **继承自 { [HusPopup](internal://HusPopup) }**\n
\n<br/>
\n### 支持的代理：\n
- **sourceDelegate: Component** 预览源项目代理(可以是 \`Image/AnimatedImage/Video\` 等)，必须提供 \`sourceSize\` 属性，代理可访问属性：\n
  - \`sourceUrl: url\` 源url\n
- **closeDelegate: Component** 关闭按钮代理。\n
- **prevDelegate: Component** 前一幅按钮代理。\n
- **nextDelegate: Component** 后一幅按钮代理。\n
- **indicatorDelegate: Component** 索引指示器代理。\n
- **operationDelegate: Component** 操作区域代理。\n
\n<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | HusTheme.animationEnabled | 是否开启动画
scaleMin | real | 1.0 | 最小缩放值
scaleMax | real | 5.0 | 最大缩放值
scaleStep | real | 0.5 | 缩放步长
currentScale | real(readonly) | - | 当前缩放值
currentRotation | real(readonly) | - | 当前旋转(角度)值
currentIndex | int | - | 当前图片索引
count | int(readonly) | - | 当前图片数量
\n<br/>
\n### {items}支持的属性：\n
属性名 | 类型 | 可选/必选 | 描述
------ | --- | :---: | ---
url | url | 必选 | 图片源
\n<br/>
\n### 支持的函数：\n
- \`get(index: int): Object\` 获取 \`index\` 处的模型数据 \n
- \`set(index: int, object: Object)\` 设置 \`index\` 处的模型数据为 \`object\` \n
- \`setProperty(index: int, propertyName: string, value: any)\` 设置 \`index\` 处的模型数据属性名 \`propertyName\` 值为 \`value\` \n
- \`move(from: int, to: int, count: int = 1)\` 将 \`count\` 个模型数据从 \`from\` 位置移动到 \`to\` 位置 \n
- \`insert(index: int, object: Object)\` 插入图片项 \`object\` 到 \`index\` 处 \n
- \`append(object: Object)\` 在末尾添加图片项 \`object\` \n
- \`remove(index: int, count: int = 1)\` 删除 \`index\` 处 \`count\` 个模型数据 \n
- \`zoomIn()\` 中心放大 \n
- \`zoomOut()\` 中心缩小 \n
- \`flipX()\` 水平翻转 \n
- \`flipY()\` 垂直翻转 \n
- \`rotate(angle: real)\` 顺时针旋转 \`angle\` 度 \n
- \`resetTransform()\` 重置所有变换 \n
- \`incrementCurrentIndex()\` 当前索引增1 \n
- \`decrementCurrentIndex()\` 当前索引减1 \n
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
- 需要预览一系列图片时和用户常用变换时使用。\n
                       `)
        }

        ThemeToken {
            source: 'HusImage'
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('基本用法')
            desc: qsTr(`
基本用法在 [HusImage](internal://HusImage) 中已有示例。\n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Column {
                    spacing: 10

                    HusButton {
                        text: 'Show image preview'
                        type: HusButton.Type_Primary
                        onClicked: {
                            imagePreview.open();
                        }
                    }

                    HusImagePreview {
                        id: imagePreview
                        items: [
                            { url: 'https://gw.alipayobjects.com/zos/antfincdn/LlvErxo8H9/photo-1503185912284-5271ff81b9a8.webp' },
                            { url: 'https://gw.alipayobjects.com/zos/antfincdn/cV16ZqzMjW/photo-1473091540282-9b846e7965e3.webp' },
                            { url: 'https://gw.alipayobjects.com/zos/antfincdn/x43I27A55%26/photo-1438109491414-7198515b166b.webp' },
                        ]
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                HusButton {
                    text: 'Show image preview'
                    type: HusButton.Type_Primary
                    onClicked: {
                        imagePreview.open();
                    }
                }

                HusImagePreview {
                    id: imagePreview
                    items: [
                        { url: 'https://gw.alipayobjects.com/zos/antfincdn/LlvErxo8H9/photo-1503185912284-5271ff81b9a8.webp' },
                        { url: 'https://gw.alipayobjects.com/zos/antfincdn/cV16ZqzMjW/photo-1473091540282-9b846e7965e3.webp' },
                        { url: 'https://gw.alipayobjects.com/zos/antfincdn/x43I27A55%26/photo-1438109491414-7198515b166b.webp' },
                    ]
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('高级用法')
            desc: qsTr(`
可以通过 \`sourceDelegate\` 将预览项替换为其他组件。\n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Column {
                    spacing: 10

                    HusButton {
                        text: 'Show gif image preview'
                        type: HusButton.Type_Primary
                        onClicked: {
                            gifPreview.open();
                        }
                    }

                    HusImagePreview {
                        id: gifPreview
                        sourceDelegate: AnimatedImage {
                            source: sourceUrl
                            fillMode: Image.PreserveAspectFit
                            onStatusChanged: {
                                if (status == Image.Ready)
                                    gifPreview.resetTransform();
                            }
                        }
                        items: [
                            { url: 'https://gw.alipayobjects.com/zos/rmsportal/LyTPSGknLUlxiVdwMWyu.gif' },
                            { url: 'https://gw.alipayobjects.com/zos/rmsportal/SQOZVQVIossbXpzDmihu.gif' },
                            { url: 'https://gw.alipayobjects.com/zos/rmsportal/OkIXkscKxywYLSrilPIf.gif' },
                        ]
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                HusButton {
                    text: 'Show gif image preview'
                    type: HusButton.Type_Primary
                    onClicked: {
                        gifPreview.open();
                    }
                }

                HusImagePreview {
                    id: gifPreview
                    sourceDelegate: AnimatedImage {
                        source: sourceUrl
                        fillMode: Image.PreserveAspectFit
                        onStatusChanged: {
                            if (status == Image.Ready)
                                gifPreview.resetTransform();
                        }
                    }
                    items: [
                        { url: 'https://gw.alipayobjects.com/zos/rmsportal/LyTPSGknLUlxiVdwMWyu.gif' },
                        { url: 'https://gw.alipayobjects.com/zos/rmsportal/SQOZVQVIossbXpzDmihu.gif' },
                        { url: 'https://gw.alipayobjects.com/zos/rmsportal/OkIXkscKxywYLSrilPIf.gif' },
                    ]
                }
            }
        }
    }
}
