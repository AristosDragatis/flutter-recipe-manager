import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../models/recipe.dart';

class AddRecipeScreen extends StatefulWidget {
  // Callback to add a new recipe
  final Function(Recipe) onAdd;

  const AddRecipeScreen({super.key, required this.onAdd});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for input fields
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _prepTimeController = TextEditingController();

  // Default values
  String _selectedDifficulty = 'Easy';
  int _rating = 3;
  File? _pickedImage;

  // Method to pick an image and save it in documents
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      // Copy to another path to avoid losing it from gallery/cache clear
      final appDir = await getApplicationDocumentsDirectory();
      final imagesDir = Directory(path.join(appDir.path, 'recipes_images'));
      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }
      final fileName = path.basename(pickedFile.path);
      final savedFile = await File(pickedFile.path)
          .copy(path.join(imagesDir.path, fileName));
      setState(() {
        _pickedImage = savedFile;
      });
    }
  }

  // Save the new recipe and return to the main screen
  void _saveRecipe() {
    // Check if an image is selected
    if (_pickedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an image for the recipe.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Validate the form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Create Recipe object from the form values
    final newRecipe = Recipe(
      title: _titleController.text,
      description: _descriptionController.text,
      prepTime: int.tryParse(_prepTimeController.text) ?? 0,
      difficulty: _selectedDifficulty,
      imageUrl: _pickedImage!.path,
      rating: _rating,
    );

    // Call the add callback
    widget.onAdd(newRecipe);
    // Go back to the previous screen
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // Main scaffold with AppBar and body
    return Scaffold(
      appBar: AppBar(title: const Text('Add Recipe')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Image picker on tap
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? const Color(0xFF1E1E1E)
                        : Colors.grey[200],
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  // Show selected image or placeholder
                  child: _pickedImage != null
                      ? Image.file(_pickedImage!, fit: BoxFit.cover)
                      : const Center(
                          child: Text('Tap to select image'),
                        ),
                ),
              ),
              const SizedBox(height: 16),
              // Title input field
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) =>
                    value!.isEmpty ? 'This field is required' : null,
              ),
              const SizedBox(height: 10),
              // Description input field
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 10),
              // Preparation time input field
              TextFormField(
                controller: _prepTimeController,
                decoration: const InputDecoration(
                  labelText: 'Preparation Time (minutes)',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field is required';
                  }
                  final number = int.tryParse(value);
                  if (number == null || number <= 0) {
                    return 'Enter a positive number';
                  }
                  if (number > 9999) {
                    return 'Enter a smaller number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              // Dropdown for difficulty selection
              DropdownButtonFormField<String>(
                value: _selectedDifficulty,
                items: ['Easy', 'Medium', 'Hard']
                    .map(
                      (diff) =>
                          DropdownMenuItem(value: diff, child: Text(diff)),
                    )
                    .toList(),
                onChanged: (value) =>
                    setState(() => _selectedDifficulty = value!),
                decoration: const InputDecoration(labelText: 'Difficulty'),
              ),
              const SizedBox(height: 10),
              // Rating selection row
              Row(
                children: [
                  const Text('Rating:'),
                  const SizedBox(width: 16),
                  // Dropdown for 0–5 rating
                  DropdownButton<int>(
                    value: _rating,
                    onChanged: (value) => setState(() => _rating = value!),
                    items: List.generate(
                      6,
                      (i) => DropdownMenuItem(value: i, child: Text('$i')),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Save recipe button
              ElevatedButton.icon(
                onPressed: _saveRecipe,
                icon: const Icon(Icons.save),
                label: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
