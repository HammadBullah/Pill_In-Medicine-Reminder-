import 'dart:math';
import '../home_page.dart';
import '../success_screen.dart';
import '../../models/error.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common/convert_time.dart';
import '../../models/medicine_type.dart';
import 'package:pill_in/global_bloc.dart';
import 'package:pill_in/models/medicine.dart';
import 'package:pill_in/pages/new_entry/new_entry_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class NewEntryPage extends StatefulWidget {
  const NewEntryPage({super.key});

  @override
  State<NewEntryPage> createState() => _NewEntryPageState();
}

class _NewEntryPageState extends State<NewEntryPage> {
  late TextEditingController nameController;
  late TextEditingController dosageController;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  late NewEntryBloc _newEntryBloc;

  late GlobalKey<ScaffoldState> _scaffoldKey;

  String? selectedTimezone;
  

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    dosageController.dispose();
    _newEntryBloc.dispose();
  }

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    dosageController = TextEditingController();
    _newEntryBloc = NewEntryBloc();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin(); 
    _scaffoldKey = GlobalKey<ScaffoldState>();
    initializeNotifications();
    initializeErrorListen();
  }
  @override
  Widget build(BuildContext context) {
    final GlobalBloc globalBloc = Provider.of<GlobalBloc>(context);


    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Add New'),
      ),
      body: Provider<NewEntryBloc>.value(
        value: _newEntryBloc,
        child: Padding(
          padding: EdgeInsets.all(2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const PanelTitle(
                title: 'Medicine Name',
                isRequired: true,
              ),
              TextFormField(
                maxLength: 12,
                controller: nameController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(border: UnderlineInputBorder()),
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(color: const Color.fromARGB(255, 19, 84, 128)),
              ),
              const PanelTitle(
                title: 'Dosage in mg',
                isRequired: false,
              ),
              TextFormField(
                maxLength: 12,
                controller: dosageController,
                textCapitalization: TextCapitalization.words,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(border: UnderlineInputBorder()),
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(color: const Color.fromARGB(255, 19, 84, 128)),
              ),
              SizedBox(
                height: 2.h,
              ),
              const PanelTitle(title: 'Medicine Type', isRequired: false),
              Padding(
                padding: EdgeInsets.only(top: 1.h),
                child: StreamBuilder<MedicineType>(
                  stream: _newEntryBloc.selectedMedicineType,
                  builder: (context, snapshot) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MedicineTypeColumn(
                          medicineType: MedicineType.Bottle,
                          name: 'Bottle',
                          iconValue: 'assests/icons/bottle.svg',
                          isSelected: snapshot.data == MedicineType.Bottle
                              ? true
                              : false),
                      MedicineTypeColumn(
                          medicineType: MedicineType.Pill,
                          name: 'Pill',
                          iconValue: 'assests/icons/pill.svg',
                          isSelected:
                              snapshot.data == MedicineType.Pill ? true : false),
                      MedicineTypeColumn(
                          medicineType: MedicineType.Syringe,
                          name: 'Syringe',
                          iconValue: 'assests/icons/syringe.svg',
                          isSelected: snapshot.data == MedicineType.Syringe
                              ? true
                              : false),
                      MedicineTypeColumn(
                          medicineType: MedicineType.Tablet,
                          name: 'Tablet',
                          iconValue: 'assests/icons/tablet.svg',
                          isSelected: snapshot.data == MedicineType.Tablet
                              ? true
                              : false),
                    ],
                  );
                }),
              ),
              const PanelTitle(title: 'Interval Selection', isRequired: true),
              const IntervalSelection(),
              const PanelTitle(title: 'Starting Time', isRequired: true),
              const SelectTime(),
              Padding(
                padding: EdgeInsets.only(
                  top: 2.h,
                  left: 8.w,
                  right: 8.w,
                ),
                child: SizedBox(
                  width: 80.w,
                  height: 9.h,
                  
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 229, 95, 95),
                      shape: const StadiumBorder(),
                      
                    ),
                    child: Center(
                      child: Text(
                        'Confirm',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              color: Colors.white,
                            ),
                      ),
                    ),
                    onPressed: () async {

                     String? medicineName;
                     int? dosage;
                     if(nameController.text == ""){
                      _newEntryBloc.submitError(EntryError.nameNull);
                      return;
                     }
                     if(nameController.text != ""){
                      medicineName = nameController.text;
                     }
                     if(dosageController.text == ""){
                      dosage = 0;
                      return;
                     }
                     if(dosageController.text != ""){
                      dosage = int.parse(dosageController.text);
                     }
                     for(var medicine in globalBloc.medicineList$!.value){
                      if(medicineName == medicine.medicineName){
                        _newEntryBloc.submitError(EntryError.nameDuplicate);
                        return;
                      }
                     }
                     if(_newEntryBloc.selectIntervals!.value == 0){
                      _newEntryBloc.submitError(EntryError.interval);
                      return;
                     }
                     if(_newEntryBloc.selectedTimeOfDay$!.value == 'None'){
                      _newEntryBloc.submitError(EntryError.startTime);
                      return;
                     }
                     String medicineType = _newEntryBloc.selectedMedicineType!.value.toString().substring(13);

                     int interval = _newEntryBloc.selectIntervals!.value;

                     String startTime = _newEntryBloc.selectedTimeOfDay$!.value;

                     List<int> intIDs = makeIDs(
                      24 / _newEntryBloc.selectIntervals!.value
                     );
                     List<String> notificationIDs = intIDs.map((i)=> i.toString()).toList();

                     Medicine newEntryMedicine = Medicine(
                      notificationIDs: notificationIDs,
                      medicineType: medicineType,
                      dosage: dosage,
                      medicineName: medicineName,
                      interval: interval,
                      startTime: startTime,
                     );
                     await globalBloc.updateMedicineList(newEntryMedicine);
                     scheduleNotification(newEntryMedicine);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const SuccessScreen()));
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void initializeErrorListen(){
    _newEntryBloc.errorState$!.listen((EntryError error) {
      switch(error){
        case EntryError.nameNull: displayError("Please enter the medicine's name");
        break;
        case EntryError.nameDuplicate:
        displayError("Medicine name already exists");
        break;
        case EntryError.dosage:
        displayError("Please enter the dosage required");
        break;
        case EntryError.type:
        displayError("Please select the medicine type");
        break;
        case EntryError.interval:
        displayError("Please select the reminder's interval");
        break;
        case EntryError.startTime:
        displayError("Please select the reminder's starting time");
        break;

      }
     });
  }

  void displayError(String error){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error),
      duration: const Duration(milliseconds: 2000),
      ),
    );
  }

  List<int> makeIDs(double n){
    var rng = Random();
    List<int> ids = [];
    for(int i=0;i<n;i++){
      ids.add(rng.nextInt(1000000000));
    }
    return ids;
  }

  initializeNotifications() async {
    AndroidInitializationSettings androidSettings =
       const AndroidInitializationSettings('@mipmap/launcher_icon');

    IOSInitializationSettings iosSettings = const IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true
    );
    InitializationSettings initializationSettings = InitializationSettings(
        android: androidSettings, iOS: iosSettings);

    bool? initialized = await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  }

  Future onSelectNotification(String? payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => const HomePage()));
  }

 Future<void> scheduleNotification(Medicine medicine) async{
    AndroidNotificationDetails androidDetails = const 
    AndroidNotificationDetails(
      "'repeatDailyAtTime channel id", 
      "repeatDailyAtTime channel name",
        importance: Importance.max,
        ledColor: Color.fromARGB(255, 3, 80, 144),
        ledOffMs: 1000,
        ledOnMs: 1000,
        enableLights: true);

      IOSNotificationDetails iosDetails = const
      IOSNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      NotificationDetails notiDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );
       var hour = int.parse(medicine.startTime![0] + medicine.startTime![1]);
    var ogValue = hour;
    var minute = int.parse(medicine.startTime![2] + medicine.startTime![3]);

    for (int i = 0; i < (24 / medicine.interval!).floor(); i++) {
      if (hour + (medicine.interval! * i) > 23) {
        hour = hour + (medicine.interval! * i) - 24;
      } else {
        hour = hour + (medicine.interval! * i);
      }
      // ignore: deprecated_member_use
      await flutterLocalNotificationsPlugin.showDailyAtTime(
        int.parse(medicine.notificationIDs![i]),
          'Reminder: ${medicine.medicineName}',
          medicine.medicineType.toString() != MedicineType.None.toString()
              ? 'It is time to take your ${medicine.medicineType!.toLowerCase()}, according to schedule'
              : 'It is time to take your medicine, according to schedule',
              Time(hour,minute,0),
              notiDetails
              );
      hour = ogValue;
    }
  }
 }

