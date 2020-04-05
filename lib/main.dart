import 'package:flutter/material.dart';
import 'package:manufacture/ui/pages/splash_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_i18n/flutter_i18n_delegate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:manufacture/data/repository/user_repository.dart';
import 'package:manufacture/bloc/authentication_bloc.dart';
import 'package:manufacture/ui/pages/home_page.dart';
import 'package:manufacture/ui/pages/login_page.dart';
import 'package:manufacture/data/repository/version_repository.dart';
import 'package:manufacture/data/repository/authority_repository.dart';
import 'package:manufacture/ui/pages/update_page.dart';
import 'package:permission_handler/permission_handler.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    print(event);
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    print(error);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }
}

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(App(userRepository: UserRepository(),));
}

class App extends StatefulWidget {
  final UserRepository userRepository;
  App({Key key, @required this.userRepository}) : super(key: key);

  @override
  State<StatefulWidget> createState() => AppState();
}

class AppState extends State<App> {
  AuthenticationBloc authenticationBloc;
  UserRepository get userRepository => widget.userRepository;
  VersionRepository _versionRepository;


  // Locale _locale = const Locale('zh', 'CH');
  @override
  void initState() {
    _versionRepository = new VersionRepository();

    authenticationBloc = AuthenticationBloc(userRepository: userRepository, versionRepository: _versionRepository);
    authenticationBloc.add(AppStarted(Theme.of(context).platform));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthenticationBloc>(
      create: (context)=>authenticationBloc,
      //bloc: authenticationBloc,
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        //home: Splash(),
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            bloc: authenticationBloc,
            builder: (context, state) {
              if (state is AuthenticationUninitialized) {
                return Splash();
              }

              if(state is AuthenticationAuthenticated){
                return HomePage(userRepository: userRepository,versionRepository: _versionRepository,);
              }

              if(state is AuthenticationUnauthenticated){
                return LoginPage(userRepository: userRepository,);
              }

              if(state is UpdateState){
                return UpdatePage(currentVersion: state.currentVersion, latestVersion: state.latestVersion,);
              }

              return Container();
            }),
        localizationsDelegates: [
          //此处
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          FlutterI18nDelegate(true, "zh_CH", "asset/flutter_i18n"),
        ],
      ),
    );
  }
}
