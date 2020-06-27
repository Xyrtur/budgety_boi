import 'index.dart';

class SetBudgetScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  SQLHelper sqlHelper = SQLHelper();
  double food, toiletries, hobbies, rent, phBill, elecBill, intBill, laundry;

  void _updateLimits(List<double> d) async {
    await sqlHelper.updateLimits(d);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Budget Settings",
            style: Theme.of(context)
                .textTheme
                .headline
                .copyWith(fontSize: SizeConfig.safeBlockVertical * 3.5473)),
      ),
      body: Form(
        key: _formKey,
        child: GridView.count(
          crossAxisCount: 2,
          padding: const EdgeInsets.all(16),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: <Widget>[
            setBudgetCard(
                context: context,
                sign: Icon(Icons.add_shopping_cart),
                type: getGroups()[0],
                f: (String value) {
                  if (value == "") {
                  } else {
                    food = double.parse(value);
                  }
                }),
            setBudgetCard(
                context: context,
                sign: Icon(Icons.toys),
                type: getGroups()[1],
                f: (String value) {
                  if (value == "") {
                  } else {
                    toiletries = double.parse(value);
                  }
                }),
            setBudgetCard(
                context: context,
                sign: Icon(Icons.games),
                type: getGroups()[2],
                f: (String value) {
                  if (value == "") {
                  } else {
                    hobbies = double.parse(value);
                  }
                }),
            setBudgetCard(
                context: context,
                sign: Icon(Icons.monetization_on),
                type: getGroups()[3],
                f: (String value) {
                  if (value == "") {
                  } else {
                    rent = double.parse(value);
                  }
                }),
            setBudgetCard(
                context: context,
                sign: Icon(Icons.phone_android),
                type: getGroups()[4],
                f: (String value) {
                  if (value == "") {
                  } else {
                    phBill = double.parse(value);
                  }
                }),
            setBudgetCard(
                context: context,
                sign: Icon(Icons.lightbulb_outline),
                type: getGroups()[5],
                f: (String value) {
                  if (value == "") {
                  } else {
                    elecBill = double.parse(value);
                  }
                }),
            setBudgetCard(
                context: context,
                sign: Icon(Icons.wifi),
                type: getGroups()[6],
                f: (String value) {
                  if (value == "") {
                  } else {
                    intBill = double.parse(value);
                  }
                }),
            setBudgetCard(
                context: context,
                sign: Icon(Icons.account_balance),
                type: getGroups()[7],
                f: (String value) {
                  if (value == "") {
                  } else {
                    laundry = double.parse(value);
                  }
                }),
            GestureDetector(
              onTap: () {
                _formKey.currentState.save();
                _updateLimits([food, toiletries, hobbies, rent, phBill, elecBill, intBill, laundry]);
                Navigator.pop(context);
              },
              child: Card(
                color: Theme.of(context).accentColor,
                child: Center(
                  child: Text("Submit", style: bodyStyleWhiteColor(context)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
