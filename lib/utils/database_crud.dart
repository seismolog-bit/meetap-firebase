import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:meetap_firebase/utils/mahasiswa.dart';

class DatabaseCrud{
  DatabaseReference _counterRef;
  DatabaseReference _userRef;

  StreamSubscription<Event> _counterSubcription;
  StreamSubscription<Event> _messagesSubcription;

  FirebaseDatabase database= new FirebaseDatabase();
  
  int _counter;

  DatabaseError error;

  static final DatabaseCrud _instance = new DatabaseCrud.internal();

  DatabaseCrud.internal();

  factory DatabaseCrud(){
    return _instance;
  }

  void initState(){
    _counterRef = FirebaseDatabase.instance.reference().child('counter');
    _userRef = database.reference().child('user');

    database.reference().child('counter').once().then((DataSnapshot snapshot){
      print('Connect to second database and read ${snapshot.value}');
    });

    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);
    
    _counterRef.keepSynced(true);
    _counterSubcription = _counterRef.onValue.listen((Event event){
      error = null;
        _counter = event.snapshot.value?? 0;
    }, onError: (Object o){
        error = o;
    });
  }

  DatabaseError getError(){
    return error;
  }

  int getCounter(){
    return _counter;
  }

  DatabaseReference getUser(){
    return _userRef;
  }

  void dispose(){
    _messagesSubcription.cancel();
    _counterSubcription.cancel();
  }

  void deleteUser(Mahasiswa user) async{
    await _userRef.child(user.id).remove().then((_){
      print('Transaction committed.');
    });
  }

  addUser(Mahasiswa user) async{
    final TransactionResult transactionResult = await _counterRef.runTransaction((MutableData mutableData) async{
      mutableData.value = (mutableData.value ?? 0) + 1;
      return mutableData;
    });

    if(transactionResult.committed){
      _userRef.push().set(<String, dynamic>{
        'nama': ''+user.nama,
        'jeniskelamin': user.jenisKelamin,
        'umur': user.umur,
      }).then((_){
        print('Transaction committed.');
      });
    }else{
      print('transaction not committed.');
      if(transactionResult.error!= null){
        print(transactionResult.error.message);
      }
    }
  }

  void updateuser(Mahasiswa user) async{
    await _userRef.child(user.id).update({
      'nama': ''+ user.nama,
      'jeniskelamin': user.jenisKelamin,
      'umur': user.umur,
    }).then((_){
      print('Transaction committed.');
    });
  }
}

class JenisKelaminR{
  
  DatabaseReference _counterRef;
  DatabaseReference _userRef;

  StreamSubscription<Event> _counterSubcription;
  StreamSubscription<Event> _messagesSubcription;

  final FirebaseDatabase database= new FirebaseDatabase();

  int _counter;

  DatabaseError error;

  static final JenisKelaminR _instance = new JenisKelaminR.internal();

  JenisKelaminR.internal();

  factory JenisKelaminR(){
    return _instance;
  }

  void initState(){
    _counterRef = FirebaseDatabase.instance.reference().child('counter');
    _userRef = database.reference().child('jeniskelamin');

    database.reference().child('counter').once().then((DataSnapshot snapshot){
      print('Connect to second database and read ${snapshot.value}');
    });

    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);
    _counterRef.keepSynced(true);
    _counterSubcription = _counterRef.onValue.listen((Event event){
      error = null;
        _counter = event.snapshot.value?? 0;
    }, onError: (Object o){
        error = o;
    });
  }

  DatabaseError getError(){
    return error;
  }

  int getCounter(){
    return _counter;
  }

  DatabaseReference getUser(){
    return _userRef;
  }

  void dispose(){
    _messagesSubcription.cancel();
    _counterSubcription.cancel();
  }
}