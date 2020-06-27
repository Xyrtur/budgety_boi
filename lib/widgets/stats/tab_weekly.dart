import 'package:budgetapp/widgets/widgets.dart';
import 'package:budgetapp/widgets/index.dart';

class WeeklyTabWidget extends StatefulWidget {
  _WeeklyTabState createState() => _WeeklyTabState();
}

class _WeeklyTabState extends State<WeeklyTabWidget> {
  SQLHelper sqlHelper = SQLHelper();
  String date = "";

  static int startDex = (Jiffy().date >= getDates()[3].date)
      ? 3
      : ((Jiffy().date >= getDates()[2].date) ? 2 : ((Jiffy().date >= getDates()[1].date) ? 1 : 0));
  int endDex = startDex + 1;
  int currentStartDex = startDex;

  void _makeVw(String time, Jiffy startDate, Jiffy endDate) async {
    await sqlHelper.makeView(time, startDate: startDate, endDate: endDate);
  }

  Future<List> _getLimitsList() async {
    var value1;
    await sqlHelper.getLimitList(false, endDex).then((value) {
      value1 = value;
    });
    return value1;
  }

  Future<List> _getValues() async {
    var food, toil, hobby;

    await sqlHelper.getValue("SUM(amount)", "weeklyValues", "grp = \"food\"").then((value1) {
      food = (value1 ?? 0).toDouble();
    });

    await sqlHelper.getValue("SUM(amount)", "weeklyValues", "grp = \"hobby\"").then((value2) {
      hobby = (value2 ?? 0).toDouble();
    });
    await sqlHelper.getValue("SUM(amount)", "weeklyValues", "grp = \"toil\"").then((value3) {
      toil = (value3 ?? 0).toDouble();
    });

    return [food, toil, hobby];
  }

