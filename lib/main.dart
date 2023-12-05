import 'package:flutter/material.dart';
import 'package:labtest/bmi.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'BMI Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController bmiController = TextEditingController();

  List<BMI> bmis = [];

  String _display = "";
  String _gender = "";

  _addBMI() async {
    if (_gender != "Female" && _gender != "Male") {
      Future.delayed(Duration.zero, () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid gender!'),
          ),
        );
      });
      return;
    }

    var bmi = BMI(fullNameController.text, double.parse(heightController.text),
        double.parse(weightController.text), _gender, "");

    var bmiValue = bmi.weight / bmi.height * bmi.height;

    setState(() {
      bmiController.text = bmiValue.toString();

      if (bmi.gender == "Female") {
        if (bmiValue < 18.5) {
          _display = "Underweight. Careful during strong wind!";
        } else if (bmiValue >= 18.5 && bmiValue < 25) {
          _display = "That’s ideal! Please maintain";
        } else if (bmiValue >= 25 && bmiValue < 30) {
          _display = "Overweight! Work out please";
        } else {
          _display = "Whoa Obese! Dangerous mate!";
        }
      } else {
        if (bmiValue < 16) {
          _display = "Underweight. Careful during strong wind!";
        } else if (bmiValue >= 16 && bmiValue < 22) {
          _display = "That’s ideal! Please maintain";
        } else if (bmiValue >= 22 && bmiValue < 27) {
          _display = "Overweight! Work out please";
        } else {
          _display = "Whoa Obese! Dangerous mate!";
        }
      }
    });

    bmi.status = _display;

    await bmi.save();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      bmis.addAll(await BMI.loadAll());

      if (bmis.isNotEmpty) {
        var bmi = bmis[bmis.length - 1];
        fullNameController.text = bmi.username;
        heightController.text = bmi.height.toString();
        weightController.text = bmi.weight.toString();
        setState(() {
          _gender = bmi.gender;
          _display = bmi.status;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(labelText: "Your Full Name"),
                  controller: fullNameController,
                ),
                TextField(
                  decoration: InputDecoration(labelText: "Height in cm; 170"),
                  controller: heightController,
                ),
                TextField(
                  decoration: InputDecoration(labelText: "Weight in KG"),
                  controller: weightController,
                ),
                TextField(
                  decoration: InputDecoration(labelText: "bmi value"),
                  controller: bmiController,
                  enabled: false,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text('Male'),
                        value: 'Male',
                        groupValue: _gender,
                        onChanged: (value) {
                          setState(() {
                            _gender = value!;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text('Female'),
                        value: 'Female',
                        groupValue: _gender,
                        onChanged: (value) {
                          setState(() {
                            _gender = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                    onPressed: () {
                      _addBMI();
                    },
                    child: Text("Caculate BMI and Save")),
                Text(
                  "$_display",
                  style: TextStyle(fontSize: 20),
                )
              ],
            ),
          ),
        ));
  }
}
