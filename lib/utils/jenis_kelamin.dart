import 'package:firebase_database/firebase_database.dart';

class MahasiswaJk{
  String _id;
  String _nama;

  MahasiswaJk(this._id, this._nama,);

  String get id => _id;
  String get nama => _nama;

  MahasiswaJk.fromSnapshot(DataSnapshot snapshot){
    _id = snapshot.key;
    _nama = snapshot.value['nama'];
  }
}