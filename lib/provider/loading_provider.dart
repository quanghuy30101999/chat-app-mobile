import 'package:flutter/foundation.dart';

class LoadingProvider with ChangeNotifier {
  bool _isLoading = false;
  bool _isOpenListImage = false;

  bool get isLoading => _isLoading;
  bool get isOpenListImage => _isOpenListImage;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setOpenListImage(bool value) {
    _isOpenListImage = value;
    notifyListeners();
  }
}
