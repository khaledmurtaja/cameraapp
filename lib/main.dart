import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cameraapp/shared/HelperFunctions.dart';
import 'package:cameraapp/shared/globalVars.dart';
import 'package:cameraapp/models/videoModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:lifecycle/lifecycle.dart';
import 'package:path_provider/path_provider.dart';
import 'models/EditedVideoModel.dart';
import 'models/FlagModel.dart';
import 'models/FlagModel.dart';
import 'models/videoModel.dart';
import 'screens/allowAccessScreen.dart';
import 'cameraApp.dart';

List<CameraDescription>? MyAvailableCameras;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory directory=await getApplicationDocumentsDirectory();
  Hive
    ..init(directory.path);
  Hive.registerAdapter(videoModelAdapter());
  Hive.registerAdapter(flagAdapter());
  Hive.registerAdapter(EditedVideoModelAdapter());
   FlaggedVideoBox = await Hive.openBox<VideoModel>('flaggedVideos');
   EditedVideosBox=await Hive.openBox<EditedVideoModel>('editedVideos');
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
