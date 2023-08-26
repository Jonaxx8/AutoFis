import 'dart:io';
import 'package:auto_fis/screens/display_image_screen.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
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

  Future uploadImage(File imageFile) async {
    print("uploading image");
    const url = 'http://3.88.18.87:3000/upload-image';

    final request = http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(
      http.MultipartFile.fromBytes(
        'image',
        imageFile.readAsBytesSync(),
        filename: 'image.jpg',
      ),
    );

    final response = await request.send();
    print(response.stream);
    if (response.statusCode == 200) {
      print('Image uploaded successfully');
    } else {
      print('Failed to upload image');
    }
  }

  Future getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // Do something with the picked image.
      // For example, you can display it or navigate to a new screen.
      uploadImage(File(pickedFile.path));
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

      uploadImage(File(image.path));

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
              children: [
                Positioned.fill(
                  child: CameraPreview(_controller),
                ),
                // Positioned.fill(
                //       child: BackdropFilter(
                //         filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                //         child: Container(
                //           color: Colors.black.withOpacity(0.3), // Adjust the opacity as needed
                //         ),
                //       ),
                //     ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.fromLTRB(screenWidth * 0.16, 0, 0, 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            FloatingActionButton(
                shape: const CircleBorder(),
                onPressed: getImage,
                child: const Icon(Icons.photo)),
            Container(
              margin: EdgeInsets.only(left: screenWidth * 0.12),
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
