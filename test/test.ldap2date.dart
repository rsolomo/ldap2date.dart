import 'package:unittest/unittest.dart';
import 'package:ldap2date/ldap2date.dart' as ldap2date;


void main() {
  group('toGeneralizedTime', () {
    test('should return a Generalized Time string', () {
      var ms = 1362079626607;
      var date = new DateTime.fromMillisecondsSinceEpoch(ms, isUtc: true);
      var time = ldap2date.toGeneralizedTime(date);
      expect(time, equals('20130228192706.607Z'));
    });
    test('should handle single digit years', () {
      var ms = -61941924311001;
      var date = new DateTime.fromMillisecondsSinceEpoch(ms, isUtc: true);
      var time = ldap2date.toGeneralizedTime(date);
      expect(time, equals('00070220135448.999Z'));
    });
    test('should not return fraction, if it is 0', () {
      var ms = 1362079626000;
      var date = new DateTime.fromMillisecondsSinceEpoch(ms, isUtc: true);
      var time = ldap2date.toGeneralizedTime(date);
      expect(time, equals('20130228192706Z'));
    });
  });
}