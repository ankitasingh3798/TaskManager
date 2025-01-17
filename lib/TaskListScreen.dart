
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'model/AddTaskScreen.dart';
import 'model/Task.dart';

class TaskListScreen extends StatefulWidget {

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final Box tasksBox=Hive.box('tasksBox');

  void _addTask() async{
    await Navigator.push(context,
        MaterialPageRoute(builder: (context)=>AddTaskScreen()),
    );
    setState(() {});
  }

  void _toggleCompletion(int index){
    final taskMap=tasksBox.getAt(index) as Map<String,dynamic>;
    Task task=Task.fromMap(taskMap);
    task.isCompleted=!task.isCompleted;
    tasksBox.putAt(index, task.toMap());
    setState(() {});
  }

  void _deleteTask(int index) {
    tasksBox.deleteAt(index);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task List')),
      body: ValueListenableBuilder(
        valueListenable: tasksBox.listenable(),
        builder: (context,Box box,_){
          if(box.isEmpty){
            return Center(child: Text('No tasks added yet.'));
          }
          return ListView.builder(
            itemCount: box.length,
              itemBuilder: (context,index){
              final taskMap=box.getAt(index) as Map<String,dynamic>;
              final task=Task.fromMap(taskMap);
              return ListTile(
                title: Text(
                  task.name,
                  style: TextStyle(
                    decoration: task.isCompleted ? TextDecoration.lineThrough:null,
                  ),
                ),
                subtitle: Text(
                  'Due:${task.dueDate?.toLocal().toString().split(' ')[0] ?? 'no due date'}\nPriority: ${task.priority}',
              ),
                trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Checkbox(
                value: task.isCompleted,
                onChanged: (_)=>_toggleCompletion(index)
                ),
                IconButton(
                onPressed: ()=> _deleteTask(index),
                icon: Icon(Icons.delete)
                ),
                ],
                ),
              );
              },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: Icon(Icons.add),
      ),
    );
  }
}
