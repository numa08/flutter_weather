import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/repositories/respositories.dart';
import 'package:http/http.dart' as http;

import 'bloc/bloc.dart';
import 'widgets/widgets.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }
}

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  final WeatherRepository weatherRepository = WeatherRepository(
      weatherApiClient: WeatherApiClient(httpClient: http.Client()));
  runApp(App(weatherRepository: weatherRepository));
}

class App extends StatefulWidget {
  final WeatherRepository weatherRepository;

  const App({Key key, this.weatherRepository})
      : assert(weatherRepository != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> {
  ThemeBloc _themeBloc = ThemeBloc();

  @override
  Widget build(BuildContext context) => BlocProvider(
        bloc: _themeBloc,
        child: BlocBuilder(
            bloc: _themeBloc,
            builder: (_, ThemeState themeState) => MaterialApp(
                  title: 'Flutter Weather',
                  theme: themeState.theme,
                  home: Weather(
                    weatherRepository: widget.weatherRepository,
                  ),
                )),
      );

  @override
  void dispose() {
    _themeBloc.dispose();
    super.dispose();
  }
}
