import 'package:flutter/widgets.dart';
import 'package:invoiceninja/data/file_storage.dart';
import 'package:invoiceninja/data/models/models.dart';
import 'package:invoiceninja/data/repositories/persistence_repository.dart';
import 'package:invoiceninja/redux/app/app_actions.dart';
import 'package:invoiceninja/redux/app/app_state.dart';
import 'package:invoiceninja/redux/auth/auth_actions.dart';
import 'package:invoiceninja/redux/auth/auth_state.dart';
import 'package:invoiceninja/redux/company/company_state.dart';
import 'package:invoiceninja/redux/ui/ui_state.dart';
import 'package:invoiceninja/ui/auth/login_vm.dart';
import 'package:redux/redux.dart';
import 'package:path_provider/path_provider.dart';

List<Middleware<AppState>> createStorePersistenceMiddleware([
  PersistenceRepository authRepository = const PersistenceRepository(
    fileStorage: const FileStorage(
      'auth_state',
      getApplicationDocumentsDirectory,
    ),
  ),
  PersistenceRepository uiRepository = const PersistenceRepository(
    fileStorage: const FileStorage(
      'ui_state',
      getApplicationDocumentsDirectory,
    ),
  ),
  PersistenceRepository company1Repository = const PersistenceRepository(
    fileStorage: const FileStorage(
      'company1_state',
      getApplicationDocumentsDirectory,
    ),
  ),
  PersistenceRepository company2Repository = const PersistenceRepository(
    fileStorage: const FileStorage(
      'company2_state',
      getApplicationDocumentsDirectory,
    ),
  ),
  PersistenceRepository company3Repository = const PersistenceRepository(
    fileStorage: const FileStorage(
      'company3_state',
      getApplicationDocumentsDirectory,
    ),
  ),
  PersistenceRepository company4Repository = const PersistenceRepository(
    fileStorage: const FileStorage(
      'company4_state',
      getApplicationDocumentsDirectory,
    ),
  ),
  PersistenceRepository company5Repository = const PersistenceRepository(
    fileStorage: const FileStorage(
      'company5_state',
      getApplicationDocumentsDirectory,
    ),
  ),
]) {
  final loadState = _createLoadState(
      authRepository,
      uiRepository,
      company1Repository,
      company2Repository,
      company3Repository,
      company4Repository,
      company5Repository);

  final dataLoaded = _createDataLoaded(company1Repository, company2Repository,
      company3Repository, company4Repository, company5Repository);

  final userLoggedIn = _createUserLoggedIn(
      authRepository,
      uiRepository,
      company1Repository,
      company2Repository,
      company3Repository,
      company4Repository,
      company5Repository);

  final uiChange = _createUIChange(uiRepository);

  final deleteState = _createDeleteState(
      authRepository,
      uiRepository,
      company1Repository,
      company2Repository,
      company3Repository,
      company4Repository,
      company5Repository);

  return [
    TypedMiddleware<AppState, UserLogout>(deleteState),
    TypedMiddleware<AppState, LoadStateRequest>(loadState),
    TypedMiddleware<AppState, UserLoginSuccess>(userLoggedIn),
    TypedMiddleware<AppState, PersistData>(dataLoaded),
    TypedMiddleware<AppState, PersistUI>(uiChange),
  ];
}

Middleware<AppState> _createLoadState(
  PersistenceRepository authRepository,
  PersistenceRepository uiRepository,
  PersistenceRepository company1Repository,
  PersistenceRepository company2Repository,
  PersistenceRepository company3Repository,
  PersistenceRepository company4Repository,
  PersistenceRepository company5Repository,
) {
  AuthState authState;
  UIState uiState;
  CompanyState company1State;
  CompanyState company2State;
  CompanyState company3State;
  CompanyState company4State;
  CompanyState company5State;

  return (Store<AppState> store, action, NextDispatcher next) {
    authRepository.exists().then((exists) {
      if (exists) {
        authRepository.loadAuthState().then((state) {
          authState = state;
          uiRepository.loadUIState().then((state) {
            uiState = state;
            company1Repository.loadCompanyState().then((state) {
              company1State = state;
              company2Repository.loadCompanyState().then((state) {
                company2State = state;
                company3Repository.loadCompanyState().then((state) {
                  company3State = state;
                  company4Repository.loadCompanyState().then((state) {
                    company4State = state;
                    company5Repository.loadCompanyState().then((state) {
                      company5State = state;
                      AppState appState = AppState().rebuild((b) => b
                        ..authState.replace(authState)
                        ..uiState.replace(uiState)
                        ..companyState1.replace(company1State)
                        ..companyState2.replace(company2State)
                        ..companyState3.replace(company3State)
                        ..companyState4.replace(company4State)
                        ..companyState5.replace(company5State));
                      store.dispatch(LoadStateSuccess(appState));
                      if (uiState.currentRoute != LoginScreen.route &&
                          authState.url.isNotEmpty) {
                        NavigatorState navigator = Navigator.of(action.context);
                        bool isFirst = true;
                        _getRoutes(appState).forEach((route) {
                          if (isFirst) {
                            navigator.pushReplacementNamed(route);
                          } else {
                            navigator.pushNamed(route);
                          }
                          isFirst = false;
                        });
                      }
                    }).catchError((error) => _handleError(store, error, action.context));
                  }).catchError((error) => _handleError(store, error, action.context));
                }).catchError((error) => _handleError(store, error, action.context));
              }).catchError((error) => _handleError(store, error, action.context));
            }).catchError((error) => _handleError(store, error, action.context));
          }).catchError((error) => _handleError(store, error, action.context));
        }).catchError((error) => _handleError(store, error, action.context));
      } else {
        store.dispatch(UserLogout());
        store.dispatch(LoadUserLogin(action.context));
      }
    }).catchError((error) => _handleError(store, error, action.context));

    next(action);
  };
}

