// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_state.dart';

// **************************************************************************
// Generator: BuiltValueGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line
// ignore_for_file: annotate_overrides
// ignore_for_file: avoid_annotating_with_dynamic
// ignore_for_file: avoid_returning_this
// ignore_for_file: omit_local_variable_types
// ignore_for_file: prefer_expression_function_bodies
// ignore_for_file: sort_constructors_first

Serializer<ClientState> _$clientStateSerializer = new _$ClientStateSerializer();
Serializer<ClientUIState> _$clientUIStateSerializer =
    new _$ClientUIStateSerializer();

class _$ClientStateSerializer implements StructuredSerializer<ClientState> {
  @override
  final Iterable<Type> types = const [ClientState, _$ClientState];
  @override
  final String wireName = 'ClientState';

  @override
  Iterable serialize(Serializers serializers, ClientState object,
      {FullType specifiedType: FullType.unspecified}) {
    final result = <Object>[
      'map',
      serializers.serialize(object.map,
          specifiedType: const FullType(BuiltMap,
              const [const FullType(int), const FullType(ClientEntity)])),
      'list',
      serializers.serialize(object.list,
          specifiedType:
              const FullType(BuiltList, const [const FullType(int)])),
    ];
    if (object.lastUpdated != null) {
      result
        ..add('lastUpdated')
        ..add(serializers.serialize(object.lastUpdated,
            specifiedType: const FullType(int)));
    }

    return result;
  }

  @override
  ClientState deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType: FullType.unspecified}) {
    final result = new ClientStateBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'lastUpdated':
          result.lastUpdated = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'map':
          result.map.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltMap, const [
                const FullType(int),
                const FullType(ClientEntity)
              ])) as BuiltMap);
          break;
        case 'list':
          result.list.replace(serializers.deserialize(value,
                  specifiedType:
                      const FullType(BuiltList, const [const FullType(int)]))
              as BuiltList);
          break;
      }
    }

    return result.build();
  }
}

class _$ClientUIStateSerializer implements StructuredSerializer<ClientUIState> {
  @override
  final Iterable<Type> types = const [ClientUIState, _$ClientUIState];
  @override
  final String wireName = 'ClientUIState';

  @override
  Iterable serialize(Serializers serializers, ClientUIState object,
      {FullType specifiedType: FullType.unspecified}) {
    final result = <Object>[
      'listUIState',
      serializers.serialize(object.listUIState,
          specifiedType: const FullType(ListUIState)),
      'dropdownFilter',
      serializers.serialize(object.dropdownFilter,
          specifiedType: const FullType(String)),
    ];
    if (object.selected != null) {
      result
        ..add('selected')
        ..add(serializers.serialize(object.selected,
            specifiedType: const FullType(ClientEntity)));
    }

    return result;
  }

  @override
  ClientUIState deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType: FullType.unspecified}) {
    final result = new ClientUIStateBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'selected':
          result.selected.replace(serializers.deserialize(value,
              specifiedType: const FullType(ClientEntity)) as ClientEntity);
          break;
        case 'listUIState':
          result.listUIState.replace(serializers.deserialize(value,
              specifiedType: const FullType(ListUIState)) as ListUIState);
          break;
        case 'dropdownFilter':
          result.dropdownFilter = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$ClientState extends ClientState {
  @override
  final int lastUpdated;
  @override
  final BuiltMap<int, ClientEntity> map;
  @override
  final BuiltList<int> list;

  factory _$ClientState([void updates(ClientStateBuilder b)]) =>
      (new ClientStateBuilder()..update(updates)).build();

  _$ClientState._({this.lastUpdated, this.map, this.list}) : super._() {
    if (map == null) throw new BuiltValueNullFieldError('ClientState', 'map');
    if (list == null) throw new BuiltValueNullFieldError('ClientState', 'list');
  }

  @override
  ClientState rebuild(void updates(ClientStateBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  ClientStateBuilder toBuilder() => new ClientStateBuilder()..replace(this);

  @override
  bool operator ==(dynamic other) {
    if (identical(other, this)) return true;
    if (other is! ClientState) return false;
    return lastUpdated == other.lastUpdated &&
        map == other.map &&
        list == other.list;
  }

  @override
  int get hashCode {
    return $jf(
        $jc($jc($jc(0, lastUpdated.hashCode), map.hashCode), list.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ClientState')
          ..add('lastUpdated', lastUpdated)
          ..add('map', map)
          ..add('list', list))
        .toString();
  }
}

class ClientStateBuilder implements Builder<ClientState, ClientStateBuilder> {
  _$ClientState _$v;

  int _lastUpdated;
  int get lastUpdated => _$this._lastUpdated;
  set lastUpdated(int lastUpdated) => _$this._lastUpdated = lastUpdated;

  MapBuilder<int, ClientEntity> _map;
  MapBuilder<int, ClientEntity> get map =>
      _$this._map ??= new MapBuilder<int, ClientEntity>();
  set map(MapBuilder<int, ClientEntity> map) => _$this._map = map;

  ListBuilder<int> _list;
  ListBuilder<int> get list => _$this._list ??= new ListBuilder<int>();
  set list(ListBuilder<int> list) => _$this._list = list;

  ClientStateBuilder();

  ClientStateBuilder get _$this {
    if (_$v != null) {
      _lastUpdated = _$v.lastUpdated;
      _map = _$v.map?.toBuilder();
      _list = _$v.list?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ClientState other) {
    if (other == null) throw new ArgumentError.notNull('other');
    _$v = other as _$ClientState;
  }

  @override
  void update(void updates(ClientStateBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$ClientState build() {
    _$ClientState _$result;
    try {
      _$result = _$v ??
          new _$ClientState._(
              lastUpdated: lastUpdated, map: map.build(), list: list.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'map';
        map.build();
        _$failedField = 'list';
        list.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'ClientState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$ClientUIState extends ClientUIState {
  @override
  final ClientEntity selected;
  @override
  final ListUIState listUIState;
  @override
  final String dropdownFilter;

  factory _$ClientUIState([void updates(ClientUIStateBuilder b)]) =>
      (new ClientUIStateBuilder()..update(updates)).build();

  _$ClientUIState._({this.selected, this.listUIState, this.dropdownFilter})
      : super._() {
    if (listUIState == null)
      throw new BuiltValueNullFieldError('ClientUIState', 'listUIState');
    if (dropdownFilter == null)
      throw new BuiltValueNullFieldError('ClientUIState', 'dropdownFilter');
  }

  @override
  ClientUIState rebuild(void updates(ClientUIStateBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  ClientUIStateBuilder toBuilder() => new ClientUIStateBuilder()..replace(this);

  @override
  bool operator ==(dynamic other) {
    if (identical(other, this)) return true;
    if (other is! ClientUIState) return false;
    return selected == other.selected &&
        listUIState == other.listUIState &&
        dropdownFilter == other.dropdownFilter;
  }

  @override
  int get hashCode {
    return $jf($jc($jc($jc(0, selected.hashCode), listUIState.hashCode),
        dropdownFilter.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ClientUIState')
          ..add('selected', selected)
          ..add('listUIState', listUIState)
          ..add('dropdownFilter', dropdownFilter))
        .toString();
  }
}

class ClientUIStateBuilder
    implements Builder<ClientUIState, ClientUIStateBuilder> {
  _$ClientUIState _$v;

  ClientEntityBuilder _selected;
  ClientEntityBuilder get selected =>
      _$this._selected ??= new ClientEntityBuilder();
  set selected(ClientEntityBuilder selected) => _$this._selected = selected;

  ListUIStateBuilder _listUIState;
  ListUIStateBuilder get listUIState =>
      _$this._listUIState ??= new ListUIStateBuilder();
  set listUIState(ListUIStateBuilder listUIState) =>
      _$this._listUIState = listUIState;

  String _dropdownFilter;
  String get dropdownFilter => _$this._dropdownFilter;
  set dropdownFilter(String dropdownFilter) =>
      _$this._dropdownFilter = dropdownFilter;

  ClientUIStateBuilder();

  ClientUIStateBuilder get _$this {
    if (_$v != null) {
      _selected = _$v.selected?.toBuilder();
      _listUIState = _$v.listUIState?.toBuilder();
      _dropdownFilter = _$v.dropdownFilter;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ClientUIState other) {
    if (other == null) throw new ArgumentError.notNull('other');
    _$v = other as _$ClientUIState;
  }

  @override
  void update(void updates(ClientUIStateBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$ClientUIState build() {
    _$ClientUIState _$result;
    try {
      _$result = _$v ??
          new _$ClientUIState._(
              selected: _selected?.build(),
              listUIState: listUIState.build(),
              dropdownFilter: dropdownFilter);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'selected';
        _selected?.build();
        _$failedField = 'listUIState';
        listUIState.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'ClientUIState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}
