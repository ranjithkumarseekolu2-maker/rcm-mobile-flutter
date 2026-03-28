class ErrorConstants {
   static const List errors = [
    {'code': 1,'codeName': 'CANCELLED', 'message': 'The operation has been cancelled','isToaster':true},
    {'code': 2,'codeName': 'UNKNOWN', 'message': 'An unexpected error occurred. Please report this error.','isToaster':false},
    {'code': 3,'codeName': 'INVALID_ARGUMENT', 'message': 'An unexpected error occurred. Please report this error.','isToaster':false},
    {'code': 4,'codeName': 'DEADLINE_EXCEEDED', 'message': 'The server is taking a long time to respond. Please retry after some time.','isToaster':true},
    {'code': 5,'codeName': 'NOT_FOUND', 'message': 'The requested data could not be found.','isToaster':true},
    {'code': 6,'codeName': 'ALREADY_EXISTS', 'message': 'The data being changed already exists on the server.','isToaster':true},
    {'code': 7,'codeName': 'PERMISSION_DENIED', 'message': 'You donot have permissions to perform this operation.','isToaster':true},
    {'code': 8,'codeName': 'RESOURCE_EXHAUSTED', 'message': 'The server is busy and is unable to respond. Please retry after some time.','isToaster':true},
    {'code': 9,'codeName': 'FAILED_PRECONDITION', 'message': 'An unexpected error occurred. Please report this error.','isToaster':false},
    {'code': 10,'codeName': 'ABORTED', 'message': 'The operation has been cancelled','isToaster':true},
    {'code': 11,'codeName': 'OUT_OF_RANGE', 'message': 'An unexpected error occurred. Please report this error.','isToaster':false},
    {'code': 12,'codeName': 'UNIMPLEMENTED', 'message': 'The application seems out of date. Try install the latest update or allow automatic updates to happen. Additional please report this error.','isToaster':false},
    {'code': 13,'codeName': 'INTERNAL', 'message': 'An unexpected error occurred. Please report this error.','isToaster':false},
    {'code': 14,'codeName': 'UNAVAILABLE', 'message': 'The server is busy and is unable to respond. Please retry after some time.','isToaster':true},
    {'code': 15,'codeName': 'DATA_LOSS', 'message': 'The application seems out of date. Try install the latest update or allow automatic updates to happen. Additional please report this error.','isToaster':false},
    {'code': 16,'codeName': 'UNAUTHENTICATED', 'message': 'You are not logged in. Please login and try again. If the error persists, please report the error.','isToaster':true},
  ];
}