import 'package:bext_notes/features/auth/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';

class AuthNotifier extends ChangeNotifier {
  final AuthBloc authBloc;

  AuthNotifier(this.authBloc) {
    authBloc.stream.listen((state) {
      notifyListeners();
    });
  }
}
