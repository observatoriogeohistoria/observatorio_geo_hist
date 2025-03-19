class IdGenerator {
  static String generate() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}
