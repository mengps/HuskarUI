[← 返回主目录](../index.md)

[← 返回本类别目录](./index.md)

# HusAsyncHasher 异步散列器 


可对任意数据(url/text/object)生成加密哈希的异步散列器。

* **模块 { HuskarUI.Basic }**

* **继承自 { QObject }**


<br/>

### 支持的代理：

- 无


<br/>

### 支持的属性：

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

<br/>

### 支持的信号：

- `hashProgress(processed: int, total: int)` 散列值计算进度

  - `processed` 已处理的字节数

  - `total` 总字节数

- `started(processed: int, total: int)` 散列值计算开始时发出

- `finished(processed: int, total: int)` 散列值计算结束时发出


<br/>

## 代码演示

### 示例 1

通过 `algorithm` 属性改变使用的哈希算法，支持的算法：

- Md4{ HusAsyncHasher.Md4 }

- Md5(默认){ HusAsyncHasher.Md5 }

- Sha1{ HusAsyncHasher.Sha1 }

- Sha224{ HusAsyncHasher.Sha224 }

- Sha256{ HusAsyncHasher.Sha256 }

- Sha384{ HusAsyncHasher.Sha384 }

- Sha512{ HusAsyncHasher.Sha512 }

- Keccak_224{ HusAsyncHasher.Keccak_224 }

- Keccak_256{ HusAsyncHasher.Keccak_256 }

- Keccak_384{ HusAsyncHasher.Keccak_384 }

- Keccak_512{ HusAsyncHasher.Keccak_512 }

- RealSha3_224{ HusAsyncHasher.RealSha3_224 }

- RealSha3_256{ HusAsyncHasher.RealSha3_256 }

- RealSha3_384{ HusAsyncHasher.RealSha3_384 }

- RealSha3_512{ HusAsyncHasher.RealSha3_512 }

- Sha3_224{ HusAsyncHasher.Sha3_224 }

- Sha3_256{ HusAsyncHasher.Sha3_256 }

- Sha3_384{ HusAsyncHasher.Sha3_384 }

- Sha3_512{ HusAsyncHasher.Sha3_512 }

- Blake2b_160{ HusAsyncHasher.Blake2b_160 }

- Blake2b_256{ HusAsyncHasher.Blake2b_256 }

- Blake2b_384{ HusAsyncHasher.Blake2b_384 }

- Blake2b_512{ HusAsyncHasher.Blake2b_512 }

- Blake2s_128{ HusAsyncHasher.Blake2s_128 }

- Blake2s_160{ HusAsyncHasher.Blake2s_160 }

- Blake2s_224{ HusAsyncHasher.Blake2s_224 }

- Blake2s_256{ HusAsyncHasher.Blake2s_256 }

通过 `sourceText` 属性设置需要进行哈希计算的目标源文本。


```qml
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
```

