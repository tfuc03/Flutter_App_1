import 'package:flutter/material.dart';

class ConfigApp extends StatefulWidget {
  const ConfigApp({super.key});

  @override
  State<ConfigApp> createState() => _ConfigAppState();
}

class _ConfigAppState extends State<ConfigApp> {
  bool light = true;
  _setMau() => light ? Colors.blue : Colors.yellow;
  _setData() => light ? "Xanh" : "Vàng";
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: _setMau(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 200,
            height: 120,
            child: FittedBox(
              fit: BoxFit.fill,
              child: Switch(
                value: light,
                activeColor: Colors.red,
                onChanged: (bool value) {
                  // This is called when the user toggles the switch.
                  setState(() {
                    light = value;
                  });
                },
              ),
            ),
          ),
          Text(
            _setData(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              backgroundColor: Colors.white,
              color: _setMau(),
            ),
          ),
        ],
      ),
    );
  }
}
