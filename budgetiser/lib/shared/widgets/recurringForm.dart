import 'package:budgetiser/shared/dataClasses/recurringData.dart';
import 'package:budgetiser/shared/picker/datePicker.dart';
import 'package:flutter/material.dart';

class RecurringForm extends StatefulWidget {
  RecurringForm({
    Key? key,
    required this.initialRecurringData,
    required this.onRecurringDataChangedCallback,
    required this.scrollController,
  }) : super(key: key);

  RecurringData initialRecurringData;
  Function(RecurringData) onRecurringDataChangedCallback;
  ScrollController scrollController;

  @override
  State<RecurringForm> createState() => _RecurringFormState();
}

class _RecurringFormState extends State<RecurringForm> {
  bool isRecurring = false;
  DateTime startDate = DateTime.now();
  IntervalType _selectedIntervalType = IntervalType.fixedInterval;
  var fixedPointOfTimeAmountController = TextEditingController();
  var fixedIntervalAmountController = TextEditingController();
  IntervalUnit fixedPointOfTimeUnit = IntervalUnit.week;
  IntervalUnit fixedIntervalUnit = IntervalUnit.day;
  DateTime? enddate;
  double repetitions = 1;

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
      repetitions = widget.initialRecurringData.repetitionAmount != null
          ? widget.initialRecurringData.repetitionAmount!.toDouble()
          : _calculateNeededRepetitions().toDouble();
    } else {
      fixedIntervalAmountController.text = "1";
      fixedIntervalUnit = IntervalUnit.day;
      fixedPointOfTimeAmountController.text = "1";
      fixedPointOfTimeUnit = IntervalUnit.week;
    }
    enddate = _getRecurringData().calculateAndSetEndDate();
  }

  int _calculateNeededRepetitions() {
    // TODO: not finished and buggy
    print("NO");
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
                      enddate = _getRecurringData().calculateAndSetEndDate();
                      _callCallback();
                    });
                  },
                ),
              ),
              InkWell(
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  _onRecurringCheckboxClicked();
                },
                child: Row(
                  children: [
                    Checkbox(
                      value: isRecurring,
                      onChanged: (bool? newValue) {
                        _onRecurringCheckboxClicked();
                      },
                    ),
                    const Text("recurring"),
                  ],
                ),
              ),
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
                        enddate = _getRecurringData().calculateAndSetEndDate();
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
                          enddate =
                              _getRecurringData().calculateAndSetEndDate();
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
                          enddate =
                              _getRecurringData().calculateAndSetEndDate();
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
                        enddate = _getRecurringData().calculateAndSetEndDate();
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
                          enddate =
                              _getRecurringData().calculateAndSetEndDate();
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
                          enddate =
                              _getRecurringData().calculateAndSetEndDate();
                          _callCallback();
                        });
                      },
                    ),
                  )
                ]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Repetitions: ${repetitions.toInt()}"),
                    Slider(
                      value: repetitions,
                      min: 1,
                      max: 100,
                      divisions: 99,
                      onChanged: (string) {
                        repetitions = string;
                        setState(() {
                          enddate =
                              _getRecurringData().calculateAndSetEndDate();
                          _callCallback();
                        });
                      },
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

  void _onRecurringCheckboxClicked() {
    setState(() {
      isRecurring = !isRecurring;
      enddate = _getRecurringData().calculateAndSetEndDate();
      _callCallback();
    });
    if (isRecurring) {
      // scrolling to the bottom of the page to show the recurring fields
      // +90 because the recurring fields are expanding
      widget.scrollController.animateTo(
          widget.scrollController.position.maxScrollExtent + 90,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut);
    }
  }

  void _callCallback() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    widget.onRecurringDataChangedCallback(_getRecurringData());
  }

  RecurringData _getRecurringData() {
    return RecurringData(
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
      repetitionAmount: repetitions.toInt(),
    );
  }
}
