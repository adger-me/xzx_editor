# xzx_editor

此项目是 `html_editor_enhanced` 项目的封装，还在完善中，基本可以使用（图片、视频需要根据自己的业务自定义上传然后回调返回地址）

## 安装
```
pubspec.yaml

dependencies:
  xzx_editor:
    git: https://github.com/adger-me/xzx_editor.git

```

## 使用

```dart
/// 初始化
final HtmlEditorController _controller = HtmlEditorController();

/// 使用
Scaffold(
    appBar: AppBar(
      title: const Text('富文本编辑器'),
    ),
    body: SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 500,
            child: XzxEditorView(
              controller: _controller,
              images: (images) async {
                print(images);
                /// 这里返回 图片地址
                return ['xxx.jpg', 'aaa.png'];
              },
              videos: (videos) async {
                print(videos);
                /// 这里返回 视频链接
                return ['xxx.mp4', 'aaa.mp4'];
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: const Text('其他内容'),
          )
        ],
      ),
    ),
)

/// 获取内容
await _controller.getText();
```
