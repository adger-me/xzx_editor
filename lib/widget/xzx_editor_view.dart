import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:xzx_editor/widget/extensions.dart';

class XzxEditorView extends StatefulWidget {
  final HtmlEditorController controller;

  const XzxEditorView({
    Key? key,
    required this.controller
  }) : super(key: key);

  @override
  _XzxEditorViewState createState() => _XzxEditorViewState();
}

class _XzxEditorViewState extends State<XzxEditorView> {
  late HtmlEditorController _controller;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    _controller = widget.controller;
    KeyboardVisibilityController().onChange.listen((visible) {
      if (visible) {
        _overlayEntry = _createOverlayEntry();
        Overlay.of(context)?.insert(_overlayEntry!);
      } else {
        _overlayEntry?.remove();
      }
    });

    super.initState();
  }

  /// 创建工具栏
  OverlayEntry _createOverlayEntry() {
    var width = MediaQuery.of(context).size.width / 6;
    return OverlayEntry(
      builder: (context) => Positioned(
        bottom: 0,
        left: 0,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 50,
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(width: 1, color: Color(0xffeeeeee)))
          ),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildToolItem(width: width, icon: 'editor_color'),
              _buildToolItem(width: width, icon: 'editor_align'),
              _buildToolItem(width: width, icon: 'editor_emoji'),
              _buildToolItem(width: width, icon: 'editor_img'),
              _buildToolItem(width: width, icon: 'editor_video'),
              _buildToolItem(width: width, icon: 'editor_link')
            ],
          ),
        ),
      )
    );
  }

  /// 按钮
  Widget _buildToolItem({double? width, required String icon}) {
    return Container(
      width: width,
      alignment: Alignment.center,
      child: Image.asset('assets/imgs/$icon.png', package: 'xzx_editor', width: 16, height: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HtmlEditor(
          controller: _controller,
          htmlToolbarOptions: const HtmlToolbarOptions(
            toolbarType: ToolbarType.nativeExpandable,
            toolbarPosition: ToolbarPosition.custom
          ),
          htmlEditorOptions: const HtmlEditorOptions(
            hint: '请输入内容',
            shouldEnsureVisible: true,
            initialText: '',
            filePath: 'packages/xzx_editor/assets/summernote.html'
          ),
        ),
      ],
    );
  }
}