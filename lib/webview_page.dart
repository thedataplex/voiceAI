// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'dart:convert';

// // ************************************************************************************************
// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'dart:convert';

// // class WebViewPage extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Text to Speech'),
// //       ),
// //       body: WebView(
// //         // initialUrl is removed because we're setting the URL through controller.loadUrl in onWebViewCreated
// //         javascriptMode: JavascriptMode.unrestricted,
// //         onWebViewCreated: (WebViewController webViewController) {
// //           _loadHtmlFromAssets(webViewController, context);
// //         },
// //       ),
// //     );
// //   }

// //   void _loadHtmlFromAssets(WebViewController controller, BuildContext context) async {
// //     String fileText = await DefaultAssetBundle.of(context).loadString('assets/web/index.html');
// //     // Convert the HTML content into a data URI and load it
// //     final String contentBase64 = base64Encode(const Utf8Encoder().convert(fileText));
// //     final String dataUri = 'data:text/html;base64,$contentBase64';
// //     controller.loadUrl(dataUri);
// //   }
// // }

// // *************************************************************************************

// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'dart:convert';

// class WebViewPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // WebView.platform = AndroidWebView(); // Uncomment if using a version that requires this for WebView initialization

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Text to Speech'),
//       ),
//       body: WebView(
//         initialUrl: 'about:blank',
//         javascriptMode: JavascriptMode.unrestricted,
//         onWebViewCreated: (WebViewController webViewController) {
//           _loadHtmlFromAssets(webViewController, context);
//         },
//         onPageFinished: (String url) {
//           // This is useful for debugging purposes
//           print("Page finished loading: $url");
//         },
//         // Enable debugging - available on Android only
//         debuggingEnabled: true,
//       ),
//     );
//   }

//   void _loadHtmlFromAssets(WebViewController controller, BuildContext context) async {
//     String fileText = await DefaultAssetBundle.of(context).loadString('assets/web/index.html');
//     final String contentBase64 = base64Encode(const Utf8Encoder().convert(fileText));
//     final String dataUri = 'data:text/html;base64,$contentBase64';
//     controller.loadUrl(dataUri);
//   }
// }
