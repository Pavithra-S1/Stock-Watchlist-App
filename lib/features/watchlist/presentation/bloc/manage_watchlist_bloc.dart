import 'package:flutter_bloc/flutter_bloc.dart';
import 'manage_watchlist_event.dart';
import 'manage_watchlist_state.dart';

class ManageWatchlistsBloc extends Bloc<ManageWatchlistsEvent, ManageWatchlistsState> {
  final List<String> _groups = ['Watchlist 1', 'Watchlsit 2', 'NIFTY', 'BANKNIFTY'];

  ManageWatchlistsBloc() : super(ManageWatchlistsInitial()) {
    on<LoadWatchlists>(_onLoad);
    on<AddWatchlistGroup>(_onAddGroup);
    on<RenameWatchlistGroup>(_onRenameGroup);
    on<DeleteWatchlistGroup>(_onDeleteGroup);
    on<ReorderWatchlistGroups>(_onReorderGroups);
  }

  void _onLoad(LoadWatchlists event, Emitter<ManageWatchlistsState> emit) {
    emit(ManageWatchlistsLoaded(List.from(_groups)));
  }

  void _onAddGroup(AddWatchlistGroup event, Emitter<ManageWatchlistsState> emit) {
    _groups.add(event.name);
    emit(ManageWatchlistsLoaded(List.from(_groups)));
  }

  void _onRenameGroup(RenameWatchlistGroup event, Emitter<ManageWatchlistsState> emit) {
    if (event.index < _groups.length) {
      _groups[event.index] = event.newName;
      emit(ManageWatchlistsLoaded(List.from(_groups)));
    }
  }

  void _onDeleteGroup(DeleteWatchlistGroup event, Emitter<ManageWatchlistsState> emit) {
    if (event.index < _groups.length) {
      _groups.removeAt(event.index);
      emit(ManageWatchlistsLoaded(List.from(_groups)));
    }
  }

  void _onReorderGroups(ReorderWatchlistGroups event, Emitter<ManageWatchlistsState> emit) {
    if (event.oldIndex == event.newIndex) return;
    final moved = _groups.removeAt(event.oldIndex);
    _groups.insert(event.newIndex > event.oldIndex ? event.newIndex - 1 : event.newIndex, moved);
    emit(ManageWatchlistsLoaded(List.from(_groups)));
  }
}
