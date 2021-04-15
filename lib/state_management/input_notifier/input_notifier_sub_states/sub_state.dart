abstract class SubState {
  SubState({this.value, this.stringValue, this.error}):canSubmit = value != null && stringValue != null && error == null;

  final String? stringValue;
  final num? value;
  final String? error;
  final bool canSubmit;
}
