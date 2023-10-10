abstract class Group {
  final int _idx;
  //factory Group() => const Group._(0);
  const Group._(this._idx);
  int toInt();
}

class Income extends Group {
  final int _idx;
  const Income._(this._idx) : super._(_idx);
  @override
  int toInt() {
    return _idx;
  }

  static const Income salary = Income._(0);
  static const Income businessIncome = Income._(1);
  static const Income commissions = Income._(2);
  static const Income investments = Income._(3);
  static const Income moneyGifts = Income._(4);
  static const Income sideGigs = Income._(5);
  static const Income privateSellings = Income._(6);
}

class Transportation extends Group {
  final int _idx;
  const Transportation._(this._idx) : super._(_idx);
  @override
  int toInt() {
    return _idx;
  }

  static const Transportation gas = Transportation._(7);
  static const Transportation parking = Transportation._(8);
  static const Transportation carMaintenance = Transportation._(9);
  static const Transportation publicTransport = Transportation._(10);
  static const Transportation bike = Transportation._(11);
}

class PersonalDevelopment extends Group {
  final int _idx;
  const PersonalDevelopment._(this._idx) : super._(_idx);
  @override
  int toInt() {
    return _idx;
  }

  static const PersonalDevelopment workshops = PersonalDevelopment._(12);
  static const PersonalDevelopment conferences = PersonalDevelopment._(13);
  static const PersonalDevelopment courses = PersonalDevelopment._(14);
  static const PersonalDevelopment coaching = PersonalDevelopment._(15);
  static const PersonalDevelopment books = PersonalDevelopment._(16);
}

class Medical extends Group {
  final int _idx;
  const Medical._(this._idx) : super._(_idx);
  @override
  int toInt() {
    return _idx;
  }

  static const Medical doctorBills = Medical._(17);
  static const Medical hospitalBills = Medical._(18);
  static const Medical dentist = Medical._(19);
  static const Medical medicalDevices = Medical._(20);
}

class Entertainment extends Group {
  final int _idx;
  const Entertainment._(this._idx) : super._(_idx);
  @override
  int toInt() {
    return _idx;
  }

  static const Entertainment cinema = Entertainment._(21);
  static const Entertainment theater = Entertainment._(22);
  static const Entertainment subscriptions = Entertainment._(23);
  static const Entertainment memberships = Entertainment._(24);
  static const Entertainment hobbies = Entertainment._(25);
}

class Housing extends Group {
  final int _idx;
  const Housing._(this._idx) : super._(_idx);
  @override
  int toInt() {
    return _idx;
  }

  static const Housing rent = Housing._(26);
  static const Housing propertyTaxes = Housing._(27);
  static const Housing homeRepairs = Housing._(28);
  static const Housing gardening = Housing._(29);
}

class Food extends Group {
  final int _idx;
  const Food._(this._idx) : super._(_idx);
  @override
  int toInt() {
    return _idx;
  }

  static const Food groceries = Food._(30);
  static const Food takeAways = Food._(31);
  static const Food snacks = Food._(32);
}

class Children extends Group {
  final int _idx;
  const Children._(this._idx) : super._(_idx);
  @override
  int toInt() {
    return _idx;
  }

  static const Children daycare = Children._(33);
  static const Children extracurricularActivities = Children._(34);
}

class Insurance extends Group {
  final int _idx;
  const Insurance._(this._idx) : super._(_idx);
  @override
  int toInt() {
    return _idx;
  }

  static const Insurance lifeInsurance = Insurance._(35);
  static const Insurance homeInsurance = Insurance._(36);
  static const Insurance carInsurance = Insurance._(37);
  static const Insurance businessInsurance = Insurance._(38);
}

class Gifts extends Group {
  final int _idx;
  const Gifts._(this._idx) : super._(_idx);
  @override
  int toInt() {
    return _idx;
  }

  static const Gifts birthdayGifts = Gifts._(39);
  static const Gifts holidayGifts = Gifts._(40);
  static const Gifts donations = Gifts._(41);
}

class EssentialBills extends Group {
  final int _idx;
  const EssentialBills._(this._idx) : super._(_idx);
  @override
  int toInt() {
    return _idx;
  }

  static const EssentialBills electricityBill = EssentialBills._(42);
  static const EssentialBills waterBill = EssentialBills._(43);
  static const EssentialBills heatBill = EssentialBills._(44);
  static const EssentialBills internetBill = EssentialBills._(45);
  static const EssentialBills phoneBill = EssentialBills._(46);
}

class PersonalCare extends Group {
  final int _idx;
  const PersonalCare._(this._idx) : super._(_idx);
  @override
  int toInt() {
    return _idx;
  }

  static const PersonalCare beauty = PersonalCare._(47);
  static const PersonalCare hygiene = PersonalCare._(48);
  static const PersonalCare grooming = PersonalCare._(49);
  static const PersonalCare spa = PersonalCare._(50);
  static const PersonalCare clothing = PersonalCare._(51);
}

class Pets extends Group {
  final int _idx;
  const Pets._(this._idx) : super._(_idx);
  @override
  int toInt() {
    return _idx;
  }

  static const Pets petFood = Pets._(52);
  static const Pets veterinaryBills = Pets._(53);
  static const Pets petTraining = Pets._(54);
}

class Debt extends Group {
  final int _idx;
  const Debt._(this._idx) : super._(_idx);
  @override
  int toInt() {
    return _idx;
  }

  static const Debt carDebt = Debt._(55);
  static const Debt personalLoans = Debt._(56);
  static const Debt houseDebt = Debt._(57);
}
