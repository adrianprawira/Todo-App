import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class GetLocation{

  static var getSpecificLoc;

  static Future<Position> determinePos() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled= await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled){
    Fluttertoast.showToast(msg: 'Please enable location services');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  } if (permission == LocationPermission.denied){
    Fluttertoast.showToast(msg: 'Location permission denied');
  }

  Position position = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.low
  );

  try {
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];

    getSpecificLoc = '${place.subAdministrativeArea}';
  } catch(e) {
    print(e);
  }
}
}

