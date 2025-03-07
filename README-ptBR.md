# dee_result

![Pub Version](https://img.shields.io/pub/v/dee_result)

Uma biblioteca para manipulação de resultados em Dart e Flutter de forma segura e estruturada.

## 📌 Visão Geral

O `dee_result` fornece duas principais abstrações para lidar com operações assíncronas e seus possíveis resultados:
- `Either<L, R>`: Representa um valor que pode ser um `Left` (falha) ou um `Right` (sucesso).
- `Result<T>`: Representa um resultado que pode ser `Ok` (sucesso) ou `Error` (falha).

## 📦 Instalação

Adicione a dependência ao seu projeto Flutter/Dart:

```yaml
dependencies:
  dee_result: ^0.0.1
```

Ou instale diretamente via terminal:

```sh
dart pub add dee_result
```

## 🚀 Como Usar

### Either

O `Either<L, R>` é útil para representar operações que podem resultar em sucesso (`Right<R>`) ou falha (`Left<L>`).

```dart
import 'package:dee_result/dee_result.dart';

Either<String, int> divide(int a, int b) {
  if (b == 0) {
    return Left("Divisão por zero não é permitida");
  }
  return Right(a ~/ b);
}

void main() {
  final result = divide(10, 2);

  result.fold(
    (left) => print("Erro: $left"),
    (right) => print("Resultado: $right"),
  );
}
```

### Result

A classe `Result<T>` encapsula o resultado de uma operação, indicando sucesso (`Ok<T>`) ou erro (`Error<T>`).

```dart
import 'package:dee_result/dee_result.dart';

Result<int> safeDivide(int a, int b) {
  if (b == 0) {
    return Result.error(Exception("Divisão por zero"));
  }
  return Result.ok(a ~/ b);
}

void main() {
  final result = safeDivide(10, 0);

  switch (result) {
    case Ok(value):
      print("Sucesso: $value");
    case Error(error):
      print("Erro: ${error.error}");
  }
}
```

### Tratamento Seguro com `runGuard`

A função `runGuard` ajuda a encapsular chamadas assíncronas, convertendo exceções automaticamente para um `Either`.

```dart
import 'package:dee_result/dee_result.dart';

Future<Either<Exception, String>> fetchData() async {
  return runGuard(() async {
    await Future.delayed(Duration(seconds: 1));
    return "Dados carregados com sucesso";
  });
}

void main() async {
  final result = await fetchData();
  
  result.fold(
    (left) => print("Erro: ${left.toString()}"),
    (right) => print("Sucesso: $right"),
  );
}
```

### Uso com Streams (`runSGuard`)

Para capturar erros em `Stream`, utilize `runSGuard`:

```dart
import 'package:dee_result/dee_result.dart';

Stream<Either<Exception, int>> numberStream() async* {
  yield* runSGuard(() async* {
    for (int i = 1; i <= 5; i++) {
      if (i == 3) throw Exception("Erro no stream!");
      yield i;
    }
  });
}

void main() async {
  await for (final result in numberStream()) {
    result.fold(
      (left) => print("Erro: ${left.toString()}"),
      (right) => print("Número: $right"),
    );
  }
}
```

## 📝 Licença

Este projeto é licenciado sob a licença BSD. Consulte o arquivo `LICENSE` para mais detalhes.

## 📢 Contribuições

Sinta-se à vontade para contribuir! Caso encontre problemas ou tenha sugestões, abra uma issue ou envie um pull request no [GitHub](https://github.com/rkpontes/dee_result).