  @override
  Widget build(BuildContext context) {
    if (endDex == 4) {
      date = getDates()[startDex].format("MMM dd") + " - " + getDates()[endDex].format("MMM dd");
      _makeVw("weekly", getDates()[startDex], getDates()[endDex]);
    } else {
      date = getDates()[startDex].format("MMM dd") +
          " - " +
          (getDates()[endDex]..subtract(days: 1)).format("MMM dd");
      _makeVw("weekly", getDates()[startDex], getDates()[endDex]..subtract(days: 1));
    }

    return ListView(
      padding: EdgeInsets.fromLTRB(SizeConfig.safeBlockHorizontal * 5, 0, SizeConfig.safeBlockHorizontal * 5,
          SizeConfig.safeBlockHorizontal * 5),
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
                    startDex = (startDex != 0) ? startDex - 1 : 0;
                    endDex = (startDex != 0) ? endDex - 1 : 1;
                  });
                }),
            Text(date, style: bodyStyleWhiteColor(context)),
            IconButton(
              icon: Icon(Icons.chevron_right, color: Colors.white),
              onPressed: () {
                setState(() {
                  startDex = (startDex != 3) ? startDex + 1 : 3;
                  endDex = (startDex != 3) ? endDex + 1 : 4;
                });
              },
            ),
          ],
        ),
        SizedBox(
          width: double.infinity,
          height: SizeConfig.blockSizeVertical * 7,
        ),
        Row(
          children: <Widget>[
            Text("Total", style: bodyStyleWhiteColor(context)),
            SizedBox(width: SizeConfig.safeBlockHorizontal * 30),
            Text("Food", style: bodyStyleWhiteColor(context)),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            FutureBuilder(
                future: Future.wait([
                  // Future<bool> firstFuture() async {...}
                  _getValues(),
                  _getLimitsList() // (),// Future<bool> secondFuture() async {...}
                  //... More futures
                ]),
                builder: (context, AsyncSnapshot<List<List>> snapshot) {
                  if (snapshot.hasData) {
                    double initValue =
                        (snapshot.data[0][0] ?? 0) + (snapshot.data[0][1] ?? 0) + (snapshot.data[0][2] ?? 0);
                    return BudgetProgressBar(
                        context,
                        ((snapshot.data[1][0] + snapshot.data[1][1] + snapshot.data[1][2]))
                            .toStringAsFixed(2),
                        initValue);
                  } else {
                    return CircularProgressIndicator();
                  }
                }),
            FutureBuilder(
                future: Future.wait([
                  // Future<bool> firstFuture() async {...}
                  _getValues(),
                  _getLimitsList() // (),// Future<bool> secondFuture() async {...}
                  //... More futures
                ]),
                builder: (context, AsyncSnapshot<List<List>> snapshot) {
                  if (snapshot.hasData) {
                    double initValue = (snapshot.data[0][0] ?? 0);
                    return BudgetProgressBar(context, (snapshot.data[1][0]).toStringAsFixed(2), initValue);
                  } else {
                    return CircularProgressIndicator();
                  }
                }),
          ],
        ),
        SizedBox(
          width: double.infinity,
          height: SizeConfig.blockSizeVertical * 4,
        ),
        Row(
          children: <Widget>[
            Text("Toiletries", style: bodyStyleWhiteColor(context)),
            SizedBox(width: SizeConfig.safeBlockHorizontal * 30),
            Text("Hobby", style: bodyStyleWhiteColor(context)),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            FutureBuilder(
                future: Future.wait([
                  // Future<bool> firstFuture() async {...}
                  _getValues(),
                  _getLimitsList() // (),// Future<bool> secondFuture() async {...}
                  //... More futures
                ]),
                builder: (context, AsyncSnapshot<List<List>> snapshot) {
                  if (snapshot.hasData) {
                    double initValue = (snapshot.data[0][1] == null) ? 0 : snapshot.data[0][1];
                    return BudgetProgressBar(context, (snapshot.data[1][1]).toStringAsFixed(2), initValue);
                  } else {
                    return CircularProgressIndicator();
                  }
                }),
            FutureBuilder(
                future: Future.wait([
                  // Future<bool> firstFuture() async {...}
                  _getValues(),
                  _getLimitsList() // (),// Future<bool> secondFuture() async {...}
                  //... More futures
                ]),
                builder: (context, AsyncSnapshot<List<List>> snapshot) {
                  if (snapshot.hasData) {
                    double initValue = (snapshot.data[0][2] == null) ? 0 : snapshot.data[0][2];
                    return BudgetProgressBar(context, (snapshot.data[1][2]).toStringAsFixed(2), initValue);
                  } else {
                    return CircularProgressIndicator();
                  }
                }),
          ],
        ),
        SizedBox(
          width: double.infinity,
          height: SizeConfig.blockSizeVertical * 7,
        ),
        Center(child: Text("Txn History", style: bodyStyleWhiteColor(context))),
        txnHistory(
            context,
            "paid_on BETWEEN \'${getDates()[endDex - 1].format("yyy-MM-dd")}\' AND \'${getDates()[endDex].format("yyy-MM-dd")}\'",
            "= \"food\"",
            "Food"),
        txnHistory(
            context,
            "paid_on BETWEEN \'${getDates()[endDex - 1].format("yyy-MM-dd")}\' AND \'${getDates()[endDex].format("yyy-MM-dd")}\'",
            "= \"hobby\"",
            "Hobby"),
        txnHistory(
            context,
            "paid_on BETWEEN \'${getDates()[endDex - 1].format("yyy-MM-dd")}\' AND \'${getDates()[endDex].format("yyy-MM-dd")}\'",
            "= \"toil\"",
            "Toiletries"),
        txnHistory(
            context,
            "paid_on BETWEEN \'${getDates()[endDex - 1].format("yyy-MM-dd")}\' AND \'${getDates()[endDex].format("yyy-MM-dd")}\'",
            "NOT IN (\"food\", \"hobby\", \"toil\")",
            "Other"),
      ],
      //
    );
  }
}
