import 'package:flutter/material.dart';

/// A widget that shows a modal bottom sheet with a list of options, 
/// allowing the user to select one option from the list.
class ModalBottomSheet extends StatelessWidget {
  final String title;  // Title of the modal bottom sheet
  final List<String> options;  // List of options to display as radio buttons
  final Function(int selectedIndex) onOptionSelected;  // Callback when an option is selected
  final int initialSelectedIndex;  // Index of the initially selected option

  /// Constructor for [ModalBottomSheet], which accepts a title, a list of options,
  /// a callback for option selection, and an optional index for the initially selected option.
  const ModalBottomSheet({
    super.key,
    required this.title,
    required this.options,
    required this.onOptionSelected,
    this.initialSelectedIndex = -1,  // Default to no option selected
  });

  @override
  Widget build(BuildContext context) {
    int selectedIndex = initialSelectedIndex;  // Initially selected index

    return StatefulBuilder(
      builder: (context, setState) => Container(
        padding: const EdgeInsets.all(16.0),
        color: Colors.white,  
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,  
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // Generate a list of radio buttons for each option
            ...List.generate(options.length, (index) {
              return RadioListTile(
                title: Text(options[index]),  // The option's label
                value: index,  // The index of the option
                groupValue: selectedIndex,  // The currently selected option's index
                onChanged: (int? value) {
                  setState(() {
                    selectedIndex = value!;  // Update the selected index
                  });
                  onOptionSelected(selectedIndex);  // Notify the callback about the selection
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
