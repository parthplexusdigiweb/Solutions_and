import 'package:flutter/material.dart';
import 'package:thrivers/widget/app_common.dart';


class CustomExpansionTile2 extends StatefulWidget {
  final String? title;
  final List<Widget> children;
  final TextStyle? style;
   Function()? onTap;
  final bool isExpanded;
   var index;


  CustomExpansionTile2({ this.title,  required this.children,  this.style,this.onTap,required this.isExpanded,this.index });

  @override
  _CustomExpansionTile2State createState() => _CustomExpansionTile2State();
}

class _CustomExpansionTile2State extends State<CustomExpansionTile2> {

  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    isExpanded = widget.isExpanded;
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: () {
      //   setState(() {
      //     isExpanded = !isExpanded;
      //   });
      // },
      // onTap: () {
      //   setState(() {
      //     widget.isExpanded = !widget.isExpanded;
      //   });
      //   widget.onTap;
      // },
      onTap: () {
        // setState(() {
        //   isExpanded = !isExpanded;
        // });
        widget.onTap?.call();
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10.0),
        // padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: widget.isExpanded ?  Border.all(color: Colors.blue) : Border.all(color: Colors.white), // Border color
          borderRadius: BorderRadius.circular(10.0) , // Border radius
        ),
        child: Column(
          children: [
            Container(
              decoration:
              (widget.isExpanded) ? boxDecoration(context,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.fromBorderSide(BorderSide.none),
                  gradient: LinearGradient(colors: [Colors.blue, Colors.blueAccent] ,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight
              )
              ) :
              box2Decoration(context,
                  borderRadius: BorderRadius.circular(8.0)
                  // clr: isExpanded ? mainColor : White1
              ),
              padding: EdgeInsets.all(15.0),
              // margin: EdgeInsets.symmetric(vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text( "${widget.title}",
                      style: widget.style ?? TextStyle(
                          fontSize: 16,
                          color: Colors.black
                      ) // Text color
                  ),
                  Icon(
                    widget.isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.black, // Icon color
                  ),
                ],
              ),
            ),
            if (widget.isExpanded)
              Column(
                children: widget.children,
              ),
          ],
        ),
      ),
    );
  }
}