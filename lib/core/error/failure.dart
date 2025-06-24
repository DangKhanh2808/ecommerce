abstract class Failure {
  final String message;
  Failure(this.message);
}

class FirestoreFailure extends Failure {
  FirestoreFailure(super.message);
}
