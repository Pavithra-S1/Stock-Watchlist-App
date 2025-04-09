abstract class ManageWatchlistsState {}

class ManageWatchlistsInitial extends ManageWatchlistsState {}

class ManageWatchlistsLoaded extends ManageWatchlistsState {
  final List<String> groups;

  ManageWatchlistsLoaded(this.groups);
}
