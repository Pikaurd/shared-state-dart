<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

Providing an ability of sharing state environment. Used for multiple life scope sharing state and dependency injection.

[中文](./README_CN.md)

## Features

1. multiple life scope sharing: eg, Sharing state over seperated pages and modules.
2. subscribing specific value changed: eg, Observing `login` key to get whether logged in or logged out.
3. Decoupling specific dependency implementation: eg, `module sub A` needs to provide the ability to pull up an advertisement from a certain vendor, but it will be determine from `module S`. We can define an interface that can be declared through `module sub A`, and `module S` can be implement the interface and injected through `SharedState`.


## Getting started

Pure `dart 3` module, no other dependency
```yaml
dependencies:
  shared_state: ^${latestVersion}
```

## Usage

### basic usage

Assign and read

```dart
const key = 'some awesome key';
SharedState().set<String>(key, 'my great value');

final v = SharedState().get<String>(key);
if (v != null) {
  // using my great value
}

// cleanup
SharedState().invalid(key);
```

Observing key change

```dart
const loginStatusKey = 'login_status';

// register event change
SharedState().onKeyChange<bool>(loginStatusKey).listen((event) {
  // got status changed
  if (event == true) {
    // value set to true
  }
  else if (event == false) {
    // value set to false
  }
  else {
    // value was set to null
  }
});

SharedState().set<bool>(loginStatusKey, false);
```

### Dependency injection

```dart
// submodule A
const String incrementorKey = 'Incrementor';

abstract interface class Incrementor { 
  void increment();
  int get value;
}

class IncrementorUsageClass {
  void foo() {
    // fetch implementation from shared state
    final incrementor = SharedState().get<Incrementor>(incrementorKey);
    if (incrementor != null) {
      print('value: ${incrementor.value}');
    }
  }
}

// container/caller module
import 'submodule a';

void main() {
  SharedState().set<Incrementor>(incrementorKey, IncrementorImpl());

  final usageClass = IncrementorUsageClass();
  // call usage class here
  usageClass.foo();
}

class IncrementorImpl implements Incrementor {
  int _v;
  int get value => _v;
  void increment() {
    _v += 1;
  }
}

```

## Additional information

⚠️ caution: Not suit for multiple `isolate` sharing state
