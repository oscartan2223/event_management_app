import 'dart:async';
import 'package:assignment/utils/form_vadidator.dart';
import 'package:assignment/widgets/components/custom_input_fields.dart';
import 'package:assignment/widgets/components/empty_space.dart';
import 'package:assignment/widgets/header_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class CustomLocationPicker extends StatefulWidget {
  const CustomLocationPicker(
      {super.key,
      required this.setLocation,
      required this.controller,
      this.initialValue});

  final void Function(LatLng) setLocation;
  final TextEditingController controller;
  final LatLng? initialValue;

  @override
  State<CustomLocationPicker> createState() => _CustomLocationPickerState();
}

class _CustomLocationPickerState extends State<CustomLocationPicker> {
  // static const LatLng _initialLocation = LatLng(3.140853, 101.693207);
  //get location API url = https://maps.googleapis.com/maps/api/geocode/json?latlng=0.00,0.00&key=

  final Location _locationController = Location();

  late LatLng _currentLocation;
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  @override
  void initState() {
    _currentLocation =
        widget.initialValue ?? const LatLng(3.140853, 101.693207);
    if (widget.initialValue != null) {
      widget.controller.value = TextEditingValue(
          text:
              '${_currentLocation.latitude.toStringAsFixed(6)}, ${_currentLocation.longitude.toStringAsFixed(6)}');
    }
    super.initState();
  }

  @override
  void dispose() {
    _mapController.future.then((controller) {
      controller.dispose();
    });
    super.dispose();
  }

  Future<void> getLocationUpdates() async {

    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _locationController.serviceEnabled();
    if (serviceEnabled) {
      serviceEnabled = await _locationController.requestService();
    } else {
      return;
    }

    permissionGranted = await _locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    } else if (permissionGranted == PermissionStatus.granted) {
      LocationData currentLocation = await _locationController.getLocation();

      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          _currentLocation =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
          _cameraToPosition(_currentLocation);
          widget.controller.value = TextEditingValue(
              text:
                  '${_currentLocation.latitude.toStringAsFixed(6)}, ${_currentLocation.longitude.toStringAsFixed(6)}');
          widget.setLocation(_currentLocation);
        });
      }
    }
  }

  Future<void> _cameraToPosition(LatLng position) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition newCameraPosition = CameraPosition(
      target: position,
      zoom: 15,
    );

    await controller
        .animateCamera(CameraUpdate.newCameraPosition(newCameraPosition));
  }

  void _onTap(LatLng location) {
    setState(() {
      _currentLocation = location;
      widget.controller.value = TextEditingValue(
          text:
              '${_currentLocation.latitude.toStringAsFixed(6)}, ${_currentLocation.longitude.toStringAsFixed(6)}');
      widget.setLocation(location);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const HeaderBar(
          headerTitle: 'Pick Location',
          menuRequired: false,
        ),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.fromLTRB(5, 35, 5, 5),
          child: Column(
            children: [
              CustomTextFormField(
                text: 'Venue',
                validator: locationValidator(),
                actionOnChanged: (_) {},
                controller: widget.controller,
              ),
              const VerticalEmptySpace(),
              Expanded(
                child: Stack(
                  children: [
                    GoogleMap(
                      onMapCreated: ((GoogleMapController controller) =>
                          _mapController.complete(controller)),
                      initialCameraPosition:
                          CameraPosition(target: _currentLocation, zoom: 15),
                      onTap: _onTap,
                      markers:
                          _currentLocation == const LatLng(3.140853, 101.693207)
                              ? {}
                              : {
                                  Marker(
                                    markerId: const MarkerId('location'),
                                    position: _currentLocation,
                                  ),
                                },
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: FloatingActionButton(
                        onPressed: getLocationUpdates,
                        shape: const CircleBorder(),
                        backgroundColor:
                            const Color.fromARGB(219, 255, 255, 255),
                        child: const Icon(
                          Icons.my_location,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    // const Center(
                    //   child: Icon(
                    //     Icons.location_pin,
                    //     color: Colors.red,
                    //     size: 48,
                    //   ),
                    // )
                  ],
                ),
              ),
            ],
          ),
        )));
  }
}
