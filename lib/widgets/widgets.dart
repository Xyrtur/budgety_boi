import 'index.dart';

List<Jiffy> getDates() {
  return [
    Jiffy()..startOf(Units.MONTH),
    Jiffy()
      ..startOf(Units.MONTH)
      ..add(days: 7),
    Jiffy()
      ..startOf(Units.MONTH)
      ..add(days: 14),
    Jiffy()
      ..startOf(Units.MONTH)
      ..add(days: 21),
    Jiffy()..endOf(Units.MONTH)
  ];
}

TextStyle bodyStyleWhiteColor(BuildContext context) {
  return Theme.of(context).textTheme.body1.copyWith(fontSize: SizeConfig.safeBlockVertical * 2.3649);
}

List<String> getGroups() {
  return ["Food", "Toiletries", "Hobbies", "Rent", "Phone", "Electricity", "Internet", "Laundry"];
}

List<String> getActualGroups() {
  return ["food", "toil", "hobby", "rent", "phbill", "elec", "intbill", "laund"];
}

Future<List<String>> _getValue(Jiffy date, String group) async {
  SQLHelper sqlHelper = SQLHelper();
  var valuee, valuee2;
  await sqlHelper
      .getValue("SUM(amount)", "records",
          "strftime(\'%m\', paid_on) = \'${date.month.toString().padLeft(2, '0')}\' AND strftime(\'%Y\', paid_on) = \'${date.year.toString()}\' AND input_type = 1 AND grp = \"$group\"")
      .then((value1) {
    valuee = (value1 ?? 0).toDouble().toStringAsFixed(2);
  });
  await sqlHelper.getValue("limit_amount", "limits", "limit_type = \"$group\"").then((value) {
    valuee2 = (value ?? 0).toDouble().toStringAsFixed(2);
  });

  return [valuee, valuee2];
}

Future<Map> _getTxnHistory(String paid_on_condition, String group) async {
  SQLHelper sqlHelper = SQLHelper();
  var valuee;
  await sqlHelper.getTxnHistory(paid_on_condition, group).then((value) {
    valuee = value;
  });

  return valuee;
}

Drawer hamborgerTime(BuildContext context) {
  return Drawer(
    child: ListView(
      children: <Widget>[
        DrawerHeader(
            child: Text("PETTHESCHNÖZER",
                style: Theme.of(context)
                    .textTheme
                    .headline
                    .copyWith(fontSize: SizeConfig.safeBlockVertical * 3.5473)),
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                image: DecorationImage(image: AssetImage("assets/schnozer.gif"), fit: BoxFit.cover))),
        ListTile(
          title: Text("Reports", style: bodyStyleWhiteColor(context)),
          leading: Icon(
            Icons.assessment,
            color: Theme.of(context).primaryColor,
          ),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.push(context, MaterialPageRoute(builder: (context) => ReportScreen()));
          },
        ),
        ListTile(
          title: Text("Inputs", style: bodyStyleWhiteColor(context)),
          leading: Icon(Icons.compare_arrows, color: Theme.of(context).primaryColor),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.push(context, MaterialPageRoute(builder: (context) => InputScreen()));
          },
        ),
        ListTile(
          title: Text("Settings", style: bodyStyleWhiteColor(context)),
          leading: Icon(Icons.settings, color: Theme.of(context).primaryColor),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen()));
          },
        ),
      ],
    ),
  );
}

class IncomeList extends StatelessWidget {
  List<Inputs> incomes = [];
  IncomeList(List<Inputs> inputs) {
    for (Inputs p in inputs) {
      if (p.type == 0) {
        incomes.add(p);
      }
    }
  }
  Widget _buildProductItem(BuildContext context, int index) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            incomes[index].name,
            textAlign: TextAlign.left,
            style: bodyStyleWhiteColor(context),
          ),
        ),
        Expanded(
          child: Text(
            '\$${incomes[index].amount}',
            textAlign: TextAlign.right,
            style: bodyStyleWhiteColor(context),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: _buildProductItem,
      itemCount: incomes.length,
    );
  }
}

class ExpenseList extends StatelessWidget {
  List<Inputs> expenses = [];
  ExpenseList(List<Inputs> inputs) {
    for (Inputs p in inputs) {
      if (p.type == 1) {
        expenses.add(p);
      }
    }
  }

  Widget _buildProductItem(BuildContext context, int index) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            expenses[index].name,
            textAlign: TextAlign.left,
            style: bodyStyleWhiteColor(context),
          ),
        ),
        Expanded(
          child: Text(
            '\$${expenses[index].amount}',
            textAlign: TextAlign.right,
            style: bodyStyleWhiteColor(context),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: _buildProductItem,
      itemCount: expenses.length,
    );
  }
}

class Inputs {
  double amount;
  String name;
  String group;
  String date;
  int type; // 0 -> income / 1 -> expense

  Inputs.expense(double amt, String nm, String grp, String date) {
    this.amount = amt;
    this.name = nm;
    this.group = grp;
    this.date = date;
    this.type = 1;
  }
  Inputs.income(double amount, String name, String date) {
    this.amount = amount;
    this.name = name;
    this.date = date;
    this.type = 0;
  }
}

