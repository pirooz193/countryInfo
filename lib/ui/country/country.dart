import 'package:cached_network_image/cached_network_image.dart';
import 'package:counries_info/data/CountryEntity.dart';
import 'package:counries_info/widgets/image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_analog_clock/flutter_analog_clock.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
// This package provides LatLng class

bool isLoading = false;
class FullScreenImage extends StatelessWidget {
  final String imageUrl;
  final String countryName;

  const FullScreenImage({super.key, required this.imageUrl, required this.countryName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 227, 236, 236),
        foregroundColor: Colors.grey.shade700,
        title: Text(
          countryName,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: Center(
        child: GestureDetector(
          onTap: () {
            // Close the full-screen image view
            Navigator.pop(context);
          },
          child: Container(
                      width: 350,
                      height: 250,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 20,
                              color: Colors.grey.shade400,
                            )
                          ]),
                      child: ImageLoadingService(
                        imageUrl: imageUrl,
                        width: 40,
                        height: 40,
                        fit: BoxFit.fill,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    )
        ),
      ),
    );
  }
}

class CountryScreen extends StatefulWidget {
  final CountryEntity country;

  const CountryScreen({super.key, required this.country});

  @override
  State<CountryScreen> createState() => _CountryScreenState();
}

class _CountryScreenState extends State<CountryScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final time = calculateTimeFromTimeZoneOffset(widget.country.timezones![widget.country.timezones!.length -1 ]);
    final dateTime = DateTime.parse(time.toString());
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
           GestureDetector(
            onTap: () {
              // Open the full-screen image view
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FullScreenImage(countryName:widget.country.name!['common'] , imageUrl: widget.country.flags!['png']),
                ),
              );
            },
            child:  Padding(
            padding: const EdgeInsets.all(8.0),
            child: ImageLoadingService(
              imageUrl: widget.country.flags!['png'],
              width: 60,
              height: 40,
              fit: BoxFit.fill,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          ),
         
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 30, 15, 10),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 250,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(15),
                    // boxShadow: [
                    //   BoxShadow(
                    //     blurRadius: 20,
                    //     color: Colors.grey.shade400,
                    //   ),
                    // ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: FlutterMap(
                      options: MapOptions(
                        center: coordinates,
                        zoom: coordinates != null ? 3.5 : 0,
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
                                size: 30,
                                color: Colors.blue,
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
                height: 20,
              ),
              Center(
                child: Text(
                  'برای بررسی تغییر ساعت فصلی بر روی ساعت زیر کلیک کنید',
                  textDirection: TextDirection.rtl,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Colors.grey.shade400,
                        fontSize: 12,
                      ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 300,
                height: 150,
                child: InkWell(
                  borderRadius: BorderRadius.circular(300),
                  onTap: () async {
                    setState(() {
                      isLoading = true; // Show loading indicator
                    });
                    await _handleTap(context, time);
                    setState(() {
                      isLoading = false; // Hide loading indicator
                    });
                  },
                  child: Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      isLoading
                          ? CircularProgressIndicator(
                              color: Colors.blue.shade100,
                            )
                          : AnalogClock(
                              dateTime: dateTime,
                              isKeepTime: true,
                              dialColor: Colors.white,
                              dialBorderColor: Colors.black,
                              dialBorderWidthFactor: 0.02,
                              markingColor: Colors.black,
                              markingRadiusFactor: 1.0,
                              markingWidthFactor: 1.0,
                              hourNumberColor: Colors.black,
                              hourNumberSizeFactor: 1.0,
                              hourNumberRadiusFactor: 1.0,
                              hourHandColor: Colors.black,
                              hourHandWidthFactor: 1.0,
                              hourHandLengthFactor: 0.95,
                              minuteHandColor: Colors.black,
                              minuteHandWidthFactor: 1.0,
                              minuteHandLengthFactor: 1.0,
                              secondHandColor: Colors.black,
                              secondHandWidthFactor: 1.0,
                              secondHandLengthFactor: 1.0,
                              centerPointColor: Colors.black,
                              centerPointWidthFactor: 1.0,
                            ),
                    ],
                  )),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 30, 8, 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    rowItems(
                        'پایتخت',
                        widget.country.capital!.isNotEmpty ? widget.country.capital![0] : '--',
                        'زبان',
                        widget.country.languages != null ? 
                               widget.country.languages .toString()
                                .split(':')[1]
                                .replaceAll("}", '') :
                            '--'),
                    const SizedBox(
                      height: 20,
                    ),
                    rowItems(
                        'پیش شماره',
                        widget.country.idd!.isNotEmpty ? (widget.country.idd!['root'] +
                                widget.country.idd!['suffixes'][0]) :
                            '--',
                        'کد',
                        widget.country.cca2 ?? '--'),
                    const SizedBox(
                      height: 20,
                    ),
                    rowItems(
                      'واحد پول',
                      widget.country.currencies != null ? 
                             widget.country.currencies .toString()
                              .split('name')[0]
                              .replaceAll(":", "")
                              .replaceAll("}", '')
                              .replaceAll("{", '') :
                          '--',
                      'روز شروع هفته',
                      widget.country.startOfWeek ?? '--',
                    ),
                  ],
                ),
              )
            ],
          ),
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
              widget.country.latlng![0].toString() +
              '&lng=' +
              widget.country.latlng![1].toString());
      if (response.statusCode == 200) {
        // API call was successful, show a popup
        final timeDif = response.data['formatted'].toString().split(' ')[1];
        final int hourDif = int.parse(timeDif.split(':')[0]);
        final int currecntCountryHour =
            int.parse(time.split(':')[0].split(" ")[1]);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: hourDif - currecntCountryHour > 0
                  ? Text(
                      'میزان تغییر ساعت :‌ ' +
                          (hourDif - currecntCountryHour).toString(),
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      textDirection: TextDirection.rtl,
                    )
                  : const Text(''),
              content: hourDif - currecntCountryHour > 0
                  ? Text(
                      time.split(':').length > 1
                          ? 'ساعت فعلی    ' +
                              "${time.split(':')[1]} : ${hourDif}"
                          : '--',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      textDirection: TextDirection.rtl)
                  : Text('کشور مورد  نظر تغییر ساعتی ندارد',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      textDirection: TextDirection.rtl),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'بستن',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Icon(
                        CupertinoIcons.clear,
                        color: Colors.grey.shade600,
                        size: 10,
                      ),
                    ],
                  ),
                ),
              ],
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
        final latitude =
            widget.country.latlng![0]; // Example latitude
        final longitude =
            widget.country.latlng![1]; // Example longitude

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
          width: 120,
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
                        overflow: TextOverflow.ellipsis,
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
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          )),
    );
  }
}
