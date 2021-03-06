import 'package:flutter/widgets.dart';
import 'package:invoiceninja/redux/client/client_actions.dart';
import 'package:invoiceninja/redux/ui/ui_actions.dart';
import 'package:invoiceninja/ui/dashboard/dashboard_screen.dart';
import 'package:redux/redux.dart';
import 'package:invoiceninja/redux/dashboard/dashboard_actions.dart';
import 'package:invoiceninja/redux/app/app_state.dart';
import 'package:invoiceninja/data/repositories/dashboard_repository.dart';

List<Middleware<AppState>> createStoreDashboardMiddleware([
  DashboardRepository repository = const DashboardRepository(),
]) {
  final viewDashboard = _createViewDashboard();
  final loadDashboard = _createLoadDashboard(repository);

  return [
    TypedMiddleware<AppState, ViewDashboard>(viewDashboard),
    TypedMiddleware<AppState, LoadDashboard>(loadDashboard),
  ];
}


Middleware<AppState> _createViewDashboard() {
  return (Store<AppState> store, action, NextDispatcher next) {
    store.dispatch(LoadDashboard());
    store.dispatch(UpdateCurrentRoute(DashboardScreen.route));

    if (action.context != null) {
      NavigatorState navigator = Navigator.of(action.context);
      navigator.pushReplacementNamed(DashboardScreen.route);
    }

    next(action);
  };
}

Middleware<AppState> _createLoadDashboard(DashboardRepository repository) {
  return (Store<AppState> store, action, NextDispatcher next) {
    AppState state = store.state;

    if (!state.dashboardState.isStale && !action.force) {
      next(action);
      return;
    }

    if (state.isLoading) {
      next(action);
      return;
    }

    store.dispatch(LoadDashboardRequest());
    repository.loadItem(state.selectedCompany, state.authState).then((data) {
      store.dispatch(LoadDashboardSuccess(data));
      if (action.completer != null) {
        action.completer.complete(null);
      }
      if (state.clientState.isStale) {
        store.dispatch(LoadClients());
      }
    }).catchError((error) {
      print(error);
      store.dispatch(LoadDashboardFailure(error));
    });

    next(action);
  };
}
