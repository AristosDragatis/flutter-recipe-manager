import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import '../models/recipe.dart';
import '../widgets/recipe_card.dart';
import 'recipe_details_screen.dart';
import 'add_recipe_screen.dart';
import '../theme_provider.dart';

class HomeScreen extends StatefulWidget {
  // Main screen of the app
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Hive box containing the recipes
  late Box<Recipe> recipeBox;

  // Default filter values
  String selectedDifficulty = 'All';
  int selectedMinRating = 0;
  int selectedMaxTime = 9999;
  bool showFilters = false;

  @override
  void initState() {
    super.initState();
    // Open Hive box for recipes
    recipeBox = Hive.box<Recipe>('recipes');

    // Add default recipes if the box is empty
    if (recipeBox.isEmpty) {
      recipeBox.addAll([
        Recipe(
          title: 'Spaghetti Bolognese',
          description: 'Traditional recipe with rich meat sauce and herbs.',
          prepTime: 40,
          difficulty: 'Medium',
          imageUrl: 'assets/images/pasta.jpg',
          rating: 4,
        ),
        Recipe(
          title: 'Stuffed Peppers',
          description: 'Tomatoes and peppers filled with rice and herbs.',
          prepTime: 60,
          difficulty: 'Hard',
          imageUrl: 'assets/images/gemista.jpg',
          rating: 5,
        ),
        Recipe(
          title: 'Caesar Salad',
          description: 'Classic Caesar with chicken, parmesan and dressing.',
          prepTime: 15,
          difficulty: 'Easy',
          imageUrl: 'assets/images/caesar.jpg',
          rating: 3,
        ),
      ]);
    }
  }

  // Getter for filtered recipes
  List<Recipe> get filteredRecipes {
    final recipes = recipeBox.values.toList();
    return recipes.where((recipe) {
      final matchDifficulty =
          selectedDifficulty == 'All' ||
          recipe.difficulty == selectedDifficulty;
      final matchRating = recipe.rating >= selectedMinRating;
      final matchTime = recipe.prepTime <= selectedMaxTime;
      return matchDifficulty && matchRating && matchTime;
    }).toList();
  }

  // Reset all filters to default values
  void resetFilters() {
    setState(() {
      selectedDifficulty = 'All';
      selectedMinRating = 0;
      selectedMaxTime = 9999;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Header with title and dark/light mode toggle
      appBar: AppBar(
        title: const Text('My Recipes'),
        actions: [
          IconButton(
            icon: Icon(
              Provider.of<ThemeProvider>(context).isDarkMode
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
          ),
        ],
      ),
      // Body with ValueListenableBuilder for auto refresh
      body: ValueListenableBuilder<Box<Recipe>>(
        valueListenable: recipeBox.listenable(),
        builder: (context, box, _) {
          final recipes = filteredRecipes;

          return Column(
            children: [
              // Button to show/hide filters
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() => showFilters = !showFilters);
                    },
                    icon: const Icon(Icons.filter_list),
                    label: const Text('Filters'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ),
              // Show filters if enabled
              if (showFilters)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.orange),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Card(
                    margin: EdgeInsets.zero,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          // Row with three filters: difficulty, rating, time
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Difficulty filter
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Difficulty',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    DropdownButton<String>(
                                      value: selectedDifficulty,
                                      isExpanded: true,
                                      onChanged: (value) {
                                        setState(
                                          () => selectedDifficulty = value!,
                                        );
                                      },
                                      items: [
                                        'All',
                                        'Easy',
                                        'Medium',
                                        'Hard',
                                      ]
                                          .map(
                                            (level) => DropdownMenuItem(
                                              value: level,
                                              child: Text(level),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Minimum rating filter
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Rating',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    DropdownButton<int>(
                                      value: selectedMinRating,
                                      isExpanded: true,
                                      onChanged: (value) {
                                        setState(
                                          () => selectedMinRating = value!,
                                        );
                                      },
                                      items: List.generate(
                                        6,
                                        (i) => DropdownMenuItem(
                                          value: i,
                                          child: Text('≥ $i ★'),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Maximum prep time filter
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Time',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    DropdownButton<int>(
                                      value: selectedMaxTime,
                                      isExpanded: true,
                                      onChanged: (value) {
                                        setState(
                                          () => selectedMaxTime = value!,
                                        );
                                      },
                                      items: [
                                        DropdownMenuItem(
                                          value: 9999,
                                          child: Text('All'),
                                        ),
                                        DropdownMenuItem(
                                          value: 15,
                                          child: Text('≤ 15 min'),
                                        ),
                                        DropdownMenuItem(
                                          value: 30,
                                          child: Text('≤ 30 min'),
                                        ),
                                        DropdownMenuItem(
                                          value: 45,
                                          child: Text('≤ 45 min'),
                                        ),
                                        DropdownMenuItem(
                                          value: 60,
                                          child: Text('≤ 60 min'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Button to reset filters
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton.icon(
                              onPressed: resetFilters,
                              icon: const Icon(Icons.refresh),
                              label: const Text('Reset'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              // List of recipes
              Expanded(
                child: ListView.builder(
                  itemCount: recipes.length,
                  itemBuilder: (context, index) {
                    final recipe = recipes[index];
                    final key = recipeBox.keyAt(
                      recipeBox.values.toList().indexOf(recipe),
                    );
                    return Dismissible(
                      // Swipe to delete recipe
                      key: Key(recipe.title),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (_) {
                        recipeBox.delete(key);
                      },
                      child: GestureDetector(
                        // Tap to view recipe details
                        onTap: () async {
                          final updatedRecipe = await Navigator.push<Recipe>(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  RecipeDetailsScreen(recipe: recipe),
                            ),
                          );
                          if (updatedRecipe != null) {
                            recipeBox.put(key, updatedRecipe);
                          }
                        },
                        // Recipe card with inline rating change
                        child: RecipeCard(
                          recipe: recipe,
                          onRatingChanged: (newRating) {
                            final updatedRecipe = recipe.copyWith(
                              rating: newRating,
                            );
                            recipeBox.put(key, updatedRecipe);
                            setState(() {});
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      // Floating button to add new recipe
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddRecipeScreen(
                onAdd: (newRecipe) {
                  recipeBox.add(newRecipe);
                },
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
