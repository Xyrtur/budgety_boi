import 'package:budgetapp/utils/index.dart';

class SQLHelper {
  static SQLHelper _databaseHelper; // Singleton DatabaseHelper
  static Database _database; // Singleton Database

  SQLHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory SQLHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = SQLHelper._createInstance(); // This is executed only once, singleton object
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'budgets.db';

    // Open/create the database at a given path
    var todosDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return todosDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute('CREATE TABLE IF NOT EXISTS records('
        'paid_on DATE,'
        'input_type INTEGER,'
        'name TINYTEXT,'
        'grp TINYTEXT,'
        'amount DECIMAL(19,2))');
    await db.execute('CREATE TABLE IF NOT EXISTS limits('
        'limit_type TEXT,'
        'limit_amount DECIMAL(19,2))');
    await db.execute('CREATE TABLE IF NOT EXISTS overflow('
        'day TINYINT(70),'
        'dfood DECIMAL(19,2),'
        'dhobby DECIMAL(19,2),'
        'wfood DECIMAL(19,2),'
        'wtoil DECIMAL(19,2),'
        'whobby DECIMAL(19,2))');
    int count = Sqflite.firstIntValue(await db.rawQuery('SELECT EXISTS(SELECT 1 FROM limits LIMIT 1)'));
    if (count <= 0) {
      await db.transaction((txn) async {
        await txn.rawInsert(
            'INSERT INTO limits(limit_type, limit_amount) VALUES("food", 10.00), ("toil",10.00),("hobby",10.00),("rent",10.00),'
            '("phbill",10.00),("elec",10.00),("intbill",10.00),("laund", 10.00)');
        for (int i = 1; i <= Jiffy().daysInMonth; i++) {
          await txn.rawInsert(
              'INSERT INTO overflow(day, dfood, dhobby, wfood, wtoil, whobby) VALUES($i, 0.00, 0.00, 0.00, 0.00, 0.00)');
        }
      });
    }
  }

  Future<void> makeView(String time, {Jiffy date, Jiffy startDate, Jiffy endDate}) async {
    Database db = await this.database;

    await db.transaction((txn) async {
      await txn.execute('DROP VIEW IF EXISTS ${time}Values');
      if (time == "monthly") {
        await txn.execute('CREATE VIEW monthlyValues AS'
            ' SELECT amount, grp from records WHERE strftime(\'%m\', paid_on) = \'${date.month.toString().padLeft(2, '0')}\' '
            'AND strftime(\'%Y\', paid_on) = \'${date.year.toString()}\' AND input_type = 1');
      } else {
        await txn.execute('CREATE VIEW weeklyValues AS'
            ' SELECT amount, grp FROM records WHERE paid_on BETWEEN \'${startDate.format("yyy-MM-dd")}\' AND \'${endDate.format("yyy-MM-dd")}\' AND input_type = 1');
      }
    });
  }

  Future<int> insertRecord(String date, int type, String name, String group, double amt) async {
    Database db = await this.database;
    await db.transaction((txn) async {
      var result = await txn.rawInsert(
          'INSERT INTO records (paid_on,input_type,name,grp,amount) VALUES(\'$date\', $type, "$name", "$group", $amt)');
      return result;
    });
  }

