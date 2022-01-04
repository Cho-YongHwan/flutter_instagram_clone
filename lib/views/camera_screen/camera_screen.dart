import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/utils/constants.dart';

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  final CameraConsumer cameraConsumer;
  final Function backToHomeScreen;
  CameraScreen(this.cameras, this.backToHomeScreen, this.cameraConsumer);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  String? imagePath;
  bool _toggleCamera = false;
  late CameraController controller;
  final _picker = ImagePicker();
  CameraConsumer _cameraConsumer = CameraConsumer.post;

  @override
  void initState() {
    // try {
    //   onCameraSelected(widget.cameras[0]);
    // } catch (e) {
    //   print(e.toString());
    // }
    // if (widget.cameraConsumer != CameraConsumer.post) {
    //   changeConsumer(widget.cameraConsumer);
    // }
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(16.0),
      child: Text(
        'No Camera Found',
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.white,
        ),
      ),
    );
  }
}
