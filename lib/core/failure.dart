abstract class Failure {
  String messageToDisplay;
  String? actualMessage;
  dynamic errorObject;

  Failure({required this.messageToDisplay, this.actualMessage, this.errorObject});
}

class RemoteFailure extends Failure {
  RemoteFailure(
      {String messageToDisplay = "Remote Connection Failure",
      String? actualMessage,
      dynamic errorObject})
      : super(
            messageToDisplay: messageToDisplay,
            actualMessage: actualMessage,
            errorObject: errorObject);
}

class FetchFailure extends Failure {
  FetchFailure(
      {String messageToDisplay = "Remote Connection Failure",
      String? actualMessage,
      dynamic errorObject})
      : super(
            messageToDisplay: messageToDisplay,
            actualMessage: actualMessage,
            errorObject: errorObject);
}
