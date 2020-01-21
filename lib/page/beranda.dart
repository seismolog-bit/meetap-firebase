import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meetap_firebase/page/add_dialog.dart';
import 'package:meetap_firebase/utils/database_crud.dart';
import 'package:meetap_firebase/utils/mahasiswa.dart';

class Beranda extends StatefulWidget {
  @override
  _BerandaState createState() => _BerandaState();
}

class _BerandaState extends State<Beranda> implements AddUserCallback{
  bool _anchorToBottom = false;
  DatabaseCrud databaseUtil = DatabaseCrud();
  DateTime currentBackPrest;

  void initState(){
    super.initState();
    databaseUtil.initState();
  }

  void dispose(){
    super.dispose();
    databaseUtil.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildTitle(BuildContext context){
      return InkWell(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Firebase Database', style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              )),
            ],
          ),
        ),
      );
    }

    List<Widget> _buildAction(){
      return <Widget>[
        IconButton(
          icon: Icon(Icons.exit_to_app, color: Colors.white,),
          onPressed: ()=> SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
        ),
      ];
    }

    return Scaffold(
      appBar: AppBar(
        title: _buildTitle(context),
        actions: _buildAction(),
      ),
      body: WillPopScope(
        child: firebaseAnimatedList(context),
        onWillPop: onWillPop,
      ),
      floatingActionButton: _buildFloating(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget firebaseAnimatedList(context){
    return FirebaseAnimatedList(
      key: ValueKey<bool> (_anchorToBottom),
      query: databaseUtil.getUser(),
      reverse: _anchorToBottom,
      sort: _anchorToBottom? (DataSnapshot a, DataSnapshot b)=> b.key.compareTo(a.key): null,
      itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index){
        return SizeTransition(
          sizeFactor: animation,
          child: showUser(snapshot),
        );
      },
    );
  }

  Future<bool> onWillPop(){
    DateTime now = DateTime.now();
    
    if (currentBackPrest == null || now.difference(currentBackPrest) > Duration(seconds: 2)) {
      currentBackPrest = now;
      Fluttertoast.showToast(msg: 'Tekan sekali lagi untuk keluar.');
      return Future.value(false);
    }

    return Future.value(true);
  }

  Widget _buildFloating(BuildContext context){
    return FloatingActionButton.extended(
      elevation: 4.0,
      icon: const Icon(Icons.add),
      label: const Text('Tambah Data'),
      onPressed: () => showEditWidget(null, false),
    );
  }

  Widget showUser(DataSnapshot res){
    Mahasiswa user = Mahasiswa.fromSnapshot(res);
    var item = Card(
      child: Container(
        child: Center(
          child: Row(
            children: <Widget>[
              CircleAvatar(
                radius: 25,
                child: Text(getShortName(user).toUpperCase(), style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold
                )),
                backgroundColor: const Color(0xFF20283e),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(user.nama, style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.lightBlueAccent
                      )),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: <Widget>[
                          Text(user.jenisKelamin, style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.lightBlueAccent
                          )),
                          Container(
                            margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                            decoration: BoxDecoration(
                              color: Colors.lightBlueAccent,
                              borderRadius: BorderRadius.circular(10)
                            ),
                            height: 8,
                            width: 8,
                          ),
                          Text(user.umur.toString()+' Tahun', style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.lightBlueAccent
                          ))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.edit, color: const Color(0xFF167F67),),
                    onPressed: ()=> showEditWidget(user, true),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_forever, color: const Color(0xFF167F67),),
                    onPressed: ()=> deleteUser(user),
                  )
                ],
              )
            ],
          ),
        ),
        padding: EdgeInsets.fromLTRB(10, 0.0, 0.0, 0.0),
      ),
    );

    return item;
  }

  String getShortName(Mahasiswa user){
    String shortName= '';
    if(user.nama.isNotEmpty){
      shortName = user.nama.substring(0, 2);
    }

    return shortName;
  }

  deleteUser (Mahasiswa user){
    setState(() {
      databaseUtil.deleteUser(user);
    });
  }

  showEditWidget(Mahasiswa user, bool isEdit){
    showDialog(
      context: context,
      builder: (BuildContext context)=> AddDialog(isEdit: isEdit, addUserCallback: this, user: user)
    );
  }

  void addUser(Mahasiswa user){
    setState(() {
      databaseUtil.addUser(user);
    });
  }

  void update(Mahasiswa user){
    setState(() {
      databaseUtil.updateuser(user);
    });
  }
}