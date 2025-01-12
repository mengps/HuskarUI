import QtQuick
import QtQuick.Controls.Basic
import DelegateUI

import "../../Controls"

Flickable {
    contentHeight: column.height
    ScrollBar.vertical: DelScrollBar { }

    Column {
        id: column
        width: parent.width - 15
        spacing: 30

        Description {
            desc: qsTr(`
## DelAsyncHasher 异步散列器 \n
可对任意数据(url/text/object)生成加密哈希的异步散列器。\n
* **继承自 { QObject }**\n
支持的代理：\n
- 无\n
支持的属性：\n
属性名 | 类型 | 描述
------ | --- | ---
algorithm | int | 哈希算法(来自 DelAsyncHasher)
asynchronous | bool | 是否异步
hashValue | string | 目标的哈希值
hashLength | int | 目标的哈希长度
source | url | 目标的源地址
sourceText | color | 目标的源文本
sourceData | arraybuffer | 目标的源数据
sourceObject | QObject* | 目标的源目标指针
                       `)
        }

        Text {
            width: parent.width - 20
            height: implicitHeight - 10
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("代码演示")
            font {
                family: DelTheme.Primary.fontPrimaryFamily
                pixelSize: DelTheme.Primary.fontPrimarySizeHeading3
            }
            color: DelTheme.Primary.colorTextBase
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`algorithm\` 属性改变使用的哈希算法，支持的算法：\n
- Md4{ DelAsyncHasher.Md4 }\n
- Md5(默认){ DelAsyncHasher.Md5 }\n
- Sha1{ DelAsyncHasher.Sha1 }\n
- Sha224{ DelAsyncHasher.Sha224 }\n
- Sha256{ DelAsyncHasher.Sha256 }\n
- Sha384{ DelAsyncHasher.Sha384 }\n
- Sha512{ DelAsyncHasher.Sha512 }\n
- Keccak_224{ DelAsyncHasher.Keccak_224 }\n
- Keccak_256{ DelAsyncHasher.Keccak_256 }\n
- Keccak_384{ DelAsyncHasher.Keccak_384 }\n
- Keccak_512{ DelAsyncHasher.Keccak_512 }\n
- RealSha3_224{ DelAsyncHasher.RealSha3_224 }\n
- RealSha3_256{ DelAsyncHasher.RealSha3_256 }\n
- RealSha3_384{ DelAsyncHasher.RealSha3_384 }\n
- RealSha3_512{ DelAsyncHasher.RealSha3_512 }\n
- Sha3_224{ DelAsyncHasher.Sha3_224 }\n
- Sha3_256{ DelAsyncHasher.Sha3_256 }\n
- Sha3_384{ DelAsyncHasher.Sha3_384 }\n
- Sha3_512{ DelAsyncHasher.Sha3_512 }\n
- Blake2b_160{ DelAsyncHasher.Blake2b_160 }\n
- Blake2b_256{ DelAsyncHasher.Blake2b_256 }\n
- Blake2b_384{ DelAsyncHasher.Blake2b_384 }\n
- Blake2b_512{ DelAsyncHasher.Blake2b_512 }\n
- Blake2s_128{ DelAsyncHasher.Blake2s_128 }\n
- Blake2s_160{ DelAsyncHasher.Blake2s_160 }\n
- Blake2s_224{ DelAsyncHasher.Blake2s_224 }\n
- Blake2s_256{ DelAsyncHasher.Blake2s_256 }\n
通过 \`sourceText\` 属性设置需要进行哈希计算的目标源文本。\n
                       `)
            code: `
                import QtQuick
                import DelegateUI

                Column {
                    DelCopyableText {
                        text: "[Source] " + hasher.sourceText
                    }

                    DelCopyableText {
                        text: "[Result] " + hasher.hashValue
                    }

                    DelAsyncHasher {
                        id: hasher
                        algorithm: DelAsyncHasher.Md5
                        sourceText: "DelegateUI"
                    }
                }
            `
            exampleDelegate: Column {
                DelCopyableText {
                    text: "[Source] " + hasher.sourceText
                }

                DelCopyableText {
                    text: "[Result] " + hasher.hashValue
                }

                DelAsyncHasher {
                    id: hasher
                    algorithm: DelAsyncHasher.Md5
                    sourceText: "DelegateUI"
                }
            }
        }
    }
}
