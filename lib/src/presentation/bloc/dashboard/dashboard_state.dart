part of 'dashboard_bloc.dart';

@freezed
abstract class DashboardState with _$DashboardState {
  const factory DashboardState({
    required RequestState state,
    required List<Company> companies,
    required List<Job> jobs,
    required String searchQuery,
    required int activeTab, // 0 = Jobs, 1 = Companies
    required String errorMessage,
  }) = _DashboardState;

  factory DashboardState.initial() => const DashboardState(
        state: RequestState.empty,
        companies: [],
        jobs: [],
        searchQuery: '',
        activeTab: 0,
        errorMessage: '',
      );
}
