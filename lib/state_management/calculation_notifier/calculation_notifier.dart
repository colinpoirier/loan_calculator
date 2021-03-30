import 'package:flutter/foundation.dart';

abstract class CalcNotifier<T> extends ChangeNotifier {
  late T _state;
  T get state => _state;

  CalcNotifier(this._state);

  @protected
  setState(T state, {bool notify = true}) {
    _state = state;
    if (notify) notifyListeners();
  }
}
