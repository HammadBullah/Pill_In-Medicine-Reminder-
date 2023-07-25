import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(2.h),
        child: Column(children: [
          const TopContainer(),
          SizedBox(
            height: 2.h,
          ),
          const Flexible(child: BottomContainer())
        ]),
      ),
      floatingActionButton: InkResponse(
        onTap: (){

        },
        child: SizedBox(
          width: 16.w,
          height: 7.h,
          child: Card(
            color: const Color.fromARGB(230, 14, 93, 133),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.h),
            ),
            child: Icon(
              Icons.add_outlined,
            size: 30.sp,
            color: const Color.fromARGB(255, 244, 244, 244)
          ),
          ),
        ),
      ),
    );
  }
}

class TopContainer extends StatelessWidget {
  const TopContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.only(
            bottom: 1.h,
          ),
          child: Text(
            'Worry less. \nLive Healthier.',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.only(
            bottom: 1.h,
          ),
          child: Text(
            'Welcome to Daily Dose',
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(
            top: 20.h,
            bottom: 1.h,
          ),
          child: Text('0', style: Theme.of(context).textTheme.headlineMedium),
        ),
      ],
    );
  }
}

class BottomContainer extends StatelessWidget {
  const BottomContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'No Medicine',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.displaySmall,
      ),
    );
  }
}
