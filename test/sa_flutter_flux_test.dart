import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sa_flutter_flux/sa_flutter_flux.dart';

class TestData {
  final String value;
  TestData({
    required this.value,
  });

  TestData copyWith({String? value}) {
    return TestData(value: value ?? this.value);
  }
}

abstract class TestEvents {
  TestEvents._();
  static const _event = 'test';
  static const created = '$_event/created';
  static const deleted = '$_event/deleted';
}

class TestActionParam {
  final String value;
  TestActionParam({required this.value});
}

class TestStore extends Mock implements FluxStore {}

class MockCreateAction extends Mock
    implements StoreAction<TestStore, TestData> {}

void main() {
  late TestStore store;
  late TestData result;
  late MockCreateAction action;
  late List<TestData> state;
  final StoreMutations mutations = {
    TestEvents.created: (payload) {
      state.add(payload as TestData);
    },
    TestEvents.deleted: (payload) {
      var data = payload as TestData;
      state.removeWhere((element) => element.value == data.value);
    }
  };

  setUpAll(() {
    store = TestStore();
    action = MockCreateAction();
    state = [];
  });

  void prepareActionParams(String event, String value) {
    result = TestData(value: value);
    when(() => store.dispatch(action)).thenAnswer((_) async {
      action.effect(store).then((value) => action.apply(store, result));
    });
    when(() => store.commit(event, result)).thenAnswer((_) async {
      mutations[event]?.call(result);
    });
    when(() => action.effect(store)).thenAnswer((_) async => result);
    when(() => action.apply(store, result)).thenAnswer((_) async {
      return store.commit(event, result);
    });
  }

  group('Store', () {
    test('''Store dispatch:
      - must call action.effect and action.apply
      - should run mutations to update the state
      ''', () async {
      prepareActionParams(TestEvents.created, 'test');
      await store.dispatch(action);
      verify(() => action.effect(store)).called(1);
      verify(() => action.apply(store, result)).called(1);
      verify(() => store.commit(TestEvents.created, result)).called(1);
      expect(state.isNotEmpty, true);
      prepareActionParams(TestEvents.deleted, 'test');
      await store.dispatch(action);
      expect(state.isEmpty, true);
    });
  });
}
