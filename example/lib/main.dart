// ignore_for_file: avoid_print

import 'package:dee_result/dee_result.dart';

void main() {
  // Example using Either
  Either<String, int> divide(int a, int b) {
    if (b == 0) return Left("Division by zero");
    return Right(a ~/ b);
  }

  final result = divide(10, 2);
  result.fold(
    (error) => print("Error: $error"),
    (value) => print("Success: $value"),
  );

  // Example using Result
  Result<int> safeDivide(int a, int b) {
    if (b == 0) return Result.error(Exception("Cannot divide by zero"));
    return Result.ok(a ~/ b);
  }

  final safeResult = safeDivide(10, 0);
  switch (safeResult) {
    case Ok<int>():
      print("Success: ${(safeResult).value}");
      break;
    case Error<int>():
      print("Error: ${(safeResult).error}");
      break;
  }

  // Using runGuard for async operations
  Future<Either<Exception, String>> fetchData() async {
    return runGuard(() async {
      await Future.delayed(Duration(seconds: 1));
      return "Data loaded successfully";
    });
  }

  fetchData().then((result) {
    result.fold(
      (error) => print("Error: ${error.toString()}"),
      (value) => print("Success: $value"),
    );
  });
}
