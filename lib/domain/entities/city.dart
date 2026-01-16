import 'package:equatable/equatable.dart';

class CityEntity extends Equatable {
  final String name;
  final String? state; // Tỉnh/Bang (có thể null)
  final String country;
  final double lat;
  final double lon;

  const CityEntity({
    required this.name,
    this.state,
    required this.country,
    required this.lat,
    required this.lon,
  });

  @override
  List<Object?> get props => [name, state, country, lat, lon];
  
  // Helper để hiển thị tên đẹp: "Hanoi, VN" hoặc "San Jose, CA, US"
  String get displayName {
    if (state != null && state!.isNotEmpty) {
      return '$name, $state, $country';
    }
    return '$name, $country';
  }
}
