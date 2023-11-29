import 'package:eduverse/model/coursedetails.dart';
import 'package:eduverse/model/viewcourses.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:video_player/video_player.dart';

class coursedetails extends StatefulWidget {
  String courseuuid;
  coursedetails(this.courseuuid);

  @override
  State<coursedetails> createState() => _coursedetailsState();
}

class _coursedetailsState extends State<coursedetails> {
  final video = "images/videos/trailer.mp4";
  late VideoPlayerController controller; // video player controller
  List<Coursedetails> view = []; //course details

  Future<void> fetchcoursedetails(String query) async {
    String url = "https://courses-eduverse.onrender.com/courses/detail/$query/";
    var response = await get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);

      setState(() {
        view.add(Coursedetails.fromJson(data));
      });
    } else {
      // Handle error, e.g., show an error message
      print("Failed to load data: ${response.statusCode}");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchcoursedetails(widget.courseuuid);
    // video player controller
    controller = VideoPlayerController.asset(video)
      ..addListener(() => setState(() {}))
      ..setLooping(true)
      ..initialize().then((value) => controller.play());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var a = MediaQuery.of(context).size.width;
    var b = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 236, 236, 237),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 249, 106, 104),
        title: Text("Course Details"),
      ),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [ 
            Row(// video player widget
              children: [
                controller.value.isInitialized?
                Container(alignment: Alignment.topCenter,
                  child: VideoPlayer(controller
                  ),
                ):Container(
                  height: 200,
                  child: Center(child: CircularProgressIndicator(),),
                ),
              ],
            )
          ],
        ),
      )),
    );
  }
}
