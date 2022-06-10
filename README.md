# Android App Bundle 测试

## 介绍

Google 现在强制所有应用必须使用 Android App Bundle 格式发布，因此在发布版本时需要测试 Android App Bundle 安装到真机运行的效果。

> **重要提示**：从 2021 年 8 月起，新应用需要使用 [Android App Bundle](https://developer.android.google.cn/guide/app-bundle) 才能在 Google Play 中发布。现在，[Play Feature Delivery](https://developer.android.google.cn/guide/app-bundle/dynamic-delivery) 或 [Play Asset Delivery](https://developer.android.google.cn/guide/app-bundle/asset-delivery) 支持大小超过 150 MB 的新应用。

好在 Google 提供了 Android Studio 和 Google Play 用来构建 app bundle 并将其转换为 APK 的工具，因此可以方便地使用。

考虑到测试人员使用，因此有必要封装一个简单的工具包使用，简化使用的难度。

## 环境

- Windows 10 21H2
- [Java Version 8 Update 321 - Java 下载](https://www.java.com/zh-CN/download/manual.jsp)
- [bundletool 1.10.0 · google/bundletool · GitHub](https://github.com/google/bundletool/releases/tag/1.10.0)
- [SDK Platform Tools 33.0.1（2022 年 3 月）  |  Android 开发者](https://developer.android.google.cn/studio/releases/platform-tools)

## 准备

需要安装 Java，下载安装 Windows 64 位版本。

- [适用于所有操作系统的 Java 下载](https://www.java.com/zh-CN/download/manual.jsp)

下载 bundletool 1.10.0 并放到 `helper` 目录中。

- [Release 1.10.0 · google/bundletool](https://github.com/google/bundletool/releases/tag/1.10.0)

下载 Android SDK 中的 platform-tools，其中包含 adb 工具，解压到 `helper/platform-tools`  目录中。

- [SDK Platform Tools 版本说明  |  Android 开发者  |  Android Developers](https://developer.android.google.cn/studio/releases/platform-tools)

## 使用方法

1. 将签名文件放到 `key/keystore.jks`
2. 修改 `key.pwd` 内容为别名密码，`key.txt` 内容为别名，`keystore.pwd` 内容为 keystore 密码
3. 将打包好的 AAB 改名为 `app.aab` 放到目录中。
4. MuMu 模拟器，双击执行 `deploy-emulator-mumu.bat`。
5. 夜神模拟器，双击执行 `deploy-emulator-yeshen.bat`。
6. 真机，双击执行 `deploy-hardware.bat`。

## 文档

- [测试 Android App Bundle  |  Android 开发者  |  Android Developers](https://developer.android.google.cn/guide/app-bundle/test)
- [bundletool  |  Android 开发者  |  Android Developers](https://developer.android.google.cn/studio/command-line/bundletool)

## 升级

### ADB

运行需要 adb，Android SDK 自带，也可以单独安装 platform-tools。下载后替换掉 `helper` 中的同名目录。

实测 MuMu 与夜神可以使用 Android SDK 中的 adb，如果有问题可以换用模拟器自带的 adb，具体需要查看文档。

- [Android 调试桥 (adb)  |  Android 开发者 中国](https://developer.android.google.cn/studio/command-line/adb)
- [SDK Platform Tools 版本说明  |  Android 开发者 中国](https://developer.android.google.cn/studio/releases/platform-tools)

### bundletool

必须下载最新版本的 bundletool，与 Google Play 官方保持一致。下载后放到 `helper` 目录中，并同步修改脚本中的路径。

- [Releases · google/bundletool · GitHub](https://github.com/google/bundletool/releases)

## 其他

不推荐生成 apk 再安装方式，因为生成过程麻烦且必须使用命令行安装。

首先需要手动编写一份硬件的配置文件：`target-apk-set.json`
```json
{
    "supportedAbis": ["arm64-v8a", "armeabi-v7a"],
    "supportedLocales": ["en"],
    "screenDensity": 640,
    "sdkVersion": 27
}
```

由于 bundletool 在生成 APK 时会将一个应用生成为多个 APK，因此这步必须要使用命令行手动安装，与上面的一键脚本完全重复了。

```sh
java -jar bundletool-all-1.10.0.jar extract-apks --apks="app.apks" --output-dir=target-apks --device-spec=target-apk-set.json
adb install-multiple target-apks\base-arm64_v8a.apk target-apks\base-master.apk
```

