import 'dart:ui';

import 'package:counries_info/data/CountryEntity.dart';
import 'package:counries_info/repository/CountryRepository.dart';
import 'package:counries_info/ui/country/country.dart';
import 'package:counries_info/ui/home/bloc/home_bloc.dart';
import 'package:counries_info/widgets/error.dart';
import 'package:counries_info/widgets/image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:marquee/marquee.dart';

final lastSearche = [];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return BlocProvider(
      create: (context) {
        final homeBloc = HomeBloc(countryRepository);
        homeBloc.add(HomeStarted());
        return homeBloc;
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 227, 236, 236),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.only(bottom: 0, right: 10, left: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _TextFieldContent(controller: controller, themeData: themeData),
              _SearchHistory(themeData: themeData),
              Expanded(
                child: BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) {
                    if (state is HomeSuccess) {
                      final countries = state.countries;
                      if (countries.isEmpty) {
                        return Center(
                          child: Text(
                            "موردی یافت نشد",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Colors.grey.shade600,
                                ),
                          ),
                        );
                      } else if (countries.length < 195) {}
                      return RefreshIndicator(
                        onRefresh: () async {
                          setState(() {
                            BlocProvider.of<HomeBloc>(context)
                                .add(HomeScreenCountrySearch(controller.text));
                          });
                        },
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height - 150,
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: countries.length,
                            itemBuilder: (context, index) {
                              final currentCountry = countries[index];
                              final time = calculateTimeFromTimeZoneOffset(
                                  currentCountry.timezones![currentCountry.timezones!.length -1 ]);
                              return InkWell(
                                  borderRadius: BorderRadius.circular(20),
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => CountryScreen(
                                            country: currentCountry),
                                      ),
                                    );
                                  },
                                  child: _CountryItem(
                                      currentCountry: currentCountry,
                                      themeData: themeData,
                                      time: time));
                            },
                          ),
                        ),
                      );
                    } else if (state is HomeLoading) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/images/earth.svg',
                              width: 120,
                              height: 120,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              'در حال جستجوی کشورها ',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Colors.grey.shade600,
                                  ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            CircularProgressIndicator(
                              color: Colors.grey.shade500,
                            ),
                          ],
                        ),
                      );
                    } else if (state is HomeError) {
                      return Center(
                        child: AppErrorWidget(
                          image: SvgPicture.asset(
                            'assets/icons/serverError.svg',
                            width: 60,
                            height: 60,
                            color: Colors.black,
                          ),
                          exception: state.exception,
                          onTap: () {
                            BlocProvider.of<HomeBloc>(context)
                                .add(HomeScreenCountrySearch(controller.text));
                          },
                        ),
                      );
                    } else {
                      throw Exception('state is not supported');
                    }
                  },
                ),
              )
            ],
          ),
        )),
      ),
    );
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

class _CountryItem extends StatelessWidget {
  const _CountryItem({
    required this.currentCountry,
    required this.themeData,
    required this.time,
  });

