import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/bloc/bloc.dart';
import 'package:flutter_weather/repositories/respositories.dart';

import 'widgets.dart';

class Weather extends StatefulWidget {
  final WeatherRepository weatherRepository;

  const Weather({Key key, this.weatherRepository})
      : assert(weatherRepository != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
  WeatherBloc _weatherBloc;
  Completer<void> _refreshCompleter;

  @override
  void initState() {
    _refreshCompleter = Completer();
    _weatherBloc = WeatherBloc(weatherRepository: widget.weatherRepository);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Flutter Weather'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () async {
                final String city = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CitySelection()),
                );
                if (city != null) {
                  _weatherBloc.dispatch(FetchWeather(city: city));
                }
              },
            )
          ],
        ),
        body: Center(
          child: BlocListener(
            bloc: _weatherBloc,
            listener: (BuildContext context, WeatherState state) {
              if (state is WeatherLoaded) {
                BlocProvider.of<ThemeBloc>(context).dispatch(
                    WeatherChanged(condition: state.weather.condition));
              }
              _refreshCompleter?.complete();
              _refreshCompleter = Completer();
            },
            child: BlocBuilder(
              bloc: _weatherBloc,
              builder: (_, WeatherState state) {
                if (state is WeatherEmpty) {
                  return Center(
                    child: Text('Please Select as Location'),
                  );
                }
                if (state is WeatherLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is WeatherLoaded) {
                  final weather = state.weather;
                  return BlocBuilder(
                    bloc: BlocProvider.of<ThemeBloc>(context),
                    builder: (_, ThemeState state) {
                      return GradientContainer(
                        color: state.color,
                        child: RefreshIndicator(
                          onRefresh: () {
                            _weatherBloc.dispatch(
                                RefreshWeather(city: weather.location));
                            return _refreshCompleter.future;
                          },
                          child: ListView(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(top: 100.0),
                                child: Center(
                                  child: Location(location: weather.location),
                                ),
                              ),
                              Center(
                                child:
                                    LastUpdated(dateTime: weather.lastUpdated),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 50.0),
                                child: Center(
                                  child: CombinedWeatherTemperature(
                                      weather: weather),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
                if (state is WeatherError) {
                  return Text(
                    'Something went wrong',
                    style: TextStyle(color: Colors.red),
                  );
                }
              },
            ),
          ),
        ),
      );

  @override
  void dispose() {
    _weatherBloc.dispose();
    super.dispose();
  }
}
