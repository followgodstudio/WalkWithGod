import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:logger_flutter/logger_flutter.dart';

import '../utils/utils.dart';

/// To monitor whether network is available, also allow logger console on shake
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
    return LogConsoleOnShake(child: widget.child);
  }
}
