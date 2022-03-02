import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Raccoon-Ration',
        color: const Color(0xFF4E7DA9),
        theme: ThemeData(
            primaryColorLight: const Color(0xFFCCEDFF),
            primaryColorDark: const Color(0xFF4E7DA9),
            textTheme: const TextTheme(
                headlineSmall: TextStyle(
                    fontSize: 16, fontFamily: 'Jost', color: Color(0xFFC5C5C5)),
                headlineMedium: TextStyle(
                  fontSize: 32,
                  fontFamily: 'Jost',
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4E7DA9),
                )),
            scaffoldBackgroundColor: const Color.fromARGB(255, 235, 249, 255),
            inputDecorationTheme: const InputDecorationTheme(
              isDense: true,
              hintStyle: TextStyle(
                fontSize: 32,
                fontFamily: 'Jost',
                fontWeight: FontWeight.bold,
                color: Color(0xFF4E7DA9),
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 0.0),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Color(0xFFC5C5C5))),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Color(0xFFC5C5C5))),
              labelStyle: TextStyle(
                  fontSize: 16, fontFamily: 'Jost', color: Color(0xFFC5C5C5)),
            ),
            chipTheme: const ChipThemeData(
                backgroundColor: Colors.white,
                shadowColor: Color(0xFF4E7DA9),
                elevation: 3,
                showCheckmark: false,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15))),
                labelPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                labelStyle: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Jost',
                  color: Color(0xFF4E7DA9),
                ),
                selectedColor: const Color(0xFFCCEDFF))),
        home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // state
  double remainingBalance = 0.0;
  int additionalDays = 0;
  double dollarsPerDay = 0.0;
  double dolalrsPerMeal = 0.0;
  int days = 0;

  Map offCampusOptions = {
    'Winter break': false,
    'Spring break': false,
    'Saturdays': false,
    'Sundays': false,
  };

  handleOffCampusOption(String option) {
    setState(() {
      offCampusOptions[option] = !offCampusOptions[option];
    });
    print(offCampusOptions);
  }

  incrementDays() {
    setState(() {
      days++;
    });
  }

  decrementDays() {
    setState(() {
      days--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (AppBar(
          backgroundColor: Theme.of(context).primaryColorLight,
          title: Text('Raccoon Ration',
              style: TextStyle(
                  fontFamily: 'Merienda_One',
                  color: Theme.of(context).primaryColorDark)))),
      body: Container(
        padding: const EdgeInsets.fromLTRB(50, 75, 50, 0),
        child: Form(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
              Text('Enter remaining balance',
                  style: Theme.of(context).textTheme.headlineSmall),
              Container(
                height: 50,
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                          child: Text('\$',
                              style:
                                  Theme.of(context).textTheme.headlineMedium)),
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          decoration: const InputDecoration(hintText: '0.00'),
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9]+[,.]{0,1}[0-9]*')),
                          ],
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),
                      Spacer(
                        flex: 1,
                      ),
                    ]),
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 5),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                child: Text('Time off campus',
                    style: Theme.of(context).textTheme.headlineSmall),
              ),
              Wrap(
                  direction: Axis.horizontal,
                  children: List.generate(
                      offCampusOptions.length,
                      (index) => OffCampusChip(
                            title: offCampusOptions.keys.elementAt(index),
                            selected: offCampusOptions[
                                offCampusOptions.keys.elementAt(index)],
                            onSelected: handleOffCampusOption,
                          ))),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                child: Text('Additional days',
                    style: Theme.of(context).textTheme.headlineSmall),
              ),
              Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                      onTap: () {
                        decrementDays();
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                        child: Icon(
                          Icons.remove_rounded,
                          color: Theme.of(context).primaryColorDark,
                          size: 30,
                        ),
                      )),
                  Text('${days}',
                      style: Theme.of(context).textTheme.headlineMedium),
                  GestureDetector(
                      onTap: () {
                        incrementDays();
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Icon(
                          Icons.add_rounded,
                          color: Theme.of(context).primaryColorDark,
                          size: 30,
                        ),
                      )),
                ],
              ))
            ])),
      ),
    );
  }
}

class OffCampusChip extends StatelessWidget {
  const OffCampusChip(
      {required this.title,
      required this.onSelected,
      required this.selected,
      Key? key})
      : super(key: key);

  final String title;
  final Function onSelected;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
        child: ChoiceChip(
            label: Text(title),
            selected: selected,
            onSelected: (val) {
              onSelected(title);
            }));
  }
}
