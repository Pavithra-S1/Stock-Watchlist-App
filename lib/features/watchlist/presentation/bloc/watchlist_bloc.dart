import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/watchlist_symbol.dart';
import '../../data/datasources/repositories/watchlist_repository.dart';
import 'watchlist_event.dart';
import 'watchlist_state.dart';

class WatchlistBloc extends Bloc<WatchlistEvent, WatchlistState> {
  final WatchlistRepository repository;
  final Map<String, List<WatchlistSymbol>> _symbolStorage = {};

  String _activeGroup = '';
  bool _editMode = false;

  WatchlistBloc(this.repository) : super(WatchlistInitial()) {
    on<LoadWatchlist>(_onLoadWatchlist);
    on<AddSymbolToWatchlist>(_onAddSymbol);
    on<ToggleEditMode>(_onToggleEditMode);
    on<ReorderSymbol>(_onReorderSymbol);
    on<RemoveSymbol>(_onRemoveSymbol);
  }

  Future<void> _onLoadWatchlist(
    LoadWatchlist event,
    Emitter<WatchlistState> emit,
  ) async {
    final symbols = await repository.getSymbolsByGroup(event.group);
    _activeGroup = event.group;
    _symbolStorage[_activeGroup] = List.from(symbols);
    _editMode = false;
    emit(WatchlistLoaded(
      symbols: _symbolStorage[_activeGroup]!,
      isEditMode: _editMode,
    ));
  }

  Future<void> _onAddSymbol(
    AddSymbolToWatchlist event,
    Emitter<WatchlistState> emit,
  ) async {
    final currentList = _symbolStorage[event.group] ?? [];
    final exists = currentList.any((s) => s.name == event.symbol.name);

    if (!exists) {
      currentList.add(event.symbol);
      _symbolStorage[event.group] = currentList;
      await repository.saveSymbolsToGroup(event.group, currentList);
      emit(WatchlistLoaded(
        symbols: List.from(currentList),
        isEditMode: _editMode,
      ));
    }
  }

  void _onToggleEditMode(
    ToggleEditMode event,
    Emitter<WatchlistState> emit,
  ) {
    _editMode = !_editMode;
    final currentList = _symbolStorage[_activeGroup] ?? [];
    emit(WatchlistLoaded(
      symbols: List.from(currentList),
      isEditMode: _editMode,
    ));
  }

  Future<void> _onReorderSymbol(
    ReorderSymbol event,
    Emitter<WatchlistState> emit,
  ) async {
    final list = _symbolStorage[_activeGroup];
    if (list == null || event.oldIndex == event.newIndex) return;

    final updated = List<WatchlistSymbol>.from(list);
    final movedItem = updated.removeAt(event.oldIndex);
    updated.insert(
      event.newIndex > event.oldIndex ? event.newIndex - 1 : event.newIndex,
      movedItem,
    );

    _symbolStorage[_activeGroup] = updated;
    await repository.saveSymbolsToGroup(_activeGroup, updated);

    emit(WatchlistLoaded(
      symbols: List.from(updated),
      isEditMode: _editMode,
    ));
  }

  Future<void> _onRemoveSymbol(
    RemoveSymbol event,
    Emitter<WatchlistState> emit,
  ) async {
    final list = _symbolStorage[_activeGroup];
    if (list == null || event.index >= list.length) return;

    final updated = List<WatchlistSymbol>.from(list)..removeAt(event.index);
    _symbolStorage[_activeGroup] = updated;
    await repository.saveSymbolsToGroup(_activeGroup, updated);

    emit(WatchlistLoaded(
      symbols: updated,
      isEditMode: _editMode,
    ));
  }
}