List<String> _getRoutes(AppState state) {
  List<String> routes = [];
  var route = '';
  EntityType entityType = null;

  state.uiState.currentRoute
      .split('/')
      .where((part) => part.isNotEmpty)
      .forEach((part) {
    if (part == 'edit') {
      // Only restore new unsaved entities to prevent conflicts
      bool isNew = state.getUIState(entityType).isSelectedNew;
      if (isNew) {
        route += '/edit';
      } else if (entityType == EntityType.client) {
        route += '/view';
      }
    } else {
      if (entityType == null) {
        entityType = EntityType.valueOf(part);
      }

      route += '/' + part;
    }

    routes.add(route);
  });

  return routes;
}

_handleError(store, error, context) {
  print(error);
  store.dispatch(UserLogout());
  store.dispatch(LoadUserLogin(context));
}

Middleware<AppState> _createUserLoggedIn(
  PersistenceRepository authRepository,
  PersistenceRepository uiRepository,
  PersistenceRepository company1Repository,
  PersistenceRepository company2Repository,
  PersistenceRepository company3Repository,
  PersistenceRepository company4Repository,
  PersistenceRepository company5Repository,
) {
  return (Store<AppState> store, action, NextDispatcher next) {
    next(action);

    var state = store.state;

    authRepository.saveAuthState(state.authState);
    uiRepository.saveUIState(state.uiState);
    company1Repository.saveCompanyState(state.companyState1);
    company2Repository.saveCompanyState(state.companyState2);
    company3Repository.saveCompanyState(state.companyState3);
    company4Repository.saveCompanyState(state.companyState4);
    company5Repository.saveCompanyState(state.companyState5);
  };
}

Middleware<AppState> _createUIChange(PersistenceRepository uiRepository) {
  return (Store<AppState> store, action, NextDispatcher next) {
    next(action);

    uiRepository.saveUIState(store.state.uiState);
  };
}

Middleware<AppState> _createDataLoaded(
  PersistenceRepository company1Repository,
  PersistenceRepository company2Repository,
  PersistenceRepository company3Repository,
  PersistenceRepository company4Repository,
  PersistenceRepository company5Repository,
) {
  return (Store<AppState> store, action, NextDispatcher next) {
    // first process the action so the data is in the state
    next(action);

    AppState state = store.state;

    switch (state.uiState.selectedCompanyIndex) {
      case 1:
        company1Repository.saveCompanyState(state.companyState1);
        break;
      case 2:
        company2Repository.saveCompanyState(state.companyState2);
        break;
      case 3:
        company3Repository.saveCompanyState(state.companyState3);
        break;
      case 4:
        company4Repository.saveCompanyState(state.companyState4);
        break;
      case 5:
        company5Repository.saveCompanyState(state.companyState5);
        break;
    }
  };
}

Middleware<AppState> _createDeleteState(
  PersistenceRepository authRepository,
  PersistenceRepository uiRepository,
  PersistenceRepository company1Repository,
  PersistenceRepository company2Repository,
  PersistenceRepository company3Repository,
  PersistenceRepository company4Repository,
  PersistenceRepository company5Repository,
) {
  return (Store<AppState> store, action, NextDispatcher next) {
    authRepository.delete();
    uiRepository.delete();
    company1Repository.delete();
    company2Repository.delete();
    company3Repository.delete();
    company4Repository.delete();
    company5Repository.delete();

    next(action);
  };
}
