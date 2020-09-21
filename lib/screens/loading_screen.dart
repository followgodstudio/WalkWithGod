import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walk_with_god/providers/splash_provider.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: FutureBuilder(
              future: Provider.of<SplashProvider>(context).fetch_splash_image(),
              builder: (ctx, asyncSnapshot) {
                if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  if (asyncSnapshot.error != null) {
                    return Center(
                      child: Text('An error occurred!'),
                    );
                  } else {
                    return Center(child: Image.network(asyncSnapshot.data));
                  }
                }
              }
              // Center(
              //   child: Center(child: CircularProgressIndicator()),
              // ),

              )),
    );
  }
}
