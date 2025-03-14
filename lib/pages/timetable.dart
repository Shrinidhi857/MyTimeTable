
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytimetable/components/mybuttons.dart';
import 'package:mytimetable/components/subjectbox.dart';
import 'package:hive/hive.dart';
import '../components/dialogbox.dart';
import '../data/database.dart';

class TimeTablePage extends StatefulWidget {
  final VoidCallback? refresh;
  const TimeTablePage({super.key,required this.refresh});

  @override
  State<TimeTablePage> createState() => _TimeTablePageState();
}

// Define timetable data

class _TimeTablePageState extends State<TimeTablePage> {

  final _myBox= Hive.box("mybox");
  TextEditingController startController =TextEditingController();
  TextEditingController endController =TextEditingController();
  TextEditingController subjectController =TextEditingController();

  late String startTime,endTime;
  TimeTableDatabase db = TimeTableDatabase();

  @override
  void initState(){
    //first time ever opening the  app, then create default app
    if(_myBox.get("TIMETABLE") == null){
      db.createInitializeData();
    }else
    {
      db.loadData();

    }
    super.initState();
  }

  /*void checkBoxChanged(bool? value,int index) {
    setState(() {
      db.timeTable[index][1]=!db.toDoList[index][1];
    });
    db.updateDataBase();
  }*/

  void saveNewSubject(String day) {
    if (subjectController.text.trim().isEmpty) {
      // Skip if subjectController is empty
      return;
    }

    setState(() {
      db.timeTable[day]?.add({
        'subject': subjectController.text,
        'starttime': startController.text,
        'endtime': endController.text,
      });

      // Clear controllers after saving
      subjectController.clear();
      startController.clear();
      endController.clear();
    });

    db.updateDatabase();
    Navigator.of(context).pop();
    widget.refresh;
  }



  void createNewSubject(String day){
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
            subjectController: subjectController,
            startTimeController: startController,
            endTimeController: endController,
            onSave: () => saveNewSubject(day),
            onCancel: () => Navigator.of(context).pop()
        );
      }
    );
  }

  void confirmDelete(int index,String day){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20), // Adjust the radius as needed
            ),
            content: Container(
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.delete,
                  size:100,
                  ),
                  Text("Delete item?")
                  ,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyButton(text: "Delete", onPressed: ()=>deleteSubject(index, day)),
                      MyButton(text: "Cancel", onPressed: ()=>Navigator.of(context).pop()),
                    ],
                  )
                ],
              ),
            ),
          );
        }
    );
  }




  void deleteSubject(int index, String day) {
    setState(() {
      if (db.timeTable.containsKey(day) && index >= 0 && index < db.timeTable[day]!.length) {
        db.timeTable[day]!.removeAt(index); // Remove the task at the given index
      }
    });
    db.updateDatabase();
    Navigator.of(context).pop();
    widget.refresh?.call();
  }



  @override
  Widget build(BuildContext context) {
    double itemWidth = 150; // Fixed width of each item
    double itemHeight = 80; // Fixed height of each item
    double dayColumnWidth = 100; // Width for day names
    double spacing = 8; // Spacing between items

    int rowCount = 7; // Fixed: 7 days
    int maxSubjects = db.timeTable.values.map((list) => list.length).fold(0, (a, b) => a > b ? a : b)+1;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          "Create Timetable",
            style: GoogleFonts.roboto(
              color: Theme.of(context).colorScheme.inversePrimary,
              fontWeight: FontWeight.w900,
              fontSize: 25,
            )
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal, // Enable horizontal scrolling
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: List.generate(rowCount, (rowIndex) {
                String day = db.timeTable.keys.elementAt(rowIndex);
                List<Map<String, String>> subjects = db.timeTable[day] ?? [];

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // First column for Day Name
                    SizedBox(
                      width: dayColumnWidth,
                      child: Text(
                        day,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    // Subject Boxes
                    Row(
                      children: List.generate(maxSubjects, (colIndex) {
                        if (colIndex < subjects.length) {
                          return Padding(
                            padding: EdgeInsets.all(spacing),
                            child: GestureDetector(
                              onLongPress: ()=>confirmDelete(colIndex,day),
                              child: RoundedBox(
                                width: itemWidth,
                                height: itemHeight,
                                startTime: subjects[colIndex]['starttime']!,
                                endTime: subjects[colIndex]['endtime']!,
                                subject: subjects[colIndex]['subject']!,
                              ),
                            ),
                          );
                        }
                        else if(colIndex == subjects.length){
                          return Padding(
                            padding: EdgeInsets.all(spacing),
                            child: SizedBox(
                              width: 150, // Set fixed width
                              height: 80, // Set fixed height
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Circular background behind the "+" icon
                                  Container(
                                    width: 50, // Adjust the size of the circle
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.primary, // Faded primary color
                                      shape: BoxShape.circle,
                                      // Makes it a circle
                                    ),
                                  ),
                                  // The actual button
                                  ElevatedButton(
                                    onPressed:()=>createNewSubject(day),
                                    style: ElevatedButton.styleFrom(
                                      fixedSize: Size(150, 80),
                                      backgroundColor: Colors.transparent,// Set fixed size for button
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        side: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 2),// Slightly rounded rectangle
                                      ),
                                    ),
                                    child: Icon(Icons.add, size: 30, color: Colors.white), // Icon with adjusted size
                                  ),

                                ],
                              ),
                            ),
                          );

                        }
                        else
                        {// Empty box to maintain grid alignment
                          return Padding(
                            padding: EdgeInsets.all(spacing),
                            child: SizedBox(width: itemWidth, height: itemHeight),
                          );
                        }
                      },
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
