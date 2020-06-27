import 'index.dart';

class SettingsScreen extends StatefulWidget {
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final List<String> entries = <String>['Budgets'];
  final List<IconData> iconList = <IconData>[Icons.money_off];

  //for later use when add more settings
//  final List<String> entries = <String>['Budgets', 'Nightmode'];
//  final List<IconData> iconList = <IconData>[Icons.money_off, Icons.brightness_3];
//  final List<Function> functionList = <Function>[];

  @override
  Widget build(BuildContext context) {
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
            'Settings',
            style: Theme.of(context).textTheme.headline,
          ),
        ),
        drawer: hamborgerTime(context),
        body: ListView.separated(
          padding: const EdgeInsets.all(8),
          itemCount: entries.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              leading: Icon(iconList[index], color: Colors.grey[500]),
              title: Text(
                entries[index],
                style: Theme.of(context).textTheme.body1,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SetBudgetScreen()),
                );
              },
            );
          },
          separatorBuilder: (BuildContext context, int index) => const Divider(),
        ),
      ),
    );
  }
}
