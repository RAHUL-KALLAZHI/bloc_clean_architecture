import 'package:bloc_clean_architecture/src/comman/enum.dart';
import 'package:bloc_clean_architecture/src/domain/entities/company.dart';
import 'package:bloc_clean_architecture/src/domain/entities/job.dart';
import 'package:bloc_clean_architecture/src/domain/usecase/get_companies.dart';
import 'package:bloc_clean_architecture/src/domain/usecase/get_jobs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';
part 'dashboard_bloc.freezed.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetCompanies _getCompanies;
  final GetJobs _getJobs;

  DashboardBloc(this._getCompanies, this._getJobs)
      : super(DashboardState.initial()) {
    on<DashboardEvent>((event, emit) async {
      await event.map(
        fetchData: (_) async {
          emit(state.copyWith(state: RequestState.loading));

          final companiesResult = await _getCompanies.execute();
          final jobsResult = await _getJobs.execute();

          List<Company> fetchedCompanies = state.companies;
          List<Job> fetchedJobs = state.jobs;
          String errorMsg = '';
          bool hasError = false;

          companiesResult.fold(
            (failure) {
              errorMsg += 'Companies error: ${failure.message}\n';
              hasError = true;
            },
            (companies) {
              fetchedCompanies = List<Company>.from(companies)
                ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
            },
          );

          jobsResult.fold(
            (failure) {
              errorMsg += 'Jobs error: ${failure.message}';
              hasError = true;
            },
            (jobs) {
              fetchedJobs = jobs;
            },
          );

          if (hasError) {
            emit(state.copyWith(
              state: RequestState.error,
              errorMessage: errorMsg,
              companies: fetchedCompanies,
              jobs: fetchedJobs,
            ));
          } else {
            emit(state.copyWith(
              state: RequestState.loaded,
              companies: fetchedCompanies,
              jobs: fetchedJobs,
            ));
          }
        },
        searchQueryChanged: (e) {
          emit(state.copyWith(searchQuery: e.query));
        },
        tabChanged: (e) {
          emit(state.copyWith(activeTab: e.tabIndex));
        },
      );
    });
  }
}
