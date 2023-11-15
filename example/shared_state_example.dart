import 'package:shared_state/shared_state.dart';

const classKey = 'class';

void main() {
  var store = SharedState();
  // basic usage
  store.onKeyChange<String>(classKey).listen((event) {
    print('$classKey changed to $event');
  });
  // print('awesome: ${store.}');
}

class A {
  A() {
    SharedState().set<String>(classKey, 'A');
  }
}

class B {
  B() {
    SharedState().set<String>(classKey, 'B');
  }
}

const String incrementorKey = 'Incrementor';

abstract interface class Incrementor {
  void increment();
  int get value;
}
