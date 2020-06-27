import 'index.dart';

void main() => runApp(BudgetApp());

class BudgetApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          canvasColor: Color(0xFF002B36),
          primaryColor: Colors.white,
          primaryColorLight: Color(0xFF9ec3cc),
          accentColor: Color(0xFFD0413C),
          textTheme: TextTheme(
            headline: TextStyle(
                fontFamily: 'PT Sans', fontWeight: FontWeight.bold, color: Color(0xFF002B36), fontSize: 30),
            body1: TextStyle(fontFamily: 'PT Sans', color: Colors.white, fontSize: 20),
          ),
        ),
        home: SafeArea(child: ReportScreen()));
  }
}
