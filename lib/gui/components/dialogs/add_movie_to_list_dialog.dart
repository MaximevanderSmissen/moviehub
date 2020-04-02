import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class AddMovieToListDialog extends StatefulWidget {
  @override
  _AddMovieToListDialogState createState() => _AddMovieToListDialogState();

  VoidCallback onSortChange;
  int movieId;

  AddMovieToListDialog({this.onSortChange, int movieId});

}

class _AddMovieToListDialogState extends State<AddMovieToListDialog> {


  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(3.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.only(
          top: 25,
          bottom: 10,
          left: 25,
          right: 15,
        ),
        decoration: new BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(5.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black26.withOpacity(0.3),
              blurRadius: 25.0,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Add movie to a list",
                style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF3e3e3e)),
              ),
            ),
            SizedBox(height: 16.0),
            Align(
              alignment: Alignment.bottomRight,
              child: FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Done"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}