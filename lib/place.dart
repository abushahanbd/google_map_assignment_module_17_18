import 'package:google_maps_flutter/google_maps_flutter.dart';

class LandMark {
  const LandMark({
    required this.id,
    required this.title,
    required this.position,
    required this.fact,
  });

  final String id;
  final String title;
  final LatLng position;
  final String fact;
}

class Places {
  static const LandMark parlament = LandMark(
    id: 'parlament',
    title: 'National Parlament',
    position: LatLng(23.7625, 90.3783),
    fact: 'Jatio Sangsad bhaban',
  );

  static const LandMark shahidminar = LandMark(
    id: 'shahidminar',
    title: 'Shahidminar',
    position: LatLng(23.7271, 90.3967),
    fact: 'Remembers the Language Movement',
  );

  static const LandMark lalbaghFort = LandMark(
    id: 'lalbagh',
    title: 'Lalbagh Fort',
    position: LatLng(23.7190, 90.3880),
    fact: 'Mughal fort, started in 1678',
  );

  static const LandMark ahsanManzil = LandMark(
    id: 'ahsan_manzil',
    title: 'Ahsan Manzil',
    position: LatLng(23.7086, 90.4068),
    fact: 'The Pink Palace',
  );

  static const LandMark hatirjheel = LandMark(
    id: 'hatirjheel',
    title: 'Hatirjheel',
    position: LatLng(23.7690, 90.4240),
    fact: 'The lake in the middle of the city',
  );

  static const LandMark university = LandMark(
    id: 'du',
    title: 'University of Dhaka',
    position: LatLng(23.7340, 90.3928),
    fact: 'University of Dhaka campus',
  );

  static const LandMark glorySchool01 = LandMark(
    id: 'glorySchool1',
    title: 'Glory Pre-cadet And High School, Brance-01',
    position: LatLng(23.760423, 90.442000),
    fact: 'This is a Famous School In this are',
  );

  static const LandMark glorySchool02 = LandMark(
    id: 'glorySchool2',
    title: 'Glory Pre-cadet And High School, Brance-01',
    position: LatLng(23.759869, 90.445472),
    fact: 'This is a Famous School In this are',
  );

  static const List<LandMark> all = [
    parlament,
    shahidminar,
    lalbaghFort,
    ahsanManzil,
    hatirjheel,
    university,
    glorySchool01,
    glorySchool02,
  ];

  // Campush Shuttle Routes in order.
  static const List<LandMark> shuttleRoute = [
    shahidminar,
    lalbaghFort,
    ahsanManzil,
  
    glorySchool01,
    glorySchool02,
      hatirjheel,
    parlament,
  ];

  // first camera frame. later moves go through GoogleMapController
  static const CameraPosition openingCamera = CameraPosition(
    target: LatLng(23.740, 90.400),
    zoom: 12,
  );
}
