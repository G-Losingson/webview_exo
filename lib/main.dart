import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GeminiWebViewApp(),
    ),
  );
}

class GeminiWebViewApp extends StatefulWidget {
  const GeminiWebViewApp({super.key});

  @override
  State<GeminiWebViewApp> createState() => _GeminiWebViewAppState();
}

class _GeminiWebViewAppState extends State<GeminiWebViewApp> {
  dynamic themeController, theme, loadingPercent = 0;
  dynamic webController = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..enableZoom(false)
    ..setNavigationDelegate(
      NavigationDelegate(
        onHttpAuthRequest: (request) {},
        onUrlChange: (change) {},
        onProgress: (int progress) {},
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          if (request.url.startsWith('https://www.google.com')) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    )
    ..loadRequest(
      Uri.parse('https://gemini.google.com/'),
    );
  @override
  void initState() {
    // ignore: unused_local_variable
    Future<void> future = Future.delayed(const Duration(seconds: 8), () async {
      theme = await webController.runJavaScriptReturningResult(
        "document.body.classList.contains('light-theme')",
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Color(0xFF1C1C16),
        systemNavigationBarColor: Color(0xFF1C1C16),
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: MediaQuery.sizeOf(context).height * 0.05),
        child: WebViewWidget(controller: webController),
      ),
    );
  }
}
