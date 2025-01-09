/// Helper method to convert CamelCase to snake_case
String convertToSnakeCase(String input) {
  return input.replaceAllMapped(RegExp('(?<!^)([A-Z])'), (Match match) {
    return '_${match.group(0)!.toLowerCase()}';
  });
}
