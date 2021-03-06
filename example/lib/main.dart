import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:xzx_editor/xzx_editor.dart';
import 'package:html_editor_enhanced/html_editor.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final HtmlEditorController _controller = HtmlEditorController();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await XzxEditor.platformVersion ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
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
                    return [];
                  },
                  videos: (videos) async {
                    print(videos);
                    return [
                      'https://kbit-oss.oss-cn-shenzhen.aliyuncs.com/upload/feimg/video/test_video.mp4',
                      'https://kbit-oss.oss-cn-shenzhen.aliyuncs.com/upload/feimg/video/test_video_h.mp4'
                    ];
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: const Text('aaaa'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
