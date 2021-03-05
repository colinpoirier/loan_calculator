class Validator {
  static const amountMax = 100000000.0;
  static const amountMin = 0.01;

  static String? amount(String? val) {
    if (val != null && val.isNotEmpty) {
      double? amount = double.tryParse(val);
      if (amount == null) {
        return 'Please enter a number';
      } else if (amount > amountMax) {
        return 'Exceeds $amountMax';
      } else if (amount < amountMin) {
        return 'Must be at least $amountMin';
      }
    }
    return null;
  }

  static const interestMax = 100.0;
  static const interestMin = 0.01;

  static String? interest(String? val) {
    if (val != null && val.isNotEmpty) {
      double? percent = double.tryParse(val);
      if (percent == null) {
        return 'Please enter a number';
      } else if (percent > interestMax) {
        return 'Exceeds $interestMax';
      } else if (percent < interestMin) {
        return 'Must be at least $interestMin';
      }
    }
    return null;
  }

  static const monthMax = 600;
  static const monthMin = 1;
  static const yearMax = monthMax / 12;
  static const yearMin = monthMin / 12;


  static String? length(String? val, bool isChangeTime) {
    if (val != null && val.isNotEmpty) {
      double? months = double.tryParse(val);
      if (months == null) {
        return 'Please enter a number';
      } else if (isChangeTime) {
        if (months > yearMax) {
          return 'Exceeds $yearMax';
        } else if (months < yearMin) {
          return 'Must be at least ${yearMin.toStringAsFixed(5)}...';
        } else if (months * 12 != (months * 12).toInt()) {
          return 'Not a whole Month';
        }
      } else if (months > monthMax) {
        return 'Exceeds $monthMax';
      } else if (months < monthMin) {
        return 'Must be at least $monthMin';
      } else if (months != months.toInt()) {
        return 'Not a whole Month';
      }
    }
    return null;
  }
}
