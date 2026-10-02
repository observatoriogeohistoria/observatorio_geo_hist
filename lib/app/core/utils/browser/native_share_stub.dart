enum NativeShareResult { shared, cancelled, failed }

bool canNativeShare() => false;

Future<NativeShareResult> nativeShare({required String title, required String url}) async =>
    NativeShareResult.failed;
