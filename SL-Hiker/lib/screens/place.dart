import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:self_employer/screens/home.dart';
import 'package:url_launcher/url_launcher.dart';

import 'bookings.dart';
import 'guide.dart';

class place extends StatefulWidget {
  String placeId;
  String placeName;
  String image;
  String info;
  String maplink;
  place(
      {super.key,
      required this.placeName,
      required this.image,
      required this.info,
      required this.placeId,
      required this.maplink});
  @override
  State<place> createState() =>
      _placeState(placeName, image, info, placeId, maplink);
}

class _placeState extends State<place> {
  String placeName;
  String image;
  String info;
  String placeId;
  String maplink;

  _placeState(
      this.placeName, this.image, this.info, this.placeId, this.maplink);

  late Size mediasize;
  late Color myColor;
  bool showForm = true;
  final _db = FirebaseFirestore.instance;
  late Future<List<String>> documentIds;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void toggle_form() {
    setState(() {
      showForm = !showForm;
    });
  }

  @override
  Widget build(BuildContext context) {
    myColor = Theme.of(context).primaryColor;
    mediasize = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const home()));
        return true;
      },
      child: Scaffold(
        body: Column(
          children: [
            Container(
              height: mediasize.height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(image),
                  fit: BoxFit.cover,
                ),
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 250),
                      buildbottom(),
                    ],
                  ),
                ),
              ) /* add child content here */,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildbottom() {
    return SizedBox(
      child: Opacity(
        opacity: 1,
        child: Card(
          color: const Color(0xFFffffff),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          )),
          child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: mediasize.width,
                    margin: const EdgeInsets.all(10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(image, fit: BoxFit.fill),
                    ),
                  ),
                  Text(placeName,
                      style: const TextStyle(
                          fontSize: 32, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 20),
                  Text(
                    info,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    bookings(placeId: placeId)));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Hire camping items')),
                  const SizedBox(
                    height: 5,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => guide(placeId: placeId)));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Hire a guide')),
                  const SizedBox(
                    height: 5,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        _openGoogleMaps();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: Text("Direction to $placeName")),
                ],
              )),
        ),
      ),
    );
  }

  Widget imgCard() {
    return const SizedBox(width: 100, height: 50, child: Text("data"));
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Future<void> _openGoogleMaps() async {
    String mapsUrl = maplink;

    if (await canLaunch(mapsUrl)) {
      await launch(mapsUrl);
    } else {
      print('Could not launch $mapsUrl');
    }
  }
}
