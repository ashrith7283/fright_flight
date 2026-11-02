import 'package:flutter_test/flutter_test.dart';
import 'package:fright_flight/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('missing key reads as null', () async {
    SharedPreferences.setMockInitialValues({});
    expect(await SharedPreferencesStorageService().readHighScore(), isNull);
  });

  test('round trip', () async {
    SharedPreferences.setMockInitialValues({});
    final s = SharedPreferencesStorageService();
    await s.writeHighScore(12);
    expect(await s.readHighScore(), 12);
  });

  test('wrong-typed value throws', () async {
    SharedPreferences.setMockInitialValues({'high_score': 'oops'});
    expect(
      SharedPreferencesStorageService().readHighScore(),
      throwsA(anything),
    );
  });
}
