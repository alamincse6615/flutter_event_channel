import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),

        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      home: const BatteryLevelPage(),
    );
  }
}

class BatteryLevelPage extends StatefulWidget {
  const BatteryLevelPage({super.key});

  @override
  _BatteryLevelPageState createState() => _BatteryLevelPageState();
}

class _BatteryLevelPageState extends State<BatteryLevelPage> {
  static const EventChannel _batteryChannel = EventChannel('battery_channel');
  String _batteryStatus = 'ব্যাটারি তথ্য পাওয়া যাচ্ছে না।';
  int batteryLevel = 0;
  bool isCharging = false;
  @override
  void initState() {
    super.initState();
    _getBatteryStatus();
  }
  void _getBatteryStatus() {
    _batteryChannel.receiveBroadcastStream().listen((dynamic event) {
      setState(() {
        batteryLevel = event['batteryLevel'];
        isCharging = event['isCharging'];

        _batteryStatus = 'ব্যাটারি স্তর: $batteryLevel%\nচার্জ করা হচ্ছে: ${isCharging ? 'হ্যাঁ' : 'না'}';
      });
    }, onError: (dynamic error) {
      setState(() {
        _batteryStatus = 'ব্যাটারি তথ্য পাওয়া যাচ্ছে না: $error';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Event Channel Example'),centerTitle: true,),
      body: Center(child:AnimatedContainer(
        width: 300,
        height: 150,
        duration: Duration(milliseconds: 500),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: isCharging
                ? [Colors.greenAccent, Colors.green]
                : [Colors.redAccent, Colors.red],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: isCharging ? Colors.black26 : Colors.black54,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: Icon(
                isCharging ? Icons.battery_charging_full : Icons.battery_alert,
                size: 60,
                color: Colors.white,
                key: ValueKey<bool>(isCharging), // Unique key for animation
              ),
            ),
            Positioned(
              bottom: 10,
              child: Row(
                children: [
                  Text(
                    isCharging ? 'চার্জ হচ্ছে' : 'চার্জ হচ্ছে না',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 10,),
                  Text(
                    '$batteryLevel%',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                ],
              ),
            ),
            Positioned(
              top: 10,
              child: Text(
                'Battery Status',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
            ),
          ],
        ),
      ),),
    );
  }
}
