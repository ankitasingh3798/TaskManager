
class Task{
   String name;
  DateTime? dueDate;
   String priority;
  bool isCompleted;

  Task({required this.name, this.dueDate, required this.priority, this.isCompleted =false,});

  Map<String,dynamic> toMap() {

    return{
      'name':name,
      'dueDate':dueDate?.toIso8601String(),
      'priority':priority,
      'isCompleted':isCompleted
    };
  }

  static Task fromMap(Map<String, dynamic>map)
  {
    return Task(
        name: map['name'],
        dueDate: map['dueDate']!=null? DateTime.parse(map['dueDate']):null,
        priority: map['priority'],
    isCompleted: map['isCompleted']
    );
  }

}