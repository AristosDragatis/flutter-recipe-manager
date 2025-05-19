import 'dart:io';
import 'package:flutter/material.dart';
import '../models/recipe.dart';

class RecipeCard extends StatelessWidget {
  // Main card displaying brief recipe info
  final Recipe recipe;
  // Callback to update rating from the parent widget
  final ValueChanged<int>? onRatingChanged;

  // Constructor that requires the recipe and optionally the rating-change callback
  const RecipeCard({super.key, required this.recipe, this.onRatingChanged});

  @override
  Widget build(BuildContext context) {
    return Card(
      // Card with margin, elevation and rounded corners
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          ClipRRect(
            // Clip the image with rounded corners on the left side only
            borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(12),
            ),
            child: recipe.imageUrl.startsWith('assets/')
                // Show image from assets
                ? Image.asset(
                    recipe.imageUrl,
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  )
                // Show image from a local file
                : Image.file(
                    File(recipe.imageUrl),
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    // Recipe title
                    recipe.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    // Display preparation time
                    'Χρόνος: ${recipe.prepTime} λεπτά',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    // Display recipe difficulty
                    'Δυσκολία: ${recipe.difficulty}',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: List.generate(5, (index) {
                      return GestureDetector(
                        // Tap to change rating via callback
                        onTap: onRatingChanged != null
                            ? () {
                                final newRating =
                                    (index == 0 && recipe.rating == 1)
                                        ? 0
                                        : index + 1;
                                onRatingChanged!(newRating);
                              }
                            : null,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: Icon(
                            index < recipe.rating
                                ? Icons.star
                                : Icons.star_border,
                            color: index < recipe.rating
                                ? Colors.orange
                                : Colors.grey,
                            size: 20,
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }
}
