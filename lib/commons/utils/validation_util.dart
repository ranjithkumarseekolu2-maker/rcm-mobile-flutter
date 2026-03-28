class Validators {
  static final RegExp _phoneRegExp = RegExp(r'[1-9]{1}[0-9]{9}$');
  static final RegExp _amountRegExp = RegExp(r'[0-9]$');
  static final RegExp _nameRegExp = RegExp(r'[a-zA-Z-,]$');
  static final RegExp _panRegExp = RegExp(r'[A-Z]{5}[0-9]{4}[A-Z]{1}$');
  static final RegExp _gstRegExp =
      RegExp(r'[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$');

  static bool isValidPhone(String value) {
    print('enterd value: ${value}');
    if (_phoneRegExp.hasMatch(value)) {
      print('matched');
      return true;
    } else {
      print('not matched');
      return false;
    }
  }

  static bool isValidAmount(String value) {
    if (_amountRegExp.hasMatch(value)) {
      print('matched');
      return true;
    } else {
      print('not matched');
      return false;
    }
  }

  static bool isValidName(String value) {
    if (_nameRegExp.hasMatch(value)) {
      return true;
    } else {
      print('not matched');
      return false;
    }
  }

  static bool isValidGST(String value) {
    if (_gstRegExp.hasMatch(value)) {
      return true;
    } else {
      print('not matched');
      return false;
    }
  }

  static bool isValidPAN(String value) {
    if (_panRegExp.hasMatch(value)) {
      return true;
    } else {
      print('not matched');
      return false;
    }
  }

  static String formatRefID(basketRef) {
    List formattedRefID = [];
    for (var i = 0; i < basketRef.toString().split('').length; i++) {
      if (i == 3 || i == 7) {
        formattedRefID.add(basketRef[i] + ' ');
      } else {
        formattedRefID.add(basketRef[i]);
      }
    }

    return formattedRefID.join('');
  }
}
