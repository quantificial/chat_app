import 'dart:io';

import 'package:firebase_app/l10n/s.dart';
import 'package:firebase_app/main.dart';
import 'package:firebase_app/widgets/pickers/user_image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({
    super.key,
    required this.submitAuthForm,
  });

  final void Function(String email, String password, String username,
      File? image, bool isLogin) submitAuthForm;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();

  bool _isLogin = true;
  bool _isLoading = false;

  String lang = 'en';

  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';

  File? _userImageFile;

  void _pickImage(File image) {
    _userImageFile = image;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
          margin: EdgeInsets.all(20),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              // flutter form
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                if (!_isLogin) UserImagePicker(imagePickFn: _pickImage),

                // text fields and decoration
                TextFormField(
                  key: const ValueKey('email'),
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return S.of(context)!.enter_valid_email_address;
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration:
                      InputDecoration(labelText: S.of(context)!.email_address),
                  onSaved: (newValue) => _userEmail = newValue!,
                ),
                if (!_isLogin)
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Username'),
                    key: const ValueKey('username'),
                    validator: (value) {
                      if (value!.length < 4) {
                        return 'invalid username';
                      }

                      return null;
                    },
                    onSaved: (newValue) => _userName = newValue!,
                  ),
                TextFormField(
                  key: const ValueKey('password'),
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 7) {
                      return 'password invalid';
                    }
                    return null;
                  },
                  onSaved: (newValue) => _userPassword = newValue!,
                ),
                SizedBox(
                  height: 12,
                ),
                if (_isLoading) CircularProgressIndicator(),
                if (!_isLoading)
                  OutlinedButton.icon(
                      onPressed: () {
                        setState(() {
                          _isLoading = true;
                        });
                        // Validation ////////////////////////////////////
                        final isValid = _formKey.currentState!.validate();
                        FocusScope.of(context).unfocus();

                        if (_userImageFile == null && !_isLogin) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Please pick an image')));

                          setState(() {
                            _isLoading = false;
                          });

                          return;
                        }

                        // Save /////////////////////////////////////////
                        if (isValid) {
                          _formKey.currentState!.save();
                          widget.submitAuthForm(_userEmail, _userPassword,
                              _userName, _userImageFile, _isLogin);
                          // print(_userEmail);
                          // print(_userName);
                          // print(_userPassword);
                          //Future.delayed(Duration(seconds: 5));
                        }
                        setState(() {
                          _isLoading = false;
                        });
                      },
                      icon: Icon(Icons.rectangle),
                      label: Text('Login')),
                TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
                    icon: Icon(Icons.person),
                    label: Text(_isLogin
                        ? 'Create New Account'
                        : 'I already have an account')),
                TextButton.icon(
                    onPressed: () {
                      lang = lang == 'en' ? 'zh' : 'en';
                      MyApp.setLocale(context, Locale(lang));
                    },
                    icon: Icon(Icons.language),
                    label: Text('Switch Language'))
              ]),
            ),
          )),
    );
  }
}
