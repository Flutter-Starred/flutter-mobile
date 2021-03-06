import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:invoiceninja/redux/app/app_actions.dart';
import 'package:invoiceninja/redux/app/app_state.dart';

class LoadStateRequest {
  final BuildContext context;
  LoadStateRequest(this.context);
}
class LoadStateSuccess {
  final AppState state;
  LoadStateSuccess(this.state);
}

class LoadUserLogin {
  final BuildContext context;
  LoadUserLogin(this.context);
}

class UserLoginLoaded {
  final String email;
  final String password;
  final String url;
  final String secret;

  UserLoginLoaded(this.email, this.password, this.url, this.secret);
}

class UserLoginRequest implements StartLoading {
  final Completer completer;
  final String email;
  final String password;
  final String url;
  final String secret;

  UserLoginRequest(this.completer, this.email, this.password, this.url, this.secret);
}

class UserLoginSuccess implements StopLoading {}

class UserLoginFailure implements StopLoading {
  final String error;

  UserLoginFailure(this.error);
}

class UserLogout implements PersistData {}

