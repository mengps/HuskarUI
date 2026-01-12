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
# HusAsyncHasher 异步散列器 \n
可对任意数据(url/text/object)生成加密哈希的异步散列器。\n
* **继承自 { QObject }**\n
\n<br/>
\n### 支持的代理：\n
- 无\n
\n<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
algorithm | enum | HusAsyncHasher.Md5 | 哈希算法(来自 HusAsyncHasher)
asynchronous | bool | true | 是否异步
hashValue | string | '' | 目标的哈希值
hashLength | int | - | 目标的哈希长度
source | url | '' | 目标的源地址
sourceText | color | '' | 目标的源文本
sourceData | arraybuffer | '' | 目标的源数据
sourceObject | QObject* | null | 目标的源指针
\n<br/>
\n### 支持的信号：\n
- \`hashProgress(processed: int, total: int)\` 散列值计算进度\n
  - \`processed\` 已处理的字节数\n
  - \`total\` 总字节数\n
- \`started(processed: int, total: int)\` 散列值计算开始时发出\n
- \`finished(processed: int, total: int)\` 散列值计算结束时发出\n
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
当需要对(url/text/object)生成加密哈希时使用。\n
                       `)
        }

        ThemeToken { }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`algorithm\` 属性改变使用的哈希算法，支持的算法：\n
- Md4{ HusAsyncHasher.Md4 }\n
- Md5(默认){ HusAsyncHasher.Md5 }\n
- Sha1{ HusAsyncHasher.Sha1 }\n
- Sha224{ HusAsyncHasher.Sha224 }\n
- Sha256{ HusAsyncHasher.Sha256 }\n
- Sha384{ HusAsyncHasher.Sha384 }\n
- Sha512{ HusAsyncHasher.Sha512 }\n
- Keccak_224{ HusAsyncHasher.Keccak_224 }\n
- Keccak_256{ HusAsyncHasher.Keccak_256 }\n
- Keccak_384{ HusAsyncHasher.Keccak_384 }\n
- Keccak_512{ HusAsyncHasher.Keccak_512 }\n
- RealSha3_224{ HusAsyncHasher.RealSha3_224 }\n
- RealSha3_256{ HusAsyncHasher.RealSha3_256 }\n
- RealSha3_384{ HusAsyncHasher.RealSha3_384 }\n
- RealSha3_512{ HusAsyncHasher.RealSha3_512 }\n
- Sha3_224{ HusAsyncHasher.Sha3_224 }\n
- Sha3_256{ HusAsyncHasher.Sha3_256 }\n
- Sha3_384{ HusAsyncHasher.Sha3_384 }\n
- Sha3_512{ HusAsyncHasher.Sha3_512 }\n
- Blake2b_160{ HusAsyncHasher.Blake2b_160 }\n
- Blake2b_256{ HusAsyncHasher.Blake2b_256 }\n
- Blake2b_384{ HusAsyncHasher.Blake2b_384 }\n
- Blake2b_512{ HusAsyncHasher.Blake2b_512 }\n
- Blake2s_128{ HusAsyncHasher.Blake2s_128 }\n
- Blake2s_160{ HusAsyncHasher.Blake2s_160 }\n
- Blake2s_224{ HusAsyncHasher.Blake2s_224 }\n
- Blake2s_256{ HusAsyncHasher.Blake2s_256 }\n
通过 \`sourceText\` 属性设置需要进行哈希计算的目标源文本。\n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Column {
                    HusCopyableText {
                        text: '[Source] ' + hasher.sourceText
                    }

                    HusCopyableText {
                        text: '[Result] ' + hasher.hashValue
                    }

                    HusAsyncHasher {
                        id: hasher
                        algorithm: HusAsyncHasher.Md5
                        sourceText: 'HuskarUI'
                    }
                }
            `
            exampleDelegate: Column {
                HusCopyableText {
                    text: '[Source] ' + hasher.sourceText
                }

                HusCopyableText {
                    text: '[Result] ' + hasher.hashValue
                }

                HusAsyncHasher {
                    id: hasher
                    algorithm: HusAsyncHasher.Md5
                    sourceText: 'HuskarUI'
                }
            }
        }
    }
}
