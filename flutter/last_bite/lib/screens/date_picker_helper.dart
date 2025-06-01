import 'package:flutter/material.dart';


class DatePickerField extends StatefulWidget {
  final DateTime initialDate;
  final Function(DateTime) onDateSelected;
  final bool showFutureOnly;

  const DatePickerField({
    Key? key,
    required this.initialDate,
    required this.onDateSelected,
    this.showFutureOnly = true,
  }) : super(key: key);

  @override
  State<DatePickerField> createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  late DateTime _selectedDate;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _updateTextController();
  }

  void _updateTextController() {
    _controller = TextEditingController(
      text: "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}"
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: const InputDecoration(
        labelText: 'Delivery Date',
        suffixIcon: Icon(Icons.calendar_today),
      ),
      readOnly: true,
      onTap: () async {
        // Set initialDate to today or the selected date if it's in the future
        DateTime now = DateTime.now();
        DateTime initialDate = widget.showFutureOnly && _selectedDate.isBefore(now)
            ? now
            : _selectedDate;
            
        final DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: widget.showFutureOnly ? now : now.subtract(const Duration(days: 365)),
          lastDate: now.add(const Duration(days: 365)),
        );

        if (pickedDate != null) {
          setState(() {
            _selectedDate = DateTime(
              pickedDate.year,
              pickedDate.month,
              pickedDate.day,
              _selectedDate.hour,
              _selectedDate.minute,
            );
            _updateTextController();
          });
          
          widget.onDateSelected(_selectedDate);
        }
      },
    );
  }
}