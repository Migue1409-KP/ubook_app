import 'package:flutter_test/flutter_test.dart';
import 'package:ubook_app/service/analytics_service.dart';

void main() {
  test('AnalyticsService is a no-op before Firebase is initialized', () async {
    expect(AnalyticsService.instance.observer, isNull);

    await AnalyticsService.instance.logLogin(method: 'password');
    await AnalyticsService.instance.logScreen('login');
  });
}
