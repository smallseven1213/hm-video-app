# shared

A new Flutter plugin project.

## Flutter 官方 Getting Started

This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter development, view the
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

The plugin project was generated without specifying the `--platforms` flag, no platforms are currently supported.
To add platforms, run `flutter create -t plugin --platforms <platforms> .` in this directory.
You can also find a detailed instruction on how to add platforms in the `pubspec.yaml` at https://flutter.dev/docs/development/packages-and-plugins/developing-packages#plugin-platforms.

## 給Member的 Getting Started

### Shared 專案資料夾架構
- features/**/*.dart     各個共用頁面Page
- models/**/*_model.dart       各個Class型別
- controllers/**/**_controller.dart   GetX Obs Controllers
- services/**/*_service.dart   Service
- utils/**/*.dart               Util工具

### App端引用範例
in App pubspec example:
```
dev_dependencies:
  shared:
    path: ../../path
```


### Ref
- [Flutter Plugin and Package](https://juejin.cn/post/7041504300933054478)
- [Melos Example](https://github.com/nilsreichardt/codemagic_monorepo_example/blob/main/apps/counter_app/pubspec.yaml)