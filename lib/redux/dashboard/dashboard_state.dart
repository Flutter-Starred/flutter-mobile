import 'package:invoiceninja/constants.dart';
import 'package:invoiceninja/data/models/models.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dashboard_state.g.dart';

abstract class DashboardState implements Built<DashboardState, DashboardStateBuilder> {

  @nullable
  int get lastUpdated;

  @nullable
  DashboardEntity get data;

  factory DashboardState() {
    return _$DashboardState._(
      data: null,
    );
  }

  bool get isStale {
    if (! isLoaded) {
      return true;
    }

    return DateTime.now().millisecondsSinceEpoch - lastUpdated > kMillisecondsToRefreshData;
  }

  bool get isLoaded {
    return lastUpdated != null;
  }

  DashboardState._();
  static Serializer<DashboardState> get serializer => _$dashboardStateSerializer;
}
