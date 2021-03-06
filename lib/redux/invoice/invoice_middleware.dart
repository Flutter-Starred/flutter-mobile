import 'package:flutter/material.dart';
import 'package:invoiceninja/data/models/models.dart';
import 'package:invoiceninja/redux/ui/ui_actions.dart';
import 'package:invoiceninja/ui/invoice/edit/invoice_edit_vm.dart';
import 'package:invoiceninja/ui/invoice/invoice_screen.dart';
import 'package:invoiceninja/ui/invoice/view/invoice_view_vm.dart';
import 'package:redux/redux.dart';
import 'package:invoiceninja/redux/invoice/invoice_actions.dart';
import 'package:invoiceninja/redux/client/client_actions.dart';
import 'package:invoiceninja/redux/app/app_state.dart';
import 'package:invoiceninja/data/repositories/invoice_repository.dart';

List<Middleware<AppState>> createStoreInvoicesMiddleware([
  InvoiceRepository repository = const InvoiceRepository(),
]) {
  final viewInvoiceList = _viewInvoiceList();
  final viewInvoice = _viewInvoice();
  final editInvoice = _editInvoice();
  final loadInvoices = _loadInvoices(repository);
  final saveInvoice = _saveInvoice(repository);
  final archiveInvoice = _archiveInvoice(repository);
  final deleteInvoice = _deleteInvoice(repository);
  final restoreInvoice = _restoreInvoice(repository);
  final emailInvoice = _emailInvoice(repository);

  return [
    TypedMiddleware<AppState, ViewInvoiceList>(viewInvoiceList),
    TypedMiddleware<AppState, ViewInvoice>(viewInvoice),
    TypedMiddleware<AppState, EditInvoice>(editInvoice),
    TypedMiddleware<AppState, LoadInvoices>(loadInvoices),
    TypedMiddleware<AppState, SaveInvoiceRequest>(saveInvoice),
    TypedMiddleware<AppState, ArchiveInvoiceRequest>(archiveInvoice),
    TypedMiddleware<AppState, DeleteInvoiceRequest>(deleteInvoice),
    TypedMiddleware<AppState, RestoreInvoiceRequest>(restoreInvoice),
    TypedMiddleware<AppState, EmailInvoiceRequest>(emailInvoice),
  ];
}

Middleware<AppState> _viewInvoiceList() {
  return (Store<AppState> store, action, NextDispatcher next) {
    store.dispatch(LoadInvoices());
    store.dispatch(UpdateCurrentRoute(InvoiceScreen.route));

    if (action.context != null) {
      NavigatorState navigator = Navigator.of(action.context);
      navigator.pushReplacementNamed(InvoiceScreen.route);
    }

    next(action);
  };
}

Middleware<AppState> _viewInvoice() {
  return (Store<AppState> store, action, NextDispatcher next) {
    next(action);

    store.dispatch(UpdateCurrentRoute(InvoiceViewScreen.route));
    Navigator.of(action.context).pushNamed(InvoiceViewScreen.route);
  };
}

Middleware<AppState> _editInvoice() {
  return (Store<AppState> store, action, NextDispatcher next) {
    next(action);

    store.dispatch(UpdateCurrentRoute(InvoiceEditScreen.route));
    Navigator.of(action.context).pushNamed(InvoiceEditScreen.route);
  };
}

Middleware<AppState> _archiveInvoice(InvoiceRepository repository) {
  return (Store<AppState> store, action, NextDispatcher next) {
    var origInvoice = store.state.invoiceState.map[action.invoiceId];
    repository
        .saveData(store.state.selectedCompany, store.state.authState,
            origInvoice, EntityAction.archive)
        .then((invoice) {
      store.dispatch(ArchiveInvoiceSuccess(invoice));
      if (action.completer != null) {
        action.completer.complete(null);
      }
    }).catchError((error) {
      print(error);
      store.dispatch(ArchiveInvoiceFailure(origInvoice));
    });

    next(action);
  };
}

Middleware<AppState> _deleteInvoice(InvoiceRepository repository) {
  return (Store<AppState> store, action, NextDispatcher next) {
    var origInvoice = store.state.invoiceState.map[action.invoiceId];
    repository
        .saveData(store.state.selectedCompany, store.state.authState,
            origInvoice, EntityAction.delete)
        .then((invoice) {
      store.dispatch(DeleteInvoiceSuccess(invoice));
      if (action.completer != null) {
        action.completer.complete(null);
      }
    }).catchError((error) {
      print(error);
      store.dispatch(DeleteInvoiceFailure(origInvoice));
    });

    next(action);
  };
}

Middleware<AppState> _restoreInvoice(InvoiceRepository repository) {
  return (Store<AppState> store, action, NextDispatcher next) {
    var origInvoice = store.state.invoiceState.map[action.invoiceId];
    repository
        .saveData(store.state.selectedCompany, store.state.authState,
            origInvoice, EntityAction.restore)
        .then((invoice) {
      store.dispatch(RestoreInvoiceSuccess(invoice));
      if (action.completer != null) {
        action.completer.complete(null);
      }
    }).catchError((error) {
      print(error);
      store.dispatch(RestoreInvoiceFailure(origInvoice));
    });

    next(action);
  };
}

Middleware<AppState> _emailInvoice(InvoiceRepository repository) {
  return (Store<AppState> store, action, NextDispatcher next) {
    var origInvoice = store.state.invoiceState.map[action.invoiceId];
    repository
        .emailInvoice(store.state.selectedCompany, store.state.authState,
        origInvoice)
        .then((response) {
      store.dispatch(EmailInvoiceSuccess());
      if (action.completer != null) {
        action.completer.complete(null);
      }
    }).catchError((error) {
      print(error);
      store.dispatch(EmailInvoiceFailure(error));
    });

    next(action);
  };
}

Middleware<AppState> _saveInvoice(InvoiceRepository repository) {
  return (Store<AppState> store, action, NextDispatcher next) {
    repository
        .saveData(
            store.state.selectedCompany, store.state.authState, action.invoice)
        .then((invoice) {
      if (action.invoice.isNew()) {
        store.dispatch(AddInvoiceSuccess(invoice));
      } else {
        store.dispatch(SaveInvoiceSuccess(invoice));
      }
      action.completer.complete(null);
    }).catchError((error) {
      print(error);
      store.dispatch(SaveInvoiceFailure(error));
    });

    next(action);
  };
}

Middleware<AppState> _loadInvoices(InvoiceRepository repository) {
  return (Store<AppState> store, action, NextDispatcher next) {

    AppState state = store.state;

    if (!state.invoiceState.isStale && !action.force) {
      next(action);
      return;
    }

    if (state.isLoading) {
      next(action);
      return;
    }

    store.dispatch(LoadInvoicesRequest());
    repository
        .loadList(state.selectedCompany, state.authState)
        .then((data) {
      store.dispatch(LoadInvoicesSuccess(data));
      if (action.completer != null) {
        action.completer.complete(null);
      }
      if (state.clientState.isStale) {
        store.dispatch(LoadClients());
      }
    }).catchError((error) {
      print(error);
      store.dispatch(LoadInvoicesFailure(error));
    });

    next(action);
  };
}
