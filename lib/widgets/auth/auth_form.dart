import 'dart:io';

import 'package:chat_firebase/widgets/pickers/user_image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final void Function(
    String email,
    String username,
    String password,
    File image,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;
  final bool isLoading;

  @override
  _AuthFormState createState() => _AuthFormState();

  AuthForm(this.submitFn, this.isLoading);
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  var _isLogin = true;
  late File? _userImageFile;

  void _pickedImage(File? image) {
    _userImageFile = image;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState?.validate();
    FocusScope.of(context).unfocus();

    if (_userImageFile == null && !_isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please pick the image'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }

    if (isValid == true && _userImageFile != null) {
      _formKey.currentState?.save();
      widget.submitFn(
        _userEmail.trim(),
        _userName.trim(),
        _userPassword.trim(),
        _userImageFile!,
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_isLogin) UserImagePicker(_pickedImage),
                  TextFormField(
                    key: ValueKey('email'),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty == true ||
                          value.contains('@') == false) {
                        return 'Please enter valid email address';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(labelText: 'Email address'),
                    onSaved: (value) {
                      _userEmail = value!;
                    },
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey('username'),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty == true ||
                            value.length < 4) {
                          return 'Please enter valid user name with at least 4 symbols';
                        }
                        return null;
                      },
                      decoration: InputDecoration(labelText: 'User name'),
                      onSaved: (value) {
                        _userName = value!;
                      },
                    ),
                  TextFormField(
                    key: ValueKey('password'),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty == true ||
                          value.length < 7) {
                        return 'Please enter valid password with at least 7 symbols';
                      }
                      return null;
                    },
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'Password'),
                    onSaved: (value) {
                      _userPassword = value!;
                    },
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  if (widget.isLoading == true) CircularProgressIndicator(),
                  if (widget.isLoading == false)
                    RaisedButton(
                      onPressed: _trySubmit,
                      child: Text(
                        _isLogin == true ? 'Login' : 'Sign up',
                      ),
                    ),
                  if (widget.isLoading == false)
                    FlatButton(
                      textColor: Theme.of(context).primaryColor,
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(
                        _isLogin == true
                            ? 'Create new account'
                            : 'I already have an account',
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
