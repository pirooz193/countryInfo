import 'package:counries_info/data/CountryEntity.dart';
import 'package:counries_info/widgets/image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
// This package provides LatLng class

  bool isLoading = false;


class CountryScreen extends StatefulWidget {
  final CountryEntity country;

  const CountryScreen({super.key, required this.country});

  @override
  State<CountryScreen> createState() => _CountryScreenState();
}

class _CountryScreenState extends State<CountryScreen> {
  @override
  Widget build(BuildContext context) {
    
    final time = calculateTimeFromTimeZoneOffset(widget.country.timezones![0]);
    final coordinates =
        _parseCoordinatesFromUrl(widget.country.maps!['openStreetMaps']);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 227, 236, 236),
        foregroundColor: Colors.grey.shade700,
        title: Text(
          widget.country.name!['common'],
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ImageLoadingService(
              imageUrl: widget.country.flags!['png'],
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
                        subdomains: const ['a', 'b', 'c'],
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
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 50,
                ),
                Container(
                  width: 100,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.grey.shade300,
                      ),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 15,
                          color: Colors.grey.shade200,
                        )
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Center(
                      child: Text(
                        //  time,
                        time.split(':').length > 1
                            ? "${time.split(':')[0].split(" ")[1]} : ${time.split(':')[1]}"
                            : '--',
                        // currentCountry.timezones.toString(),
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: () async {
                    setState(() {
                      isLoading = true; // Show loading indicator
                    });
                    await _handleTap(context, time);
                    setState(() {
                      isLoading = false; // Hide loading indicator
                    });
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        CupertinoIcons.exclamationmark_circle,
                        color: Colors.grey.shade600,
                        size: 30,
                      ),
                      if (isLoading)
                        CircularProgressIndicator(
                          color: Colors.red.shade100,

                        ), // Show loading indicator
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
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
                          widget.country.capital![0],
                          'زبان',
                          widget.country.languages
                                  .toString()
                                  .split(':')[1]
                                  .replaceAll("}", '') ??
                              '--'),
                      const SizedBox(
                        height: 20,
                      ),
                      rowItems(
                          'پیش شماره',
                          widget.country.idd!['root'] + widget.country.idd!['suffixes'][0] ??
                              '--',
                          'کد',
                          widget.country.cca2 ?? '--'),
                      const SizedBox(
                        height: 20,
                      ),
                      rowItems(
                        'واحد پول',
                        widget.country.currencies
                                .toString()
                                .split('name')[0]
                                .replaceAll(":", "")
                                .replaceAll("}", '')
                                .replaceAll("{", '') ??
                            '--',
                        'روز شروع هفته',
                        widget.country.startOfWeek ?? '--',
                      ),
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

  Future<void>? _handleTap(BuildContext context, time) async {
    // Make your API call here
    // String apiUrl = 'https://your-api-url-here.com';
    try {
      final response = await Dio().get(
          'http://api.timezonedb.com/v2.1/get-time-zone?key=X93PENQOQENE&format=json&by=position&lat=' +
              widget.country.capitalInfo!['latlng'][0].toString() +
              '&lng=' +
              widget.country.capitalInfo!['latlng'][1].toString());
      if (response.statusCode == 200) {
        // API call was successful, show a popup
        final timeDif = response.data['formatted'].toString().split(' ')[1];
        final int hourDif = int.parse(timeDif.split(':')[0]);
        final int currecntCountryHour =
            int.parse(time.split(':')[0].split(" ")[1]);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: AlertDialog(
                title: hourDif - currecntCountryHour > 0
                    ? Text('میزان تغییر ساعت :‌ ' +
                        (hourDif - currecntCountryHour).toString())
                    : Text(''),
                content: hourDif - currecntCountryHour > 0
                    ? Text(
                        time.split(':').length > 1
                            ? 'ساعت فعلی : ' +
                                "${time.split(':')[1]} : ${hourDif}"
                            : '--',
                      )
                    : const Text('کشور مورد  نظر تغییر ساعتی ندارد'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Close'),
                  ),
                ],
              ),
            );
          },
        );
      } else {
        // API call failed, show an error popup
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('Failed to fetch data from the API.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      }
    } catch (error) {
      print('Error making API call: $error');
    }
  }

  String calculateTimeFromTimeZoneOffset(String timeZoneOffset) {
    String formattedUtcTime = '';
    if (timeZoneOffset == 'UTC') {
      DateTime localTime = DateTime.now();

      DateTime utcTime = localTime;
      formattedUtcTime = "${utcTime.toUtc()}";
    } else {
      String sign = timeZoneOffset.substring(3, 4);
      int hours = int.parse(timeZoneOffset.substring(4, 6));
      int minutes = int.parse(timeZoneOffset.substring(7, 9));

      int totalOffsetMinutes =
          (sign == '+') ? (hours * 60 + minutes) : (-hours * 60 - minutes);

      DateTime localTime = DateTime.now();

      DateTime utcTime = (sign == '+')
          ? localTime.add(Duration(minutes: totalOffsetMinutes))
          : localTime.subtract(Duration(minutes: totalOffsetMinutes));

      formattedUtcTime = "${utcTime.toUtc()}";
    }

    return formattedUtcTime;
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
        final latitude = widget.country.capitalInfo!['latlng'][0]; // Example latitude
        final longitude =
            widget.country.capitalInfo!['latlng'][1]; // Example longitude

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
