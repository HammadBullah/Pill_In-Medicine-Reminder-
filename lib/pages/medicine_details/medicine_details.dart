import '../../global_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../models/medicine.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class MedicineDetails extends StatefulWidget {
  const MedicineDetails(this.medicine, {super.key,});
  final Medicine medicine;

  @override
  State<MedicineDetails> createState() => _MedicineDetailsState();
}

class _MedicineDetailsState extends State<MedicineDetails> {

  @override
  Widget build(BuildContext context) {
    final GlobalBloc _globalBloc = Provider.of<GlobalBloc>(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color:  Color.fromARGB(255, 229, 95, 95),),
        title: const Text('Medicine Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(2.h),
        child: Column(
          children: [
            MainSection(medicine: widget.medicine,),
            ExtendedSection(medicine: widget.medicine,),
            const Spacer(),
            SizedBox(
              width: 100.w,
              height: 7.h,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 229, 95, 95),
                  shape: const StadiumBorder(),
                  elevation: 1.h.w,
                ),
                onPressed: () {
                  openAlertBox(context, _globalBloc);
                },
                child: Text(
                  'Delete',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
            SizedBox(
              height: 1.h,
            )
          ],
        ),
      ),
    );
  }

  openAlertBox(BuildContext context, GlobalBloc _globalBloc) {
    return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2.h),
          ),
          contentPadding: EdgeInsets.only(top: 1.h),
          title: Text('Do you want to delete it?',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
            color: const Color.fromARGB(230, 14, 93, 133),
            fontWeight: FontWeight.w600,
          ),),
          actions: [
            TextButton(
              onPressed: (){
                Navigator.of(context).pop();
              }, 
              child: Text('Cancel',
              style: Theme.of(context).textTheme.bodySmall,
              ),
              ),
              TextButton(
              onPressed: () async {

                await _globalBloc.removeMedicine(widget.medicine);
                Navigator.popUntil(context, ModalRoute.withName('/home'));
              }, 
              child: Text('Yes',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color:  const Color.fromARGB(255, 229, 95, 95),
              )
              ),
              ),
          ],
          );
      },
        );
      }
}

class MainSection extends StatelessWidget {
  const MainSection({super.key, this.medicine});
  final Medicine? medicine;
  Hero makeIcon(double size) {
    if (medicine!.medicineType == 'Bottle') {
      return Hero(
          tag: medicine!.medicineName! + medicine!.medicineType!,
          child: SvgPicture.asset('assests/icons/bottle.svg', height: 9.h));
    } else if (medicine!.medicineType == 'Pill') {
      return Hero(
          tag: medicine!.medicineName! + medicine!.medicineType!,
          child: SvgPicture.asset('assests/icons/pill.svg', height: 9.h));
    } else if (medicine!.medicineType == 'Syringe') {
      return Hero(
          tag: medicine!.medicineName! + medicine!.medicineType!,
          child: SvgPicture.asset('assests/icons/syringe.svg', height: 9.h));
    } else if (medicine!.medicineType == 'Tablet') {
      return Hero(
          tag: medicine!.medicineName! + medicine!.medicineType!,
          child: SvgPicture.asset('assests/icons/tablet.svg', height: 9.h));
    }
    return Hero(
      tag: medicine!.medicineName! + medicine!.medicineType!,
      child: Icon(
        Icons.error,
        color: Colors.black,
        size: size,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        makeIcon(7.h),
        SizedBox(width: 26.w),
        Column(
          children: [
            Hero(
              tag: medicine!.medicineName!,
              child: Material(
                color: Colors.transparent,
                child: MainInfoTab(
                  fieldTitle: 'Medicine Name',
                  fieldInfo: medicine!.medicineName!,
                ),
              ),
            ),
            MainInfoTab(
              fieldTitle: 'Dosage', 
              fieldInfo: medicine!.dosage == 0 ? 'Not Specified': 
              ("${medicine!.dosage} mg")),
          ],
        ),
      ],
    );
  }
}

class MainInfoTab extends StatelessWidget {
  const MainInfoTab(
      {super.key, required this.fieldTitle, required this.fieldInfo});

  final String fieldTitle;
  final String fieldInfo;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40.w,
      height: 10.h,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(fieldTitle, style: Theme.of(context).textTheme.titleSmall),
            SizedBox(
              height: 0.3.h,
            ),
            Text(fieldInfo, style: Theme.of(context).textTheme.headlineSmall)
          ],
        ),
      ),
    );
  }
}

class ExtendedSection extends StatelessWidget {
  const ExtendedSection({super.key, this.medicine});

  final Medicine? medicine;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children:  [
        ExtendedInfoTab(
          fieldInfo: medicine!.medicineType! == 'None' 
          ? 'NotSpecified': medicine!.medicineType!,
          fieldTitle: 'Medicine Type',
        ),
        ExtendedInfoTab(
          fieldInfo: 'Every ${medicine!.interval} hours | ${medicine!.interval == 24 ? "One time a day" : "${(24 / medicine!.interval!).floor()} times a day"}',
          fieldTitle: 'Dose Interval',
        ),
        ExtendedInfoTab(
          fieldInfo: '${medicine!.startTime![0]}${medicine!.startTime![1]}: ${medicine!.startTime![2]}${medicine!.startTime![3]}',
          fieldTitle: 'Start Time',
        ),
      ],
    );
  }
}

class ExtendedInfoTab extends StatelessWidget {
  const ExtendedInfoTab(
      {super.key, required this.fieldTitle, required this.fieldInfo});
  final String fieldTitle;
  final String fieldInfo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 1.h),
            child: Text(
              fieldTitle,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Colors.black,
                  ),
            ),
          ),
          Text(
            fieldInfo,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: const Color.fromARGB(255, 229, 95, 95),
                ),
          )
        ],
      ),
    );
  }
}
