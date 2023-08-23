import 'package:auto_fis/model/camera_model.dart';
import 'package:auto_fis/screens/main_screen.dart';
import 'package:auto_fis/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.camera.request();
  await Permission.storage.request();
  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  runApp(
    ChangeNotifierProvider(create: (context) => CameraModel(cameras),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(), // Show SplashScreen initially
      routes: {
        '/mainScreen': (context) => MainScreen(camera: Provider.of<CameraModel>(context).selectedCamera!),
      },
    );
  }
}

