import 'dart:io';
import 'package:flutter/material.dart';
import '../models/recipe.dart';

class RecipeDetailsScreen extends StatefulWidget {
  // Screen for recipe details with dynamic rating update
  final Recipe recipe;

  // Constructor that requires a recipe
  const RecipeDetailsScreen({super.key, required this.recipe});

  @override
  State<RecipeDetailsScreen> createState() => _RecipeDetailsScreenState();
}

class _RecipeDetailsScreenState extends State<RecipeDetailsScreen> {
  // Current rating for display and update
  late int currentRating;

  @override
  void initState() {
    super.initState();
    // Initialize currentRating with initial recipe rating
    currentRating = widget.recipe.rating;
  }

  // Update currentRating and refresh screen
  void updateRating(int newRating) {
    setState(() {
      currentRating = newRating;
    });
  }

  @override
  Widget build(BuildContext context) {
    final recipe = widget.recipe;
    // PopScope to handle returning with a result
    return PopScope<Recipe>(
      // Return true if rating has not changed
      canPop: currentRating == recipe.rating,
      // Handle back navigation if rating changed
      onPopInvokedWithResult: (bool didPop, Recipe? result) {
        if (!didPop) {
          if (currentRating != recipe.rating) {
            final updatedRecipe = recipe.copyWith(rating: currentRating);
            Navigator.pop(context, updatedRecipe);
          } else {
            Navigator.pop(context);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(recipe.title)),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display image from assets or file
              recipe.imageUrl.startsWith('assets/')
                  ? Image.asset(
                      recipe.imageUrl,
                      width: double.infinity,
                      height: 220,
                      fit: BoxFit.cover,
                    )
                  : Image.file(
                      File(recipe.imageUrl),
                      width: double.infinity,
                      height: 220,
                      fit: BoxFit.cover,
                    ),
              // Padding around the content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Display recipe title
                    Text(
                      recipe.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Display preparation time
                    Text(
                      'Preparation time: ${recipe.prepTime} minutes',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    // Display difficulty level
                    Text(
                      'Difficulty: ${recipe.difficulty}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 12),
                    // Star layout for rating
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(5, (index) {
                        return GestureDetector(
                          // Handle tap to change rating
                          onTap: () {
                            // Toggle logic for 0 rating if first star is tapped and current rating is 1
                            if (index == 0 && currentRating == 1) {
                              updateRating(0);
                            } else {
                              updateRating(index + 1);
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: Icon(
                              index < currentRating
                                  ? Icons.star
                                  : Icons.star_border,
                              color: index < currentRating
                                  ? Colors.orange
                                  : Colors.grey,
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 16),
                    // Description heading
                    const Text(
                      'Description:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Display recipe description
                    Text(
                      recipe.description,
                      style: const TextStyle(fontSize: 16),
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
}
