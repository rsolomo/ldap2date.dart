library ldap2date;

String _pad2(int n) {
  if (n < 10) return '0' + n.toString();
  return n.toString();
}

String _pad4(int n) {
  if (n < 10) return '000' + n.toString();
  if (n < 100) return '00' + n.toString();
  if (n < 1000) return '0' + n.toString();
  return n.toString();
}

int _year(String s) {
  return int.parse(s.substring(0, 4), radix: 10);
}

int _month(String s) {
  return int.parse(s.substring(4, 6), radix: 10);
}

int _day(String s) {
  return int.parse(s.substring(6, 8), radix: 10);
}

int _hour(String s) {
  return int.parse(s.substring(8, 10), radix: 10);
}

int _minute(String s) {
  return int.parse(s.substring(10, 12), radix: 10, onError : (e) => 0);
}

int _second(String s) {
  return int.parse(s.substring(12, 14), radix: 10, onError : (e) => 0);
}

/**
 * Returns a string in LDAP Generalized Time format.
 *
 *  ldap2date.toGeneralizedTime(DateTime d);
 */
String toGeneralizedTime(DateTime datetime) {
  var d = datetime.toUtc();
  var ms = d.millisecond;
  var fraction = ms != 0 ? '.' + ms.toString() : '';
  var str = '' +
    _pad4(d.year) +
    _pad2(d.month) +
    _pad2(d.day) +
    _pad2(d.hour) +
    _pad2(d.minute) +
    _pad2(d.second) +
    fraction + 'Z';
  return str;
}

/**
 * Parses LDAP time strings.
 * 
 * This returns a new [DateTime] based upon the formatted string.  
 * 
 *  ldap2date.parse('20130228192706.607Z')
 */
DateTime parse(String s) {
  return new DateTime(
      _year(s),
      _month(s),
      _day(s),
      _hour(s),
      _minute(s),
      _second(s));
}