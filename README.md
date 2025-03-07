# dee_result

![Pub Version](https://img.shields.io/pub/v/dee_result)

A library for handling results in Dart and Flutter in a safe and structured way.

## 📌 Overview

`dee_result` provides two main abstractions for handling asynchronous operations and their possible results:
- `Either<L, R>`: Represents a value that can be either `Left` (failure) or `Right` (success).
- `Result<T>`: Represents a result that can be `Ok` (success) or `Error` (failure).

## 📦 Installation

Add the dependency to your Flutter/Dart project:

```yaml
dependencies:
  dee_result: ^0.0.1
```

Or install it directly via terminal:

```sh
dart pub add dee_result
```

## 🚀 How to Use

### Either

`Either<L, R>` is useful for representing operations that may result in success (`Right<R>`) or failure (`Left<L>`).

```dart
import 'package:dee_result/dee_result.dart';

Either<String, int> divide(int a, int b) {
  if (b == 0) {
    return Left("Division by zero is not allowed");
  }
  return Right(a ~/ b);
}

void main() {
  final result = divide(10, 2);

  result.fold(
    (left) => print("Error: $left"),
    (right) => print("Result: $right"),
  );
}
```

### Result

The `Result<T>` class encapsulates the result of an operation, indicating success (`Ok<T>`) or error (`Error<T>`).

```dart
import 'package:dee_result/dee_result.dart';

Result<int> safeDivide(int a, int b) {
  if (b == 0) {
    return Result.error(Exception("Division by zero"));
  }
  return Result.ok(a ~/ b);
}

void main() {
  final result = safeDivide(10, 0);

  switch (result) {
    case Ok(value):
      print("Success: $value");
    case Error(error):
      print("Error: ${error.error}");
  }
}
```

### Safe Handling with `runGuard`

The `runGuard` function helps encapsulate asynchronous calls, automatically converting exceptions into an `Either`.

```dart
import 'package:dee_result/dee_result.dart';

Future<Either<Exception, String>> fetchData() async {
  return runGuard(() async {
    await Future.delayed(Duration(seconds: 1));
    return "Data loaded successfully";
  });
}

void main() async {
  final result = await fetchData();
  
  result.fold(
    (left) => print("Error: ${left.toString()}"),
    (right) => print("Success: $right"),
  );
}
```

### Using Streams (`runSGuard`)

To capture errors in a `Stream`, use `runSGuard`:

```dart
import 'package:dee_result/dee_result.dart';

Stream<Either<Exception, int>> numberStream() async* {
  yield* runSGuard(() async* {
    for (int i = 1; i <= 5; i++) {
      if (i == 3) throw Exception("Stream error!");
      yield i;
    }
  });
}

void main() async {
  await for (final result in numberStream()) {
    result.fold(
      (left) => print("Error: ${left.toString()}"),
      (right) => print("Number: $right"),
    );
  }
}
```

## 📝 License

This project is licensed under the BSD license. See the `LICENSE` file for details.

## 📢 Contributions

Feel free to contribute! If you find any issues or have suggestions, open an issue or submit a pull request on [GitHub](https://github.com/rkpontes/dee_result).

