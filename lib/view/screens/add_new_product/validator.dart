import 'package:shop_app/utilis/constants.dart';

class FormValidation {
  String titleValidator(value) {
    if (value.isEmpty) {
      return 'Enter product title';
    }
    return null;
  }

  String priceValidator(value) {
    if (value.isEmpty) {
      return 'Enter product price';
    } else if (double.tryParse(value) == null) {
      return 'Enter a valid price amount';
    } else if (double.parse(value) <= 0) {
      return 'Enter a price amount greater than 0';
    }
    return null;
  }

  String descriptionValidator(value) {
    if (value.isEmpty) {
      return 'Enter product description';
    } else if (value.length < 10) {
      return 'Enter description minimum 10 character!';
    }
    return null;
  }

  String imageUrlValidator(value) {
    if (value.isEmpty) {
      return 'Enter product image url';
    } else if (!value.startsWith('http') && !value.startsWith('https')) {
      return 'Enter a valid url!';
    } else if (!value.endsWith('.png') &&
        !value.endsWith('.jpg') &&
        !value.endsWith('.jpeg')) {
      return 'Enter a valid image url!';
    }
    return null;
  }

  String validateEmail(value) {
    if (value.isEmpty) {
      return kEmailNullError;
    } else if (!emailValidatorRegExp.hasMatch(value)) {
      return kInvalidEmailError;
    }
    return null;
  }

  String validatePassword(value) {
    if (value.isEmpty) {
      return kPassNullError;
    } else if (value.length < 8) {
      return kShortPassError;
    }
    return null;
  }

  String validatRepeatePassword(value, String password) {
    if (value.isEmpty) {
      return kPassNullError;
    } else if (value != password) {
      return kMatchPassError;
    }
    return null;
  }
}
