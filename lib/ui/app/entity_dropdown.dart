import 'dart:math';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:invoiceninja/data/models/models.dart';
import 'package:invoiceninja/redux/app/app_state.dart';
import 'package:invoiceninja/utils/localization.dart';
import 'package:redux/redux.dart';

class EntityDropdown extends StatefulWidget {
  EntityDropdown({
    @required this.entityType,
    @required this.labelText,
    @required this.entityList,
    @required this.entityMap,
    @required this.onFilterChanged,
    @required this.onSelected,
    this.initialValue,
  });

  final EntityType entityType;
  final List<int> entityList;
  final BuiltMap<int, BaseEntity> entityMap;
  final String labelText;
  final String initialValue;
  final Function(String) onFilterChanged;
  final Function(int) onSelected;

  @override
  _EntityDropdownState createState() => _EntityDropdownState();
}

class _EntityDropdownState extends State<EntityDropdown> {
  final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textController.text = widget.initialValue;
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  _showOptions() {
    widget.onFilterChanged('');
    var localization = AppLocalization.of(context);

    _headerRow() {
      return Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Icon(
              Icons.search,
              color: Colors.grey,
            ),
          ),
          Expanded(
            child: TextField(
              onChanged: (value) => widget.onFilterChanged(value),
              autofocus: true,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: localization.filter,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          )
        ],
      );
    }

    _entityList(store) {
      return Column(
          mainAxisSize: MainAxisSize.min,
          children: widget.entityList
              .getRange(0, min(6, widget.entityList.length))
              .map((entityId) {
            var entity = widget.entityMap[entityId];
            var filter =
                store.state.getUIState(widget.entityType).dropdownFilter;
            var subtitle = null;
            var matchField = entity.matchesSearchField(filter);
            if (matchField != null) {
              var field = localization.lookup(matchField);
              var value = entity.matchesSearchValue(filter);
              subtitle = '$field: $value';
            }
            return ListTile(
              dense: true,
              title: Text(entity.listDisplayName),
              subtitle: subtitle != null ? Text(subtitle) : null,
              onTap: () {
                _textController.text =
                    widget.entityMap[entityId].listDisplayName;
                widget.onSelected(entityId);
                Navigator.pop(context);
              },
            );
          }).toList());
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: StoreBuilder(
                builder: (BuildContext context, Store<AppState> store) {
              return Column(
                children: <Widget>[
                  Material(
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          _headerRow(),
                          _entityList(store),
                        ]),
                  ),
                  Expanded(child: Container()),
                ],
              );
            }),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showOptions(),
      child: IgnorePointer(
        child: TextFormField(
          controller: _textController,
          decoration: InputDecoration(
            labelText: widget.labelText,
            suffixIcon: Icon(Icons.search),
          ),
        ),
      ),
    );
  }
}
