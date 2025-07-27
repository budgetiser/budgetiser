import 'package:budgetiser/core/database/models/account.dart';
import 'package:budgetiser/transactions/multi_step_form/account_picker.dart';
import 'package:flutter/material.dart';

class MultiStepTransactionForm extends StatefulWidget {
  const MultiStepTransactionForm({Key? key}) : super(key: key);

  @override
  State<MultiStepTransactionForm> createState() => _MultiStepTransactionFormState();
}

class _MultiStepTransactionFormState extends State<MultiStepTransactionForm> {
  int _currentStep = 0;
  final _formKeys = List.generate(4, (_) => GlobalKey<FormState>());

  // Form data
  final _personalData = {
    'firstName': '',
    'lastName': '',
    'email': '',
  };

  final _addressData = {
    'street': '',
    'city': '',
    'zipCode': '',
    'country': '',
  };

  final _professionalData = {
    'occupation': '',
    'company': '',
    'experience': '',
  };

  final _additionalData = {
    'interests': '',
    'referral': '',
  };

  bool _isLastStep() {
    return _currentStep == 3;
  }

  bool _isFirstStep() {
    return _currentStep == 0;
  }

  bool _validateCurrentStep() {
    return _formKeys[_currentStep].currentState!.validate();
  }

  void _saveCurrentStep() {
    _formKeys[_currentStep].currentState!.save();
  }

  void _nextStep() {
    if (_validateCurrentStep()) {
      _saveCurrentStep();
      if (!_isLastStep()) {
        setState(() {
          _currentStep++;
        });
      } else {
        _submitForm();
      }
    }
  }

  void _previousStep() {
    if (!_isFirstStep()) {
      setState(() {
        _currentStep--;
      });
    }
  }

  void _submitForm() {
    // Combine all form data
    final formData = {
      ..._personalData,
      ..._addressData,
      ..._professionalData,
      ..._additionalData,
    };

    // Show success dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Form Submitted'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Thank you for submitting the form!', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              const Text('Here is a summary of your information:'),
              const SizedBox(height: 8),
              ...formData.entries.map((entry) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Text('${_formatKey(entry.key)}: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                    Expanded(child: Text(entry.value)),
                  ],
                ),
              )),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Reset form
              setState(() {
                _currentStep = 0;
              });
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String _formatKey(String key) {
    final result = key.replaceAllMapped(
      RegExp(r'([A-Z])'),
          (match) => ' ${match.group(0)}',
    );
    return result[0].toUpperCase() + result.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Multi-Step Form'),
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildProgressIndicator(),
            const SizedBox(height: 16),
            _buildStepTitle(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: _buildCurrentStep(),
              ),
            ),
            _buildNavigation(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: List.generate(
          4,
              (index) => Expanded(
            child: Container(
              height: 4,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: index <= _currentStep ? Theme.of(context).colorScheme.primary : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepTitle() {
    final titles = [
      'Personal Information',
      'Address Details',
      'Professional Background',
      'Additional Information',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Text(
            'Step ${_currentStep + 1} of 4',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            titles[_currentStep],
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildPersonalInfoStep();
      case 1:
        return _buildAddressStep();
      case 2:
        return _buildProfessionalStep();
      case 3:
        return _buildAdditionalInfoStep();
      default:
        return Container();
    }
  }

  Widget _buildPersonalInfoStep() {
    return TransactionFormAccountPicker(
      onAccountPicked: (Account account) {

      },
    );
  }

  Widget _buildAddressStep() {
    return Form(
      key: _formKeys[1],
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Street Address',
              hintText: 'Enter your street address',
              prefixIcon: Icon(Icons.home),
            ),
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your street address';
              }
              return null;
            },
            onSaved: (value) {
              _addressData['street'] = value!;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'City',
              hintText: 'Enter your city',
              prefixIcon: Icon(Icons.location_city),
            ),
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your city';
              }
              return null;
            },
            onSaved: (value) {
              _addressData['city'] = value!;
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'ZIP/Postal Code',
                    hintText: 'Enter your ZIP code',
                    prefixIcon: Icon(Icons.place),
                  ),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter ZIP code';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _addressData['zipCode'] = value!;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Country',
                    hintText: 'Enter your country',
                    prefixIcon: Icon(Icons.flag),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your country';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _addressData['country'] = value!;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildStepDescription(
            'Your address information helps us provide relevant services.',
            Icons.info_outline,
          ),
        ],
      ),
    );
  }

  Widget _buildProfessionalStep() {
    return Form(
      key: _formKeys[2],
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Occupation',
              hintText: 'Enter your occupation',
              prefixIcon: Icon(Icons.work),
            ),
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your occupation';
              }
              return null;
            },
            onSaved: (value) {
              _professionalData['occupation'] = value!;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Company/Organization',
              hintText: 'Enter your company or organization',
              prefixIcon: Icon(Icons.business),
            ),
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your company';
              }
              return null;
            },
            onSaved: (value) {
              _professionalData['company'] = value!;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Years of Experience',
              hintText: 'Enter your years of experience',
              prefixIcon: Icon(Icons.timer),
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your experience';
              } else if (int.tryParse(value) == null) {
                return 'Please enter a valid number';
              }
              return null;
            },
            onSaved: (value) {
              _professionalData['experience'] = value!;
            },
          ),
          const SizedBox(height: 16),
          _buildStepDescription(
            'Your professional background helps us tailor content.',
            Icons.info_outline,
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalInfoStep() {
    return Form(
      key: _formKeys[3],
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Areas of Interest',
              hintText: 'Enter your areas of interest (comma separated)',
              prefixIcon: Icon(Icons.interests),
            ),
            textInputAction: TextInputAction.next,
            maxLines: 2,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your interests';
              }
              return null;
            },
            onSaved: (value) {
              _additionalData['interests'] = value!;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'How did you hear about us?',
              hintText: 'Enter your referral source',
              prefixIcon: Icon(Icons.hearing),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your referral source';
              }
              return null;
            },
            onSaved: (value) {
              _additionalData['referral'] = value!;
            },
          ),
          const SizedBox(height: 24),
          _buildStepDescription(
            'You\'re almost done! Please review all your information before submitting.',
            Icons.check_circle_outline,
          ),
        ],
      ),
    );
  }

  Widget _buildStepDescription(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigation() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (!_isFirstStep())
            OutlinedButton.icon(
              onPressed: _previousStep,
              icon: const Icon(Icons.arrow_back),
              label: const Text('Back'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            )
          else
            const SizedBox(width: 85), // Maintain layout balance
          ElevatedButton.icon(
            onPressed: _nextStep,
            icon: Icon(_isLastStep() ? Icons.check : Icons.arrow_forward),
            label: Text(_isLastStep() ? 'Submit' : 'Next'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}