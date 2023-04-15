import 'package:firebase_app/l10n/s.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({
    super.key,
  });

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();

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
                // text fields and decoration
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return S.of(context)!.enter_valid_email_address;
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: 'Email Address'),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Username'),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                SizedBox(
                  height: 12,
                ),
                OutlinedButton.icon(
                    onPressed: () {
                      _formKey.currentState!.validate();
                    },
                    icon: Icon(Icons.rectangle),
                    label: Text('Login')),
                TextButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.person),
                    label: Text('New Account'))
              ]),
            ),
          )),
    );
  }
}