class SelectTime extends StatefulWidget {
  const SelectTime({super.key});

  @override
  State<SelectTime> createState() => _SelectTimeState();
}

class _SelectTimeState extends State<SelectTime> {
  TimeOfDay _time = const TimeOfDay(hour: 0, minute: 00);
  bool _clicked = false;

  Future<TimeOfDay?> _selectTime() async {
    final NewEntryBloc newEntryBloc = Provider.of<NewEntryBloc>(context, listen: false);


    final TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: _time);

    if (picked != null && picked != _time) {
      setState(() {
        _time = picked;
        _clicked = true;

        newEntryBloc.updateTime(convertTime(_time.hour.toString()) +
        convertTime(_time.minute.toString()));
      });
    }
    return picked;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 9.h,
      child: Padding(
        padding: EdgeInsets.only(top: 2.h),
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 9, 152, 184),
            shape: const StadiumBorder(),
          ),
          onPressed: () {
            _selectTime();
          },
          child: Center(
            child: Text(
              _clicked == false
                  ? "Select Time"
                  : "${convertTime(_time.hour.toString())}:${convertTime(_time.minute.toString())}",
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Colors.white,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}

class IntervalSelection extends StatefulWidget {
  const IntervalSelection({super.key});

  @override
  State<IntervalSelection> createState() => _IntervalSelectionState();
}

class _IntervalSelectionState extends State<IntervalSelection> {
  final _intervals = [6, 8, 12, 24];
  var _selected = 0;

  @override
  Widget build(BuildContext context) {
    final NewEntryBloc newEntryBloc = Provider.of<NewEntryBloc>(context);
    return Padding(
      padding: EdgeInsets.only(top: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Remind me every',
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
              color: Colors.black,
            ),
          ),
          DropdownButton(
            iconEnabledColor: const Color.fromARGB(255, 9, 152, 184),
            dropdownColor: const Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.circular(2.h),
            itemHeight: 6.h,
            hint: _selected == 0
                ? Text(
                    'Select an Interval',
                    style: Theme.of(context).textTheme.bodySmall,
                  )
                : null,
            elevation: 2,
            value: _selected == 0 ? null : _selected,
            items: _intervals.map(
              (int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(
                    value.toString(),
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color:const Color.fromARGB(255, 229, 95, 95),
                        ),
                  ),
                );
              },
            ).toList(),
            onChanged: (newVal) {
              setState(
                () {
                  _selected = newVal!;
                  newEntryBloc.updateInterval(newVal);
                },
              );
            },
          ),
          Text(
            _selected == 1 ? "hour" : "hours",
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class MedicineTypeColumn extends StatelessWidget {
  const MedicineTypeColumn(
      {super.key,
      required this.medicineType,
      required this.name,
      required this.iconValue,
      required this.isSelected});
  final MedicineType medicineType;
  final String name;
  final String iconValue;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final NewEntryBloc newEntryBloc = Provider.of<NewEntryBloc>(context);
    return GestureDetector(
      onTap: () {

        newEntryBloc.updateSelectedMedicine(medicineType);

      },
      child: Column(
        children: [
          Container(
            width: 20.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 227, 227, 227),
                blurRadius: 0.4.h,
                spreadRadius: 1,
                ),
              ],
              borderRadius: BorderRadius.circular(3.h),
              color: isSelected
                  ? const Color.fromARGB(255, 9, 152, 184)
                  : const Color.fromARGB(255, 243, 243, 243),
            ),
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(
                  top: 1.h,
                  bottom: 1.h,
                ),
                child: SvgPicture.asset(
                  iconValue,
                  height: 7.h,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 1.h),
            child: Container(
              width: 20.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color.fromARGB(255, 9, 152, 184)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  name,
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: isSelected
                            ? Colors.white
                            : const Color.fromARGB(255, 9, 152, 184),
                      ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class PanelTitle extends StatelessWidget {
  const PanelTitle({super.key, required this.title, required this.isRequired});
  final String title;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 2.h),
      child: Text.rich(
        TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: title,
              style: Theme.of(context).textTheme.labelMedium,
            ),
            TextSpan(
              text: isRequired ? '*' : "",
              style: Theme.of(context)
                  .textTheme
                  .labelMedium!
                  .copyWith(color: const Color.fromARGB(255, 10, 43, 103)),
            ),
          ],
        ),
      ),
    );
  }
}
