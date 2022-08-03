import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cameraapp/HelperFunctions.dart';
import 'package:cameraapp/globalVars.dart';
import 'package:cameraapp/videoModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:lifecycle/lifecycle.dart';
import 'package:path_provider/path_provider.dart';
import 'FlagModel.dart';
import 'allowAccessScreen.dart';
import 'cameraApp.dart';

List<CameraDescription>? MyAvailableCameras;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory directory=await getApplicationDocumentsDirectory();
  Hive
    ..init(directory.path);
  Hive.registerAdapter(videoModelAdapter());
  Hive.registerAdapter(flagAdapter());
   box = await Hive.openBox<VideoModel>('flaggedVideos');
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  MyAvailableCameras=await availableCameras();
  print(MyAvailableCameras!.length);
   await getFilePath();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorObservers: [defaultLifecycleObserver],
      title: 'camera app flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:permissionsGranted? CustomCamera():AllowAccessScreen()
    );
  }
}
