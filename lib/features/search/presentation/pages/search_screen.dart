import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../watchlist/domain/entities/watchlist_symbol.dart';
import '../../data/datasources/search_local_data_source.dart';
import '../bloc/search_bloc.dart';
import '../bloc/search_event.dart';
import '../bloc/search_state.dart';
import '../../../watchlist/presentation/bloc/watchlist_bloc.dart';
import '../../../watchlist/presentation/bloc/watchlist_event.dart';

class SearchScreen extends StatelessWidget {
  final String group;

  const SearchScreen({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchBloc(SearchLocalDataSource())..add(SearchQueryChanged('')),
      child: SearchView(group: group),
    );
  }
}

class SearchView extends StatelessWidget {
  final String group;

  const SearchView({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<SearchBloc>();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Search'),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              onChanged: (query) => bloc.add(SearchQueryChanged(query)),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search Stocks',
                hintStyle: const TextStyle(color: Colors.white60),
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                filled: true,
                fillColor: const Color(0xFF1C1C1C),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                if (state is SearchLoaded) {
                  return ListView.builder(
                    itemCount: state.results.length,
                    itemBuilder: (context, index) {
                      final symbol = state.results[index];
                      return ListTile(
                        title: Text(
                          symbol.name,
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          symbol.exchange,
                          style: const TextStyle(color: Colors.white60),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.add, color: Colors.greenAccent),
                          onPressed: () {
                            final watchlistBloc = context.read<WatchlistBloc>();

                            watchlistBloc.add(
                              AddSymbolToWatchlist(
                                group: group,
                                symbol: WatchlistSymbol(
                                  name: symbol.name,
                                  exchange: symbol.exchange,
                                  price: 1000,
                                  change: 5.5,
                                  percent: 1.23,
                                ),
                              ),
                            );

                            Navigator.pop(context);
                          },
                        ),
                      );
                    },
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }
}