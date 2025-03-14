import 'package:flutter/material.dart';
import 'package:mytimetable/components/marquee.dart';
import 'package:mytimetable/components/subjectname.dart';

class RoundedBox extends StatefulWidget {

  final double width;
  final double height;
  final String startTime;
  final String endTime;
  final String subject;

   RoundedBox({
    super.key,
    required this.width,
    required this.height,
    required this.startTime,
    required this.endTime,
    required this.subject,

  });

  @override
  State<RoundedBox> createState() => _RoundedBoxState();
}


class _RoundedBoxState extends State<RoundedBox> {
  TextEditingController _controller =TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child:Column(
        children: [
          /*Text(widget.subject,
            style: TextStyle(
              color: Theme.of(context).colorScheme.inversePrimary,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),*/
          MarqueeComp(
            text: widget.subject,
              width: 80,
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
          ),

          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.startTime,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                ),
              ),

              Text(widget.endTime,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                ),
              ),
            ]
          )
        ],
      ),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
