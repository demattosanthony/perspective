import 'package:flutter/material.dart';

class ProfileListTile extends StatelessWidget {
  const ProfileListTile({Key key, this.icon, this.title, this.press}) : super(key: key);

  final String title;
  final IconData icon;
  final Function press;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: InkWell(
        onTap: press,
              child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 5,
          child: ListTile(
            leading: Icon(icon, color: Colors.blue),
            title: Text(
              title,
              style: TextStyle(fontSize: 18),
            ),
            trailing: Icon(Icons.arrow_right),
          ),
        ),
      ),
    );
  }
}
