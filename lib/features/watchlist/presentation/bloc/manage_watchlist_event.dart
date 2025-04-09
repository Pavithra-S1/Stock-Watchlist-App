abstract class ManageWatchlistsEvent {}

class LoadWatchlists extends ManageWatchlistsEvent {}

class AddWatchlistGroup extends ManageWatchlistsEvent {
  final String name;

  AddWatchlistGroup(this.name);
}

class RenameWatchlistGroup extends ManageWatchlistsEvent {
  final int index;
  final String newName;

  RenameWatchlistGroup({required this.index, required this.newName});
}

class DeleteWatchlistGroup extends ManageWatchlistsEvent {
  final int index;

  DeleteWatchlistGroup(this.index);
}

class ReorderWatchlistGroups extends ManageWatchlistsEvent {
  final int oldIndex;
  final int newIndex;

  ReorderWatchlistGroups({required this.oldIndex, required this.newIndex});
}
