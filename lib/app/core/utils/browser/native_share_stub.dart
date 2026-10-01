/// Resultado da folha de compartilhamento do aparelho.
enum NativeShareResult { shared, cancelled, failed }

/// Fora do navegador não há folha de compartilhamento.
bool canNativeShare() => false;

Future<NativeShareResult> nativeShare({required String title, required String url}) async =>
    NativeShareResult.failed;
