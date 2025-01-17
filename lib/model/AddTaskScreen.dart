import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'Task.dart';

class AddTaskScreen extends StatefulWidget {


  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _fromkey=GlobalKey<FormState>();
  final TextEditingController _nameController =TextEditingController();
  DateTime? _dueDate;
  String _priority ='Medium' ;

  void _saveTask(){
    if(_fromkey.currentState!.validate()){
      final task=Task(
        name:_nameController.text,
        dueDate:_dueDate,
          priority:_priority,
      );

      final box=Hive.box('tasksBox');
      box.add(task.toMap());
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _fromkey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Task Name'),
                validator: (value)=>value!.isEmpty ? 'Please enter a task name': null,
              ),
              SizedBox(height: 10),
              Row(
                  children: [
                    Text('Due Date:'),
                    SizedBox(height: 16),
                    TextButton(
                        onPressed: () async{
                          _dueDate=await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          setState(() {});
                        },
                        child: Text(
                         _dueDate !=null ? _dueDate!.toLocal().toString().split(' ')[0]: 'Select Date'
                        ),
                    ),
                  ],
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _priority,
                items: ['High', 'Medium','Low']
                       .map((priority) => DropdownMenuItem(
                    value: priority,child: Text(priority))).toList(),
                onChanged: (value) => setState(() => _priority=value!),
                decoration: InputDecoration(labelText: 'Priority'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                  onPressed: _saveTask,
                  child: Text('Save Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
