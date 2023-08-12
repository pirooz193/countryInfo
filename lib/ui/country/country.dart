import 'package:cached_network_image/cached_network_image.dart';
import 'package:counries_info/data/CountryEntity.dart';
import 'package:counries_info/widgets/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
// This package provides LatLng class

class CountryScreen extends StatelessWidget {
  final CountryEntity country;

  const CountryScreen({super.key, required this.country});

  @override
  Widget build(BuildContext context) {
    final coordinates =
        _parseCoordinatesFromUrl(country.maps!['openStreetMaps']);
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 227, 236, 236),
        foregroundColor: Colors.grey.shade700,
        title: Text(
          country.name!['common'],
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ImageLoadingService(
              imageUrl: country.flags!['png'],
              width: 60,
              height: 40,
              fit: BoxFit.fill,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 30, 15, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 300,
                decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 20,
                        color: Colors.grey.shade400,
                      )
                    ]),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: FlutterMap(
                    options: MapOptions(
                      center: coordinates,
                      zoom: coordinates != null ? 4.0 : 0,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                        subdomains: ['a', 'b', 'c'],
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            width: 100.0,
                            height: 100.0,
                            point: coordinates ?? const LatLng(0, 0),
                            builder: (ctx) => const Icon(
                              Icons.location_on,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Divider(
              indent: 15,
              endIndent: 15,
              height: 1,
              thickness: 0.5,
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 30, 8, 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      rowItems(
                          'پایتخت',
                          country.capital![0] ?? '--',
                          'زبان',
                          country.languages
                                  .toString()
                                  .split(':')[1]
                                  .replaceAll("}", '') ??
                              '--'),
                      const SizedBox(
                        height: 20,
                      ),
                      rowItems(
                        'پیش شماره',
                          country.idd!['root'] + country.idd!['suffixes'][0] ??
                              '--',
                          'کد',
                          country.cca2 ?? '--'
                          ),
                      const SizedBox(
                        height: 20,
                      ),
                      rowItems(
                         
                          'واحد پول',
                          country.currencies
                                  .toString()
                                  .split('name')[0]
                                  .replaceAll(":", "")
                                  .replaceAll("}", '')
                                  .replaceAll("{", '') ??
                              '--' ,  'روز شروع هفته',
                          country.startOfWeek ?? '--',),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget rowItems(
      String title, String content, String title2, String content2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _CounteryDetails(title: title, content: content),
        _CounteryDetails(title: title2, content: content2),
      ],
    );
  }

  LatLng? _parseCoordinatesFromUrl(String url) {
    final regex = RegExp(r'/relation/(\d+)');
    final match = regex.firstMatch(url);
    if (match != null && match.groupCount == 1) {
      final relationId = int.tryParse(match.group(1)!);
      if (relationId != null) {
        final latitude = country.latlng![0]; // Example latitude
        final longitude = country.latlng![1]; // Example longitude

        return LatLng(latitude, longitude);
      }
    }
    return null;
  }
}

class _CounteryDetails extends StatelessWidget {
  final String title;
  final String content;

  const _CounteryDetails({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {},
      child: Container(
          width: 150,
          height: 100,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  blurRadius: 20,
                  color: Colors.grey.shade400,
                )
              ]),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Divider(
                  indent: 8,
                  endIndent: 8,
                  height: 1,
                  thickness: 0.8,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  content,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Colors.grey.shade800,
                      ),
                  overflow: TextOverflow.fade,
                ),
              ],
            ),
          )),
    );
  }
}
