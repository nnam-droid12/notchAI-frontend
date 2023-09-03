import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class BookAppointment extends StatefulWidget {
  const BookAppointment({Key? key}) : super(key: key);

  @override
  State<BookAppointment> createState() => _BookAppointmentState();
}

class _BookAppointmentState extends State<BookAppointment> {
  GoogleMapController? mapController;
  Location location = Location();
  LatLng? userLocation;
  List<Doctor> doctors = [
    Doctor(id: 1, name: 'Dr. John Doe', specialty: 'Cardiologist', location: const LatLng(37.7749, -122.4194)),
    Doctor(id: 2, name: 'Dr. Jane Smith', specialty: 'Dermatologist', location: const LatLng(37.7833, -122.4167)),
   
  ];

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  void _getUserLocation() async {
    try {
      final userLocationData = await location.getLocation();
      setState(() {
        userLocation = LatLng(
          userLocationData.latitude!,
          userLocationData.longitude!,
        );
      });
    } catch (error) {
      print("Error getting user location: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Appointment'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                setState(() {
                  mapController = controller;
                });
              },
              initialCameraPosition: CameraPosition(
                target: userLocation ?? const LatLng(0, 0),
                zoom: 15,
              ),
              markers: _buildDoctorMarkers(),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _showAppointmentDialog(context);
            },
            child: const Text('Book Appointment'),
          ),
        ],
      ),
    );
  }

  Set<Marker> _buildDoctorMarkers() {
    final Set<Marker> markers = {};

    for (final doctor in doctors) {
      markers.add(
        Marker(
          markerId: MarkerId('doctor${doctor.id}'),
          position: doctor.location,
          infoWindow: InfoWindow(
            title: doctor.name,
            snippet: doctor.specialty,
          ),
        ),
      );
    }

    return markers;
  }

  Future<void> _showAppointmentDialog(BuildContext context) async {
    final selectedDoctor = await showDialog<Doctor>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Select a Doctor'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: doctors.map((doctor) {
              return ListTile(
                title: Text(doctor.name),
                subtitle: Text(doctor.specialty),
                onTap: () {
                  Navigator.of(dialogContext).pop(doctor);
                },
              );
            }).toList(),
          ),
        );
      },
    );

    if (selectedDoctor != null) {
      // Implement appointment booking logic here
      // You can navigate to a confirmation screen or perform other actions
      // For now, we'll just show a snackbar as an example
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Appointment booked with Dr. ${selectedDoctor.name}'),
        ),
      );
    }
  }
}

class Doctor {
  final int id;
  final String name;
  final String specialty;
  final LatLng location;

  Doctor({required this.id, required this.name, required this.specialty, required this.location});
}

