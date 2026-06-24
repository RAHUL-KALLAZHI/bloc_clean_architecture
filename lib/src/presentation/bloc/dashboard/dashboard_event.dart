part of 'dashboard_bloc.dart';

@freezed
class DashboardEvent with _$DashboardEvent {
  const factory DashboardEvent.fetchData() = _FetchData;
  const factory DashboardEvent.searchQueryChanged(String query) = _SearchQueryChanged;
  const factory DashboardEvent.tabChanged(int tabIndex) = _TabChanged;
}
