import 'package:flutter/material.dart';

class ModalBottomSheet extends StatelessWidget {
  final String title;
  final List<String> options; // Текстовые подписи
  final Function(int selectedIndex) onOptionSelected; // Обработка выбора
  final int initialSelectedIndex; // Индекс для предустановленного выбора

  const ModalBottomSheet({
    super.key,
    required this.title,
    required this.options,
    required this.onOptionSelected,
    this.initialSelectedIndex = -1, // -1, если ничего не выбрано
  });

  @override
  Widget build(BuildContext context) {
    int selectedIndex = initialSelectedIndex; // Локальная переменная для текущего выбора

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
            ...List.generate(options.length, (index) {
              return RadioListTile(
                title: Text(options[index]),
                value: index,
                groupValue: selectedIndex,
                onChanged: (int? value) {
                  setState(() {
                    selectedIndex = value!;
                  });
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
