import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebSlideView extends StatelessWidget {
  final String title;
  final String selectedUrl;

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  WebSlideView({
    super.key,
    required this.title,
    required this.selectedUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   backgroundColor: const Color(0xFF672855),
        //   title: Center(child: Text(title, textAlign: TextAlign.center)),
        //   toolbarHeight: 50,
        // ),
        body: WebView(
      initialUrl: selectedUrl,
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController webViewController) {
        _controller.complete(webViewController);
      },
    ));
  }
}
