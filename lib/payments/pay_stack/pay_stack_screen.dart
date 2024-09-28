import 'dart:async';

import 'package:driver/constant/constant.dart';
import 'package:driver/payments/pay_stack/paystack_url_generator.dart';
import 'package:driver/theme/app_them_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PayStackScreen extends StatefulWidget {
  final String initialURl;
  final String reference;
  final String amount;
  final String secretKey;
  final String callBackUrl;

  const PayStackScreen({super.key, required this.initialURl, required this.reference, required this.amount, required this.secretKey, required this.callBackUrl});

  @override
  State<PayStackScreen> createState() => _PayStackScreenState();
}

class _PayStackScreenState extends State<PayStackScreen> {
  WebViewController controller = WebViewController();

  @override
  void initState() {
    initController();
    super.initState();
  }

  initController() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest navigation) async {
            debugPrint("--->2${navigation.url}");
            debugPrint("--->2" "${widget.callBackUrl}?trxref=${widget.reference}&reference=${widget.reference}");
            if (navigation.url == '${Constant.paymentCallbackURL}/success?trxref=${widget.reference}&reference=${widget.reference}' ||
                navigation.url == '${widget.callBackUrl}?trxref=${widget.reference}&reference=${widget.reference}') {
              final isDone = await PayStackURLGen.verifyTransaction(secretKey: widget.secretKey, reference: widget.reference, amount: widget.amount);
              Get.back(result: isDone);
            }
            if ((navigation.url == '${widget.callBackUrl}?trxref=${widget.reference}&reference=${widget.reference}') ||
                (navigation.url == "https://hello.pstk.xyz/callback") ||
                (navigation.url == 'https://standard.pay_stack.co/close')) {
              final isDone = await PayStackURLGen.verifyTransaction(secretKey: widget.secretKey, reference: widget.reference, amount: widget.amount);
              Get.back(result: isDone);
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.initialURl));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _showMyDialog();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
            forceMaterialTransparency: true,
            backgroundColor: AppThemData.primary500,
            title: const Text("Payment"),
            centerTitle: false,
            leading: GestureDetector(
              onTap: () {
                _showMyDialog();
              },
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            )),
        body: WebViewWidget(controller: controller),
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cancel Payment'),
          content: const SingleChildScrollView(
            child: Text("cancelPayment?"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text(
                'Continue',
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
