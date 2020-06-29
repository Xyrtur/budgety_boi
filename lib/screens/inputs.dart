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

  double px16 = SizeConfig.safeBlockVertical * 1.8919;
  double px8 = SizeConfig.safeBlockVertical * 0.9459;
  double px20 = SizeConfig.safeBlockVertical * 2.3649;
  double px30 = SizeConfig.safeBlockVertical * 3.5473;
  double px32 = SizeConfig.safeBlockVertical * 3.7839;
  double px15 = SizeConfig.safeBlockVertical * 1.7736;
  double px80 = SizeConfig.safeBlockVertical * 9.4595;
  double px35 = SizeConfig.safeBlockVertical * 4.1385;
  double px12 = SizeConfig.safeBlockVertical * 1.4189;

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

    TextStyle bodyStyleCanvasColor =
        Theme.of(context).textTheme.body1.copyWith(color: canvasColor, fontSize: px20);

    TextStyle bodyStyleWhiteColor = Theme.of(context).textTheme.body1.copyWith(fontSize: px20);

    TextStyle headlineStyle = Theme.of(context).textTheme.headline.copyWith(fontSize: px30);

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
            style: headlineStyle,
          ),
        ),
        drawer: hamborgerTime(context),
        body: Padding(
          padding: EdgeInsets.all(px12),
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
                            padding: EdgeInsets.only(bottom: px12),
                            child: Text('Incomes', style: bodyStyleWhiteColor),
                          ),
                          IncomeList(_inputs),
                          Padding(
                            padding: EdgeInsets.only(top: px16),
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
                                            title: Text("New Income", style: headlineStyle),
                                            contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(Radius.circular(px32))),
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
                                                          padding: EdgeInsets.fromLTRB(px16, px16, px16, px8),
                                                          child: Row(
                                                            children: <Widget>[
                                                              Padding(
                                                                padding: EdgeInsets.fromLTRB(0, 0, px8, 0),
                                                                child:
                                                                    Text("Name", style: bodyStyleCanvasColor),
                                                              ),
                                                              Expanded(
                                                                child: Container(
                                                                  height: 80,
                                                                  child: Center(
                                                                    child: TextFormField(
                                                                      style: bodyStyleCanvasColor,
                                                                      keyboardType: TextInputType.text,
                                                                      decoration: InputDecoration(
                                                                          isDense: true,
                                                                          focusedBorder: OutlineInputBorder(
                                                                              borderRadius:
                                                                                  BorderRadius.circular(
                                                                                      px16)),
                                                                          border: OutlineInputBorder(
                                                                              borderRadius:
                                                                                  BorderRadius.circular(
                                                                                      px16))),
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
                                                          padding: EdgeInsets.fromLTRB(px16, px8, px16, px8),
                                                          child: Row(
                                                            children: <Widget>[
                                                              Padding(
                                                                padding: EdgeInsets.fromLTRB(0, px20, 0, px8),
                                                                child: Center(
                                                                  child: RaisedButton(
                                                                    padding: EdgeInsets.all(px8),
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.all(
                                                                            Radius.circular(px8))),
                                                                    color: accentColor,
                                                                    child: Text(
                                                                      date,
                                                                      style: bodyStyleWhiteColor,
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
                                                                padding: EdgeInsets.fromLTRB(px20, 0, px8, 0),
                                                                child:
                                                                    Text("Amt.", style: bodyStyleCanvasColor),
                                                              ),
                                                              Expanded(
                                                                child: Container(
                                                                  height: px80,
                                                                  child: Center(
                                                                    child: TextFormField(
                                                                      style: bodyStyleCanvasColor,
                                                                      keyboardType:
                                                                          TextInputType.numberWithOptions(
                                                                              decimal: true),
                                                                      decoration: InputDecoration(
                                                                          isDense: true,
                                                                          focusedBorder: OutlineInputBorder(
                                                                              borderRadius:
                                                                                  BorderRadius.circular(
                                                                                      px16)),
                                                                          border: OutlineInputBorder(
                                                                              borderRadius:
                                                                                  BorderRadius.circular(
                                                                                      px16))),
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
                                                            padding: EdgeInsets.only(top: px15, bottom: px15),
                                                            decoration: BoxDecoration(
                                                              color: accentColor,
                                                              borderRadius: BorderRadius.only(
                                                                  bottomLeft: Radius.circular(px32),
                                                                  bottomRight: Radius.circular(px32)),
                                                            ),
                                                            child: Text(
                                                              "Submit",
                                                              style: bodyStyleWhiteColor,
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
                      padding: EdgeInsets.fromLTRB(0, px8, 0, px8),
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
                            padding: EdgeInsets.only(bottom: px12),
                            child: Text('Expenses', style: TextStyle(fontSize: px20)),
                          ),
                          ExpenseList(_inputs),
                          Padding(
                            padding: EdgeInsets.only(top: px16),
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
                                            title: Text("New Expense", style: headlineStyle),
                                            contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(Radius.circular(px32))),
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
                                                          padding: EdgeInsets.fromLTRB(px16, px16, px16, px8),
                                                          child: Row(
                                                            children: <Widget>[
                                                              Padding(
                                                                padding: EdgeInsets.fromLTRB(0, 0, px8, 0),
                                                                child:
                                                                    Text("Name", style: bodyStyleCanvasColor),
                                                              ),
                                                              Expanded(
                                                                child: Container(
                                                                  height: px80, // 80px
                                                                  child: Center(
                                                                    child: TextFormField(
                                                                      style: bodyStyleCanvasColor,
                                                                      keyboardType: TextInputType.text,
                                                                      decoration: InputDecoration(
                                                                          isDense: true,
                                                                          focusedBorder: OutlineInputBorder(
                                                                              borderRadius:
                                                                                  BorderRadius.circular(
                                                                                      px16)),
                                                                          border: OutlineInputBorder(
                                                                              borderRadius:
                                                                                  BorderRadius.circular(
                                                                                      px16))),
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
                                                          padding: EdgeInsets.fromLTRB(px16, px8, px16, px8),
                                                          child: Row(
                                                            children: <Widget>[
                                                              Padding(
                                                                padding: EdgeInsets.fromLTRB(0, px20, 0, px8),
                                                                child: Center(
                                                                  child: RaisedButton(
                                                                    padding: EdgeInsets.all(px8),
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.all(
                                                                            Radius.circular(px8))),
                                                                    color: accentColor,
                                                                    child: Text(
                                                                      date,
                                                                      style: bodyStyleWhiteColor,
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
                                                                padding: EdgeInsets.fromLTRB(px20, 0, px8, 0),
                                                                child:
                                                                    Text("Amt.", style: bodyStyleCanvasColor),
                                                              ),
                                                              Expanded(
                                                                child: Container(
                                                                  height: px80,
                                                                  child: Center(
                                                                    child: TextFormField(
                                                                      style: bodyStyleCanvasColor,
                                                                      keyboardType:
                                                                          TextInputType.numberWithOptions(
                                                                              decimal: true),
                                                                      decoration: InputDecoration(
                                                                          isDense: true,
                                                                          focusedBorder: OutlineInputBorder(
                                                                              borderRadius:
                                                                                  BorderRadius.circular(
                                                                                      px16)),
                                                                          border: OutlineInputBorder(
                                                                              borderRadius:
                                                                                  BorderRadius.circular(
                                                                                      px16))),
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
                                                            padding: EdgeInsets.fromLTRB(0, px8, px8, px12),
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
                                                                  padding: EdgeInsets.fromLTRB(
                                                                      px12, px8, px12, px8),
                                                                  margin: EdgeInsets.only(left: px8),
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment.center,
                                                                    mainAxisSize: MainAxisSize.min,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment.center,
                                                                    children: <Widget>[
                                                                      Ink(
                                                                        width: px35,
                                                                        height: px35,
                                                                        decoration: ShapeDecoration(
                                                                          color: accentColor,
                                                                          shape: CircleBorder(),
                                                                        ),
                                                                        child: iconList[index],
                                                                      ),
                                                                      Text(
                                                                        typeList[index],
                                                                        style: bodyStyleCanvasColor,
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
                                                            padding: EdgeInsets.only(top: px15, bottom: px15),
                                                            decoration: BoxDecoration(
                                                              color: accentColor,
                                                              borderRadius: BorderRadius.only(
                                                                  bottomLeft: Radius.circular(px32),
                                                                  bottomRight: Radius.circular(px32)),
                                                            ),
                                                            child: Text(
                                                              "Submit",
                                                              style: bodyStyleWhiteColor,
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
                padding: EdgeInsets.fromLTRB(0, px20, 0, px8),
                child: Center(
                  child: RaisedButton(
                    padding: EdgeInsets.all(px8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(px8))),
                    color: accentColor,
                    child: Text(
                      'Update',
                      style: bodyStyleWhiteColor,
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
