import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/di/injection.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../widgets/movie_card.dart';
import '../widgets/bottom_navigation_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomeBloc _homeBloc;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _homeBloc = getIt<HomeBloc>();
    _homeBloc.add(const LoadMovies());

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _homeBloc.close();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _homeBloc.add(LoadMoreMovies());
    }
  }

  void _onRefresh() {
    _homeBloc.add(const LoadMovies(refresh: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: RefreshIndicator(
        onRefresh: () async => _onRefresh(),
        child: BlocBuilder<HomeBloc, HomeState>(
          bloc: _homeBloc,
          builder: (context, state) {
            if (state is HomeInitial || state is HomeLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.primaryColor,
                  ),
                ),
              );
            }

            if (state is HomeError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          _homeBloc.add(const LoadMovies(refresh: true)),
                      child: Text('home.retry'.tr()),
                    ),
                  ],
                ),
              );
            }

            if (state is HomeLoaded || state is HomeLoadingMore) {
              final movies = state is HomeLoaded
                  ? state.movies
                  : (state as HomeLoadingMore).movies;
              final hasNextPage = state is HomeLoaded
                  ? state.hasNextPage
                  : (state as HomeLoadingMore).hasNextPage;

              return CustomScrollView(
                controller: _scrollController,
                slivers: [
                  // App Bar
                  SliverAppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    floating: true,
                    title: Text(
                      'home.title'.tr(),
                      style: const TextStyle(
                        color: AppTheme.textPrimaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    centerTitle: true,
                  ),

                  // Movies List
                  SliverPadding(
                    padding: const EdgeInsets.all(16.0),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        if (index >= movies.length) {
                          if (hasNextPage && state is HomeLoadingMore) {
                            return const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppTheme.primaryColor,
                                  ),
                                ),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        }

                        final movie = movies[index];
                        return MovieCard(
                              movie: movie,
                              onFavoriteToggle: () {
                                _homeBloc.add(ToggleFavorite(movie.id));
                              },
                            )
                            .animate()
                            .fadeIn(
                              delay: Duration(milliseconds: index * 100),
                              duration: 600.ms,
                            )
                            .slideY(begin: 0.3, duration: 600.ms);
                      }, childCount: movies.length + (hasNextPage ? 1 : 0)),
                    ),
                  ),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 0),
    );
  }
}
