class StringFormatter {
  static upperFirstCase(String str) {
    return "${str[0].toUpperCase()}${str.substring(1)}";
  }
}