/// A convenience class for handling either values of an option.
/// This class is typically used to represent the result of an operation
/// which can be either failed or successful.
abstract class Either<L, R> {
  const Either();

  E fold<E>(E Function(L) ifLeft, E Function(R) ifRight);

  bool isLeft() => fold((_) => true, (_) => false);
  bool isRight() => fold((_) => false, (_) => true);

  L getLeft() => fold(
      (leftValue) => leftValue, (_) => throw UnimplementedError("getLeft"));

  R getRight() => fold(
      (_) => throw UnimplementedError("getRight"), (rightValue) => rightValue);
}

/// A class representing the left side of an [Either] class.
/// This class is typically used to represent the failure of an operation.
/// The value of the failure is stored in the [value] field.
class Left<L, R> extends Either<L, R> {
  final L value;
  const Left(this.value);

  @override
  E fold<E>(E Function(L value) ifLeft, E Function(R value) ifRight) =>
      ifLeft(value);
}

/// A class representing the right side of an [Either] class.
/// This class is typically used to represent the success of an operation.
/// The value of the success is stored in the [value] field.
class Right<L, R> extends Either<L, R> {
  final R value;
  const Right(this.value);

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
