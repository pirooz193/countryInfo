import 'package:counries_info/common/exceptions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppErrorWidget extends StatelessWidget {
  final AppException exception;
  final GestureTapCallback onTap;
  final Widget image;
  const AppErrorWidget({
    Key? key,
    required this.exception,
    required this.onTap,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            image,
            Text(exception.message),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: onTap,
                child: Text(
                  'تلاش دوباره',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                      ),
                ))
          ]),
    );
  }
}