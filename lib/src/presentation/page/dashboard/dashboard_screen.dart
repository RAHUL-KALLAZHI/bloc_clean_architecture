import 'package:bloc_clean_architecture/src/comman/routes.dart';
import 'package:bloc_clean_architecture/src/comman/enum.dart';
import 'package:bloc_clean_architecture/src/domain/entities/company.dart';
import 'package:bloc_clean_architecture/src/domain/entities/job.dart';
import 'package:bloc_clean_architecture/src/presentation/bloc/authenticator_watcher/authenticator_watcher_bloc.dart';
import 'package:bloc_clean_architecture/src/presentation/bloc/dashboard/dashboard_bloc.dart';
import 'package:bloc_clean_architecture/src/utilities/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bloc_clean_architecture/src/presentation/cubit/theme/theme_cubit.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  final TextEditingController _searchController = TextEditingController();
  Company? _selectedCompany;

  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(const DashboardEvent.fetchData());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _formatTimestamp(int timestamp) {
    if (timestamp <= 0) return 'Unknown';
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showJobDetails(BuildContext context, Job job, String companyName) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.75),
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: theme.disabledColor.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  job.title,
                  style: theme.textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  companyName,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Updated on ${_formatTimestamp(job.lastUpdated)}',
                  style: theme.textTheme.titleSmall,
                ),
                if ((job.postedDate != null && job.postedDate!.isNotEmpty) ||
                    (job.lastDateToApply != null &&
                        job.lastDateToApply!.isNotEmpty)) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 16,
                    runSpacing: 8,
                    children: [
                      if (job.postedDate != null && job.postedDate!.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: theme.primaryColor.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: theme.primaryColor.withOpacity(0.15),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                size: 14,
                                color: theme.primaryColor,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Published: ${job.postedDate}',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  color: theme.primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (job.lastDateToApply != null &&
                          job.lastDateToApply!.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.error.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: theme.colorScheme.error.withOpacity(0.15),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.hourglass_empty_outlined,
                                size: 14,
                                color: theme.colorScheme.error,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Apply by: ${job.lastDateToApply}',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  color: theme.colorScheme.error,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
                const Divider(height: 30),
                Text(
                  'Job Description',
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  job.description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.language),
                        label: const Text('Open Job Link'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.disabledColor.withOpacity(0.2),
                          foregroundColor: theme.textTheme.bodyLarge?.color,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () async {
                          if (job.jobUrl.isNotEmpty) {
                            var urlString = job.jobUrl.trim();
                            if (!urlString.startsWith('http://') &&
                                !urlString.startsWith('https://')) {
                              urlString = 'https://$urlString';
                            }
                            final uri = Uri.parse(urlString);
                            try {
                              final launched = await launchUrl(
                                uri,
                                mode: LaunchMode.inAppWebView,
                              );
                              if (!launched) {
                                Fluttertoast.showToast(
                                  msg: 'Could not launch URL',
                                );
                              }
                            } catch (e) {
                              Fluttertoast.showToast(
                                msg: 'Error opening link: $e',
                              );
                            }
                          } else {
                            Fluttertoast.showToast(msg: 'No link available');
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.email),
                        label: const Text('Apply / Contact'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () async {
                          if (job.email.isNotEmpty) {
                            final Uri emailLaunchUri = Uri(
                              scheme: 'mailto',
                              path: job.email.trim(),
                              queryParameters: {
                                'subject': 'Application for ${job.title}',
                              },
                            );
                            try {
                              final launched = await launchUrl(emailLaunchUri);
                              if (!launched) {
                                Fluttertoast.showToast(
                                  msg: 'Could not open mail client',
                                );
                              }
                            } catch (e) {
                              Fluttertoast.showToast(
                                msg: 'Error opening mail client: $e',
                              );
                            }
                          } else {
                            Fluttertoast.showToast(
                              msg: 'No contact email available',
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Company> _groupCompanies(List<Company> companies) {
    final Map<String, List<Company>> groupedByName = {};
    for (final company in companies) {
      final key = company.name.trim().toLowerCase();
      if (key.isNotEmpty) {
        groupedByName.putIfAbsent(key, () => []).add(company);
      }
    }

    final List<Company> uniqueCompanies = [];
    groupedByName.forEach((key, list) {
      final first = list.first;
      
      final Map<String, bool> combinedJobIds = {};
      for (final c in list) {
        combinedJobIds.addAll(c.jobIds);
      }
      
      int combinedJobCount = 0;
      for (final c in list) {
        combinedJobCount += c.jobCount;
      }
      
      int newestLastUpdated = 0;
      for (final c in list) {
        if (c.lastUpdated > newestLastUpdated) {
          newestLastUpdated = c.lastUpdated;
        }
      }
      
      String? mergedLogoUrl;
      for (final c in list) {
        if (c.logoUrl != null && c.logoUrl!.trim().isNotEmpty) {
          mergedLogoUrl = c.logoUrl;
          break;
        }
      }

      uniqueCompanies.add(Company(
        id: first.id,
        name: first.name,
        email: first.email,
        jobCount: combinedJobCount,
        jobIds: combinedJobIds,
        lastUpdated: newestLastUpdated,
        logoUrl: mergedLogoUrl,
      ));
    });

    return uniqueCompanies;
  }

  Widget _buildCompanyHeader(Company company) {
    final theme = Theme.of(context);
    final initials = company.name.trim().isNotEmpty
        ? company.name
            .trim()
            .split(' ')
            .map((e) => e[0])
            .take(2)
            .join()
            .toUpperCase()
        : '?';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      color: theme.primaryColor.withOpacity(0.05),
      child: Column(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor:
                (company.logoUrl != null && company.logoUrl!.isNotEmpty)
                    ? Colors.white
                    : theme.primaryColor,
            child: (company.logoUrl != null && company.logoUrl!.isNotEmpty)
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(35),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: CachedNetworkImage(
                        imageUrl: company.logoUrl!,
                        fit: BoxFit.contain,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        errorWidget: (context, url, error) => Text(
                          initials,
                          style: TextStyle(
                            color: theme.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  )
                : Text(
                    initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
          ),
          const SizedBox(height: 12),
          Text(
            company.name,
            textAlign: TextAlign.center,
            style: theme.textTheme.displayMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            company.email,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.hintColor,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: theme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${company.jobCount} Active Opening${company.jobCount == 1 ? '' : 's'}',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopScope(
      canPop: _selectedCompany == null,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _selectedCompany != null) {
          setState(() {
            _selectedCompany = null;
            _searchController.clear();
            context.read<DashboardBloc>().add(
                  const DashboardEvent.searchQueryChanged(''),
                );
          });
        }
      },
      child: BlocListener<AuthenticatorWatcherBloc, AuthenticatorWatcherState>(
        listener: (context, state) {
          state.maybeMap(
            orElse: () {},
            unauthenticated: (_) {
              context.goNamed(AppRoutes.LOGIN_ROUTE_NAME);
            },
          );
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(_selectedCompany?.name ?? 'Job Portal'),
            backgroundColor: theme.primaryColor,
            foregroundColor: Colors.white,
            leading: _selectedCompany != null
                ? IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      setState(() {
                        _selectedCompany = null;
                        _searchController.clear();
                        context.read<DashboardBloc>().add(
                              const DashboardEvent.searchQueryChanged(''),
                            );
                      });
                    },
                  )
                : Builder(
                    builder: (context) => IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  ),
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Builder(
                  builder: (context) {
                    User? user;
                    try {
                      user = FirebaseAuth.instance.currentUser;
                    } catch (_) {
                      // Safe fallback if Firebase is not initialized (e.g. in widget tests)
                    }
                    final email = user?.email ?? 'No Email';
                    final name = user?.displayName ?? 'Guest User';
                    final photoUrl = user?.photoURL;

                    return UserAccountsDrawerHeader(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                      ),
                      currentAccountPicture: CircleAvatar(
                        backgroundImage:
                            photoUrl != null ? NetworkImage(photoUrl) : null,
                        backgroundColor: Colors.white,
                        child: photoUrl == null
                            ? Text(
                                name.trim().isNotEmpty
                                    ? name
                                        .trim()
                                        .split(' ')
                                        .map((e) => e[0])
                                        .take(2)
                                        .join()
                                        .toUpperCase()
                                    : '?',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              )
                            : null,
                      ),
                      accountName: Text(
                        name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      accountEmail: Text(email),
                    );
                  },
                ),
                BlocBuilder<ThemeCubit, ThemeState>(
                  builder: (context, themeState) {
                    final isDark = themeState is ThemeDark;
                    return SwitchListTile(
                      title: const Text('Dark Mode'),
                      secondary:
                          Icon(isDark ? Icons.dark_mode : Icons.light_mode),
                      value: isDark,
                      onChanged: (_) {
                        context.read<ThemeCubit>().changeTheme();
                      },
                    );
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.exit_to_app, color: Colors.red),
                  title: const Text(
                    'Sign Out',
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    context.read<AuthenticatorWatcherBloc>().add(
                          const AuthenticatorWatcherEvent.signOut(),
                        );
                  },
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(
                    child: Text(
                      'App Version: 1.0.0+1',
                      style: TextStyle(
                          color: Theme.of(context).hintColor, fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: BlocBuilder<DashboardBloc, DashboardState>(
            builder: (context, state) {
              final query = state.searchQuery.toLowerCase();

              if (_selectedCompany != null) {
                // Selected company jobs
                final company = _selectedCompany!;
                final companyJobs = state.jobs.where((job) {
                  final jobCompany = state.companies.firstWhere(
                    (c) => c.id == job.companyId,
                    orElse: () => Company(
                      id: '',
                      name: '',
                      email: '',
                      jobCount: 0,
                      jobIds: const {},
                      lastUpdated: 0,
                    ),
                  );
                  return jobCompany.name.trim().toLowerCase() ==
                      company.name.trim().toLowerCase();
                }).toList();

                final filteredJobs = companyJobs.where((job) {
                  return job.title.toLowerCase().contains(query) ||
                      job.description.toLowerCase().contains(query);
                }).toList();

                return Column(
                  children: [
                    _buildCompanyHeader(company),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      color: theme.primaryColor.withOpacity(0.05),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (val) {
                          context.read<DashboardBloc>().add(
                                DashboardEvent.searchQueryChanged(val),
                              );
                        },
                        decoration: InputDecoration(
                          hintText: 'Search jobs under this company...',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _searchController.clear();
                                    context.read<DashboardBloc>().add(
                                          const DashboardEvent
                                              .searchQueryChanged(''),
                                        );
                                  },
                                )
                              : null,
                          filled: true,
                          fillColor: theme.cardColor,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          if (filteredJobs.isEmpty) {
                            return _buildEmptyState(
                              context,
                              'No jobs found matching "${state.searchQuery}"',
                            );
                          }

                          return ListView.builder(
                            key: ValueKey('jobs_list_${company.id}'),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 12.0,
                            ),
                            itemCount: filteredJobs.length,
                            itemBuilder: (context, index) {
                              final job = filteredJobs[index];
                              return _buildJobCard(context, job, company);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                );
              }

              // Otherwise, list of companies (grouped to merge duplicates)
              final filteredCompanies = state.companies.where((company) {
                return company.name.toLowerCase().contains(query) ||
                    company.email.toLowerCase().contains(query);
              }).toList();

              final uniqueCompanies = _groupCompanies(filteredCompanies)
                ..sort((a, b) =>
                    a.name.toLowerCase().compareTo(b.name.toLowerCase()));

              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    color: theme.primaryColor.withOpacity(0.05),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (val) {
                        context.read<DashboardBloc>().add(
                              DashboardEvent.searchQueryChanged(val),
                            );
                      },
                      decoration: InputDecoration(
                        hintText: 'Search companies by name or email...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();
                                  context.read<DashboardBloc>().add(
                                        const DashboardEvent
                                            .searchQueryChanged(''),
                                      );
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: theme.cardColor,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        if (state.state == RequestState.loading ||
                            state.state == RequestState.empty) {
                          return Center(
                            child: SpinKitFadingCircle(
                              color: theme.primaryColor,
                              size: 50.0,
                            ),
                          );
                        }

                        if (state.state == RequestState.error) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    color: theme.colorScheme.error,
                                    size: 60,
                                  ),
                                  const SizedBox(height: 15),
                                  Text(
                                    'Oops, something went wrong!',
                                    style: theme.textTheme.displayMedium,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    state.errorMessage,
                                    textAlign: TextAlign.center,
                                    style: theme.textTheme.titleSmall,
                                  ),
                                  const SizedBox(height: 20),
                                  ElevatedButton.icon(
                                    icon: const Icon(Icons.refresh),
                                    label: const Text('Try Again'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: theme.primaryColor,
                                      foregroundColor: Colors.white,
                                    ),
                                    onPressed: () {
                                      context.read<DashboardBloc>().add(
                                            const DashboardEvent.fetchData(),
                                          );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        if (uniqueCompanies.isEmpty) {
                          return _buildEmptyState(
                            context,
                            'No companies found matching "${state.searchQuery}"',
                          );
                        }

                        return ListView.builder(
                          key: const PageStorageKey('companies_list_view'),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 12.0,
                          ),
                          itemCount: uniqueCompanies.length,
                          itemBuilder: (context, index) {
                            final company = uniqueCompanies[index];
                            return _buildCompanyCard(context, company);
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildJobCard(BuildContext context, Job job, Company company) {
    final theme = Theme.of(context);
    final initials = company.name.trim().isNotEmpty
        ? company.name
            .trim()
            .split(' ')
            .map((e) => e[0])
            .take(2)
            .join()
            .toUpperCase()
        : '?';

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _showJobDetails(context, job, company.name),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor:
                        (company.logoUrl != null && company.logoUrl!.isNotEmpty)
                            ? Colors.white
                            : theme.primaryColor,
                    child: (company.logoUrl != null && company.logoUrl!.isNotEmpty)
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(22),
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: CachedNetworkImage(
                                imageUrl: company.logoUrl!,
                                fit: BoxFit.contain,
                                placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(strokeWidth: 1.0),
                                ),
                                errorWidget: (context, url, error) => Text(
                                  initials,
                                  style: TextStyle(
                                    color: theme.primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Text(
                            initials,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          company.name,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if ((job.postedDate != null &&
                                job.postedDate!.isNotEmpty) ||
                            (job.lastDateToApply != null &&
                                job.lastDateToApply!.isNotEmpty)) ...[
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 12,
                            runSpacing: 4,
                            children: [
                              if (job.postedDate != null &&
                                  job.postedDate!.isNotEmpty)
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.calendar_today_outlined,
                                      size: 12,
                                      color: theme.hintColor,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Posted: ${job.postedDate}',
                                      style: theme.textTheme.headlineSmall
                                          ?.copyWith(
                                        color: theme.hintColor,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              if (job.lastDateToApply != null &&
                                  job.lastDateToApply!.isNotEmpty)
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.hourglass_empty_outlined,
                                      size: 12,
                                      color: theme.colorScheme.error
                                          .withOpacity(0.8),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Apply by: ${job.lastDateToApply}',
                                      style: theme.textTheme.headlineSmall
                                          ?.copyWith(
                                        color: theme.colorScheme.error
                                            .withOpacity(0.8),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      _formatTimestamp(job.lastUpdated),
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: theme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                job.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.hintColor,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Tap to view details',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: theme.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: theme.primaryColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompanyCard(BuildContext context, Company company) {
    final theme = Theme.of(context);
    final initials = company.name.trim().isNotEmpty
        ? company.name
            .trim()
            .split(' ')
            .map((e) => e[0])
            .take(2)
            .join()
            .toUpperCase()
        : '?';

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedCompany = company;
            _searchController.clear();
            context.read<DashboardBloc>().add(
                  const DashboardEvent.searchQueryChanged(''),
                );
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor:
                    (company.logoUrl != null && company.logoUrl!.isNotEmpty)
                        ? Colors.white
                        : theme.primaryColor,
                child: (company.logoUrl != null && company.logoUrl!.isNotEmpty)
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: CachedNetworkImage(
                            imageUrl: company.logoUrl!,
                            fit: BoxFit.contain,
                            placeholder: (context, url) => const Center(
                              child:
                                  CircularProgressIndicator(strokeWidth: 1.5),
                            ),
                            errorWidget: (context, url, error) => Text(
                              initials,
                              style: TextStyle(
                                color: theme.primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      )
                    : Text(
                        initials,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      company.name,
                      style: theme.textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      company.email,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.hintColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: theme.primaryColor.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text(
                      '${company.jobCount}',
                      style: theme.textTheme.displaySmall?.copyWith(
                        color: theme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      company.jobCount == 1 ? 'Job' : 'Jobs',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: theme.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, String message) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_outlined,
              size: 80,
              color: theme.disabledColor.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.hintColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
