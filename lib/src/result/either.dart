/// A convenience class for handling either values of an option.
/// This class is typically used to represent the result of an operation
/// which can be either failed or successful.
abstract class Either<L, R> {
  /// Creates an instance of Either.
  const Either();

  /// Applies a function depending on whether the instance is `Left` or `Right`.
  ///
  /// - If the instance is `Left`, `ifLeft` is executed.
  /// - If the instance is `Right`, `ifRight` is executed.
  ///
  /// Example:
  /// ```dart
  /// Either<String, int> result = Right(10);
  /// String message = result.fold(
  ///   (left) => "Error: $left",
  ///   (right) => "Success: $right"
  /// );
  /// print(message); // Outputs: Success: 10
  /// ```
  E fold<E>(E Function(L) ifLeft, E Function(R) ifRight);

  /// Checks if the instance is a `Left` value (failure).
  bool isLeft() => fold((_) => true, (_) => false);

  /// Checks if the instance is a `Right` value (success).
  bool isRight() => fold((_) => false, (_) => true);

  /// Retrieves the `Left` value, throwing an error if it is `Right`.
  ///
  /// Example:
  /// ```dart
  /// Either<String, int> result = Left("Error occurred");
  /// print(result.getLeft()); // Outputs: Error occurred
  /// ```
  L getLeft() => fold(
      (leftValue) => leftValue, (_) => throw UnimplementedError("getLeft"));

  /// Retrieves the `Right` value, throwing an error if it is `Left`.
  ///
  /// Example:
  /// ```dart
  /// Either<String, int> result = Right(100);
  /// print(result.getRight()); // Outputs: 100
  /// ```
  R getRight() => fold(
      (_) => throw UnimplementedError("getRight"), (rightValue) => rightValue);
}

/// A class representing the left side of an [Either] class.
/// This class is typically used to represent the failure of an operation.
/// The value of the failure is stored in the [value] field.
class Left<L, R> extends Either<L, R> {
  /// The value of the failure.
  final L value;

  /// Creates an instance of Left.
  const Left(this.value);

  /// Applies a function depending on whether the instance is `Left` or `Right`.
  /// If the instance is `Left`, `ifLeft` is executed.
  /// If the instance is `Right`, `ifRight
  /// Example:
  /// ```dart
  /// Either<String, int> result = Left("Error occurred");
  /// String message = result.fold(
  ///  (left) => "Error: $left",
  /// (right) => "Success: $right"
  /// );
  /// print(message); // Outputs: Error: Error occurred
  /// ```
  @override
  E fold<E>(E Function(L value) ifLeft, E Function(R value) ifRight) =>
      ifLeft(value);
}

/// A class representing the right side of an [Either] class.
/// This class is typically used to represent the success of an operation.
/// The value of the success is stored in the [value] field.
class Right<L, R> extends Either<L, R> {
  /// The value of the success.
  final R value;

  /// Creates an instance of Right.
  const Right(this.value);

  /// Applies a function depending on whether the instance is `Left` or `Right`.
  /// If the instance is `Left`, `ifLeft` is executed.
  /// If the instance is `Right`, `ifRight
  /// Example:
  /// ```dart
  /// Either<String, int> result = Right(10);
  /// String message = result.fold(
  ///  (left) => "Error: $left",
  /// (right) => "Success: $right"
  /// );
  /// print(message); // Outputs: Success: 10
  /// ```
  @override
  E fold<E>(E Function(L value) ifLeft, E Function(R value) ifRight) =>
      ifRight(value);
}

/// this function wraps a future and map it exceptions to failures
Future<Either<Exception, T>> runGuard<T>(
  Future<T> Function() future,
) async {
  try {
    final result = await future();
    return Right(result);
  } catch (e) {
    return Left(Exception(e.toString()));
  }
}

/// this is a [stream] version of runGuard
Stream<Either<Exception, T>> runSGuard<T>(
  Stream<T> Function() stream,
) async* {
  try {
    await for (final result in stream()) {
      yield Right(result);
    }
  } catch (e) {
    yield Left(Exception(e.toString()));
  }
}
