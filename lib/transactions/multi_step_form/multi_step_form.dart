import 'package:budgetiser/transactions/multi_step_form/account_selection_step.dart';
import 'package:budgetiser/transactions/multi_step_form/multi_step_element.dart';
import 'package:flutter/material.dart';

class MultiStepTransactionForm extends StatefulWidget {
  MultiStepTransactionForm({super.key, required this.steps});

  List<MultiStepElement> steps;

  @override
  State<MultiStepTransactionForm> createState() =>
      _MultiStepTransactionFormState();
}

class _MultiStepTransactionFormState extends State<MultiStepTransactionForm> {
  late List<GlobalKey<FormState>> _formKeys;
  int _currentStep = 0;

  @override
  void initState() {
    _formKeys =
        List.generate(widget.steps.length, (_) => GlobalKey<FormState>());
    super.initState();
  }

  bool _isLastStep() {
    return _currentStep == _formKeys.length - 1;
  }

  bool _isFirstStep() {
    return _currentStep == 0;
  }

  bool _validateCurrentStep() {
    return _formKeys[_currentStep].currentState!.validate();
  }

  void _goToStep(int step) {
    if (!_validateCurrentStep()) {
      return;
    }
    if (step >= 0 && step < _formKeys.length) {
      setState(() {
        _currentStep = step;
      });
    }
  }

  void _nextStepOrSubmit() {
    if (_validateCurrentStep()) {
      if (!_isLastStep()) {
        setState(() {
          _currentStep++;
        });
      } else {
        // TODO: submit the form
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create new Transaction'),
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildProgressIndicator(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: _buildCurrentStep(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text(_isLastStep() ? 'Submit' : 'Next'),
        icon: _isLastStep()
            ? const Icon(Icons.check)
            : const Icon(Icons.arrow_forward),
        onPressed: () => {
          setState(() {
            _nextStepOrSubmit();
          }),
        },
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: List.generate(
          _formKeys.length,
          (index) => Expanded(
            child: InkWell(
              onTap: () => setState(() {
                _currentStep = index;
              }),
              child: Column(
                children: [
                  Container(
                    height: 4,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: _generateStepColor(index),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 4),
                  widget.steps[index].header,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _generateStepColor(int step) {
    if (step < _currentStep) {
      return Colors.green;
    } else if (step == _currentStep) {
      return Theme.of(context).colorScheme.primary;
    } else {
      return Colors.grey.shade300;
    }
  }

  Widget _buildCurrentStep() {
    return widget.steps[_currentStep];
  }

  Widget buildAccountSelection() {
    return Form(
      key: _formKeys[0],
      child: AccountSelectionFormField(
        validator: (value) {
          if (value == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.green,
                content: Text(
                  'FOOOOOOOO ${value}',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
            return 'Please select an account';
          } else if (value.$1 == null && value.$2 == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.green,
                content: Text(
                  '${value}',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
            return 'Please select an saccount';
          }
          return null;
        },
      ),
    );
  }
}
