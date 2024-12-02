import 'package:flutter/material.dart';
import 'modal_bottom_sheet.dart'; // Импортируем виджет всплывающего окна

class FilterSortSection extends StatelessWidget {
  const FilterSortSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  // Показываем всплывающее окно с фильтрацией
                  showModalBottomSheet(
                    context: context,
                    builder: (_) => ModalBottomSheet(
                      title: 'Show tasks',
                      options: ['All', 'To-do', 'Done'], // Опции
                      initialSelectedIndex: 0, // Начальный выбор
                      onOptionSelected: (selectedIndex) {
                        // Логика обработки выбранной опции
                        //print('Выбрана опция: $selectedIndex');
                      },
                    ),
                  );
                },
                child: Row(
                  children: [
                    const Icon(Icons.filter_list, color: Colors.blue),
                    const SizedBox(width: 8),
                    const Text('Filter'),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context, 
                    builder: (_) => ModalBottomSheet(
                      title: 'Sort by', 
                      options: ['Default', 'Due date', 'Title'], 
                      initialSelectedIndex: 0,
                      onOptionSelected: (selectedIndex) {
                        // Логика обработки выбранной опции
                        //print('Выбрана опция: $selectedIndex');
                      },
                    )
                  );
                },
                child: Row(
                  children: [
                    const Icon(Icons.sort, color: Colors.blue),
                    const SizedBox(width: 8),
                    const Text('Sort'),
                  ],
                ),
              ),
            ],
          ),

          // Разделительная полоса
          const Divider(
            color: Colors.grey, // Цвет разделителя
            thickness: 1, // Толщина линии
          ),
        ],
      ),
    );
  }
}
