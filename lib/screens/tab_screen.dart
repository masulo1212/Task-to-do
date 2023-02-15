import 'package:flutter/material.dart';
import 'package:flutter_tasks_app/screens/mydrawer.dart';
import 'package:flutter_tasks_app/screens/tasks_complete_screen.dart';
import 'package:flutter_tasks_app/screens/tasks_favorite_screen.dart';
import 'package:flutter_tasks_app/screens/tasks_pending.dart';

import '../blocs/bloc_exports.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({Key? key}) : super(key: key);

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> with SingleTickerProviderStateMixin {
  TabController? tabController;

  final List<Tab> tabs = [const Tab(text: 'Pending'), const Tab(text: 'Complete'), const Tab(text: 'Favorite')];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
        title: const Text('Tasks to do'),
      ),
      body: BlocBuilder<SwitchBloc, SwitchState>(
        builder: (context, state) {
          return Column(
            children: [
              TabBar(
                labelColor: state.switchVal ? Colors.white : Colors.black,
                controller: tabController,
                tabs: tabs,
              ),
              Expanded(
                  child: TabBarView(
                      controller: tabController, children: const [TasksPending(), TaskComplete(), TaskFavorite()]))
            ],
          );
        },
      ),
    );
  }
}
