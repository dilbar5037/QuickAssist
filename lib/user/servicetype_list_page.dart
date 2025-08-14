import 'package:flutter/material.dart';


class ViewServicebyType extends StatefulWidget {

  final Map<String,dynamic>? data;
  const ViewServicebyType({super.key,this.data});

  @override
  State<ViewServicebyType> createState() => _ViewServicebyTypeState();
}

class _ViewServicebyTypeState extends State<ViewServicebyType> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text("${widget.data!['type']} Service Stations near You",style: TextStyle(color: Colors.white),),
      ),

      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [





          ],
        ),
      ),
    );
  }
}
