import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'configurations/app_config.dart';
import 'environment.dart';
import 'main.dart';

void main() async {
  var configuredApp = AppConfig(
      child: MyApp(
        environment: EnvironmentValue.production,
      ),
      appTitle: "Follow Him Production",
      buildFlavor: "Production");

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  return runApp(configuredApp);
}
