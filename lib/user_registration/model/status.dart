import 'package:firebase_auth/firebase_auth.dart';

class Success {

  Object? response;
  Success({

    this.response,
  });
}

class Failure {

  dynamic errorResponse;
  Failure({
    this.errorResponse,
  });

}

  enum AuthStatus {
  uninitialized,
  authenticated,
  authenticating,
  unauthenticated
}
class UpdateResponse {
  String? status;
  String? response;
  UpdateResponse({

    this.response,
  });
}