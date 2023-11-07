import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/provider/favorites_provider.dart';
import 'package:meals_app/pages/categories_page.dart';
import 'package:meals_app/pages/filter_page.dart';
import 'package:meals_app/pages/meal_page.dart';
import 'package:meals_app/provider/filter_provider.dart';
import 'package:meals_app/widgets/main_drawer.dart';

const kInitialFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegetarian: false,
  Filter.vegan: false,
};

class TabsPage extends ConsumerStatefulWidget {
  const TabsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _TabsPageState();
  }
}

class _TabsPageState extends ConsumerState<TabsPage> {
  int _selectPageIndex = 0;

  void showInfoMessage(String text) {}

  void _selectPage(int index) {
    setState(() {
      _selectPageIndex = index;
    });
  }

  void _setScreen(String identifier) async {
    Navigator.of(context).pop();
    if (identifier == "filters") {
      await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(
          builder: (ctx) => const FilterPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableMeals = ref.watch(filterMealsProvider);

    //category page as default page

    Widget activePage = CategoryPage(
      availableMeals: availableMeals,
    );

    var activePageTitle = "Categories";

    if (_selectPageIndex == 1) {
      final favoriteMeal = ref.watch(favoriteMealsProvider);
      activePage = MealPage(
        meals: favoriteMeal,
      );
      activePageTitle = "Favorite";
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      drawer: MainDrawer(
        onSelect: _setScreen,
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            _selectPage(index);
          },
          currentIndex: _selectPageIndex,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey[500],
          showUnselectedLabels: false,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.set_meal), label: "Category"),
            BottomNavigationBarItem(
                icon: Icon(Icons.star_border), label: "Favorite"),
          ]),
    );
  }
}