  final CountryEntity currentCountry;
  final ThemeData themeData;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 20, 10, 15),
      child: Container(
        width: 40,
        height: 100,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                color: Colors.grey.shade400,
              )
            ]),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 15, 5),
          child: Row(
            children: [
              currentCountry.flags != null
                  ? Container(
                      width: 60,
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 20,
                              color: Colors.grey.shade500,
                            )
                          ]),
                      child: ImageLoadingService(
                        imageUrl: currentCountry.flags!['png'],
                        width: 40,
                        height: 40,
                        fit: BoxFit.fill,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    )
                  : SvgPicture.asset(
                      'assets/icons/serverError.svg',
                      width: 60,
                      height: 60,
                      color: Colors.black,
                    ),
              const SizedBox(
                width: 8,
              ),
              VerticalDivider(
                color: Colors.grey.shade400,
                indent: 10,
                endIndent: 10,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ignore: prefer_interpolation_to_compose_strings
                    Text(currentCountry.name!["common"] ?? 'noting',
                        overflow: TextOverflow.ellipsis,
                        style: themeData.textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.bold,
                        )),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      "کد : ${currentCountry.cca2!}",
                      style: themeData.textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                width: 15,
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
                      style: themeData.textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchHistory extends StatelessWidget {
  const _SearchHistory({
    required this.themeData,
  });

  final ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeSuccess) {
          final reversedList = state.lastSearches!.reversed.toSet().toList();
          if (reversedList.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 20,
                child:Marquee(
                      textDirection: TextDirection.ltr,
                      text:
                          ".برای اطلاع از تغییر ساعت فصلی هر کشور، وارد آن کشور شوید و بر روی  ساعت آن کشور ضربه بزنید",
                      style: themeData.textTheme.bodyMedium!.copyWith(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                      scrollAxis: Axis.horizontal,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      blankSpace: 10.0,
                      velocity: 25.0,
                      pauseAfterRound: const Duration(seconds: 1),
                      showFadingOnlyWhenScrolling: true,
                      fadingEdgeStartFraction: 0.05,
                      fadingEdgeEndFraction: 0.01,
                    ),
              ),
            );
          }
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 20,
                    child: Marquee(
                      textDirection: TextDirection.ltr,
                      text:
                          ".برای اطلاع از تغییر ساعت فصلی هر کشور، وارد آن کشور شوید و بر روی ساعت آن کشور ضربه بزنید",
                      style: themeData.textTheme.bodyMedium!.copyWith(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                      scrollAxis: Axis.horizontal,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      blankSpace: 10.0,
                      velocity: 25.0,
                      pauseAfterRound: const Duration(seconds: 1),
                      showFadingOnlyWhenScrolling: true,
                      fadingEdgeStartFraction: 0.05,
                      fadingEdgeEndFraction: 0.01,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  'جستجو های پیشین :‌',
                  style: themeData.textTheme.bodyMedium!.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: reversedList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 80,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(15),
                            onTap: () {
                              context.read<HomeBloc>().add(
                                  HomeScreenCountrySearch(reversedList[index]));
                            },
                            child: Center(
                              child: Text(
                                reversedList[index],
                                overflow: TextOverflow.fade,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                SizedBox(
                  width: 200,
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15),
                      onTap: () {
                        context.read<HomeBloc>().add(ClearSearchHistory());
                      },
                      child: Row(
                        children: [
                          Icon(
                            CupertinoIcons.trash,
                            size: 15,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            'پاک کردن تاریخچه ',
                            style: themeData.textTheme.bodySmall!.copyWith(
                              color: Colors.grey.shade500,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                state.countries.length < 250
                    ? Container(
                        width: 180,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors
                              .grey.shade300, // Set your desired color here
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(15),
                            splashColor: Colors.white,
                            onTap: () {
                              context
                                  .read<HomeBloc>()
                                  .add(HomeScreenCountrySearch(''));
                            },
                            child: Row(
                              children: [
                                Icon(
                                  CupertinoIcons.square_list,
                                  size: 15,
                                  color: Colors.grey.shade600,
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  'بازگشت به لیست اصلی',
                                  style:
                                      themeData.textTheme.bodySmall!.copyWith(
                                    color: Colors.grey.shade600,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          );
        } else if (state is HomeLoading) {
          return const SizedBox();
        } else {
          return Center(
            child: Text(
              "---",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade700,
                  ),
            ),
          );
        }
      },
    );
  }
}

class _TextFieldContent extends StatelessWidget {
  const _TextFieldContent({
    required this.controller,
    required this.themeData,
  });

  final TextEditingController controller;
  final ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (controller.text.isNotEmpty) {
          // Navigate back to PageB
          // Navigator.of(context).pop();
          controller.clear();
          context.read<HomeBloc>().add(HomeRefresh());
          return false; // Prevent default back button behavior
        }else 
        return true; // Allow default back button behavior
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 30, 0, 10),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                      topRight: Radius.circular(8),
                      bottomRight: Radius.circular(8)),
                ),
                child: Builder(
                  builder: (context) {
                    return Directionality(
                      textDirection: TextDirection.rtl,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: TextField(
                          selectionHeightStyle: BoxHeightStyle
                              .max, // Moves the selection handles above and below the text
                          selectionWidthStyle: BoxWidthStyle.tight,
                          cursorColor: Colors.grey.shade400,
                          cursorHeight: 25,
                          controller: controller,
                          onChanged: (value) {
                            final searchKeyword = value.trim();
                            if (searchKeyword.isEmpty) {
                              // Perform operation when searchKeyword is empty
                              context
                                  .read<HomeBloc>()
                                  .add(HomeScreenCountrySearch(''));
                            }
                          },
                          onSubmitted: (value) {
                            final searchKeyword = value.trim();
                            if (searchKeyword.isNotEmpty) {
                              context
                                  .read<HomeBloc>()
                                  .add(HomeScreenCountrySearch(searchKeyword));
                            }
                          },
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            labelText:
                                'نام کشور مورد نظر یا بخشی از آن را بنویسید ...',
                            labelStyle:
                                themeData.textTheme.bodyMedium!.copyWith(
                              color: Colors.grey.shade400,
                              fontSize: 11,
                            ),
                            border: InputBorder.none,
                            suffixIcon: GestureDetector(
                              onTap: () {
                                if (controller.text.isNotEmpty) {
                                  controller.clear(); // Clear the text field
                                  // context
                                  //     .read<HomeBloc>()
                                  //     .add(HomeScreenCountrySearch(''));
                                }
                              },
                              child: const Icon(Icons.clear),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 20,
                            ),
                          ),
                          textInputAction: TextInputAction.search,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Container(
              height: 50,
              width: 50,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                    topRight: Radius.circular(15),
                    bottomRight: Radius.circular(15)),
              ),
              child: BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  return InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      if (controller.text.isNotEmpty) {
                        context.read<HomeBloc>().add(
                            HomeScreenCountrySearch(controller.text));
                      }
                    },
                    child: Icon(
                      Icons.search,
                      color: Colors.blue.shade300,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
