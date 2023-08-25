import 'package:auto_fis/screens/display_image_screen.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

  @override
  State<MainScreen> createState() => _MainScreen();
}

class _MainScreen extends State<MainScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.high,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final ImagePicker _picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // Do something with the picked image.
      // For example, you can display it or navigate to a new screen.
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DisplayImageScreen(
            imagePath: pickedFile.path,
          ),
        ),
      );
    }
  }

  Future clickPicture() async {
    try {
      await _initializeControllerFuture;
      _controller.setFlashMode(FlashMode.off);
      final image = await _controller.takePicture();

      if (!mounted) return;

      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DisplayImageScreen(
            // Pass the automatically generated path to
            // the DisplayPictureScreen widget.
            imagePath: image.path,
          ),
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              fit: StackFit.expand, // Wrap with Stack to fill the whole screen
              children: [
                CameraPreview(_controller),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.fromLTRB(screenWidth*0.16, 0, 0, 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            FloatingActionButton(
                shape: const CircleBorder(),
                onPressed: getImage,
                child: const Icon(Icons.photo)),
            Container(
              margin: EdgeInsets.only(left: screenWidth*0.12),
              width: 80,
              height: 80,
              child: FloatingActionButton(
                shape: const CircleBorder(),
                heroTag: "btn1",
                onPressed: clickPicture,
                child: const Icon(
                  Icons.camera_alt,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
