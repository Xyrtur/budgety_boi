import 'index.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key key}) : super(key: key);

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> with SingleTickerProviderStateMixin {
  final List<Tab> myTabs = <Tab>[
    Tab(text: 'DAILY'),
    Tab(text: 'WEEKLY'),
    Tab(text: 'MONTHLY'),
  ];

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Image(
            image: AssetImage('assets/schnozer.gif'),
            fit: BoxFit.cover,
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            'Reports',
            style: Theme.of(context).textTheme.headline,
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(80),
            child: TabBar(
              tabs: myTabs,
              controller: _tabController,
            ),
          ),
        ),
        drawer: hamborgerTime(context),
        body: TabBarView(
          controller: _tabController,
          children: [
            DailyTabWidget(),
            WeeklyTabWidget(),
            MonthlyTabWidget(),
          ],
        ),
      ),
    );
  }
}
