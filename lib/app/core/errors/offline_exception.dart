/// Consulta sem resposta do servidor: o Firestore offline devolve o cache vazio em vez de falhar.
class OfflineException implements Exception {
  const OfflineException();
}
