import '../../models/error.dart';
import 'package:rxdart/rxdart.dart';
import '../../models/medicine_type.dart';

class NewEntryBloc{
  BehaviorSubject<MedicineType>? _selectedMedicineType$;
  ValueStream<MedicineType>? get selectedMedicineType => _selectedMedicineType$!.stream;

  BehaviorSubject<int>? _selectedIntervals;
  BehaviorSubject<int>? get selectIntervals => _selectedIntervals;

  BehaviorSubject<String>? _selectedTimeOfDay$;
  BehaviorSubject<String>?  get selectedTimeOfDay$ => _selectedTimeOfDay$;

  BehaviorSubject<EntryError>? _errorState$;
  BehaviorSubject<EntryError>? get errorState$ => _errorState$;

  NewEntryBloc(){
    _selectedMedicineType$ = BehaviorSubject<MedicineType>.seeded(MedicineType.None);

    _selectedTimeOfDay$ = BehaviorSubject<String>.seeded('none');

    _selectedIntervals = BehaviorSubject<int>.seeded(0);
    _errorState$ = BehaviorSubject<EntryError>();
  }

  void dispose(){
    _selectedMedicineType$!.close();
    _selectedIntervals!.close();
    _selectedTimeOfDay$!.close();
  }

  void submitError(EntryError error){
    _errorState$!.add(error);
  }

  void updateInterval(int interval){
    _selectedIntervals!.add(interval);
  }


  void updateTime(String time){
    _selectedTimeOfDay$!.add(time);
  }


  void updateSelectedMedicine(MedicineType type){
    MedicineType _tempType = _selectedMedicineType$!.value;
    if (type == _tempType) {
      _selectedMedicineType$!.add(MedicineType.None);
    } else{
      _selectedMedicineType$!.add(type);
    }
  }
}
