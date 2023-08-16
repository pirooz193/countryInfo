import 'package:counries_info/common/exceptions.dart';
import 'package:flutter/material.dart';

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
            Text(exception.message, textDirection: TextDirection.rtl,textAlign: TextAlign.center,),
            const SizedBox( 
              height: 10,
            ),
            Text('(دوست عزیز از اونجایی که در ایران زندگی می‌کنیم احتمال ایجاد تحریم وجود دارد. در صورتی که از اتصال اینترنت  خود مطمئن هستید، از تحریم شکن ها استفاده کنید و دوباره امتحان کنید.\nبا سپاس - برنامه ساعت جهانی  )', textDirection: TextDirection.rtl,textAlign: TextAlign.center,style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Colors.grey.shade500,
              fontSize: 12,
            ),),
            const SizedBox( 
              height: 10,
            ),
            ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade800,
                ),
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
