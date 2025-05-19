import 'package:hive/hive.dart';
part 'recipe.g.dart';

/// Hive class with id: 0
@HiveType(typeId: 0)
class Recipe extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String description;

  @HiveField(2)
  final int prepTime;

  @HiveField(3)
  final String difficulty;

  @HiveField(4)
  final String imageUrl;

  @HiveField(5)
  final int rating;

  /// Constructor for a recipe
  Recipe({
    required this.title,
    required this.description,
    required this.prepTime,
    required this.difficulty,
    required this.imageUrl,
    required this.rating,
  });

  /// Method to copy the recipe with optional field changes
  Recipe copyWith({
    String? title,
    String? description,
    int? prepTime,
    String? difficulty,
    String? imageUrl,
    int? rating,
  }) {
    return Recipe(
      title: title ?? this.title,
      description: description ?? this.description,
      prepTime: prepTime ?? this.prepTime,
      difficulty: difficulty ?? this.difficulty,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
    );
  }
}
