import 'package:unittest/unittest.dart';
import 'package:ldap2date/ldap2date.dart' as ldap2date;


void main() {
  DateTime date = ldap2date.parse('20130305032706.607Z');
  assert(date.toUtc().toString() == '2013-03-05 03:27:06.607Z');
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
    test('should parse the milliseconds', () {
      var ms = ldap2date.parse(TIME).millisecond;
      expect(ms, equals(607));
    });
    test('should parse ms even if minutes/seconds are missing', () {
      var ms = ldap2date.parse('2013022819.648Z').millisecond;
      expect(ms, equals(648));
    });
    test('should work with commas', () {
      var ms = ldap2date.parse('2013022819,648Z').millisecond;
      expect(ms, equals(648));
    });
    test('should return 0 if milliseconds are not present', () {
      var ms = ldap2date.parse('2013022819Z').millisecond;
      expect(ms, equals(0));
    });
    test('should handle 2 digit fractions', () {
      var ms = ldap2date.parse('20130228192706.12Z').millisecond;
      expect(ms, equals(120));
    });
    test('should handle 1 digit fractions', () {
      var ms = ldap2date.parse('20130228192706.8Z').millisecond;
      expect(ms, equals(800));
    });
    test('should handle positive timezones', () {
      DateTime date = ldap2date.parse('20130228192706.8+531');
      expect(date.millisecond, equals(800));
      expect(date.minute, equals(58));
      expect(date.hour, equals(0));
    });
    test('should handle negative timezones', () {
      DateTime date = ldap2date.parse('20130228192706.8-531');
      expect(date.millisecond, equals(800));
      expect(date.minute, equals(56));
      expect(date.hour, equals(13));
    });
    test('timezone minutes should be optional', () {
      DateTime date = ldap2date.parse('20130228192706.8-5');
      expect(date.millisecond, equals(800));
      expect(date.minute, equals(27));
      expect(date.hour, equals(14));
    });
    test('should throw a FormatException if the date cannot be parsed', () {
      expect(() => ldap2date.parse('A2013022819Z'), throwsFormatException);
    });
    test('should throw a FormatException if the date cannot be parsed (2)', () {
      expect(() => ldap2date.parse('201'), throwsFormatException);
    });
    test('should throw a FormatException if the timezone is not present', () {
      expect(() => ldap2date.parse('20130228192706.85'), throwsFormatException);
    });
  });
  group('toGeneralizedTime', () {
    test('should return a Generalized Time string', () {
      var ms = 1362079626607;
      var date = new DateTime.fromMillisecondsSinceEpoch(ms, isUtc: true);
      var ldaptime = ldap2date.toGeneralizedTime(date);
      expect(ldaptime, equals('20130228192706.607Z'));
    });
    test('should handle single digit years', () {
      var ms = -61941924311001;
      var date = new DateTime.fromMillisecondsSinceEpoch(ms, isUtc: true);
      var ldaptime = ldap2date.toGeneralizedTime(date);
      expect(ldaptime, equals('00070220135448.999Z'));
    });
    test('should not return fraction, if it is 0', () {
      var ms = 1362079626000;
      var date = new DateTime.fromMillisecondsSinceEpoch(ms, isUtc: true);
      var ldaptime = ldap2date.toGeneralizedTime(date);
      expect(ldaptime, equals('20130228192706Z'));
    });
  });
  test('parse / toGeneralizedTime should be opposite of each other', () {
    var date = DateTime.parse('2013-03-05 03:27:06.607Z');
    var ldaptime = ldap2date.toGeneralizedTime(date);
    var date2 = ldap2date.parse(ldaptime).toUtc();
    expect(ldaptime, equals('20130305032706.607Z'));
    expect(date2.toString(), equals('2013-03-05 03:27:06.607Z'));
  });
}