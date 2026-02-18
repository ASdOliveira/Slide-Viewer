import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebSlideViewPage extends StatefulWidget {
  final String selectedUrl;

  const WebSlideViewPage({super.key, required this.selectedUrl});

  @override
  State<WebSlideViewPage> createState() => _WebSlideViewPageState();
}

class _WebSlideViewPageState extends State<WebSlideViewPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    // Para maior compatibilidade com iOS
    final params = const PlatformWebViewControllerCreationParams();
    final controller = WebViewController.fromPlatformCreationParams(params);

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.selectedUrl));

    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebViewWidget(controller: _controller),
    );
  }
}
