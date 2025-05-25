import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:math' as math;

import 'base.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool autoStartWorkout = BaseClass.settingsBox.get("autoStartWorkout", defaultValue: false);
  bool darkMode = BaseClass.settingsBox.get("darkMode", defaultValue: false);

  @override
  Widget build(BuildContext context) {
    BaseClass.init(context);

    return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),

      appBar: appBarDesign(),

      body: settingsBodyDesign(),
    );
  }

  PreferredSize appBarDesign() {
    return PreferredSize(
      preferredSize: Size.fromHeight(BaseClass.appBarHeight),
      /* Add shadow effect to app bar */
      child: AppBar(
        centerTitle: true,
        toolbarHeight: BaseClass.appBarHeight,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: const Color(0xFFE0E0E0), // Border color
            height: 1, // Border thickness
          ),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Transform.rotate(
              angle: math.pi,
              child: SvgPicture.asset(
                'images/back-icon.svg',
                height: 14,
              ),
            )),
        title: const Text(
          "Settings",
          style: TextStyle(
              color: Color(0xFF262626),
              fontSize: 18,
              fontWeight: FontWeight.w500
          ),
        ),
        backgroundColor: const Color(0xFFF8F8F8),
      ),
    );
  }

  ListView settingsBodyDesign() {
    return ListView(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF8F8F8),
            border: Border(
              bottom: BorderSide(
                color: Color(0xFFE0E0E0),  // Set the border color
                width: 1.0,          // Set the border width
              ),
            )
          ),
          child: ListTile(
            title: const Text(
                "Auto Start Workout",
                style: TextStyle(
                    color: Color(0xFF262626),
                    fontSize: 14
                )
            ),
            trailing: Transform.scale(
              scale: 0.8, // Adjust the scale
              child: Switch(
                inactiveTrackColor: const Color(0xFFF8F8F8),
                activeTrackColor: const Color(0xFF005EAA),
                value: autoStartWorkout,
                onChanged: (value) {
                  setState(() {
                    autoStartWorkout = value;
                    BaseClass.settingsBox.put('autoStartWorkout', value);
                  });
                },
              ),
            ),
          ),
        ),
        Container(
          decoration: const BoxDecoration(
              color: Color(0xFFF8F8F8),
              border: Border(
                bottom: BorderSide(
                  color: Color(0xFFE0E0E0),  // Set the border color
                  width: 1.0,          // Set the border width
                ),
              )
          ),
          child: ListTile(
            title: const Text(
                "Dark Mode",
                style: TextStyle(
                    color: Color(0xFF262626),
                    fontSize: 14
                )
            ),
            trailing: Transform.scale(
              scale: 0.8, // Adjust the scale
              child: Switch(
                inactiveTrackColor: const Color(0xFFF8F8F8),
                activeTrackColor: const Color(0xFF005EAA),
                value: darkMode,
                onChanged: (value) {
                  setState(() {
                    darkMode = value;
                    BaseClass.settingsBox.put('darkMode', darkMode);
                  });
                },
              ),
            ),
          ),
        ),
        Container(
          decoration: const BoxDecoration(
              color: Color(0xFFF8F8F8),
              border: Border(
                bottom: BorderSide(
                  color: Color(0xFFE0E0E0),  // Set the border color
                  width: 1.0,          // Set the border width
                ),
              )
          ),
          child: ListTile(
            title: const Text(
                'Clear All Settings',
                style: TextStyle(
                    color: Color(0xFF262626),
                    fontSize: 14
                )
            ),
            trailing: const Icon(Icons.delete),
            onTap: () {
              BaseClass.settingsBox.clear();
              setState(() {});
            },
          ),
        ),
      ],
    );
  }
}
