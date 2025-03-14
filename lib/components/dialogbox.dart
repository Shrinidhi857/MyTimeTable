import 'package:flutter/material.dart';
import 'package:mytimetable/components/timepage.dart';
import 'mybuttons.dart';

class DialogBox extends StatefulWidget {
  final TextEditingController subjectController;
  final TextEditingController startTimeController;
  final TextEditingController endTimeController;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  DialogBox({
    super.key,
    required this.subjectController,
    required this.startTimeController,
    required this.endTimeController,
    required this.onSave,
    required this.onCancel,
  });

  @override
  _DialogBoxState createState() => _DialogBoxState();
}

class _DialogBoxState extends State<DialogBox> {
  TextEditingController hourController = TextEditingController();
  TextEditingController minuteController = TextEditingController();
  TextEditingController timeFormatController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        height: 220,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextField(
              controller: widget.subjectController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary,),

                ),
                hintText: "Enter Subject",
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTimePicker("Start", widget.startTimeController,"Start"),
                _buildTimePicker("End", widget.endTimeController,"End"),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyButton(
                  text: "SAVE",
                  onPressed: widget.onSave,
                ),
                MyButton(
                  text: "CANCEL",
                  onPressed: widget.onCancel,
                ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
    );
  }

  Widget _buildTimePicker(String label, TextEditingController controller,String time) {
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NumberPage(
                  hourController: hourController,
                  minuteController: minuteController,
                  timeFormatController: timeFormatController,
                ),
              ),
            );

            setState(() {
              controller.text =
              "${hourController.text.padLeft(2, '0')}:${minuteController.text.padLeft(2, '0')} ${timeFormatController.text}";
            });
          },
          child: Container(
            height: 40,
            width: 100,
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                  color: Theme.of(context).colorScheme.secondary,
                  width: 1),
            ),
            child: Text(
              controller.text.isNotEmpty ? controller.text : time,
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }
}
