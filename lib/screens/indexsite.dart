import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class IndexsiteScreen extends StatefulWidget {
  const IndexsiteScreen({super.key});

  @override
  State<IndexsiteScreen> createState() => _IndexsiteScreenState();
}

class _IndexsiteScreenState extends State<IndexsiteScreen> {
  late final WebViewController controller;

  void initState() {
    super.initState();
    controller = WebViewController()
      ..loadRequest(
        Uri.parse('https://www.flutter.dev'),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebViewWidget(
        controller: controller,
        // initialUrl: "https://www.index.viveeeeeek.us/",
        // javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
