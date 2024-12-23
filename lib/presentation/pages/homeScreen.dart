import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:moviestore/presentation/blocs/homeBloc/home_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:moviestore/data/data_sources/categoryRemoteData.dart';
import 'package:moviestore/presentation/constans/colors.dart';
import 'package:moviestore/presentation/constans/icons.dart';
import 'package:moviestore/presentation/constans/string.dart';
import 'package:moviestore/presentation/constans/textStyle.dart';
import 'package:moviestore/presentation/pages/categoryScreen.dart';
import 'package:moviestore/presentation/pages/profileScreen.dart';
import 'package:moviestore/presentation/pages/watchlistScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildShimmerEffect() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 3 / 2,
      ),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: cardColor,
          highlightColor: textColor,
          child: Container(
            height: 120,
            width: 160,
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(
        categoryRemoteDataSource: CategoryRemoteDataSource(Dio()),
      )..add(LoadCategoriesEvent()),
      child: Scaffold(
        backgroundColor: mainColor,
        appBar: AppBar(
          surfaceTintColor: mainColor,
          backgroundColor: mainColor,
          elevation: 0,
          title: Text(
            MOVIESSTORE,
            style: appBar,
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: BELL,
              onPressed: () {},
            ),
          ],
        ),
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          children: [
            BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                if (state is CategoriesLoading) {
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: _buildShimmerEffect(),
                  );
                } else if (state is CategoriesLoaded) {
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: secondColor,
                            ),
                            borderRadius: BorderRadius.circular(28),
                          ),
                          child: TextField(
                            style: search,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(20.0),
                              suffixIcon: SEARCHICON,
                              hintText: SEARCH,
                              hintStyle: search,
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Text(
                          TRENDINGCATEGORY,
                          style: homeFirst,
                        ),
                        const SizedBox(height: 40),
                        Expanded(
                          child: GridView.builder(
                            gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16.0,
                              mainAxisSpacing: 16.0,
                              childAspectRatio: 3 / 2,
                            ),
                            itemCount: state.categories.length,
                            itemBuilder: (context, index) {
                              final category = state.categories[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MoviesListScreen(
                                        categoryId: category.id,
                                        categoryTitle: category.title,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 120,
                                  width: 160,
                                  decoration: BoxDecoration(
                                    color: cardColor,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Center(
                                    child: Text(
                                      category.title,
                                      style: homeCategory,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (state is CategoriesError) {
                  return Center(
                    child: Text(
                      'Error: ${state.error}',
                      style: homeCategory,
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),

            const WatchListScreen(),

            const ProfileScreen(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: mainColor,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _selectedIndex == 0 ? SELECTEDHOME : UNSELECTEDHOME,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _selectedIndex == 1
                    ? SELECTEDWATCHLIST
                    : UNSELECTEDWATCHLIST,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child:
                _selectedIndex == 2 ? UNSELECTEDUSER : UNSELECTEDUSER,
              ),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}
