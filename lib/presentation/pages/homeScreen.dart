import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:moviestore/data/data_sources/categoryRemoteData.dart';
import 'package:moviestore/data/models/categoriesModel.dart';
import 'package:moviestore/presentation/constans/colors.dart';
import 'package:moviestore/presentation/constans/icons.dart';
import 'package:moviestore/presentation/constans/string.dart';
import 'package:moviestore/presentation/constans/textStyle.dart';
import 'package:moviestore/presentation/pages/categoryScreen.dart';
import 'package:moviestore/presentation/pages/profileScreen.dart';
import 'package:moviestore/presentation/pages/watchlistScreen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CategoryRemoteDataSource _categoryRemoteDataSource =
  CategoryRemoteDataSource(Dio());
  List<categoryModel> _categories = [];
  bool _isLoading = true;
  String? _errorMessage;

  int _selectedIndex = 0; // To track the selected page index
  PageController _pageController = PageController(); // Controller for PageView

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      final categories = await _categoryRemoteDataSource.getCategories();
      setState(() {
        _categories = categories;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

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

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            onPressed: () {
            },
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
          // Home Screen
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar
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
                      contentPadding: EdgeInsets.all(20.0),
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
                  child: _isLoading
                      ? Center(
                    child: CircularProgressIndicator(
                      color: selectColor,
                    ),
                  )
                      : _errorMessage != null
                      ? Center(
                    child: Text(
                      'Error: $_errorMessage',
                      style: homeCategory,
                    ),
                  )
                      : GridView.builder(
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                      childAspectRatio: 3 / 2,
                    ),
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MoviesListScreen(
                                categoryId: category.id, // Pass category ID
                                categoryTitle: category.title, // Pass category title
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
          ),
          // WatchList Screen
          WatchListScreen(watchlist: [],),

          ProfileScreen(username: "Marwan"),
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
              child: _selectedIndex == 0
                  ? SELECTEDHOME
                  : UNSELECTEDHOME,
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
              child: _selectedIndex == 2
                  ? UNSELECTEDUSER
                  : UNSELECTEDUSER,
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}
