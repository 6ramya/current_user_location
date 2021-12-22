import 'package:permission_handler/permission_handler.dart';

class AccessLocation {
  Future<void> requestLocationPermission() async {
    final serviceStatusLocation = await Permission.location.isGranted;
    bool isLocation = serviceStatusLocation == ServiceStatus.enabled;

    final status = await Permission.location.request();

    if (status == PermissionStatus.granted) {
      print('permission granted');
    } else if (status == PermissionStatus.denied) {
      print('Permission denied');
    } else if (status == PermissionStatus.permanentlyDenied) {
      print('Permission permanently denied');
      await openAppSettings();
    }
  }
}
