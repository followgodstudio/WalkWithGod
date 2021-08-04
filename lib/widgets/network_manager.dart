import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user/notification_provider.dart';

import '../utils/utils.dart';

/// To monitor whether network is available
class NetworkManager extends StatefulWidget {
  final Widget child;
  NetworkManager({Key key, this.child}) : super(key: key);
  _NetworkManagerState createState() => _NetworkManagerState();
}

class _NetworkManagerState extends State<NetworkManager> {
  StreamSubscription<ConnectivityResult> subscription;
  bool isConnected = true;

  @override
  void initState() {
    super.initState();
    checkNetwork();
    NotificationProvider notification =
        Provider.of<NotificationProvider>(context, listen: false);
    notification.updateContext(context);
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  Future<void> checkNetwork() async {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        showPopUpDialog(context, false, "请检查网络连接");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
