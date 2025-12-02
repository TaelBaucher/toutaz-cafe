class FirestoreResult {
  final bool success;
  final String? error;

  FirestoreResult({
    required this.success,
    this.error
  });
}