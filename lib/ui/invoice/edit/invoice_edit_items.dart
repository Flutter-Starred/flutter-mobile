import 'package:flutter/material.dart';
import 'package:invoiceninja/data/models/models.dart';
import 'package:invoiceninja/ui/invoice/edit/invoice_edit_vm.dart';
import 'package:invoiceninja/utils/localization.dart';
import 'package:invoiceninja/ui/app/form_card.dart';

class InvoiceEditItems extends StatelessWidget {
  InvoiceEditItems({
    Key key,
    @required this.viewModel,
  }) : super(key: key);

  final InvoiceEditVM viewModel;

  @override
  Widget build(BuildContext context) {
    var localization = AppLocalization.of(context);
    var invoice = viewModel.invoice;
    var invoiceItems = invoice.invoiceItems.map((invoiceItem) =>
        ItemEditDetails(
            viewModel: viewModel,
            key: Key('__${EntityType.invoiceItem}_${invoiceItem.id}__'),
            invoiceItem: invoiceItem,
            index: invoice.invoiceItems.indexOf(invoiceItem)));

    return ListView(
      children: []
        ..addAll(invoiceItems)
        ..add(Padding(
          padding: const EdgeInsets.all(12.0),
          child: RaisedButton(
            elevation: 4.0,
            color: Theme.of(context).primaryColor,
            textColor: Theme.of(context).secondaryHeaderColor,
            child: Text(localization.addItem.toUpperCase()),
            onPressed: viewModel.onAddInvoiceItemPressed,
          ),
        )),
    );
  }
}

class ItemEditDetails extends StatefulWidget {
  ItemEditDetails({
    Key key,
    @required this.index,
    @required this.invoiceItem,
    @required this.viewModel,
  }) : super(key: key);

  final int index;
  final InvoiceItemEntity invoiceItem;
  final InvoiceEditVM viewModel;

  @override
  ItemEditDetailsState createState() => ItemEditDetailsState();
}

class ItemEditDetailsState extends State<ItemEditDetails> {
  final _productKeyController = TextEditingController();
  final _notesController = TextEditingController();
  final _costController = TextEditingController();
  final _qtyController = TextEditingController();

  var _controllers = [];

  @override
  void didChangeDependencies() {
    _controllers = [
      _productKeyController,
      _notesController,
      _costController,
      _qtyController,
    ];

    _controllers.forEach((controller) => controller.removeListener(_onChanged));

    var invoiceItem = widget.invoiceItem;
    _productKeyController.text = invoiceItem.productKey;
    _notesController.text = invoiceItem.notes;
    _costController.text = invoiceItem.cost?.toStringAsFixed(2) ?? '';
    _qtyController.text = invoiceItem.qty?.toStringAsFixed(2) ?? '';

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
    var invoiceItem = widget.invoiceItem.rebuild((b) => b
      ..productKey = _productKeyController.text.trim()
      ..notes = _notesController.text.trim()
      ..cost = double.tryParse(_costController.text) ?? 0.0
      ..qty = double.tryParse(_qtyController.text) ?? 0.0);
    if (invoiceItem != widget.invoiceItem) {
      widget.viewModel.onChangedInvoiceItem(invoiceItem, widget.index);
    }
  }

  @override
  Widget build(BuildContext context) {
    var localization = AppLocalization.of(context);

    _confirmDelete() {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              semanticLabel: localization.areYouSure,
              title: Text(localization.areYouSure),
              actions: <Widget>[
                new FlatButton(
                    child: Text(localization.cancel.toUpperCase()),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                new FlatButton(
                    child: Text(localization.ok.toUpperCase()),
                    onPressed: () {
                      widget.viewModel.onRemoveInvoiceItemPressed(widget.index);
                      Navigator.pop(context);
                    })
              ],
            ),
      );
    }

    return FormCard(
      children: <Widget>[
        TextFormField(
          autocorrect: false,
          controller: _productKeyController,
          decoration: InputDecoration(
            labelText: localization.product,
          ),
        ),
        TextFormField(
          autocorrect: false,
          controller: _notesController,
          maxLines: 4,
          decoration: InputDecoration(
            labelText: localization.description,
          ),
        ),
        TextFormField(
          autocorrect: false,
          controller: _costController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: localization.unitCost,
          ),
        ),
        TextFormField(
          autocorrect: false,
          controller: _qtyController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: localization.quantity,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 14.0),
              child: FlatButton(
                child: Text(
                  localization.remove,
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
                onPressed: _confirmDelete,
              ),
            )
          ],
        ),
      ],
    );
  }
}
