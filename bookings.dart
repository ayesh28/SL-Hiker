import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class bookings extends StatefulWidget {
  String placeId;
  bookings({super.key, required this.placeId});
  @override
  State<bookings> createState() => _bookingsState(placeId);
}

class _bookingsState extends State<bookings> {
  String placeid;
  _bookingsState(this.placeid);

  final _firestore = FirebaseFirestore.instance;
  late Size mediasize = MediaQuery.of(context).size;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<List<Widget>> fetchData() async {
    QuerySnapshot snapshot =
        await _firestore.collection('places/$placeid/Bookings').get();
    List<Widget> items = [];

    for (var document in snapshot.docs) {
      String itemName = document['Name'];
      String imageUrl = document['image_url'];

      items.add(
        Column(
          children: [
            Container(
              height: 80,
              width: mediasize.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  width: 1,
                  color: Colors.blue,
                ),
              ),
              child: Center(
                child: ListTile(
                  title: Text(
                    itemName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                        width: 100, height: 100, imageUrl, fit: BoxFit.fill),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            )
          ],
        ),
      );
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        body: Container(
          width: mediasize.width,
          height: mediasize.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/p.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Wrap(
                children: [
                  Column(
                    children: [
                      FutureBuilder(
                        future: fetchData(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return SizedBox(
                              height: mediasize.height,
                              child: const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                    Text("Loading Data ...",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            List<Widget> items = snapshot.data as List<Widget>;
                            if (items.isEmpty) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Available Shops",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(
                                      height: mediasize.height,
                                      width: mediasize.width,
                                      child: const Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.error_sharp,
                                              color: Colors.red, size: 50),
                                          Text("No available shops found",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white)),
                                        ],
                                      )),
                                ],
                              );
                            } else {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Available Shops",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Container(
                                    height: mediasize.height,
                                    width: mediasize.width,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        width: 1,
                                        color: Colors.transparent,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ListView(
                                        children: items,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
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
