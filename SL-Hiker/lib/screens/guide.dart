import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:self_employer/providers/auth_provider.dart';
import 'package:self_employer/providers/place_provider.dart';
import 'package:self_employer/screens/auth_screen/signIn_screen.dart';
import 'package:self_employer/screens/place.dart';

import '../widgets/custom_text.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _State();
}

class _State extends State<home> {
  late Size mediasize = MediaQuery.of(context).size;
  bool issignout = false;
  Set<Marker> autoMarkers = {};
  List<Map<String, dynamic>> filteredCardData = [];
  List<Map<String, dynamic>> userData = [];
  String searchText = '';
  late GoogleMapController mapController;

  TextEditingController placeNameController = TextEditingController();
  TextEditingController placeInfoController = TextEditingController();
  // TextEditingController passwordController = TextEditingController();

  final ImagePicker picker = ImagePicker();
  File? imageFile;

  @override
  void initState() {
    super.initState();
    fetchAutoMarkersFromFirestore();
    fetchDataFromFirestore().then((data) {
      setState(() {
        userData = data;
        filteredCardData = data;
      });
    });
    // TODO: implement initState
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    setState(() {
      imageFile = null;
      placeInfoController.dispose();
      placeNameController.dispose();
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: (){
        showModalBottomSheet(
            isScrollControlled: true,
            useSafeArea: true,
            context: context,
            builder: (context) {
              return buildBottomSheet();
            },
        );
      },
          backgroundColor: Colors.white,
        child: Icon(Icons.add,color: Color.fromRGBO(64, 124, 226, 1),)
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/p.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: build_body(context),
        ),
      ),
    );
  }

  Widget createButton({required bool isShowboarder, required String buttonText, bool? isLoading}){
    return Container(
      width: 300,
      height: 56,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          color: isShowboarder?Color.fromRGBO(64, 124, 226, 1):Colors.transparent,
          border: Border.all(width: 1,color: Color.fromRGBO(64, 124, 226, 1))
      ),
      child: Center(child:(isLoading??false)?CircularProgressIndicator(color: Colors.white,):Text(buttonText??"",style: TextStyle(fontSize: 16,color: isShowboarder?Colors.white:Color.fromRGBO(64, 124, 226, 1),fontWeight: FontWeight.w500),)),
    );
  }

  Widget build_body(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        5.0,
        5.0,
        5.0,
        5.0,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: (){
                    Provider.of<UserAuthProvider>(context,listen: false).signOut().then((onValue){
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SigninScreen(),), (Route<dynamic> route) => false);
                    });
                  },
                    child: Icon(Icons.logout_rounded,color: Colors.white,)),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: Image.asset("assets/images/10.png"),
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      const Opacity(
                        opacity: 0.8,
                        child: Text(
                          "SL Hiker",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Opacity(
                  opacity: 0.8,
                  child: Container(
                    margin:
                        const EdgeInsets.only(bottom: 10, left: 5, right: 5),
                    child: TextField(
                      onChanged: (text) {
                        filterCards(text);
                      },
                      style: const TextStyle(color: Colors.black, fontSize: 15),
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          hintText:
                              "Search the best hiking routes in Sri Lanka",
                          prefixIcon: const Icon(Icons.search),
                          prefixIconColor: Colors.black),
                    ),
                  ),
                ),
              ],
            )),
            LayoutBuilder(builder: (Context, constraints) {
              return Wrap(
                children: [
                  SizedBox(
                    height: 260,
                    child: handleCard(context),
                  ),
                ],
              );
            }),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: mediasize.height,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: GoogleMap(
                  mapType: MapType.terrain,
                  onMapCreated: (controller) {
                    setState(() {
                      mapController = controller;
                    });
                  },
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(7.8731, 80.7718),
                    zoom: 8.0,
                  ),
                  zoomControlsEnabled: true,
                  scrollGesturesEnabled: true,
                  zoomGesturesEnabled: true,
                  rotateGesturesEnabled: true,
                  tiltGesturesEnabled: true,
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                  mapToolbarEnabled: true,
                  compassEnabled: true,
                  markers: autoMarkers,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildBottomSheet(){
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(onTap:()=>Navigator.pop(context),
                  child: Icon(Icons.close,color: Color.fromRGBO(64, 124, 226, 1),)),
              Center(child: Text("Add A Place",style: TextStyle(fontSize: 22,fontWeight: FontWeight.w700,color: Colors.black54),)),
              SizedBox(height: 20,),
              Center(
                child: GestureDetector(
                  onTap: () async {
                    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                    setState(() {
                      imageFile = File(image!.path);
                    });
                  },
                  child: Container(
                    height: 150,
                    width: 200,
                    decoration: BoxDecoration(
                      border: Border.all(width: 2,color: Color.fromRGBO(64, 124, 226, 1)),
                      borderRadius: BorderRadius.circular(12),
                      image: imageFile == null?DecorationImage(image: AssetImage("assets/images/image.png")):DecorationImage(image: FileImage(imageFile!),fit:BoxFit.cover )
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              SizedBox(height: 20,),
              Text("Place Name",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700,color: Colors.black54)),
              CustomText(hintText: "Enter Place Name", prefixIcon: Icons.mode_of_travel, textController: placeNameController),
              SizedBox(height: 20,),
              Text("Place Info",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700,color: Colors.black54)),
              CustomText(hintText: "Enter Place Info", prefixIcon: Icons.info_outline, textController: placeInfoController),
              SizedBox(height: 20,),
              Spacer(),
              Consumer<PlaceProvider>(
                builder: (BuildContext context, placeProvider, Widget? child) {
                  return GestureDetector(
                      onTap: () async {
                        String placeName = placeNameController.text.trim();
                        String placeInfo = placeInfoController.text.trim();
                        // String name = nameController.text.trim();

                        if(placeInfo.isNotEmpty && placeName.isNotEmpty){
                          bool responce = await  Provider.of<PlaceProvider>(context,listen: false).setPlace(placeName,placeInfo,imageFile);

                          if(responce){
                            showToast("Place Added");
                            Navigator.pop(context);
                          }
                          else{
                            print("object,failed");
                          }
                        }
                        else{
                          print("All field must be filed");
                        }

                      },
                      child: Center(child: createButton(isShowboarder: true, buttonText: "Add",isLoading: placeProvider.isLoading)));
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void filterCards(String searchText) {
    setState(() {
      filteredCardData = userData
          .where((card) => card['placeName']
              .toLowerCase()
              .contains(searchText.toLowerCase()))
          .toList();
    });
  }

  Future<void> fetchAutoMarkersFromFirestore() async {
    var markIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), 'assets/images/mount.png');
    try {
      List<Map<String, dynamic>> userData =
          await fetchlatlngDataFromFirestore();
      for (int index = 0; index < userData.length; index++) {
        double latitude = double.parse(userData[index]['lat']);
        double longitude = double.parse(userData[index]['long']);
        String title = userData[index]['placeName'];

        setState(() {
          autoMarkers.add(
            Marker(
              markerId: MarkerId(title),
              position: LatLng(latitude, longitude),
              icon: markIcon,
              infoWindow: InfoWindow(
                title: title,
                snippet: userData[index]['location'],
              ),
            ),
          );
        });
      }

      // Trigger a rebuild to update the markers on the map
    } catch (e) {
      print('Error fetching data: $e');
      showToast("$e");
    }
  }

  Widget handleCard(BuildContext context) {
    return FutureBuilder(
        future: fetchDataFromFirestore(),
        builder: (context, snapshots) {
          if (snapshots.connectionState == ConnectionState.waiting) {
            return const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Opacity(
                  opacity: 0.8,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 7),
                Opacity(
                  opacity: 0.8,
                  child: Text("Loading Data ...",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
              ],
            );
          } else if (snapshots.hasError) {
            return const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.network_check,
                  color: Colors.white,
                  size: 40,
                ),
                SizedBox(
                  height: 7,
                ),
                Text("Network error",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ],
            );
          } else {
            List<Map<String, dynamic>>? userdata = snapshots.data;
            if (filteredCardData.isEmpty) {
              return const Center(
                child: SizedBox(
                  height: 130,
                  child: Column(
                    children: [
                      Icon(Icons.location_off_outlined,
                          color: Colors.red, size: 60),
                      Opacity(
                        opacity: 0.8,
                        child: Text("Unable to findour search location.",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: filteredCardData.length,
                  itemBuilder: (context, index) {
                    return StreamBuilder<Object>(
                        stream: null,
                        builder: (context, snapshot) {
                          return build_card(
                            filteredCardData[index]['placeName']??"",
                            filteredCardData[index]['location']??"",
                            filteredCardData[index]['placeImage']??"",
                            filteredCardData[index]['info']??"",
                            filteredCardData[index]['retrievedplaceIds']??"",
                            filteredCardData[index]['maplink']??"",
                          );
                        });
                  });
            }
          }
        });
  }
}

class build_card extends StatelessWidget {
  final String placeName;
  final String locationName;
  final String imageName;
  final String info;
  final String placeId;
  final String maplink;

  const build_card(this.placeName, this.locationName, this.imageName, this.info,
      this.placeId, this.maplink,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.8,
      child: Container(
        margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white, width: 2)),
        child: Column(
          children: [
            Center(
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Wrap(
                      children: [
                        Image.network(
                          imageName,
                          fit: BoxFit.fill,
                          height: 130,
                          width: 200,
                          errorBuilder: (BuildContext context, Object exception,
                              StackTrace? stackTrace) {
                            return const SizedBox(
                              height: 130,
                              child: Icon(
                                Icons.error,
                                size: 40,
                                color: Colors.red,
                              ),
                            ); // Display an error icon on image load failure.
                          },
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child; // Image is fully loaded, show it.
                            } else {
                              return const SizedBox(
                                  height: 130,
                                  width: 50,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircularProgressIndicator(
                                        backgroundColor: Colors.transparent,
                                        color: Colors.black,
                                      ),
                                    ],
                                  )); // Display a loading indicator.
                            }
                          },
                        ),
                      ],
                    ))),
            const SizedBox(
              height: 4,
            ),
            Wrap(
              children: [
                Text(
                  placeName,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(
              height: 4,
            ),
            Wrap(
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on),
                    Text(
                      locationName,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => place(
                            placeName: placeName,
                            image: imageName,
                            info: info,
                            placeId: placeId,
                            maplink: maplink)));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black54,
              ),
              child: const Text(
                'Read More',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ],
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

Future<List<String>> getDocumentIDs() async {
  try {
    CollectionReference collection =
        FirebaseFirestore.instance.collection('places');
    QuerySnapshot querySnapshot = await collection.get();
    List<String> documentIds = querySnapshot.docs.map((doc) => doc.id).toList();
    return documentIds;
  } on Exception {
    showToast("Network Errror2");
    rethrow;
  }
}

Future<List<Map<String, dynamic>>> getDataFromFirestore(
    List<String> documentIds) async {
  try {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await firestore
        .collection('places')
        .where(FieldPath.documentId, whereIn: documentIds)
        .get();

    List<Map<String, dynamic>> userData = querySnapshot.docs
        .map((doc) => {
              'retrievedplaceIds': doc['placeId']??"",
              'placeName': doc['name']??"",
              'location': doc['location']??"",
              'placeImage': doc['image']??"",
              'info': doc['info']??"",
              'maplink': doc['maplink']??"",
            })
        .toList();
    return userData;
  } on Exception {
    showToast("Network Error2");
    rethrow;
  }
}

Future<List<Map<String, dynamic>>> getlatlngDataFromFirestore(
    List<String> documentIds) async {
  try {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await firestore
        .collection('places')
        .where(FieldPath.documentId, whereIn: documentIds)
        .get();

    List<Map<String, dynamic>> userData = querySnapshot.docs
        .map((doc) => {
              'lat': doc['lat']??"",
              'long': doc['long']??"",
              'placeName': doc['name']??"",
              'location': doc['location']??"",
            })
        .toList();
    return userData;
  } on Exception {
    showToast("Network Error2");
    rethrow;
  }
}

Future<List<Map<String, dynamic>>> fetchDataFromFirestore() async {
  try {
    List<String> documentIds = await getDocumentIDs();
    return await getDataFromFirestore(documentIds);
  } catch (e) {
    print('Error fetching data: $e');
    rethrow; // Return an empty list or handle accordingly
  }
}

Future<List<Map<String, dynamic>>> fetchlatlngDataFromFirestore() async {
  try {
    List<String> documentIds = await getDocumentIDs();
    return await getlatlngDataFromFirestore(documentIds);
  } catch (e) {
    print('Error fetching data: $e');
    rethrow; // Return an empty list or handle accordingly
  }
}
