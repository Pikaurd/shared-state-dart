import 'package:shared_state/shared_state.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    final store = SharedState();

    setUp(() {
      // Additional setup goes here.
    });

    test('set and get test', () {
      store.set<bool>('isAwesome', true);
      expect(store.get<bool>('isAwesome'), isTrue);
      expect(store.get<bool>('empty'), isNull);
    });
  });
}
