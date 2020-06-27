import 'package:budgetapp/widgets/widgets.dart';
import 'package:budgetapp/widgets/index.dart';

class MonthlyTabWidget extends StatefulWidget {
  _MonthlyTabState createState() => _MonthlyTabState();
}

class _MonthlyTabState extends State<MonthlyTabWidget> {
  SQLHelper sqlHelper = SQLHelper();

  Jiffy dateJiffy = Jiffy();
  void _makeVw(String time, Jiffy date) async {
    await sqlHelper.makeView(time, date: date);
  }

  Future<List> _getLimitsList() async {
    var value1;
    await sqlHelper.getLimitList(false, 0).then((value) {
      value1 = value;
    });
    return value1;
  }

  Future<List> _getValues() async {
    var food, toil, hobby;

    await sqlHelper.getValue("SUM(amount)", "monthlyValues", "grp = \"food\"").then((value1) {
      food = (value1 ?? 0).toDouble();
    });

    await sqlHelper.getValue("SUM(amount)", "monthlyValues", "grp = \"hobby\"").then((value2) {
      hobby = (value2 ?? 0).toDouble();
    });
    await sqlHelper.getValue("SUM(amount)", "monthlyValues", "grp = \"toil\"").then((value3) {
      toil = (value3 ?? 0).toDouble();
    });

    return [food, toil, hobby];
  }

  @override
  Widget build(BuildContext context) {
    String date = dateJiffy.yMMMM;

    _makeVw("monthly", dateJiffy);

    return ListView(
        padding: EdgeInsets.fromLTRB(SizeConfig.safeBlockHorizontal * 5, 0,
            SizeConfig.safeBlockHorizontal * 5, SizeConfig.safeBlockHorizontal * 5),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              IconButton(
                  icon: Icon(Icons.chevron_left, color: Colors.white),
                  color: Colors.white,
                  onPressed: () {
                    setState(() {
                      date = (dateJiffy..subtract(months: 1)).yMMMM;
                    });
                  }),
              Text(date, style: Theme.of(context).textTheme.body1),
              IconButton(
                icon: Icon(Icons.chevron_right, color: Colors.white),
                onPressed: () {
                  setState(() {
                    date = (dateJiffy..add(months: 1)).yMMMM;
                  });
                },
              ),
            ],
          ),
          SizedBox(
            width: double.infinity,
            height: SizeConfig.blockSizeVertical * 4,
          ),
          SizedBox(
            width: double.infinity,
            height: SizeConfig.blockSizeVertical * 3,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              graphCard(
                context: context,
                type: "Total",
                typeSlider: FutureBuilder(
                    future: Future.wait([
                      // Future<bool> firstFuture() async {...}
                      _getValues(),
                      _getLimitsList() // (),// Future<bool> secondFuture() async {...}
                      //... More futures
                    ]),
                    builder: (context, AsyncSnapshot<List<List>> snapshot) {
                      if (snapshot.hasData) {
                        double initValue = (snapshot.data[0][0] ?? 0) +
                            (snapshot.data[0][1] ?? 0) +
                            (snapshot.data[0][2] ?? 0);
                        return BudgetProgressBar(
                            context,
                            (snapshot.data[1][0] + snapshot.data[1][1] + snapshot.data[1][2])
                                .toStringAsFixed(2),
                            initValue);
                      } else {
                        return CircularProgressIndicator();
                      }
                    }),
              ),
              graphCard(
                context: context,
                type: "Food",
                typeSlider: FutureBuilder(
                    future: Future.wait([
                      // Future<bool> firstFuture() async {...}
                      _getValues(),
                      _getLimitsList() // (),// Future<bool> secondFuture() async {...}
                      //... More futures
                    ]),
                    builder: (context, AsyncSnapshot<List<List>> snapshot) {
                      if (snapshot.hasData) {
                        double initValue = (snapshot.data[0][0] == null) ? 0 : snapshot.data[0][0];
                        return BudgetProgressBar(context, snapshot.data[1][0].toStringAsFixed(2), initValue);
                      } else {
                        return CircularProgressIndicator();
                      }
                    }),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              graphCard(
                context: context,
                type: "Toiletries",
                typeSlider: FutureBuilder(
                    future: Future.wait([
                      // Future<bool> firstFuture() async {...}
                      _getValues(),
                      _getLimitsList() // (),// Future<bool> secondFuture() async {...}
                      //... More futures
                    ]),
                    builder: (context, AsyncSnapshot<List<List>> snapshot) {
                      if (snapshot.hasData) {
                        double initValue = (snapshot.data[0][1] == null) ? 0 : snapshot.data[0][1];
                        return BudgetProgressBar(context, snapshot.data[1][1].toStringAsFixed(2), initValue);
                      } else {
                        return CircularProgressIndicator();
                      }
                    }),
              ),
              graphCard(
                context: context,
                type: "Hobby",
                typeSlider: FutureBuilder(
                    future: Future.wait([
                      // Future<bool> firstFuture() async {...}
                      _getValues(),
                      _getLimitsList() // (),// Future<bool> secondFuture() async {...}
                      //... More futures
                    ]),
                    builder: (context, AsyncSnapshot<List<List>> snapshot) {
                      if (snapshot.hasData) {
                        double initValue = (snapshot.data[0][2] == null) ? 0 : snapshot.data[0][2];
                        return BudgetProgressBar(context, snapshot.data[1][2].toStringAsFixed(2), initValue);
                      } else {
                        return CircularProgressIndicator();
                      }
                    }),
              ),
            ],
          ),
          otherExpenseCard(context, 7, dateJiffy),
          otherExpenseCard(context, 5, dateJiffy),
        ]);
  }
}
