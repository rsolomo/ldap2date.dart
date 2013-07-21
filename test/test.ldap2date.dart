import 'package:unittest/unittest.dart';
import 'package:ldap2date/ldap2date.dart' as ldap2date;


void main() {
  group('parse', () {
    const TIME = '20130228192706.607Z';
    test('should parse the year', () {
      var year = ldap2date.parse(TIME).year;
      expect(year, equals(2013));
    });
    test('should parse the month', () {
      var month = ldap2date.parse(TIME).month;
      expect(month, equals(2));
    });
    test('should parse the day', () {
      var day = ldap2date.parse(TIME).day;
      expect(day, equals(28));
    });
    test('should parse the hour', () {
      var hour = ldap2date.parse(TIME).hour;
      expect(hour, equals(19));
    });
    test('should parse the minute', () {
      var minute = ldap2date.parse(TIME).minute;
      expect(minute, equals(27));
    });
    test('should set minutes to 0 if omitted', () {
      var minute = ldap2date.parse('2013022819.607Z').minute;
      expect(minute, equals(0));
    });
    test('should parse the second', () {
      var second = ldap2date.parse(TIME).second;
      expect(second, equals(6));
    });
    test('should return 0 if seconds are not present', () {
      var second = ldap2date.parse('201302281927.607Z').second;
      expect(second, equals(0));
    });
  });
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