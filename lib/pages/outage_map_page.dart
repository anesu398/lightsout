import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class OutageMapPage extends StatelessWidget {
  const OutageMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    const center = LatLng(-20.1567, 28.5810);
    final markers = <Marker>[
      _marker(-20.1601, 28.5702, 'Khumalo'),
      _marker(-20.1483, 28.5941, 'Polytechnic'),
      _marker(-20.1428, 28.6077, 'Ascot'),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Outage Utility Map')),
      body: FlutterMap(
        options: const MapOptions(
          initialCenter: center,
          initialZoom: 13.2,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.lightsout',
          ),
          MarkerLayer(markers: markers),
        ],
      ),
    );
  }

  Marker _marker(double lat, double lng, String title) {
    return Marker(
      point: LatLng(lat, lng),
      width: 100,
      height: 70,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(999),
              boxShadow: const [
                BoxShadow(color: Color(0x25000000), blurRadius: 8, offset: Offset(0, 2)),
              ],
            ),
            child: Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
          ),
          const Icon(Icons.location_pin, color: Colors.redAccent, size: 28),
        ],
      ),
    );
  }
}
