import 'package:flutter/material.dart';
import 'package:todo_app/ui/screens/home_page.dart';

/// A widget for displaying a form to input task details like title, description, and date/time.
class InputFormWidget extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final DateTime? selectedDateTime;
  final ValueChanged<DateTime> onDateTimePicked;
  final VoidCallback onSave;
  final String appBarTitle;

  /// Constructor for [InputFormWidget] that takes controllers for title and description,
  /// the selected date/time, callbacks for date/time selection and saving, and an optional 
  /// app bar title.
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
        child: Center(  
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 600), 
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
                        // Show date picker
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: selectedDateTime ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );

                        if (selectedDate != null) {
                          // Show time picker after selecting date
                          final selectedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(
                              selectedDateTime ?? DateTime.now(),
                            ),
                          );

                          if (selectedTime != null) {
                            // Combine date and time to form the complete dateTime
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
                      backgroundColor: Colors.blue, 
                      foregroundColor: Colors.white, 
                    ),
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Formats the date and time into a readable string.
  /// 
  /// [dateTime] is the [DateTime] object to format.
  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
