import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:xzx_editor/widget/extensions.dart';

class XzxEditorView extends StatefulWidget {
  final HtmlEditorController controller;
  final Future<List<String>> Function(List<File> images)? images;
  final Future<List<String>> Function(List<File> videos)? videos;
  final double? height;
  final Callbacks? callbacks;

  const XzxEditorView({
    Key? key,
    required this.controller,
    this.images,
    this.videos,
    this.height,
    this.callbacks
  }) : super(key: key);

  @override
  _XzxEditorViewState createState() => _XzxEditorViewState();
}

class _XzxEditorViewState extends State<XzxEditorView> {
  late HtmlEditorController _controller;
  OverlayEntry? _overlayEntry;
  OverlayEntry? _secondOverlayEntry;
  final List<int> _selected = [0, 0];

  @override
  void initState() {
    _controller = widget.controller;
    KeyboardVisibilityController().onChange.listen((visible) {
      if (visible && mounted) {
        _overlayEntry = _createOverlayEntry(_mainToolBar());
        Overlay.of(context)?.insert(_overlayEntry!);
      } else {
        _overlayEntry?.remove();
        _overlayEntry = null;
        _secondOverlayEntry?.remove();
        _secondOverlayEntry = null;
      }
    });

    super.initState();
  }

  /// 创建浮动
  OverlayEntry _createOverlayEntry(Widget child, {double bottom = 0}) {
    return OverlayEntry(
      builder: (context) => Positioned(
        /// 键盘高度
        bottom: MediaQuery.of(context).viewInsets.bottom + bottom,
        left: 0,
        child: child,
      )
    );
  }

  /// 一级工具栏
  Widget _mainToolBar() {
    var width = (MediaQuery.of(context).size.width - 10) / 6;
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 49,
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(width: 1, color: Color(0xffeeeeee)))
      ),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildToolItem(width: width, icon: 'editor_color').intoGesture(
            onTap: () {
              _toggleSecondToolBar(
                child: ToolbarWidget(
                  controller: _controller,
                  htmlToolbarOptions: const HtmlToolbarOptions(
                    toolbarPosition: ToolbarPosition.custom,
                    renderSeparatorWidget: false,
                    defaultToolbarButtons: [
                      ColorButtons(),
                      FontButtons()
                    ],
                  ),
                  callbacks: Callbacks(),
                ),
                index: 0
              );
            }
          ),
          _buildToolItem(width: width, icon: 'editor_align').intoGesture(
            onTap: () {
              _toggleSecondToolBar(
                child: ToolbarWidget(
                  controller: _controller,
                  htmlToolbarOptions: const HtmlToolbarOptions(
                    toolbarPosition: ToolbarPosition.custom,
                    renderSeparatorWidget: false,
                    defaultToolbarButtons: [
                      ParagraphButtons(
                        caseConverter: false,
                        lineHeight: false
                      ),
                      OtherButtons(
                        help: false,
                        fullscreen: false
                      )
                    ],
                  ),
                  callbacks: Callbacks(),
                ),
                index: 1
              );
            }
          ),
          _buildToolItem(width: width, icon: 'editor_emoji').intoGesture(
            onTap: () {}
          ),
          _buildToolItem(width: width, icon: 'editor_img').intoGesture(
            onTap: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.image,
                allowMultiple: true,
              );
              List<File> images = (result?.paths ?? []).map((path) => File(path!)).toList();
              if (widget.images != null) {
                widget.images!(images).then((imgs) {
                  /// 插入到富文本
                  for (var i = 0; i < imgs.length; i++) {
                    _controller.insertNetworkImage(imgs[i]);
                  }
                });
              }
            }
          ),
          _buildToolItem(width: width, icon: 'editor_video').intoGesture(
              onTap: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.video,
                  allowMultiple: true,
                );
                List<File> files = (result?.paths ?? []).map((path) => File(path!)).toList();
                if (widget.videos != null) {
                  widget.videos!(files).then((videos) {
                    /// 插入到富文本
                    for (var i = 0; i < videos.length; i++) {
                      _controller.insertHtml("<video controls src='${videos[i]}' poster='${videos[i]}?x-oss-process=video/snapshot,t_7000,f_jpg,w_750,m_fast'></video>");
                    }
                  });
                }
              }
          ),
          _buildToolItem(width: width, icon: 'editor_link')
        ],
      ),
    );
  }

  /// 显示隐藏二级工具栏
  void _toggleSecondToolBar({Widget? child, int index = 0}) {
    if (_selected[index] == 1 && _secondOverlayEntry != null) {
      _secondOverlayEntry?.remove();
      _secondOverlayEntry =  null;
      _selected.fillRange(0, _selected.length, 0);
      return;
    }
    _secondOverlayEntry?.remove();
    _secondOverlayEntry = _createOverlayEntry(_secondToolBar(child: child), bottom: 50);
    Overlay.of(context)?.insert(_secondOverlayEntry!);
    _selected.fillRange(0, _selected.length, 0);
    _selected[index] = 1;
  }

  /// 二级工具栏
  Widget _secondToolBar({Widget? child}) {
    return Card(
      borderOnForeground: false,
      elevation: 0,
      margin: EdgeInsets.zero,
      child: Container(
        height: 49,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(width: 1, color: Color(0xffeeeeee)))
        ),
        child: child,
      ),
    );
  }


  /// 按钮
  Widget _buildToolItem({double? width, required String icon}) {
    return SizedBox(
      width: width,
      child: Container(
        width: 20,
        alignment: Alignment.center,
        child: Image.asset('assets/imgs/$icon.png', package: 'xzx_editor', width: 16, height: 16),
      ),
    );
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _secondOverlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HtmlEditor(
          controller: _controller,
          htmlToolbarOptions: const HtmlToolbarOptions(
            toolbarPosition: ToolbarPosition.custom,
            defaultToolbarButtons: []
          ),
          htmlEditorOptions: const HtmlEditorOptions(
            hint: '请输入内容',
            shouldEnsureVisible: true,
            initialText: '',
            filePath: 'packages/xzx_editor/assets/summernote.html'
          ),
          otherOptions: OtherOptions(
            height: widget.height ?? 100
          ),
          callbacks: widget.callbacks,
        ),
      ],
    );
  }
}