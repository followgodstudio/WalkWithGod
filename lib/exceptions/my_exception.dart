class MyException implements Exception {
  String message;

  MyException(String message) {
    this.message = message;
  }

  @override
  String toString() {
    return message;
  }
}
