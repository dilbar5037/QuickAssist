class Validate {
  static String? Textvalidator(String value) {
    final trimmed = value.trim();
    if (trimmed.length < 2) {
      return 'REQUIRED FIELD';
    }
    return null;
  }

  static String? check(String value) {
    if (value.trim().isEmpty) {
      return 'REQUIRED FIELD';
    }
    return null;
  }

  static String? GenderValidator(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty || trimmed.toLowerCase() == 'select gender') {
      return 'REQUIRED FIELD';
    }
    return null;
  }

  static String? pwdvalidator(String value) {
    if (value.length < 8) {
      return 'PASSWORD SHOULD CONTAIN ATLEAST 8 CHARACTERS';
    }
    return null;
  }

  static String? confirmvalidator(String value, String password) {
    if (value != password) {
      return 'PASSWORD MISSMATCH ';
    }
    return null;
  }

  static String? phnvalidator(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return 'REQUIRED FIELD';
    }
    if (!RegExp(r'^\d{10}$').hasMatch(trimmed)) {
      return 'INVALID PHONE NUMBER';
    }
    return null;
  }

  static String? pinvalidator(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return 'REQUIRED FIELD';
    }
    if (!RegExp(r'^\d{6}$').hasMatch(trimmed)) {
      return 'NUMBER MUST BE 6 DIGIT';
    }
    return null;
  }

  static String? emailValidator(String value) {
    const pattern =
        r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    final regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Email format is invalid';
    }
    return null;
  }
}
