import 'package:counting/cubit/counter_cubit.dart';
import 'package:counting/cubit/counter_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() => runApp(const PointerCounterState());

class PointerCounterState extends StatelessWidget {
  const PointerCounterState({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CounterCubit(CounterState()),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CounterCubit, CounterState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('points counter'),
            backgroundColor: Colors.orange,
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 500,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text(
                          'Team A',
                          style: TextStyle(fontSize: 40),
                        ),
                        Text(
                          '${BlocProvider.of<CounterCubit>(context).teamAPoints}',
                          style: const TextStyle(fontSize: 150),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            BlocProvider.of<CounterCubit>(context)
                                .teamIncrement(team: 'A', buttomNumber: 1);
                          },
                          // ignore: sort_child_properties_last
                          child: const Text(
                            'Add 1 point',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            minimumSize: const Size(140, 45),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            BlocProvider.of<CounterCubit>(context)
                                .teamIncrement(team: 'A', buttomNumber: 2);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            minimumSize: const Size(140, 45),
                          ),
                          child: const Text(
                            'Add 2 point',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            BlocProvider.of<CounterCubit>(context)
                                .teamIncrement(team: 'A', buttomNumber: 3);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            minimumSize: const Size(140, 45),
                          ),
                          child: const Text(
                            'Add 3 point',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 500,
                    child: VerticalDivider(
                      endIndent: 50,
                      thickness: 2,
                      color: Color.fromARGB(255, 211, 211, 211),
                    ),
                  ),
                  SizedBox(
                    height: 500,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text(
                          'Team B',
                          style: TextStyle(fontSize: 40),
                        ),
                        Text(
                          '${BlocProvider.of<CounterCubit>(context).teamBPoints}',
                          style: const TextStyle(fontSize: 150),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            BlocProvider.of<CounterCubit>(context)
                                .teamIncrement(team: 'B', buttomNumber: 1);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            minimumSize: const Size(140, 45),
                          ),
                          child: const Text(
                            'Add 1 point',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            BlocProvider.of<CounterCubit>(context)
                                .teamIncrement(team: 'B', buttomNumber: 2);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            minimumSize: const Size(140, 45),
                          ),
                          child: const Text(
                            'Add 2 point',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            BlocProvider.of<CounterCubit>(context)
                                .teamIncrement(team: 'B', buttomNumber: 3);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            minimumSize: const Size(140, 45),
                          ),
                          child: const Text(
                            'Add 3 point',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  BlocProvider.of<CounterCubit>(context).setPoints();
                },
                // ignore: sort_child_properties_last
                child: const Text(
                  'Reset',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  minimumSize: const Size(140, 45),
                ),
              ),
            ],
          ),
        );
      },
      listener: (context, state) {},
    );
  }
}
