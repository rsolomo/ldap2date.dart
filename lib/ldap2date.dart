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