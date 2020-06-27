import 'package:budgetapp/widgets/index.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'index.dart';

class InputScreen extends StatefulWidget {
  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final _inputKey = GlobalKey<FormState>();
  SQLHelper sqlHelper = SQLHelper();

  List<Inputs> _inputs = [];
  List<String> typeList = getGroups();
  List<Icon> iconList = [
    Icon(Icons.add_shopping_cart, color: Colors.white),
    Icon(Icons.toys, color: Colors.white),
    Icon(Icons.games, color: Colors.white),
    Icon(Icons.monetization_on, color: Colors.white),
    Icon(Icons.phone_android, color: Colors.white),
    Icon(Icons.lightbulb_outline, color: Colors.white),
    Icon(Icons.wifi, color: Colors.white),
    Icon(Icons.account_balance, color: Colors.white),
  ];
  Color canvasColor, accentColor;

  int _selected;
  double _money;
  String _name;
  String _date;

  void _inputNewStuff(List<Inputs> newStuff) async {
    for (Inputs p in newStuff) {
      await sqlHelper.insertRecord(p.date, p.type, p.name, p.group, p.amount);
    }
    await sqlHelper.updateOverflow(newStuff);
  }

  BoxDecoration selected(int index) {
    if (_selected == index) {
      return BoxDecoration(
        border: Border.all(width: 3.0, color: Color(0xFF38565E)),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      );
    } else {
      return BoxDecoration(
        border: Border.all(width: 3.0, color: Colors.grey),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    canvasColor = Theme.of(context).canvasColor;
    accentColor = Theme.of(context).accentColor;
    String date = Jiffy().format("dd/MM/yyy");
    _date = Jiffy().format("yyyy-MM-dd");
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Image(
            image: AssetImage('assets/schnozer.gif'),
            fit: BoxFit.cover,
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: SizedBox(
              width: double.infinity,
              height: 50,
            ),
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            'Inputs',
            style: Theme.of(context).textTheme.headline,
          ),
        ),
        drawer: hamborgerTime(context),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Text('Incomes', style: TextStyle(fontSize: 20.0)),
                          ),
                          IncomeList(_inputs),
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Ink(
                              decoration: ShapeDecoration(
                                color: accentColor,
                                shape: CircleBorder(),
                              ),
                              child: IconButton(
                                icon: Icon(Icons.add),
                                color: Colors.white,
                                onPressed: () {
                                  setState(() {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text("New Income",
                                                style: Theme.of(context).textTheme.headline),
                                            contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(Radius.circular(32.0))),
                                            content: StatefulBuilder(
                                              builder: (BuildContext bcontext, StateSetter setDialogState) {
                                                return Container(
                                                  height: SizeConfig.safeBlockVertical * 30.3,
                                                  width: double.maxFinite,
                                                  child: Form(
                                                    key: _inputKey,
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: <Widget>[
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8),
                                                          child: Row(
                                                            children: <Widget>[
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets.fromLTRB(0, 0, 8, 0),
                                                                child: Text("Name",
                                                                    style: Theme.of(context)
                                                                        .textTheme
                                                                        .body1
                                                                        .copyWith(color: canvasColor)),
                                                              ),
                                                              Expanded(
                                                                child: Container(
                                                                  height: 80,
                                                                  child: Center(
                                                                    child: TextFormField(
                                                                      style: Theme.of(context)
                                                                          .textTheme
                                                                          .body1
                                                                          .copyWith(color: canvasColor),
                                                                      keyboardType: TextInputType.text,
                                                                      decoration: InputDecoration(
                                                                          isDense: true,
                                                                          focusedBorder: OutlineInputBorder(
                                                                              borderRadius:
                                                                                  BorderRadius.circular(
                                                                                      16.0)),
                                                                          border: OutlineInputBorder(
                                                                              borderRadius:
                                                                                  BorderRadius.circular(
                                                                                      16.0))),
                                                                      onSaved: (String value) {
                                                                        _name = value;
                                                                      },
                                                                      validator: (String value) {
                                                                        return value.isEmpty
                                                                            ? 'Please enter a name'
                                                                            : null;
                                                                      },
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8),
                                                          child: Row(
                                                            children: <Widget>[
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets.fromLTRB(0, 20, 0, 8),
                                                                child: Center(
                                                                  child: RaisedButton(
                                                                    padding: EdgeInsets.all(8),
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.all(
                                                                            Radius.circular(8.0))),
                                                                    color: accentColor,
                                                                    child: Text(
                                                                      date,
                                                                      style:
                                                                          Theme.of(context).textTheme.body1,
                                                                    ),
                                                                    onPressed: () async {
                                                                      var datePicked = await DatePicker
                                                                          .showSimpleDatePicker(
                                                                        context,
                                                                        initialDate: DateTime.now(),
                                                                        firstDate: DateTime(2017),
                                                                        lastDate: DateTime(2021),
                                                                        dateFormat: "dd-MMM-yyyy",
                                                                        locale: DateTimePickerLocale.en_us,
                                                                        looping: false,
                                                                      );
                                                                      setDialogState(() {
                                                                        _date = Jiffy(datePicked)
                                                                            .format("yyyy-MM-dd");
                                                                        date = Jiffy(datePicked)
                                                                            .format("dd/MM/yyy");
                                                                      });
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets.fromLTRB(20, 0, 8, 0),
                                                                child: Text("Amt.",
                                                                    style: Theme.of(context)
                                                                        .textTheme
                                                                        .body1
                                                                        .copyWith(color: canvasColor)),
                                                              ),
                                                              Expanded(
                                                                child: Container(
                                                                  height: 80,
                                                                  child: Center(
                                                                    child: TextFormField(
                                                                      style: Theme.of(context)
                                                                          .textTheme
                                                                          .body1
                                                                          .copyWith(color: canvasColor),
                                                                      keyboardType:
                                                                          TextInputType.numberWithOptions(
                                                                              decimal: true),
                                                                      decoration: InputDecoration(
                                                                          isDense: true,
                                                                          focusedBorder: OutlineInputBorder(
                                                                              borderRadius:
                                                                                  BorderRadius.circular(
                                                                                      16.0)),
                                                                          border: OutlineInputBorder(
                                                                              borderRadius:
                                                                                  BorderRadius.circular(
                                                                                      16.0))),
                                                                      onSaved: (String value) {
                                                                        _money = double.parse(value);
                                                                      },
                                                                      validator: (String value) {
                                                                        return value.isEmpty
                                                                            ? 'Please enter an amount'
                                                                            : null;
                                                                      },
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            if (_inputKey.currentState.validate()) {
                                                              _inputKey.currentState.save();

                                                              setState(() {
                                                                _inputs.add(
                                                                    new Inputs.income(_money, _name, _date));
                                                              });
                                                              Navigator.pop(context, true);
                                                            }
                                                          },
                                                          child: Container(
                                                            padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                                                            decoration: BoxDecoration(
                                                              color: accentColor,
                                                              borderRadius: BorderRadius.only(
                                                                  bottomLeft: Radius.circular(32.0),
                                                                  bottomRight: Radius.circular(32.0)),
                                                            ),
                                                            child: Text(
                                                              "Submit",
                                                              style: Theme.of(context).textTheme.body1,
                                                              textAlign: TextAlign.center,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          );
                                        });
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 8),
                      child: VerticalDivider(
                        width: 10,
                        thickness: 2,
                        color: Colors.grey,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Text('Expenses', style: TextStyle(fontSize: 20.0)),
                          ),
                          ExpenseList(_inputs),
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Ink(
                              decoration: ShapeDecoration(
                                color: accentColor,
                                shape: CircleBorder(),
                              ),
                              child: IconButton(
                                icon: Icon(Icons.add),
                                color: Colors.white,
                                onPressed: () {
                                  setState(() {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text("New Expense",
                                                style: Theme.of(context).textTheme.headline),
                                            contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(Radius.circular(32.0))),
                                            content: StatefulBuilder(
                                              builder: (BuildContext bcontext, StateSetter setDialogState) {
                                                return Container(
                                                  height: SizeConfig.safeBlockVertical * 42.5,
                                                  width: double.maxFinite,
                                                  child: Form(
                                                    key: _inputKey,
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: <Widget>[
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8),
                                                          child: Row(
                                                            children: <Widget>[
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets.fromLTRB(0, 0, 8, 0),
                                                                child: Text("Name",
                                                                    style: Theme.of(context)
                                                                        .textTheme
                                                                        .body1
                                                                        .copyWith(color: canvasColor)),
                                                              ),
                                                              Expanded(
                                                                child: Container(
                                                                  height: 80,
                                                                  child: Center(
                                                                    child: TextFormField(
                                                                      style: Theme.of(context)
                                                                          .textTheme
                                                                          .body1
                                                                          .copyWith(color: canvasColor),
                                                                      keyboardType: TextInputType.text,
                                                                      decoration: InputDecoration(
                                                                          isDense: true,
                                                                          focusedBorder: OutlineInputBorder(
                                                                              borderRadius:
                                                                                  BorderRadius.circular(
                                                                                      16.0)),
                                                                          border: OutlineInputBorder(
                                                                              borderRadius:
                                                                                  BorderRadius.circular(
                                                                                      16.0))),
                                                                      onSaved: (String value) {
                                                                        _name = value;
                                                                      },
                                                                      validator: (String value) {
                                                                        return value.isEmpty
                                                                            ? 'Please enter a name'
                                                                            : null;
                                                                      },
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8),
                                                          child: Row(
                                                            children: <Widget>[
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets.fromLTRB(0, 20, 0, 8),
                                                                child: Center(
                                                                  child: RaisedButton(
                                                                    padding: EdgeInsets.all(8),
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.all(
                                                                            Radius.circular(8.0))),
                                                                    color: accentColor,
                                                                    child: Text(
                                                                      date,
                                                                      style:
                                                                          Theme.of(context).textTheme.body1,
                                                                    ),
                                                                    onPressed: () async {
                                                                      var datePicked = await DatePicker
                                                                          .showSimpleDatePicker(
                                                                        context,
                                                                        initialDate: DateTime.now(),
                                                                        firstDate: DateTime(2017),
                                                                        lastDate: DateTime(2021),
                                                                        dateFormat: "dd-MMM-yyyy",
                                                                        locale: DateTimePickerLocale.en_us,
                                                                        looping: false,
                                                                      );
                                                                      setDialogState(() {
                                                                        _date = Jiffy(datePicked)
                                                                            .format("yyyy-MM-dd");
                                                                        date = Jiffy(datePicked)
                                                                            .format("dd/MM/yyy");
                                                                      });
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets.fromLTRB(20, 0, 8, 0),
                                                                child: Text("Amt.",
                                                                    style: Theme.of(context)
                                                                        .textTheme
                                                                        .body1
                                                                        .copyWith(color: canvasColor)),
                                                              ),
                                                              Expanded(
                                                                child: Container(
                                                                  height: 80,
                                                                  child: Center(
                                                                    child: TextFormField(
                                                                      style: Theme.of(context)
                                                                          .textTheme
                                                                          .body1
                                                                          .copyWith(color: canvasColor),
                                                                      keyboardType:
                                                                          TextInputType.numberWithOptions(
                                                                              decimal: true),
                                                                      decoration: InputDecoration(
                                                                          isDense: true,
                                                                          focusedBorder: OutlineInputBorder(
                                                                              borderRadius:
                                                                                  BorderRadius.circular(
                                                                                      16.0)),
                                                                          border: OutlineInputBorder(
                                                                              borderRadius:
                                                                                  BorderRadius.circular(
                                                                                      16.0))),
                                                                      onSaved: (String value) {
                                                                        _money = double.parse(value);
                                                                      },
                                                                      validator: (String value) {
                                                                        return value.isEmpty
                                                                            ? 'Please enter an amount'
                                                                            : null;
                                                                      },
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: ListView.builder(
                                                            shrinkWrap: true,
                                                            padding: EdgeInsets.fromLTRB(0, 8, 8, 12),
                                                            scrollDirection: Axis.horizontal,
                                                            itemCount: 8,
                                                            itemBuilder: (BuildContext bContext, int index) {
                                                              return GestureDetector(
                                                                onTap: () {
                                                                  setDialogState(() {
                                                                    _selected = index;
                                                                  });
                                                                },
                                                                child: Container(
                                                                  decoration: selected(index),
                                                                  padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
                                                                  margin: EdgeInsets.only(left: 8),
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment.center,
                                                                    mainAxisSize: MainAxisSize.min,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment.center,
                                                                    children: <Widget>[
                                                                      Ink(
                                                                        width: 35,
                                                                        height: 35,
                                                                        decoration: ShapeDecoration(
                                                                          color: accentColor,
                                                                          shape: CircleBorder(),
                                                                        ),
                                                                        child: iconList[index],
                                                                      ),
                                                                      Text(
                                                                        typeList[index],
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .body1
                                                                            .copyWith(color: canvasColor),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            if (_inputKey.currentState.validate()) {
                                                              _inputKey.currentState.save();

                                                              setState(() {
                                                                _inputs.add(new Inputs.expense(_money, _name,
                                                                    getActualGroups()[_selected], _date));
                                                              });
                                                              Navigator.pop(context, true);
                                                            }
                                                          },
                                                          child: Container(
                                                            padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                                                            decoration: BoxDecoration(
                                                              color: accentColor,
                                                              borderRadius: BorderRadius.only(
                                                                  bottomLeft: Radius.circular(32.0),
                                                                  bottomRight: Radius.circular(32.0)),
                                                            ),
                                                            child: Text(
                                                              "Submit",
                                                              style: Theme.of(context).textTheme.body1,
                                                              textAlign: TextAlign.center,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          );
                                        });
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 8),
                child: Center(
                  child: RaisedButton(
                    padding: EdgeInsets.all(8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    color: accentColor,
                    child: Text(
                      'Update',
                      style: Theme.of(context).textTheme.body1,
                    ),
                    onPressed: () {
                      _inputNewStuff(_inputs);
                      Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ReportScreen()));
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