SleekCircularSlider BudgetProgressBar(BuildContext context, String limit, double initialValue) {
  return SleekCircularSlider(
    appearance: CircularSliderAppearance(
        counterClockwise: true,
        size: SizeConfig.safeBlockHorizontal * 35,
        startAngle: 270,
        angleRange: 360,
        customWidths: CustomSliderWidths(
          progressBarWidth: SizeConfig.safeBlockHorizontal * 35 / 13,
        ),
        customColors: CustomSliderColors(
            hideShadow: true,
            dotColor: Color(0xFFDC322F),
            trackColor: Colors.white70,
            progressBarColor: Color(0xFFDC322F)),
        infoProperties: InfoProperties(
            modifier: (double value) {
              return '\$${initialValue.toStringAsFixed(2)}';
            },
            mainLabelStyle:
                Theme.of(context).textTheme.body1.copyWith(fontSize: SizeConfig.safeBlockVertical * 2.9561),
            bottomLabelStyle:
                Theme.of(context).textTheme.body1.copyWith(fontSize: SizeConfig.safeBlockVertical * 1.7736),
            bottomLabelText: "/ \$$limit")),
    max: double.parse(limit),
    min: (double.parse(limit) < 0) ? double.parse(limit) - 1 : 0,
    initialValue: (initialValue > double.parse(limit)) ? double.parse(limit) : initialValue,
  );
}

Card setBudgetCard({BuildContext context, Icon sign, String type, Function f}) {
  return Card(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        sign,
        Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(type,
                style: bodyStyleWhiteColor(context).copyWith(color: Theme.of(context).canvasColor))),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: TextFormField(
            keyboardType: TextInputType.numberWithOptions(signed: false, decimal: true),
            decoration: InputDecoration(
                isDense: true, border: OutlineInputBorder(), focusedBorder: OutlineInputBorder()),
            onSaved: f,
          ),
        ),
      ],
    ),
  );
}

Expanded graphCard({BuildContext context, String type, Widget typeSlider}) {
  return Expanded(
    child: GestureDetector(
      onTap: () {
        //todo show graphs / pass function to call in the constructor
      },
      child: Container(
        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border.all(width: 3.0, color: Color(0xFF38565E)),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        child: Card(
          color: Theme.of(context).canvasColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(8, 8, 0, 0),
                child: Text(type, style: bodyStyleWhiteColor(context), textAlign: TextAlign.left),
              ),
              Padding(padding: EdgeInsets.all(10), child: typeSlider)
            ],
          ),
        ),
      ),
    ),
  );
}

Theme txnHistory(BuildContext context, String paid_on_condition, String group, String subtitle) {
  List<String> names = [];
  List<double> amounts = [];
  List<String> groups = [];

  return Theme(
    data: ThemeData(unselectedWidgetColor: Colors.white, accentColor: Theme.of(context).accentColor),
    child: ExpansionTile(
      title: Text(
        subtitle,
        style: Theme.of(context).textTheme.body1.copyWith(fontSize: SizeConfig.safeBlockVertical * 1.7736),
      ),
      subtitle: Divider(
        height: 10,
        thickness: 2,
        color: Colors.grey,
      ),
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            FutureBuilder(
                future: _getTxnHistory(paid_on_condition, group),
                builder: (context, AsyncSnapshot<Map> snapshot) {
                  if (snapshot.hasData && snapshot.data.length != 0) {
                    if (group == "NOT IN (\"food\", \"hobby\")" ||
                        group == "NOT IN (\"food\", \"hobby\", \"toil\")") {
                      snapshot.data.forEach((key, val) {
                        names.add(key);
                        amounts.add(val[0]);
                        groups.add(val[1]);
                      });
                    } else {
                      snapshot.data.forEach((key, val) {
                        names.add(key);
                        amounts.add(val);
                      });
                    }
                    return Expanded(
                      child: Container(
                        height: SizeConfig.safeBlockVertical * 10,
                        child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext bContext, int index) {
                              return Container(
                                decoration: BoxDecoration(
                                  border: Border.all(width: 3.0, color: Colors.grey),
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                ),
                                padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
                                margin: EdgeInsets.only(left: 8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      names[index],
                                      style: Theme.of(context)
                                          .textTheme
                                          .body1
                                          .copyWith(fontSize: SizeConfig.safeBlockVertical * 1.7736),
                                    ),
                                    (group == "NOT IN (\"food\", \"hobby\")")
                                        ? Text(
                                            groups[index],
                                            style: Theme.of(context)
                                                .textTheme
                                                .body1
                                                .copyWith(fontSize: SizeConfig.safeBlockVertical * 1.7736),
                                          )
                                        : Container(width: 0, height: 0),
                                    Text(
                                      "\$${amounts[index].toStringAsFixed(2)}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .body1
                                          .copyWith(fontSize: SizeConfig.safeBlockVertical * 1.7736),
                                    ),
                                  ],
                                ),
                              );
                            }),
                      ),
                    );
                  } else {
                    return Container(
                      width: 0,
                      height: 0,
                    );
                  }
                }),
          ],
        ),
      ],
    ),
  );
}

Center otherExpenseCard(BuildContext context, int group, Jiffy date) {
  return Center(
    child: Card(
      margin: EdgeInsets.only(bottom: 8.0, top: 8.0),
      color: Theme.of(context).canvasColor,
      elevation: 5.0,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(getGroups()[group], style: bodyStyleWhiteColor(context)),
            FutureBuilder(
                future: _getValue(date, getActualGroups()[group]),
                builder: (context, AsyncSnapshot<List<String>> snapshot) {
                  if (snapshot.hasData) {
                    return Text("\$${snapshot.data[0]} \\ \$${snapshot.data[1]} ",
                        style: bodyStyleWhiteColor(context));
                  } else {
                    return CircularProgressIndicator();
                  }
                }),
          ],
        ),
      ),
    ),
  );
}
