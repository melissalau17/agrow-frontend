import 'package:flutter/material.dart';

class Task {
  final String title;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String mode;
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
  String _mode = 'Manual';
  bool _isTaskCompleted = false;

  // ✅ Fixed & cleaned up _selectTime function
  Future<void> _selectTime(BuildContext context, bool isStart) async {
    final ctx = context; // store context to silence linter safely
    final TimeOfDay? picked = await showTimePicker(
      context: ctx,
      initialTime: isStart
          ? (_startTime ?? TimeOfDay.now())
          : (_endTime ?? _startTime ?? TimeOfDay.now()),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF00A550)),
          ),
          child: child!,
        );
      },
    );

    if (!mounted) return; 

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
          if (_endTime != null && _startTime!.hour > _endTime!.hour) {
            _endTime = null;
          }
        } else {
          _endTime = picked;
        }
      });
    }
  }

  void _saveTask() {
    if (_taskController.text.isEmpty ||
        _startTime == null ||
        _endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please fill out all fields and select a time interval.',
          ),
        ),
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

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Task "${newTask.title}" saved successfully!')),
    );

    Navigator.of(context).pop(newTask);
  }

  // --- Mode Pill Widget ---
  Widget _buildModePill(String mode, bool isSelected) {
    final Color color = mode == 'Automated'
        ? const Color(0xFF00A550)
        : Colors.grey.shade600;

    return GestureDetector(
      onTap: () {
        setState(() => _mode = mode);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        margin: const EdgeInsets.only(right: 6),
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

  String _formatTime(TimeOfDay? time) {
    if (time == null) return 'Select Time...';
    return time.format(context);
  }

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
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.1),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: const [
                  SizedBox(width: 40),
                  Expanded(
                    child: Text(
                      "Task",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 150,
                    child: Text(
                      "Interval",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 80,
                    child: Text(
                      "Mode",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(height: 20, thickness: 1, color: Color(0xFFE0E0E0)),

              Row(
                children: [
                  SizedBox(
                    width: 40,
                    child: Checkbox(
                      value: _isTaskCompleted,
                      onChanged: (bool? val) =>
                          setState(() => _isTaskCompleted = val ?? false),
                      activeColor: const Color(0xFF00A550),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _taskController,
                      decoration: const InputDecoration(
                        hintText: 'Enter task...',
                        border: InputBorder.none,
                        isDense: true,
                      ),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      final ctx = context;
                      await _selectTime(ctx, true);
                      if (!mounted) return;
                      if (_startTime != null) {
                        await _selectTime(ctx, false);
                        if (!mounted) return;
                      }
                    },
                    child: SizedBox(
                      width: 150,
                      child: Text(
                        _formatInterval(),
                        style: TextStyle(
                          color: (_startTime != null && _endTime != null)
                              ? Colors.black
                              : Colors.grey,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 80,
                    child: Row(
                      children: [
                        _buildModePill('Manual', _mode == 'Manual'),
                        _buildModePill('Automated', _mode == 'Automated'),
                      ],
                    ),
                  ),
                ],
              ),

              const Divider(height: 20, thickness: 1, color: Color(0xFFE0E0E0)),

              // Example existing task row
              Row(
                children: [
                  SizedBox(
                    width: 40,
                    child: Checkbox(
                      value: true,
                      onChanged: (val) {},
                      activeColor: const Color(0xFF00A550),
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      "Water Tomato Field",
                      style: TextStyle(
                        fontSize: 16,
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 150,
                    child: Text(
                      "12:30 PM - 1:30 PM",
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(width: 80, child: _buildModePill('Automated', true)),
                ],
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        child: ElevatedButton(
          onPressed: _saveTask,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00A550),
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 5,
          ),
          child: const Text(
            'Save Task',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
