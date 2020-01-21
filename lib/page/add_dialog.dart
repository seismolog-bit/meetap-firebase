import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:meetap_firebase/utils/database_crud.dart';
import 'package:meetap_firebase/utils/jenis_kelamin.dart';
import 'package:meetap_firebase/utils/mahasiswa.dart';

class AddDialog extends StatefulWidget {
  final Mahasiswa user;
  final bool isEdit;
  final AddUserCallback addUserCallback;
  AddDialog({this.user, this.isEdit, this.addUserCallback});
  @override
  _AddDialogState createState() => _AddDialogState();
}

class _AddDialogState extends State<AddDialog> {
  final teName = TextEditingController();
  final teUmur = TextEditingController();
  String jkValue = '';

  JenisKelaminR jenisKelamin;
  DatabaseReference databaseReference;
  
  final List<MahasiswaJk> itemJk= List();

  void initState(){
    super.initState();
    
    if(widget.user != null){
      jkValue = widget.user.jenisKelamin;
      teName.text = widget.user.nama;
      teUmur.text = widget.user.umur.toString();
    }

    final FirebaseDatabase database = FirebaseDatabase.instance;
    databaseReference = database.reference().child('jeniskelamin');
    databaseReference.onChildAdded.listen(entryAddJenisKelamin);
  }

  entryAddJenisKelamin(Event event) {
    setState(() {
      itemJk.add(MahasiswaJk.fromSnapshot(event.snapshot));
    });
  }


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        primary: false,
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            getTextField('Nama', teName),
            getTextField('Umur', teUmur),
            SizedBox(height: 5),
            Text('Jenis Kelamin'),
            buildRadio(),
            GestureDetector(
              onTap: ()=> onTap(widget.isEdit, widget.addUserCallback, context),
              child: getAppBorderButton(widget.isEdit? 'Edit': 'Add', EdgeInsets.fromLTRB(0, 10.0, 0, 0)),
            )
          ],
        ),
      )
    );
  }

  Widget getTextField(String inputBoxName, TextEditingController inputBoxController){
    var loginBtn = Padding(
      padding: const EdgeInsets.all(5.0),
      child: TextFormField(
        controller: inputBoxController,
        decoration: InputDecoration(
          hintText: inputBoxName
        ),
      ),
    );

    return loginBtn;
  }

  Widget buildRadio(){
    return Column(
      children: itemJk.map((data)=> RadioListTile(
        title: Text(data.nama),
        value: data.nama,
        dense: true,
        onChanged: (value){
          setState(()=> jkValue = value);
        }, 
        groupValue: jkValue,
      )).toList(),
    );
  }

  Widget showJenisKelamin(DataSnapshot res){
    MahasiswaJk mJk = MahasiswaJk.fromSnapshot(res);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        RadioListTile(
          title: Text(mJk.nama),
          value: mJk.nama,
          dense: true,
          onChanged: (value){
            setState(()=> jkValue = value);
          },
          groupValue: jkValue,
        ),
      ],
    );
  }

  Widget getAppBorderButton(String buttonLabel, EdgeInsets margin){
    var loginBtn= Container(
      margin: margin,
      padding: EdgeInsets.all(8.0),
      alignment: FractionalOffset.center,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF28324E)),
        borderRadius: BorderRadius.all(const Radius.circular(6.0))
      ),
      child: Text(buttonLabel, style: TextStyle(
        color: const Color(0xFF28324E),
        fontSize: 20.0,
        fontWeight: FontWeight.w300,
        letterSpacing: 0.3
      )),
    );

    return loginBtn;
  }

  Mahasiswa getData(bool isEdit){
    return Mahasiswa(isEdit? widget.user.id: '', teName.text, jkValue, int.parse(teUmur.text),);
  }

  onTap(bool isEdit, AddUserCallback _berandaState, BuildContext context){
    if(isEdit){
      _berandaState.update(getData(isEdit));
    }else{
      _berandaState.addUser(getData(isEdit));
    }

    Navigator.of(context).pop();
  }
}

abstract class AddUserCallback{
  void addUser(Mahasiswa user);
  void update(Mahasiswa user);
}