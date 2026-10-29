/// Query with no server response: offline, Firestore returns the empty cache instead of failing.
class OfflineException implements Exception {
  const OfflineException();
}