//  Future<int> delete(int id) async {
//    return await db.delete(tableTodo, where: '$columnId = ?', whereArgs: [id]);
//  }

  Future<Map<String, dynamic>> getTxnHistory(String paid_on_condition, String group) async {
    Database db = await this.database;
    Map<String, dynamic> historyMap = new Map();

    if (group == "NOT IN (\"food\", \"hobby\")" || group == "NOT IN (\"food\", \"hobby\", \"toil\")") {
      await db
          .rawQuery(
              'SELECT name, amount, grp FROM records WHERE $paid_on_condition AND input_type = 1 AND grp $group ORDER BY amount DESC')
          .then((List<Map<String, dynamic>> resultList) {
        resultList.forEach((Map<String, dynamic> resultMap) {
          historyMap[resultMap['name']] = [resultMap['amount'].toDouble(), resultMap['grp']];
        });
      });
      return historyMap;
    } else {
      await db
          .rawQuery(
              'SELECT name, amount FROM records WHERE $paid_on_condition AND input_type = 1 AND grp $group ORDER BY amount DESC')
          .then((List<Map<String, dynamic>> resultList) {
        resultList.forEach((Map<String, dynamic> resultMap) {
          historyMap[resultMap['name']] = resultMap['amount'].toDouble();
        });
      });

      return historyMap;
    }
  }

  Future<List<double>> getLimitList(bool isDaily, int num) async {
    Database db = await this.database;
    List<double> limitList = [];
    Map<String, dynamic> overflowList;
    if (isDaily) {
      await getValue("limit_amount", "limits", "limit_type = \"food\"").then((value) {
        limitList.add(((value / Jiffy().daysInMonth) ?? 0).toDouble());
      });
      await getValue("limit_amount", "limits", "limit_type = \"hobby\"").then((value) {
        limitList.add(((value / Jiffy().daysInMonth) ?? 0).toDouble());
      });

      await db
          .rawQuery('SELECT dfood, dhobby FROM overflow WHERE day = $num - 1')
          .then((List<Map<String, dynamic>> resultList) {
        resultList.forEach((Map<String, dynamic> resultMap) {
          overflowList = resultMap;
        });
      });

      // add overflow
      limitList[0] += overflowList['dfood'];
      limitList[1] += overflowList['dhobby'];
      return limitList;
    } else {
      await getValue("limit_amount", "limits", "limit_type = \"food\"").then((value) {
        limitList.add((value ?? 0).toDouble());
      });
      await getValue("limit_amount", "limits", "limit_type = \"toil\"").then((value) {
        limitList.add((value ?? 0).toDouble());
      });
      await getValue("limit_amount", "limits", "limit_type = \"hobby\"").then((value) {
        limitList.add((value ?? 0).toDouble());
      });

      if (!(num == 0)) {
        int _daysInWeek = (num == 4)
            ? getDates()[num].diff(getDates()[num - 1], Units.DAY) + 1
            : getDates()[num].diff(getDates()[num - 1], Units.DAY);

        await db
            .rawQuery('SELECT wfood, wtoil, whobby FROM overflow WHERE day = $num - 1')
            .then((List<Map<String, dynamic>> resultList) {
          resultList.forEach((Map<String, dynamic> resultMap) {
            overflowList = resultMap;
          });
        });
        // add overflow
        limitList[0] = limitList[0] / Jiffy().daysInMonth * _daysInWeek + overflowList['wfood'];
        limitList[1] = limitList[1] / Jiffy().daysInMonth * _daysInWeek + overflowList['wtoil'];
        limitList[2] = limitList[2] / Jiffy().daysInMonth * _daysInWeek + overflowList['whobby'];
      }
      return limitList;
    }
  }

  Future getValue(String want, String table, String condition) async {
    Database db = await this.database;
    var value;

    await db
        .rawQuery('SELECT $want FROM $table WHERE $condition LIMIT 1')
        .then((List<Map<String, dynamic>> resultList) {
      resultList[0].forEach((key, val) => value = val);
    });
    return value;
  }

  Future<double> getCurrentW(int dex, String group, double overflow, Jiffy date) async {
    int daysInWeek = (dex == 4)
        ? getDates()[dex].diff(getDates()[dex - 1], Units.DAY) + 1
        : getDates()[dex].diff(getDates()[dex - 1], Units.DAY);
    double limitAmt, spentSoFar;

    await getValue("limit_amount", "limits", "limit_type = \"$group\"").then((value) {
      limitAmt = (value ?? 0).toDouble();
    });
    await getValue("SUM(amount)", "records",
            "grp = \"$group\" AND paid_on BETWEEN \'${getDates()[dex - 1].format("yyy-MM-dd")}\' AND \'${date.format("yyy-MM-dd")}\' AND input_type = 1")
        .then((value) {
      spentSoFar = (value ?? 0).toDouble();
    });
    return ((limitAmt / Jiffy().daysInMonth) * daysInWeek + overflow) - spentSoFar;
  }

  Future<void> updateWeeklyOverflow(int dex, String group) async {
    var db = await this.database;
    double currentW, week3Overflow, weekOverflow;
    for (int i = dex; i <= 4; i++) {
      if (i == 1) {
        await getCurrentW(i, group, 0, getDates()[i]..subtract(days: 1)).then((value) {
          currentW = (value ?? 0).toDouble();
        });
        await db.rawUpdate('UPDATE overflow SET w$group = $currentW WHERE day = $i');
      } else if (i == 4) {
        await getValue("w$group", "overflow", "day = 3").then((value) {
          week3Overflow = (value ?? 0).toDouble();
        });
        await getCurrentW(i, group, week3Overflow, getDates()[i]).then((value) {
          currentW = (value ?? 0).toDouble();
        });
        await db.rawUpdate('UPDATE overflow SET w$group = $currentW WHERE day = $i');
      } else {
        await getValue("w$group", "overflow", "day = ${i - 1}").then((value) {
          weekOverflow = (value ?? 0).toDouble();
        });
        await getCurrentW(i, group, weekOverflow, getDates()[i]..subtract(days: 1)).then((value) {
          currentW = (value ?? 0).toDouble();
        });
        await db.rawUpdate('UPDATE overflow SET w$group = $currentW WHERE day = $i');
      }
    }
  }

  Future<void> updateDailyOverflow(String group, int dateOfLastTxn) async {
    var db = await this.database;

    double limitAmt, prevDgroup, spentSoFar;
    await getValue("limit_amount", "limits", "limit_type = \"$group\"").then((value) {
      limitAmt = (value ?? 0).toDouble();
    });
    // catch the rest of the table up to date with the new overflow values; cant do one big update
    for (int i = dateOfLastTxn; i <= Jiffy().daysInMonth; i++) {
      await getValue("d$group", "overflow", "day = ${i - 1}").then((value) {
        prevDgroup = (value ?? 0).toDouble();
      });

      await getValue(
              "SUM(amount)",
              "records",
              "grp = \"$group\" AND paid_on = \'${(Jiffy({
                "year": Jiffy().year,
                "month": Jiffy().month,
                "day": i
              }).format("yyyy-MM-dd"))}\' AND input_type = 1")
          .then((value) {
        spentSoFar = (value ?? 0).toDouble();
      });

      double currentDgroup = (limitAmt / Jiffy().daysInMonth + prevDgroup) - spentSoFar;
      await db.rawUpdate('UPDATE overflow SET d$group = $currentDgroup WHERE day = $i');
    }
  }

  Future<void> updateOverflow(List<Inputs> inputs) async {
    var db = await this.database;

    List<Map<String, dynamic>> x = await db.rawQuery(
        'SELECT strftime(\'%m\', paid_on) FROM records ORDER BY paid_on DESC LIMIT 1'); //check current month against month of last txn
    int monthLastTxn = Sqflite.firstIntValue(x);

    if (Jiffy().month != monthLastTxn) {
      await db.rawDelete('DELETE FROM overflow'); //delete all rows in table
      for (int i = 1; i <= Jiffy().daysInMonth; i++) {
        await db.transaction((txn) async {
          await txn.rawInsert(
              'INSERT INTO overflow(day, dfood, dhobby, wfood, wtoil, whobby) VALUES($i, 0.00,0.00,0.00,0.00,0.00)'); //repopulates for current month after deletion
        });
      }
    }

    int _endDex = (Jiffy().date < getDates()[1].date)
        ? 1
        : ((Jiffy().date < getDates()[2].date) ? 2 : ((Jiffy().date < getDates()[3].date) ? 3 : 4));

    List<String> groupTypesPresent = [];
    Map<String, int> lastTxnDates = {"food": 31, "hobby": 31, "toil": 31};

    for (Inputs p in inputs) {
      //just hope ur only inputting txn's from this month
      if (p.group == "food" ||
          p.group == "hobby" ||
          p.group == "toil" ||
          !groupTypesPresent.contains(p.group)) groupTypesPresent.add(p.group);

      if (lastTxnDates.containsKey(p.group) && Jiffy(p.date, "yyyy-MM-dd").date <= lastTxnDates[p.group])
        lastTxnDates[p.group] = Jiffy(p.date, "yyyy-MM-dd").date;
    }

    for (String s in groupTypesPresent) {
      switch (s) {
        case "food":
          {
            await updateDailyOverflow("food", lastTxnDates["food"]);
            await updateWeeklyOverflow(_endDex, "food");
            break;
          }
        case "hobby":
          {
            await updateDailyOverflow("hobby", lastTxnDates["hobby"]);
            await updateWeeklyOverflow(_endDex, "hobby");
            break;
          }

        case "toil":
          {
            await updateWeeklyOverflow(_endDex, "toil");
            break;
          }
      }
    }
  }

  Future<void> updateLimits(List<double> values) async {
    var db = await this.database;
    for (int i = 0; i < values.length; i++) {
      if (values[i] == null) {
      } else {
        await db.rawUpdate(
            'UPDATE limits SET limit_amount = ${values[i]} WHERE limit_type = \"${getActualGroups()[i]}\"');
      }
    }
  }

  Future close() async {
    Database db = await this.database;
    db.close();
  }
}
