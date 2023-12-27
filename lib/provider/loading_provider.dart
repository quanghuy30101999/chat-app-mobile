import 'package:flutter/foundation.dart';

class LoadingProvider with ChangeNotifier {
  bool _isLoading = false;
  bool _isOpenListImage = false;
  bool _isInCameraMode = false;

  bool get isLoading => _isLoading;
  bool get isOpenListImage => _isOpenListImage;
  bool get isInCameraMode => _isInCameraMode;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setOpenListImage(bool value) {
    _isOpenListImage = value;
    notifyListeners();
  }

  void setInCameraMode(bool value) {
    _isInCameraMode = value;
    notifyListeners();
  }
}
