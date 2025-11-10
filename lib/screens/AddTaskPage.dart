import 'package:flutter/material.dart';

// Defines the Task structure
class Task {
  final String title;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String mode; // "Manual" or "Automated"
  final bool isCompleted;

  Task({
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.mode,
    this.isCompleted = false,
  });
}

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TextEditingController _taskController = TextEditingController();
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  String _mode = 'Manual'; // Default mode
  bool _isTaskCompleted = false; // For the checklist simulation

  // --- Time Picker Logic ---
  Future<void> _selectTime(BuildContext context, bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStart ? (_startTime ?? TimeOfDay.now()) : (_endTime ?? _startTime ?? TimeOfDay.now()),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF00A550), // Green accent color
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
          // Ensure end time is later than start time if both are set
          if (_endTime != null && _startTime!.hour > _endTime!.hour) {
            _endTime = null;
          }
        } else {
          _endTime = picked;
        }
      });
    }
  }

  // --- Save Logic ---
  void _saveTask() {
    if (_taskController.text.isEmpty || _startTime == null || _endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all fields and select a time interval.')),
      );
      return;
    }

    final newTask = Task(
      title: _taskController.text,
      startTime: _startTime!,
      endTime: _endTime!,
      mode: _mode,
      isCompleted: _isTaskCompleted,
    );

    // In a real app, you would save this task to Firestore/State Management here.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Task "${newTask.title}" saved successfully!')),
    );

    Navigator.of(context).pop(newTask); // Return to Dashboard
  }

  // --- Widget Builders ---

  Widget _buildModePill(String mode, bool isSelected) {
    final color = mode == 'Automated' ? const Color(0xFF00A550) : Colors.grey.shade400;

    return GestureDetector(
      onTap: () {
        setState(() {
          _mode = mode;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          border: Border.all(color: color, width: 1.5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          mode,
          style: TextStyle(
            color: isSelected ? Colors.white : color,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  // Helper to format TimeOfDay to string
  String _formatTime(TimeOfDay? time) {
    if (time == null) return 'Select Time...';
    // Use context to handle 12h/24h format based on locale
    return time.format(context);
  }

  // Helper to format interval
  String _formatInterval() {
    if (_startTime == null || _endTime == null) return 'Select Time...';
    return '${_formatTime(_startTime)} - ${_formatTime(_endTime)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4FAF0),
      appBar: AppBar(
        title: const Text('Add Task', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Header Row ---
                  Row(
                    children: const [
                      SizedBox(width: 40, child: Text("")), // Align with Checkbox
                      Expanded(
                        child: Text("Task", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                      SizedBox(width: 150, child: Text("Interval", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                      SizedBox(width: 80, child: Text("Mode", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                    ],
                  ),
                  const Divider(height: 20, thickness: 1, color: Color(0xFFE0E0E0)),

                  // --- New Task Input Row ---
                  Row(
                    children: [
                      // Completion Checkbox (Initial state)
                      SizedBox(
                        width: 40,
                        child: Checkbox(
                          value: _isTaskCompleted,
                          onChanged: (bool? val) {
                            setState(() => _isTaskCompleted = val ?? false);
                          },
                          activeColor: const Color(0xFF00A550),
                        ),
                      ),
                      // Task Title Input
                      Expanded(
                        child: TextField(
                          controller: _taskController,
                          decoration: const InputDecoration(
                            hintText: 'Enter task...',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                            isDense: true,
                          ),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      // Time Interval Picker
                      GestureDetector(
                        onTap: () async {
                          await _selectTime(context, true); // Select Start Time
                          if (_startTime != null) {
                            await _selectTime(context, false); // Select End Time
                          }
                        },
                        child: SizedBox(
                          width: 150,
                          child: Text(
                            _formatInterval(),
                            style: TextStyle(
                              color: (_startTime != null && _endTime != null) ? Colors.black : Colors.grey,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      // Mode Selector
                      SizedBox(
                        width: 80,
                        child: Row(
                          children: [
                            _buildModePill('Manual', _mode == 'Manual'),
                            // Only show Automated if Manual is not selected (to save space)
                            if (_mode == 'Automated')
                              _buildModePill('Automated', _mode == 'Automated'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 20, thickness: 1, color: Color(0xFFE0E0E0)),


                  // --- Example Existing Task (Simulation) ---
                  Row(
                    children: [
                      // Completion Checkbox (Example)
                      SizedBox(
                        width: 40,
                        child: Checkbox(
                          value: true,
                          onChanged: (bool? val) {},
                          activeColor: const Color(0xFF00A550),
                        ),
                      ),
                      // Task Title
                      const Expanded(
                        child: Text(
                          "Water Tomato Field",
                          style: TextStyle(fontSize: 16, decoration: TextDecoration.lineThrough, color: Colors.grey),
                        ),
                      ),
                      // Time Interval
                      const SizedBox(
                        width: 150,
                        child: Text(
                          "12:30 PM - 1:30 PM",
                          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500, fontSize: 16),
                        ),
                      ),
                      // Mode Selector
                      SizedBox(
                        width: 80,
                        child: _buildModePill('Automated', true),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // Save Button in a fixed position
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        child: ElevatedButton(
          onPressed: _saveTask,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00A550),
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 5,
          ),
          child: const Text(
            'Save Task',
            style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}