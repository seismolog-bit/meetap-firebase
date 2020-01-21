import 'package:firebase_database/firebase_database.dart';

class Mahasiswa{
  String _id;
  String _nama;
  String _jenisKelamin;
  int _umur;

  Mahasiswa(this._id, this._nama, this._jenisKelamin, this._umur);

  String get id => _id;
  String get nama => _nama;
  String get jenisKelamin => _jenisKelamin;
  int get umur => _umur;

  Mahasiswa.fromSnapshot(DataSnapshot snapshot){
    _id = snapshot.key;
    _nama = snapshot.value['nama'];
    _jenisKelamin = snapshot.value['jeniskelamin'];
    _umur = snapshot.value['umur'];
  }
}