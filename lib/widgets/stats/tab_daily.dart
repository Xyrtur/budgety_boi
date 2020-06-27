import 'package:budgetapp/widgets/widgets.dart';
import 'package:budgetapp/widgets/index.dart';

class DailyTabWidget extends StatefulWidget {
  _DailyTabState createState() => _DailyTabState();
}

class _DailyTabState extends State<DailyTabWidget> {
  SQLHelper sqlHelper = SQLHelper();

  Jiffy dayJiffy = Jiffy();

  Future<List> _getValues() async {
    var valuee1, valuee2;
    await sqlHelper
        .getValue("SUM(amount)", "records",
            "paid_on = \'${dayJiffy.format("yyy-MM-dd")}\' AND input_type = 1 AND grp = \"food\"")
        .then((value1) {
      valuee1 = (value1 ?? 0).toDouble();
    });

    await sqlHelper
        .getValue("SUM(amount)", "records",
            "paid_on = \'${dayJiffy.format("yyy-MM-dd")}\' AND input_type = 1 AND grp = \"hobby\"")
        .then((value2) {
      valuee2 = (value2 ?? 0).toDouble();
    });
    return [valuee1, valuee2];
  }

  Future<List> _getLimitsList() async {
    var value1;
    await sqlHelper.getLimitList(true, dayJiffy.date).then((value) {
      value1 = value;
    });
    return value1;
  }

  @override
  Widget build(BuildContext context) {
    String _date = dayJiffy.format('EEE, MMM d');
    int currentDay = dayJiffy.date;

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.safeBlockHorizontal * 5),

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
                    if (currentDay == 1) {
                    } else {
                      _date = (dayJiffy..subtract(days: 1)).format('EEE, MMM d');
                    }
                  });
                }),
            Text(_date, style: bodyStyleWhiteColor(context)),
            IconButton(
              icon: Icon(Icons.chevron_right, color: Colors.white),
              onPressed: () {
                setState(() {
                  if (currentDay + 1 > Jiffy().daysInMonth) {
                  } else {
                    _date = (dayJiffy..add(days: 1)).format('EEE, MMM d');
                  }
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
            Text("Food", style: bodyStyleWhiteColor(context)),
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
                    double initValue = (snapshot.data[0][0] ?? 0);
                    return BudgetProgressBar(context, (snapshot.data[1][0]).toStringAsFixed(2), initValue);
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
                    double initValue = (snapshot.data[0][1] == null) ? 0 : snapshot.data[0][1];
                    return BudgetProgressBar(context, (snapshot.data[1][1]).toStringAsFixed(2), initValue);
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
        txnHistory(context, "paid_on = \'${dayJiffy.format("yyy-MM-dd")}\'", "= \"food\"", "Food"),
        txnHistory(context, "paid_on = \'${dayJiffy.format("yyy-MM-dd")}\'", "= \"hobby\"", "Hobby"),
        txnHistory(context, "paid_on = \'${dayJiffy.format("yyy-MM-dd")}\'", "NOT IN (\"food\", \"hobby\")",
            "Other"),
      ],

      //
    );
  }
}
