import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
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
                ),
                headlineLarge: TextStyle(
                  fontSize: 48,
                  fontFamily: 'Jost',
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4E7DA9),
                )),
            scaffoldBackgroundColor: const Color(0xFFF5FCFF),
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
                selectedColor: Color(0xFFCCEDFF))),
        home: HomePage());
  }
}

class Option {
  bool isSelected = false;
  int days = 0;
  Option({required this.isSelected, required this.days});
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // constants
  static const String lastDay = "2022-06-10";

  // start and return dates for each break [start date (first day of no school), return date (first day of school)]
  Map offCampusDates = {
    'Winter break': ['2021-12-11', '2022-01-03'],
    'Spring break': ['2022-03-19', '2022-03-28'],
  };

  // on init
  @override
  void initState() {
    super.initState();
    calculateOptionDays();
  }

  // state
  int mealsPerDay = 3;
  double remainingBalance = 0.0;
  int additionalDays = 0;
  double dollarsPerDay = 0.0;
  double dolalrsPerMeal = 0.0;
  int days = DateTime.parse(lastDay).difference(DateTime.now()).inDays +
      2; //+2 to include today and last day

  Map<String, Option> offCampusOptions = {
    'Winter break': Option(isSelected: false, days: 0),
    'Spring break': Option(isSelected: false, days: 0),
    'Saturdays': Option(isSelected: false, days: 0),
    'Sundays': Option(isSelected: false, days: 0),
  };

  // functions

  handleOffCampusOption(String option) {
    setState(() {
      offCampusOptions[option]!.isSelected =
          !offCampusOptions[option]!.isSelected;
    });
    updateDays(option);
    updateResults();
  }

  incrementDays() {
    setState(() {
      additionalDays++;
      days++;
    });
    updateResults();
  }

  decrementDays() {
    setState(() {
      additionalDays--;
      days--;
    });
    updateResults();
  }

  // calculates the number of days each option will subtract from the total when selected
  // updates the offCampusOptions map with the a day value
  calculateOptionDays() {
    for (var key in offCampusOptions.keys) {
      // if option is selected, subtract the days
      // handle breaks
      if (key.contains("break")) {
        print(offCampusDates[key][0]);
        DateTime breakBeginning = DateTime.parse(offCampusDates[key][0]);
        DateTime breakEnd = DateTime.parse(offCampusDates[key][1]);
        int difference = breakEnd.difference(breakBeginning).inDays;
        offCampusOptions[key]!.days = difference;
      }
      // handle saturdays and sundays
      else if (key.contains("Saturdays")) {
        offCampusOptions[key]!.days += countDays(
            DateTime.now(), DateTime.parse(lastDay), DateTime.saturday);
      } else if (key.contains("Sundays")) {
        offCampusOptions[key]!.days =
            countDays(DateTime.now(), DateTime.parse(lastDay), DateTime.sunday);
      }
    }
  }

  // updates the days variable based on which options are selected in the offCampusOptions map
  updateDays(String option) {
    if (offCampusOptions[option]!.isSelected) {
      setState(() {
        days -= offCampusOptions[option]!.days;
      });
    } else {
      setState(() {
        days += offCampusOptions[option]!.days;
      });
    }
  }

  // counts the number of a particular day of the week between two dates (inclusive)
  int countDays(DateTime start, DateTime end, int day) {
    int count = 0;
    while (start.isBefore(end)) {
      if (start.weekday == day) {
        count++;
      }
      start = start.add(const Duration(days: 1));
    }
    return count;
  }

  toggleMeals() {
    setState(() {
      mealsPerDay = mealsPerDay == 3 ? 2 : 3;
    });
    updateResults();
  }

  updateBalance(String newBalance) {
    // if newBalance can be parsed to double, update balance
    if (newBalance.isNotEmpty && double.tryParse(newBalance) != null) {
      setState(() {
        remainingBalance = double.parse(newBalance);
      });
    } else {
      setState(() {
        remainingBalance = 0.0;
      });
    }
    updateResults();
  }

  updateResults() {
    setState(() {
      dollarsPerDay = remainingBalance / days;
      dolalrsPerMeal = dollarsPerDay / mealsPerDay;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: (AppBar(
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColorLight,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Raccoon Ration',
                  style: TextStyle(
                      fontFamily: 'Merienda_One',
                      color: Theme.of(context).primaryColorDark)),
              Padding(
                padding: const EdgeInsets.only(top: 5, left: 2),
                child: Image.asset(
                  'assets/launcher/icon.png',
                  height: 30,
                  width: 30,
                ),
              )
            ],
          ))),
      body: Container(
        padding: const EdgeInsets.fromLTRB(25, 75, 25, 0),
        child: Form(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                    Widget>[
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
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
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium)),
                            Expanded(
                              flex: 4,
                              child: TextFormField(
                                onChanged: ((value) => updateBalance(value)),
                                enableInteractiveSelection: false,
                                cursorHeight: 0,
                                cursorWidth: 0,
                                decoration:
                                    const InputDecoration(hintText: '0.00'),
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp('^[0-9]{0,4}[.]?[0-9]{0,2}')),
                                ],
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                            ),
                            const Spacer(
                              flex: 1,
                            ),
                          ]),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 5),
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
                                  selected: offCampusOptions[offCampusOptions
                                          .keys
                                          .elementAt(index)]!
                                      .isSelected,
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
                        Text('$additionalDays',
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
                    )),
                  ]),
            ),
          ),
          Expanded(
              flex: 3,
              child: Center(
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                  color: Theme.of(context).primaryColorLight,
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: Column(children: [
                                Center(
                                  child: Text('Dollars per day',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall),
                                ),
                                Center(
                                  child: Text(
                                      '\$${dollarsPerDay.toStringAsFixed(2)}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineLarge),
                                ),
                              ]),
                              flex: 2),
                          Expanded(
                              flex: 2,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: [
                                      GestureDetector(
                                          onTap: () {
                                            toggleMeals();
                                          },
                                          child: Column(
                                            children: [
                                              Text('meal (${mealsPerDay})',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headlineSmall),
                                              Text(
                                                  '\$${dolalrsPerMeal.toStringAsFixed(2)}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headlineMedium
                                                      ?.copyWith(fontSize: 18)),
                                            ],
                                          )),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text('days',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall),
                                      Text(days.toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium
                                              ?.copyWith(fontSize: 18)),
                                    ],
                                  ),
                                ],
                              )),
                        ],
                      )),
                ),
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
