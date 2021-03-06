import 'package:flutter/material.dart';
import 'package:invoiceninja/data/models/entities.dart';
import 'package:invoiceninja/ui/app/entity_dropdown.dart';
import 'package:invoiceninja/ui/app/form_card.dart';
import 'package:invoiceninja/ui/app/forms/date_picker.dart';
import 'package:invoiceninja/ui/invoice/edit/invoice_edit_details_vm.dart';
import 'package:invoiceninja/utils/localization.dart';

class InvoiceEditDetails extends StatefulWidget {
  InvoiceEditDetails({
    Key key,
    @required this.viewModel,
  }) : super(key: key);

  final InvoiceEditDetailsVM viewModel;

  @override
  InvoiceEditDetailsState createState() => new InvoiceEditDetailsState();
}

class InvoiceEditDetailsState extends State<InvoiceEditDetails> {
  final _invoiceNumberController = TextEditingController();
  final _invoiceDateController = TextEditingController();
  final _poNumberController = TextEditingController();
  final _discountController = TextEditingController();
  final _partialController = TextEditingController();

  var _controllers = [];

  @override
  void didChangeDependencies() {
    _controllers = [
      _invoiceNumberController,
      _invoiceDateController,
      _poNumberController,
      _discountController,
      _partialController,
    ];

    _controllers.forEach((controller) => controller.removeListener(_onChanged));

    var invoice = widget.viewModel.invoice;
    _invoiceNumberController.text = invoice.invoiceNumber;
    _invoiceDateController.text = invoice.invoiceDate;
    _poNumberController.text = invoice.poNumber;
    _discountController.text = invoice.discount?.toStringAsFixed(2) ?? '';
    _partialController.text = invoice.partial?.toStringAsFixed(2) ?? '';

    _controllers.forEach((controller) => controller.addListener(_onChanged));

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controllers.forEach((controller) {
      controller.removeListener(_onChanged);
      controller.dispose();
    });

    super.dispose();
  }

  _onChanged() {
    var invoice = widget.viewModel.invoice.rebuild((b) => b
      ..invoiceNumber = widget.viewModel.invoice.isNew()
          ? null
          : _invoiceNumberController.text.trim()
      ..poNumber = _poNumberController.text.trim()
      ..discount = double.tryParse(_discountController.text) ?? 0.0
      ..partial = double.tryParse(_partialController.text) ?? 0.0);
    if (invoice != widget.viewModel.invoice) {
      widget.viewModel.onChanged(invoice);
    }
  }

  @override
  Widget build(BuildContext context) {
    var localization = AppLocalization.of(context);
    var viewModel = widget.viewModel;
    var invoice = viewModel.invoice;

    return ListView(
      children: <Widget>[
        FormCard(
          children: <Widget>[
            invoice.isNew()
                ? EntityDropdown(
                    entityType: EntityType.client,
                    labelText: localization.client,
                    initialValue:
                        viewModel.clientMap[invoice.clientId]?.displayName,
                    entityList: viewModel.clientList,
                    entityMap: viewModel.clientMap,
                    onFilterChanged: viewModel.onEntityFilterChanged,
                    onSelected: (clientId) {
                      viewModel.onChanged(
                          invoice.rebuild((b) => b..clientId = clientId));
                    },
                  )
                : TextFormField(
                    autocorrect: false,
                    controller: _invoiceNumberController,
                    decoration: InputDecoration(
                      labelText: localization.invoiceNumber,
                    ),
                  ),
            DatePicker(
              labelText: localization.invoiceDate,
              selectedDate: invoice.invoiceDate,
              onSelected: (date) {
                viewModel.onChanged(
                    invoice.rebuild((b) => b..invoiceDate = date));
              },
            ),
            DatePicker(
              labelText: localization.dueDate,
              selectedDate: invoice.dueDate,
              onSelected: (date) {
                viewModel.onChanged(
                    invoice.rebuild((b) => b..dueDate = date));
              },
            ),
            TextFormField(
              autocorrect: false,
              controller: _partialController,
              decoration: InputDecoration(
                labelText: localization.partial,
              ),
              keyboardType: TextInputType.number,
            ),
            invoice.partial != null && invoice.partial > 0 ? DatePicker(
              labelText: localization.partialDueDate,
              selectedDate: invoice.partialDueDate,
              onSelected: (date) {
                viewModel.onChanged(
                    invoice.rebuild((b) => b..partialDueDate = date));
              },
            ) : Container(),
            TextFormField(
              autocorrect: false,
              controller: _poNumberController,
              decoration: InputDecoration(
                labelText: localization.poNumber,
              ),
            ),
            TextFormField(
              autocorrect: false,
              controller: _discountController,
              decoration: InputDecoration(
                labelText: localization.discount,
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ],
    );
  }
}
