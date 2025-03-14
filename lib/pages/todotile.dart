import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class  ToDoTile extends StatelessWidget{
  final String taskName;
  final bool taskCompleted;
  Function(bool?)? onChanged;
  Function(BuildContext)? deleteFunction;

      ToDoTile({super.key,
      required this.taskName,
      required this.taskCompleted,
      required this.onChanged,
      required this.deleteFunction,
      });



  @override
  Widget build(BuildContext context){
    return Padding(
      padding:  EdgeInsets.only(left:25,right:25,top:25),
      child: Slidable(
        endActionPane: ActionPane(
            motion: StretchMotion(),
            children: [
              SlidableAction(
                onPressed: deleteFunction,
                icon:Icons.delete,
                backgroundColor: Colors.red.shade300,
            ),
          ]
        ),
        child:
          Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.yellow[500],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
                children: [
                  //check box
                  Checkbox(value: taskCompleted, onChanged:onChanged ,checkColor: Colors.white,activeColor: Colors.lightGreen,),
                  // Text name
                  Text(taskName),
                ]

            ),

          ),
      ),
    );
  }

}