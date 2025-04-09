import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../../watchlist/domain/entities/watchlist_symbol.dart';
import '../../../watchlist/data/datasources/watchlist_local_data_source.dart';
import '../../../watchlist/data/repositories/watchlist_repository_impl.dart';
import '../../../watchlist/presentation/bloc/watchlist_bloc.dart';
import '../../../watchlist/presentation/bloc/watchlist_event.dart';
import '../../../watchlist/presentation/bloc/watchlist_state.dart';
import '../../../search/presentation/pages/search_screen.dart';
import '../../../watchlist/presentation/pages/manage_watchlist_screen.dart';

class WatchlistScreen extends StatelessWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) =>
              WatchlistBloc(WatchlistRepositoryImpl(WatchlistLocalDataSource()))
                ..add(LoadWatchlist('Watchlist 1')),
      child: const WatchlistView(),
    );
  }
}

class WatchlistView extends StatefulWidget {
  const WatchlistView({super.key});

  @override
  State<WatchlistView> createState() => _WatchlistViewState();
}

class _WatchlistViewState extends State<WatchlistView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = [
    'Watchlist 1',
    'Watchlist 2',
    'NIFTY',
    'BANKNIFTY',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        context.read<WatchlistBloc>().add(
          LoadWatchlist(_tabs[_tabController.index]),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Watchlist'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.green,
          tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      final selectedGroup = _tabs[_tabController.index];
                      final watchlistBloc = context.read<WatchlistBloc>();

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => BlocProvider.value(
                                value: watchlistBloc,
                                child: SearchScreen(group: selectedGroup),
                              ),
                        ),
                      );
                    },
                    child: AbsorbPointer(
                      child: TextField(
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: 'Search & Add',
                          hintStyle: const TextStyle(color: Colors.white60),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                          filled: true,
                          fillColor: const Color(0xFF1C1C1C),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.settings, color: Colors.white70),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ManageWatchlistsScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<WatchlistBloc, WatchlistState>(
              builder: (context, state) {
                if (state is WatchlistLoaded) {
                  if (state.isEditMode) {
                    return ReorderableListView.builder(
                      itemCount: state.symbols.length,
                      onReorder: (oldIndex, newIndex) {
                        context.read<WatchlistBloc>().add(
                          ReorderSymbol(oldIndex: oldIndex, newIndex: newIndex),
                        );
                      },
                      itemBuilder: (context, index) {
                        final symbol = state.symbols[index];
                        return ListTile(
                          key: ValueKey(symbol.name),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          title: Text(
                            symbol.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            symbol.exchange,
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Colors.redAccent,
                            ),
                            onPressed: () {
                              context.read<WatchlistBloc>().add(
                                RemoveSymbol(index),
                              );
                            },
                          ),
                        );
                      },
                    );
                  } else {
                    return ListView.builder(
                      itemCount: state.symbols.length,
                      itemBuilder: (context, index) {
                        final symbol = state.symbols[index];
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          onLongPress: () {
                            context.read<WatchlistBloc>().add(ToggleEditMode());
                          },
                          title: Text(
                            symbol.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            symbol.exchange,
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                          trailing: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '₹${symbol.price.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: Colors.greenAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '+${symbol.change.toStringAsFixed(2)} (${symbol.percent.toStringAsFixed(2)}%)',
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              '4 / 50 Stocks',
              style: TextStyle(color: Colors.white54, fontSize: 12),
            ),
          ),
        ],
      ),
      
      floatingActionButton: BlocBuilder<WatchlistBloc, WatchlistState>(
        builder: (context, state) {
          if (state is WatchlistLoaded) {
            return Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 60), // Adjust height as needed
          child: FloatingActionButton.extended(
            onPressed: () {
              context.read<WatchlistBloc>().add(ToggleEditMode());
            },
            backgroundColor: const Color(0xFF1C1C1C),
            foregroundColor: Colors.greenAccent,
            icon: Icon(state.isEditMode ? Icons.check : Icons.edit),
            label: Text(state.isEditMode ? 'Done' : 'Edit Watchlist'),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  },
),
      
    );
  }
}
