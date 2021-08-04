import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';

import 'configurations/app_config.dart';
import 'environment.dart';
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
  await FlutterLogs.initLogs(
      logLevelsEnabled: [LogLevel.INFO, LogLevel.WARNING, LogLevel.ERROR],
      timeStampFormat: TimeStampFormat.TIME_FORMAT_READABLE,
      directoryStructure: DirectoryStructure.FOR_DATE,
      logTypesEnabled: ["device", "network", "errors"],
      logFileExtension: LogFileExtension.LOG,
      logsWriteDirectoryName: "MyLogs",
      logsExportDirectoryName: "MyLogs/Exported",
      debugFileOperations: true,
      isDebuggable: true);

  return runApp(configuredApp);
}

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }
