import 'package:flutter/material.dart';

// Define a custom Form widget.
class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _visible = false;
  bool _isLengthLessThanEight = true;
  bool _isUpperCase = true;
  bool _isOneDigit = true;

  String? validateEmail(String? value) {
    const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    final regex = RegExp(pattern);

    return value!.isNotEmpty && !regex.hasMatch(value)
        ? 'Enter a valid email address'
        : null;
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required';
              }

              return validateEmail(value);
            },
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'Email',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Color(0xff6F91BC),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: passwordController,
            keyboardType: TextInputType.visiblePassword,
            obscureText: _visible,
            maxLength: 64,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required';
              }

              if (!RegExp('.*[A-Z].*').hasMatch(value)) {
                return 'This field should have Uppercase and lowercase letters';
              }

              if (!RegExp(".*[0-9].*").hasMatch(value)) {
                return 'This field should have At least one digit';
              }

              return null;
            },
            onChanged: (value) => {
              setState(() {
                _isLengthLessThanEight = value.length < 8;
                _isUpperCase = !RegExp('.*[A-Z].*').hasMatch(value);
                _isOneDigit = !RegExp(".*[0-9].*").hasMatch(value);
              })
            },
            decoration: InputDecoration(
                suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        _visible = !_visible;
                      });
                    },
                    child: const Align(
                      widthFactor: 1.0,
                      heightFactor: 1.0,
                      child: Icon(
                        Icons.visibility_off,
                      ),
                    )),
                hintText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                )),
          ),
          const SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '8 characters or more (no spaces)',
                style: _isLengthLessThanEight
                    ? const TextStyle(color: Colors.red)
                    : const TextStyle(color: Colors.green),
              ),
              Text(
                'Uppercase and lowercase letters',
                style: _isUpperCase
                    ? const TextStyle(color: Colors.red)
                    : const TextStyle(color: Colors.green),
              ),
              Text(
                'At least one digit',
                style: _isOneDigit
                    ? const TextStyle(color: Colors.red)
                    : const TextStyle(color: Colors.green),
              ),
            ],
          ),
          const SizedBox(height: 40),
          Ink(
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(30.0),
                gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xff70C3FF), Color(0xff4B65FF)])),
            child: TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  if (passwordController.text.length < 8 ||
                      !RegExp('.*[A-Z].*').hasMatch(passwordController.text) ||
                      !RegExp(".*[0-9].*").hasMatch(passwordController.text)) {
                    return;
                  }

                  showDialog(
                      context: context,
                      builder: (BuildContext context) => Dialog(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text('Signup success.'),
                                  const SizedBox(height: 15),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Close'),
                                  ),
                                ],
                              ),
                            ),
                          ));
                }
              },
              style: TextButton.styleFrom(
                fixedSize: const Size.fromWidth(240),
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
              ),
              child: const Text(
                'Sign Up',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }
}
