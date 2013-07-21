# ldap2date.dart

Creates DateTime objects from [RFC 4517](http://www.ietf.org/rfc/rfc4517.txt) Generalized Time strings.

Conversion from DateTime to GeneralizedTime formatted strings is supported as well.

## Usage

#### Datetime ldap2date.parse(String ldaptime)

Returns a new DateTime based upon the formatted string.

May throw a FormatException if the string cannot be parsed.

```

import 'package:ldap2date/ldap2date.dart' as ldap2date;

main() {
  DateTime date = ldap2date.parse('20130305032706.607Z');
  assert(date.toUtc().toString() == '2013-03-05 03:27:06.607Z');
}

```

#### String toGeneralizedTime(Datetime datetime)

Returns a string in LDAP Generalized Time format.

```

import 'package:ldap2date/ldap2date.dart' as ldap2date;

main() {
  DateTime date = DateTime.parse('2013-03-05 03:27:06.607Z');
  assert(ldap2date.toGeneralizedTime(date) == '20130305032706.607Z');
}

```

## License

MIT