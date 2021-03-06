import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:test/test.dart';

void main() {
  const num expected = 0;

  test('rx.Observable.onErrorReturnWith', () async {
    new Observable<num>(new ErrorStream<num>(new Exception()))
        .onErrorReturnWith((dynamic e) => e is StateError ? 1 : 0)
        .listen(expectAsync1((num result) {
      expect(result, expected);
    }));
  });

  test('rx.Observable.onErrorReturnWith.asBroadcastStream', () async {
    Stream<num> stream =
        new Observable<num>(new ErrorStream<num>(new Exception()))
            .onErrorReturnWith((dynamic e) => 0)
            .asBroadcastStream();

    await expectLater(stream.isBroadcast, isTrue);

    stream.listen(expectAsync1((num result) {
      expect(result, expected);
    }));

    stream.listen(expectAsync1((num result) {
      expect(result, expected);
    }));
  });

  test('rx.Observable.onErrorReturnWith.pause.resume', () async {
    StreamSubscription<num> subscription;

    subscription = new Observable<num>(new ErrorStream<num>(new Exception()))
        .onErrorReturnWith((dynamic e) => 0)
        .listen(expectAsync1((num result) {
      expect(result, expected);

      subscription.cancel();
    }));

    subscription.pause();
    subscription.resume();
  });
}
