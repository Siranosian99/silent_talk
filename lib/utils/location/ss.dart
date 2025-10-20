// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// class SelectLocation extends StatefulWidget {
//   @override
//   _SelectLocationState createState() => _SelectLocationState();
// }
//
// class _SelectLocationState extends State<SelectLocation> {
//   LatLng? pickedLocation;
//   String address = "No location selected";
//   String savedAddress = "";
//   MapController mapController = MapController();
//   TextEditingController location=TextEditingController();
//   List<Map<String, dynamic>> suggestions = [];
//   @override
//   void initState() {
//     super.initState();
//     _loadSavedAddress();
//   }
//
//   // Load saved address from SharedPreferences
//   Future<void> _loadSavedAddress() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       savedAddress = prefs.getString('saved_address') ?? "No saved address";
//     });
//   }
//
//   // Fetch address from coordinates using OpenStreetMap's Nominatim API
//   Future<void> _getAddressFromLatLng(LatLng latLng) async {
//     final url = Uri.parse(
//         "https://nominatim.openstreetmap.org/reverse?format=json&lat=${latLng.latitude}&lon=${latLng.longitude}");
//
//     final response = await http.get(url);
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       setState(() {
//         address = data["display_name"] ?? "Address not found";
//       });
//       print("Selected Address: $address");
//     } else {
//       print("Failed to get address");
//     }
//   }
//
//   // Get current location
//   Future<void> _getCurrentLocation() async {
//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//     LatLng currentLatLng = LatLng(position.latitude, position.longitude);
//     setState(() {
//       pickedLocation = currentLatLng;
//       mapController.move(currentLatLng, 15.0);
//     });
//
//     _getAddressFromLatLng(currentLatLng);
//   }
//   Future<void> _fetchSuggestions(String query) async {
//     final url = Uri.parse(
//         "https://nominatim.openstreetmap.org/search?format=json&q=$query, Armenia");
//
//     final response = await http.get(url);
//
//     if (response.statusCode == 200) {
//       List<dynamic> data = json.decode(response.body);
//       setState(() {
//         suggestions = data.map((place) {
//           return {
//             'name': place["display_name"],
//             'lat': double.parse(place["lat"]),
//             'lon': double.parse(place["lon"]),
//           };
//         }).toList();
//       });
//     }
//   }
//   // Save the selected address
//   Future<void> _saveAddress() async {
//     if (address != "No location selected") {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       await prefs.setString('saved_address', address);
//
//       setState(() {
//         savedAddress = address;
//       });
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Address saved successfully!")),
//       );
//     }
//   }
//   Future<void> _searchLocation(String query) async {
//     final url = Uri.parse(
//         "https://nominatim.openstreetmap.org/search?format=json&q=$query");
//
//     final response = await http.get(url);
//
//     if (response.statusCode == 200) {
//       List data = json.decode(response.body);
//       if (data.isNotEmpty) {
//         double latitude = double.parse(data[0]["lat"]);
//         double longitude = double.parse(data[0]["lon"]);
//         LatLng searchedLocation = LatLng(latitude, longitude);setState(() {
//           pickedLocation = searchedLocation;
//           address = data[0]["display_name"] ?? "Address not found";
//           mapController.move(searchedLocation, 15.0);
//         });
//       } else {
//         print("No results found.");
//       }
//     } else {
//       print("Failed to fetch location.");
//     }
//   }
//   void selectLocation(Map<String, dynamic> place) {
//     LatLng newLocation = LatLng(place['lat'], place['lon']);
//     mapController.move(newLocation, 15.0);
//     setState(() {
//       location.text = place['name'];
//       suggestions.clear();
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: Text("Pick Location"),
//         leading: IconButton(onPressed: (){
//           Navigator.pop(context, savedAddress);
//         }, icon: Icon(Icons.arrow_back)),),
//
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               children: [
//                 TextField(
//                   controller: location,
//                   decoration: InputDecoration(
//                     hintText: "Search for a street in Armenia...",
//                     prefixIcon: Icon(Icons.search),
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10)),
//                   ),
//                   onChanged: (query) {
//                     if (query.length > 2) _fetchSuggestions(query);
//                   },
//                 ),
//                 // Suggestions List
//                 if (suggestions.isNotEmpty)
//                   Container(
//                     height: 200,
//                     child: ListView.builder(
//                       itemCount: suggestions.length,
//                       itemBuilder: (context, index) {
//                         return ListTile(
//                           title: Text(suggestions[index]['name']),
//                           onTap: () => selectLocation(suggestions[index]),
//                         );
//                       },
//                     ),
//                   ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: FlutterMap(
//               mapController: mapController,
//               options: MapOptions(
//                 initialCenter: LatLng(40.1792, 44.4991),
//                 initialZoom: 13.0,
//                 onTap: (tapPosition, latLng) {
//                   setState(() {
//                     pickedLocation = latLng;
//                   });
//                   _getAddressFromLatLng(latLng);
//                 },
//               ),
//               children: [
//                 TileLayer(
//                   urlTemplate:
//                   "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
//                   subdomains: ['a', 'b', 'c'],
//                   userAgentPackageName: 'com.example.silent_talk',
//                 ),
//                 if (pickedLocation != null)
//                   MarkerLayer(
//                     markers: [
//                       Marker(
//                         width: 80.0,
//                         height: 80.0,
//                         point: pickedLocation!,
//                         child: Icon(Icons.location_pin,
//                             color: Colors.red, size: 40),
//                       ),
//                     ],
//                   ),
//               ],
//             ),
//           ),
//           selectAddressSheet(),
//           addressSelectButtonsSheet(),
//           SizedBox(height: 10),
//         ],
//       ),
//     );
//   }Padding selectAddressSheet() {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Column(
//         children: [
//           Container(
//             padding: EdgeInsets.all(12),
//             margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Colors.purple.shade400, Colors.green.shade700],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Text(
//               "Address: $address",
//               style: GoogleFonts.poppins(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.white,
//               ),
//             ),
//           )
//           ,
//           SizedBox(height: 10),
//           Container(
//             padding: EdgeInsets.all(12),
//             margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black12,
//                   blurRadius: 8,
//                   offset: Offset(2, 4),
//                 ),
//               ],
//               border: Border.all(color: Colors.blue.shade300, width: 1),
//             ),
//             child: Row(
//               children: [
//                 Icon(Icons.location_on, color: Colors.blue.shade700),
//                 SizedBox(width: 10),
//                 Expanded(
//                   child: Text(
//                     "Recent Address: $savedAddress",
//                     style: GoogleFonts.poppins(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.blue.shade700,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           )
//
//         ],
//       ),
//     );
//   }
//
//   Padding addressSelectButtonsSheet() {
//     return Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Expanded(
//               child: ElevatedButton.icon(
//                 onPressed: _saveAddress,
//                 icon: Icon(Icons.history, color: Colors.white),
//                 label: Text(
//                   "Select / Last Address",
//                   style: GoogleFonts.poppins(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.white,
//                   ),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   padding: EdgeInsets.symmetric(vertical: 14),
//                   backgroundColor: Colors.blue.shade700,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   elevation: 4,
//                 ),
//               ),
//             ),
//             SizedBox(width: 12),
//             Expanded(
//               child: ElevatedButton.icon(
//                 onPressed: _getCurrentLocation,
//                 icon: Icon(Icons.my_location, color: Colors.white),
//                 label: Text(
//                   "Get Current Location",
//                   style: GoogleFonts.poppins(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.white,
//                   ),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   padding: EdgeInsets.symmetric(vertical: 14),
//                   backgroundColor: Colors.green.shade700,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   elevation: 4,
//                 ),
//               ),
//             ),
//           ],
//         ),
//     );
//   }
//
// }



























//import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:silent_talk/service/authenticator/authenticator.dart';
//
// class RequestScreen extends StatefulWidget {
//   const RequestScreen({super.key});
//
//   @override
//   State<RequestScreen> createState() => _RequestScreenState();
// }
//
// class _RequestScreenState extends State<RequestScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Requests"),
//         centerTitle: true,
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('requests')
//             .doc('9iTWrb5rTbSmmaHPUrUq3267sC83_NRZeJIyDzNamRe5tzp2xiL7SPth1')
//             .collection('users_requests')
//             .where('requestReceiverId', isEqualTo: Authenticator.user?.uid)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return const Center(child: Text('Error loading requests'));
//           }
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           final docs = snapshot.data!.docs;
//
//           if (docs.isEmpty) {
//             return const Center(child: Text('No requests found'));
//           }
//
//           return ListView.separated(
//             padding: const EdgeInsets.all(12),
//             itemCount: docs.length,
//             separatorBuilder: (context, index) => const SizedBox(height: 10),
//             itemBuilder: (context, index) {
//               final data = docs[index].data() as Map<String, dynamic>;
//               final senderName = data['senderName'] ?? 'Unknown';
//               final senderImage = data['senderImage'] ?? '';
//               final senderId = data['requestSenderId'] ?? '';
//               final requestStatus = data['requestStatus'] ?? false;
//
//               return Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.05),
//                       blurRadius: 8,
//                       offset: const Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: Row(
//                   children: [
//                     // Profile Image
//                     CircleAvatar(
//                       radius: 30,
//                       backgroundColor: Colors.grey[200],
//                       backgroundImage:
//                       senderImage.isNotEmpty ? NetworkImage(senderImage) : null,
//                       child: senderImage.isEmpty
//                           ? const Icon(Icons.person, size: 30, color: Colors.grey)
//                           : null,
//                     ),
//                     const SizedBox(width: 12),
//
//                     // Username + Full name
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             senderName,
//                             style: const TextStyle(
//                               color: Colors.black,
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           Text(
//                             senderId,
//                             style: const TextStyle(
//                               fontSize: 14,
//                               color: Colors.grey,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//
//                     // Accept Button
//                     ElevatedButton(
//                       onPressed: () {
//                         // You can update Firestore here to set requestStatus = true
//                         FirebaseFirestore.instance
//                             .collection('requests')
//                             .doc('9iTWrb5rTbSmmaHPUrUq3267sC83_NRZeJIyDzNamRe5tzp2xiL7SPth1')
//                             .collection('user_requests')
//                             .doc(docs[index].id)
//                             .update({'requestStatus': true});
//
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(content: Text('Request accepted!')),
//                         );
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor:
//                         requestStatus ? Colors.grey : Colors.green,
//                         foregroundColor: Colors.white,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 16, vertical: 8),
//                       ),
//                       child: Text(
//                         requestStatus ? 'Accepted' : 'Accept',
//                         style: const TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }