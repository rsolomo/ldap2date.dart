library ldap2date;

String _pad2(int n) {
  if (n < 10) return '0$n';
  return n.toString();
}

String _pad4(int n) {
  if (n < 10) return '000$n';
  if (n < 100) return '00$n';
  if (n < 1000) return '0$n';
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
  if (s.length < 12) return 0;
  return int.parse(s.substring(10, 12), radix: 10, onError : (e) => 0);
}

int _second(String s) {
  if (s.length < 14) return 0;
  return int.parse(s.substring(12, 14), radix: 10, onError : (e) => 0);
}

int _millisecond(String s) {
  var startIdx;
  if (s.contains('.')) {
    startIdx = s.indexOf('.') + 1;
  } else if (s.contains(',')) {
    startIdx = s.indexOf(',') + 1;
  } else {
    return 0;
  }

  var tz = 0;
  var symbolIdx = -1;
  var plusIdx = s.indexOf('+');
  var minusIdx = s.indexOf('-');
  
  if (plusIdx != -1) {
    symbolIdx = plusIdx;
  } else if (minusIdx != -1) {
    symbolIdx = minusIdx;
  } else if (!s.contains('Z')) {
    throw new FormatException();
  }

  var stopIdx = symbolIdx != -1 ? symbolIdx : s.length - 1;
  var fraction = '0' + '.' + s.substring(startIdx, stopIdx);
  var ms = double.parse(fraction) * 1000;
  
  if (symbolIdx != -1) {
    var minutes = s.substring(symbolIdx + 2);
    var hours = s.substring(symbolIdx + 1, symbolIdx + 2);
    var one = plusIdx != -1 ? 1 : -1;
    
    int hr = one * int.parse(hours, radix: 10) * 60 * 60 * 1000;
    int min = minutes.isEmpty ? 0 : one * int.parse(minutes, radix: 10) * 60 * 1000;
    tz = hr + min;
  }

  return ms.toInt() + tz;
}


/**
 * Returns a string in LDAP Generalized Time format.
 *
 *  ldap2date.toGeneralizedTime(DateTime d);
 */
String toGeneralizedTime(DateTime datetime) {
  var d = datetime.toUtc();
  var ms = d.millisecond;
  var fraction = ms != 0 ? '.$ms' : '';
  var buf = new StringBuffer();
  buf.write(_pad4(d.year));
  buf.write(_pad2(d.month));
  buf.write(_pad2(d.day));
  buf.write(_pad2(d.hour));
  buf.write(_pad2(d.minute));
  buf.write(_pad2(d.second));
  buf.write(fraction);
  buf.write('Z');
  return buf.toString();
}

/**
 * Parses LDAP time strings.
 * 
 * Returns a new [DateTime] based upon the formatted string.
 * 
 * May throw [FormatException] if the string cannot be parsed.  
 * 
 *  ldap2date.parse('20130228192706.607Z')
 */
DateTime parse(String ldaptime) {
  if (ldaptime.length < 10) throw new FormatException();
  return new DateTime.utc(
      _year(ldaptime),
      _month(ldaptime),
      _day(ldaptime),
      _hour(ldaptime),
      _minute(ldaptime),
      _second(ldaptime),
      _millisecond(ldaptime));
}