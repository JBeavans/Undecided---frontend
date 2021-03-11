import 'package:flutter/material.dart';
import 'package:test_app/Screens/Welcome/welcome.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 112,
        title: Text(
          'Rally',
          style: TextStyle(
              color: Color(0xFF000000),
              fontSize: 32,
              fontWeight: FontWeight.w700,
              fontFamily: 'Rufina'),
        ),
        elevation: 1,
      ),
      body: SettingsOptions(),
      backgroundColor: Colors.white,
    );
  }
}

class SettingsOptions extends StatefulWidget {
  @override
  _SettingsOptionsState createState() => _SettingsOptionsState();
}

class _SettingsOptionsState extends State<SettingsOptions> {
  // final List<Widget> settingsList = new List(15);
  // settingsList[0] = Divider(thickness: 18, color: Color(0xFFD8D5CF),);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          automaticallyImplyLeading: false,
          centerTitle: false,
          pinned: true,
          title: Text(
            "Settings",
            style: TextStyle(
                color: Color(0xFF000000),
                fontSize: 24,
                fontWeight: FontWeight.w400,
                fontFamily: 'Rufina'),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            <Widget>[
              headerTile("Account"),
              subTile("Username"),
              div(),
              subTile("Location"),
              div(),
              subTile('Security'),
              div(),
              subTile('Notifications'),
              headerTile('Display and Sound'),
              subTile('Contrast'),
              div(),
              subTile('Text Size'),
              div(),
              subTile('Dark Mode'),
              div(),
              subTile('Line Reader'),
              headerTile('Help'),
              subTile('Terms of Service'),
              div(),
              subTile('Community Guidelines'),
              div(),
              subTile('FAQ'),
              div(),
              subTile('Report A Bug'),
              div(),
              OutlinedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => Welcome()),
                        (route) => false);
                  },
                  child: Text(
                    "Log Out",
                    style: TextStyle(
                        color: Color(0xFF4C4C51),
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500),
                  )),
              Divider(thickness: 18, color: Color(0xFFD8D5CF)),
            ],
          ),
        ),
      ],
    ));
  }

  Widget headerTile(title) {
    return ListTile(
      title: Text(title,
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w500, fontFamily: 'Inter')),
      tileColor: Color(0xFFD8D5CF),
    );
  }

  Widget subTile(title) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.only(left: 0.5, right: 0.5),
      child: ListTile(
          title: Text(title,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Inter'))),
    );
  }

  Widget div() {
    return Divider(thickness: 6, color: Color(0xFFD8D5CF));
  }
}
