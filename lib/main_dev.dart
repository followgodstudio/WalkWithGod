import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:walk_with_god/environment.dart';
import 'configurations/app_config.dart';
import 'main.dart';

void main() async {
  var configuredApp = AppConfig(
      child: MyApp(
        environment: EnvironmentValue.development,
      ),
      appTitle: "Follow Him Dev",
      buildFlavor: "Development");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  return runApp(configuredApp);
}

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }
