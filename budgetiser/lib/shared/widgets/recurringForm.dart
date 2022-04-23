import 'package:budgetiser/shared/dataClasses/recurringData.dart';
import 'package:budgetiser/shared/dataClasses/transaction.dart';
import 'package:budgetiser/shared/picker/datePicker.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

class RecurringForm extends StatefulWidget {
  RecurringForm({
    Key? key,
    required this.initialRecurringData,
    required this.onRecurringDataChangedCallback,
  }) : super(key: key);

  RecurringData initialRecurringData;
  Function(RecurringData) onRecurringDataChangedCallback;

  @override
  State<RecurringForm> createState() => _RecurringFormState();
}

class _RecurringFormState extends State<RecurringForm> {
  bool isRecurring = false;
  DateTime startDate = DateTime.now();
  IntervalType _selectedIntervalType = IntervalType.fixedInterval;
  var fixedPointOfTimeAmountController = TextEditingController();
  var fixedIntervalAmountController = TextEditingController();
  var repetitionsController = TextEditingController();
  IntervalUnit fixedPointOfTimeUnit = IntervalUnit.week;
  IntervalUnit fixedIntervalUnit = IntervalUnit.day;
  DateTime? enddate;

  final _formKey = GlobalKey<FormState>();

  List<DropdownMenuItem<IntervalUnit>> get dropdownItemsFixedPointOfTimeUnit {
    List<DropdownMenuItem<IntervalUnit>> menuItems = [
      const DropdownMenuItem(
          child: Text("of a week"), value: IntervalUnit.week),
      const DropdownMenuItem(
          child: Text("of a month"), value: IntervalUnit.month),
      const DropdownMenuItem(
          child: Text("of a year"), value: IntervalUnit.year),
    ];
    return menuItems;
  }

  List<DropdownMenuItem<IntervalUnit>> get dropdownItemsFixedIntervalUnit {
    List<DropdownMenuItem<IntervalUnit>> menuItems = [
      const DropdownMenuItem(child: Text("day"), value: IntervalUnit.day),
      const DropdownMenuItem(child: Text("week"), value: IntervalUnit.week),
      const DropdownMenuItem(child: Text("month"), value: IntervalUnit.month),
    ];
    return menuItems;
  }

  @override
  void initState() {
    super.initState();
    isRecurring = widget.initialRecurringData.isRecurring;
    startDate = widget.initialRecurringData.startDate;
    if (isRecurring) {
      _selectedIntervalType = widget.initialRecurringData.intervalType!;
      if (_selectedIntervalType == IntervalType.fixedPointOfTime) {
        fixedPointOfTimeAmountController.text =
            widget.initialRecurringData.intervalAmount!.toString();
        fixedPointOfTimeUnit = widget.initialRecurringData.intervalUnit!;
      } else {
        fixedIntervalAmountController.text =
            widget.initialRecurringData.intervalAmount.toString();
        fixedIntervalUnit = widget.initialRecurringData.intervalUnit!;
      }
      enddate = widget.initialRecurringData.endDate;
      repetitionsController.text = _calculateNeededRepetitions().toString();
    }
    _calculateEndDate();
  }

  int _calculateNeededRepetitions() {
    // TODO: not finished and buggy
    if (isRecurring) {
      if (_selectedIntervalType == IntervalType.fixedPointOfTime) {
        switch (fixedPointOfTimeUnit) {
          case IntervalUnit.week:
            return enddate!.difference(startDate).inDays ~/ 7;
          // case "month":
          // return startDate.difference(enddate!).inDays ~/ 30;
          default:
            return 0;
        }
      } else {
        switch (fixedIntervalUnit) {
          case IntervalUnit.day:
            return enddate!.difference(startDate).inDays;
          case IntervalUnit.week:
            return enddate!.difference(startDate).inDays ~/ 7;
          // case "month":
          // return startDate.difference(enddate!).inDays ~/ 30;
          default:
            return 0;
        }
      }
    } else {
      return 0;
    }
  }

  void _calculateEndDate() {
    if (fixedIntervalAmountController.text.isEmpty &&
            _selectedIntervalType == IntervalType.fixedInterval ||
        fixedPointOfTimeAmountController.text.isEmpty &&
            _selectedIntervalType == IntervalType.fixedPointOfTime ||
        repetitionsController.text.isEmpty) {
      enddate = null;
      return;
    }

    if (_selectedIntervalType == IntervalType.fixedPointOfTime) {
      switch (fixedPointOfTimeUnit) {
        case IntervalUnit.week:
          Duration untilFirstPointOfTime = Duration(
              days: (int.parse(fixedPointOfTimeAmountController.text) -
                          startDate.weekday) >=
                      0
                  ? int.parse(fixedPointOfTimeAmountController.text) -
                      startDate.weekday
                  : 7 -
                      (startDate.weekday -
                          int.parse(fixedPointOfTimeAmountController.text)));
          Duration fromRepetitions =
              Duration(days: 7 * (int.parse(repetitionsController.text) - 1));
          enddate = startDate.add(untilFirstPointOfTime + fromRepetitions);
          break;
        case IntervalUnit.month:
          Duration untilFirstPointOfTime = Duration(
              days: int.parse(fixedPointOfTimeAmountController.text) -
                          startDate.day >=
                      0
                  ? int.parse(fixedPointOfTimeAmountController.text) -
                      startDate.day
                  : Jiffy(startDate).daysInMonth -
                      startDate.day +
                      int.parse(fixedPointOfTimeAmountController.text));
          enddate = startDate.add(untilFirstPointOfTime);
          enddate = Jiffy(enddate)
              .add(months: int.parse(repetitionsController.text) - 1)
              .dateTime;
          break;
        case IntervalUnit.year:
          Duration untilFirstPointOfTime = Duration(
            days: (int.parse(fixedPointOfTimeAmountController.text) -
                        Jiffy(startDate).dayOfYear >=
                    0)
                ? int.parse(fixedPointOfTimeAmountController.text) -
                    Jiffy(startDate).dayOfYear
                : ((Jiffy(startDate).isLeapYear == true) ? 366 : 365) -
                    Jiffy(startDate).dayOfYear +
                    int.parse(fixedPointOfTimeAmountController.text),
          );
          enddate = startDate.add(untilFirstPointOfTime);
          enddate = Jiffy(enddate)
              .add(years: int.parse(repetitionsController.text) - 1)
              .dateTime;
          break;
        default:
          print("Error in _calculateEndDate: unknown intervalMode");
      }
    } else {
      switch (fixedIntervalUnit) {
        case IntervalUnit.day:
          enddate = startDate.add(
              Duration(days: int.parse(fixedIntervalAmountController.text)) *
                  int.parse(repetitionsController.text));
          break;
        case IntervalUnit.week:
          enddate = startDate.add(Duration(
              days: int.parse(fixedIntervalAmountController.text) *
                  int.parse(repetitionsController.text) *
                  7));
          break;
        case IntervalUnit.month:
          enddate = Jiffy(startDate)
              .add(
                  months: int.parse(fixedIntervalAmountController.text) *
                      int.parse(repetitionsController.text))
              .dateTime;
          break;
        default:
          print(
              "Error in _calculateEndDate(fixedInterval): unknown intervalMode");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 0, right: 8, top: 13),
            child: Row(children: [
              Flexible(
                child: DatePicker(
                  label: "start",
                  initialDate: startDate,
                  onDateChangedCallback: (date) {
                    setState(() {
                      startDate = date;
                      _calculateEndDate();
                      _callCallback();
                    });
                  },
                ),
              ),
              Checkbox(
                value: isRecurring,
                onChanged: (bool? newValue) {
                  setState(() {
                    isRecurring = newValue!;
                    _calculateEndDate();
                    _callCallback();
                  });
                },
              ),
              const Text("recurring"),
            ]),
          ),
          if (isRecurring)
            Column(
              children: [
                Row(children: <Widget>[
                  Radio(
                    onChanged: (IntervalType? value) {
                      setState(() {
                        _selectedIntervalType = value!;
                        _calculateEndDate();
                        _callCallback();
                      });
                    },
                    groupValue: _selectedIntervalType,
                    value: IntervalType.fixedPointOfTime,
                  ),
                  const Text("always on the: "),
                  SizedBox(
                    width: 40,
                    height: 30,
                    child: TextFormField(
                      controller: fixedPointOfTimeAmountController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                        signed: false,
                      ),
                      onChanged: (string) {
                        setState(() {
                          _calculateEndDate();
                          _callCallback();
                        });
                      },
                      validator: (value) {
                        if (value!.isEmpty &&
                            _selectedIntervalType ==
                                IntervalType.fixedPointOfTime) {
                          return "Please enter a number";
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    child: DropdownButton(
                      value: fixedPointOfTimeUnit,
                      items: dropdownItemsFixedPointOfTimeUnit,
                      onChanged: (IntervalUnit? value) {
                        setState(() {
                          fixedPointOfTimeUnit = value!;
                          _calculateEndDate();
                          _callCallback();
                        });
                      },
                    ),
                  )
                ]),
                Row(children: <Widget>[
                  Radio(
                    onChanged: (IntervalType? value) {
                      setState(() {
                        _selectedIntervalType = value!;
                        _calculateEndDate();
                        _callCallback();
                      });
                    },
                    groupValue: _selectedIntervalType,
                    value: IntervalType.fixedInterval,
                  ),
                  const Text("every: "),
                  SizedBox(
                    width: 40,
                    height: 30,
                    child: TextFormField(
                      controller: fixedIntervalAmountController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: false,
                        signed: false,
                      ),
                      onChanged: (string) {
                        setState(() {
                          _calculateEndDate();
                          _callCallback();
                        });
                      },
                      validator: (value) {
                        if (value!.isEmpty &&
                            _selectedIntervalType ==
                                IntervalType.fixedInterval) {
                          return "Please enter a number";
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    child: DropdownButton(
                      value: fixedIntervalUnit,
                      items: dropdownItemsFixedIntervalUnit,
                      onChanged: (IntervalUnit? value) {
                        setState(() {
                          fixedIntervalUnit = value!;
                          _calculateEndDate();
                          _callCallback();
                        });
                      },
                    ),
                  )
                ]),
                Row(
                  children: [
                    const Text("Repetitions: "),
                    SizedBox(
                      width: 40,
                      height: 30,
                      child: TextFormField(
                        controller: repetitionsController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: false,
                          signed: false,
                        ),
                        onChanged: (string) {
                          setState(() {
                            _calculateEndDate();
                            _callCallback();
                          });
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter a number";
                          }
                          return null;
                        },
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Text(
                        "Ends on: ${enddate != null ? enddate.toString().substring(0, 10) : ""}"),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }

  void _callCallback() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    widget.onRecurringDataChangedCallback(
      RecurringData(
        startDate: startDate,
        isRecurring: isRecurring,
        intervalType: _selectedIntervalType,
        intervalUnit: _selectedIntervalType == IntervalType.fixedInterval
            ? fixedIntervalUnit
            : fixedPointOfTimeUnit,
        intervalAmount: fixedPointOfTimeAmountController.text.isEmpty &&
                    _selectedIntervalType == IntervalType.fixedPointOfTime ||
                fixedIntervalAmountController.text.isEmpty &&
                    _selectedIntervalType == IntervalType.fixedInterval
            ? null
            : _selectedIntervalType == IntervalType.fixedPointOfTime
                ? int.parse(fixedPointOfTimeAmountController.text)
                : int.parse(fixedIntervalAmountController.text),
        endDate: enddate,
      ),
    );
  }
}
