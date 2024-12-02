import 'package:flutter/material.dart';
import 'package:todo_app/ui/screens/home_page.dart';

class InputFormWidget extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final DateTime? selectedDateTime;
  final ValueChanged<DateTime> onDateTimePicked;
  final VoidCallback onSave;
  final String appBarTitle;

  const InputFormWidget({
    super.key,
    required this.titleController,
    required this.descriptionController,
    this.selectedDateTime,
    required this.onDateTimePicked,
    required this.onSave,
    this.appBarTitle = 'Form',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            )
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
              textInputAction: TextInputAction.newline,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    selectedDateTime != null
                        ? 'Selected: ${_formatDateTime(selectedDateTime!)}'
                        : 'Pick Date & Time',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () async {
                    
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDateTime ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );

                    if (selectedDate != null) {
                      final selectedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(
                          selectedDateTime ?? DateTime.now(),
                        ),
                      );

                      if (selectedTime != null) {
                        final dateTime = DateTime(
                          selectedDate.year,
                          selectedDate.month,
                          selectedDate.day,
                          selectedTime.hour,
                          selectedTime.minute,
                        );
                        onDateTimePicked(dateTime);
                      }
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
              onPressed: onSave,
              style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Цвет кнопки
                    foregroundColor: Colors.white, // Цвет текста
                  ),
              child: const Text('Save'),
            ),
            )
            
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
