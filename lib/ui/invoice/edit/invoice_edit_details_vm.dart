import 'package:built_collection/built_collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:invoiceninja/redux/client/client_actions.dart';
import 'package:invoiceninja/ui/invoice/edit/invoice_edit_details.dart';
import 'package:redux/redux.dart';
import 'package:invoiceninja/redux/invoice/invoice_actions.dart';
import 'package:invoiceninja/data/models/models.dart';
import 'package:invoiceninja/redux/app/app_state.dart';
import 'package:invoiceninja/redux/client/client_selectors.dart';

class InvoiceEditDetailsScreen extends StatelessWidget {
  InvoiceEditDetailsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, InvoiceEditDetailsVM>(
      converter: (Store<AppState> store) {
        return InvoiceEditDetailsVM.fromStore(store);
      },
      builder: (context, vm) {
        return InvoiceEditDetails(
          viewModel: vm,
        );
      },
    );
  }
}

class InvoiceEditDetailsVM {
  final InvoiceEntity invoice;
  final Function(InvoiceEntity) onChanged;
  final Function(String) onEntityFilterChanged;
  final List<int> clientList;
  final BuiltMap<int, ClientEntity> clientMap;

  InvoiceEditDetailsVM({
    @required this.invoice,
    @required this.onChanged,
    @required this.onEntityFilterChanged,
    @required this.clientList,
    @required this.clientMap,
  });

  factory InvoiceEditDetailsVM.fromStore(Store<AppState> store) {
    AppState state = store.state;
    final invoice = state.invoiceUIState.selected;

    return InvoiceEditDetailsVM(
        invoice: invoice,
        onChanged: (InvoiceEntity invoice) =>
            store.dispatch(UpdateInvoice(invoice)),
        clientList: memoizedDropdownClientList(state.clientState.map,
            state.clientState.list, state.clientUIState.dropdownFilter),
        clientMap: state.clientState.map,
        onEntityFilterChanged: (String filter) =>
            store.dispatch(FilterClientDropdown(filter)));
  }
}
