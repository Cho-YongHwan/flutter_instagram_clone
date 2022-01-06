import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/show_error_dialog.dart';
import 'package:instagram_clone/views/home_screen/home_screen.dart';
import 'package:instagram_clone/views/profile_screen/profile_screen.dart';

class CustomNavigation {
  static void navigateToUserProfile({
    BuildContext? context,
    bool? isCameFromBottomNavigation,
    int? currentUserId,
    int? userId,
  }) {
    Navigator.push(
      context!,
      MaterialPageRoute(
        builder: (_) => ProfileScreen(
          isCameFromBottomNavigation: isCameFromBottomNavigation!,
          currentUserId: currentUserId!,
          userId: userId!,
          onProfileEdited: () {},
          goToCameraScreen: () => navigateToHomeScreen(context, currentUserId, initialPage: 0),
        ),
      ),
    );
  }

  // static void navigateToShowErrorDialog(
  //     BuildContext context, String errorMessage) {
  //   Navigator.push(context,
  //       MaterialPageRoute(builder: (_) => ShowErrorDialog(errorMessage)));
  // }
  static Future<List<CameraDescription>> getCameras(
      BuildContext context) async {
    late List<CameraDescription> _cameras;
    try {
      _cameras = await availableCameras();
    } on CameraException catch (_) {
      ShowErrorDialog.showAlertDialog(
          errorMessage: 'Cant get cameras!', context: context);
    }

    return _cameras;
  }

  static void navigateToHomeScreen(BuildContext context, int currentUserId,
      {int initialPage = 1}) async {
    List<CameraDescription> _cameras;
    if (initialPage == 0) {
      _cameras = await getCameras(context);
      if (_cameras == null) {
        return;
      }
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => HomeScreen(
            currentUserId: currentUserId,
            initialPage: initialPage,
            cameras: _cameras,
          ),
        ),
        (Route<dynamic> route) => false,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => HomeScreen(
            currentUserId: currentUserId,
            initialPage: initialPage, cameras: [],
          ),
        ),
        (Route<dynamic> route) => false,
      );
    }
  }
}
