import 'package:flutter/material.dart';
import 'package:flutter_tasks_app/screens/tab_screen.dart';
import 'package:flutter_tasks_app/services/theme.dart';
import 'package:flutter_tasks_app/blocs/bloc_exports.dart';
import 'package:get/get.dart';
import 'package:json_theme/json_theme_schemas.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  //user json_theme package
  SchemaValidator.enabled = false;
  WidgetsFlutterBinding.ensureInitialized();

  //得到本機路徑並初始化hydrated bloc storage
  final storage = await HydratedStorage.build(storageDirectory: await getApplicationDocumentsDirectory());

  //load theme form json
  ThemeData? lightTheme = await LoadTheme.lightTheme();
  ThemeData? darkTheme = await LoadTheme.darkTheme();

  //init app
  HydratedBlocOverrides.runZoned(() => runApp(MyApp(lightTheme: lightTheme!, darkTheme: darkTheme!)), storage: storage);
}

class MyApp extends StatelessWidget {
  final ThemeData lightTheme;
  final ThemeData darkTheme;
  const MyApp({Key? key, required this.lightTheme, required this.darkTheme}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => TasksBloc()), BlocProvider(create: (context) => SwitchBloc())],
      child: BlocBuilder<SwitchBloc, SwitchState>(
        builder: (context, state) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Tasks App',
            theme: state.switchVal ? darkTheme : lightTheme,
            home: const TabScreen(),
          );
        },
      ),
    );
  }
}
