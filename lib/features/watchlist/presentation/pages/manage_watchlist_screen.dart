import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/manage_watchlist_bloc.dart';
import '../bloc/manage_watchlist_event.dart';
import '../bloc/manage_watchlist_state.dart';

class ManageWatchlistsScreen extends StatelessWidget {
  const ManageWatchlistsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ManageWatchlistsBloc()..add(LoadWatchlists()),
      child: const ManageWatchlistsView(),
    );
  }
}

class ManageWatchlistsView extends StatelessWidget {
  const ManageWatchlistsView({super.key});

  void _showRenameDialog(BuildContext context, int index, String currentName) {
    final controller = TextEditingController(text: currentName);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text('Rename Watchlist'),
        content: TextField(
          controller: controller,
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          decoration: const InputDecoration(hintText: 'Enter new name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<ManageWatchlistsBloc>().add(
                    RenameWatchlistGroup(index: index, newName: controller.text.trim()),
                  );
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text('New Watchlist'),
        content: TextField(
          controller: controller,
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          decoration: const InputDecoration(hintText: 'Watchlist name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<ManageWatchlistsBloc>().add(
                    AddWatchlistGroup(controller.text.trim()),
                  );
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onBackground;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.background,
        title: const Text('Manage Watchlist'),
        foregroundColor: textColor,
      ),
      body: BlocBuilder<ManageWatchlistsBloc, ManageWatchlistsState>(
        builder: (context, state) {
          if (state is ManageWatchlistsLoaded) {
            return ListView(
              children: [
                const SizedBox(height: 12),
                ReorderableListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.groups.length,
                  onReorder: (oldIndex, newIndex) {
                    context.read<ManageWatchlistsBloc>().add(
                          ReorderWatchlistGroups(
                            oldIndex: oldIndex,
                            newIndex: newIndex,
                          ),
                        );
                  },
                  itemBuilder: (context, index) {
                    final group = state.groups[index];
                    return ListTile(
                      key: ValueKey(group),
                      leading: Icon(Icons.drag_handle, color: textColor),
                      title: Text(
                        group,
                        style: TextStyle(color: textColor, fontSize: 16),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _showRenameDialog(context, index, group),
                            color: textColor.withOpacity(0.7),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              context.read<ManageWatchlistsBloc>().add(
                                    DeleteWatchlistGroup(index),
                                  );
                            },
                            color: Colors.redAccent,
                          ),
                        ],
                      ),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextButton.icon(
                    onPressed: () => _showAddDialog(context),
                    icon: const Icon(Icons.add, color: Colors.greenAccent),
                    label: const Text(
                      'Add Watchlist',
                      style: TextStyle(color: Colors.greenAccent),
                    ),
                  ),
                ),
                Divider(color: textColor.withOpacity(0.2)),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Customize Watchlist View',
                    style: TextStyle(
                      color: textColor.withOpacity(0.7),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ...List.generate(3, (i) => _buildStockTile(context)),
              ],
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildStockTile(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = theme.colorScheme.surface;
    final textColor = theme.colorScheme.onSurface;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white10),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(12),
          title: Text(
            'SYMBOL',
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text('NSE   📦  50', style: TextStyle(color: textColor.withOpacity(0.6))),
              const SizedBox(height: 4),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: '656 ', style: TextStyle(color: Colors.greenAccent)),
                    const TextSpan(text: '@ 1629.55  '),
                    TextSpan(text: '60 ', style: TextStyle(color: Colors.redAccent)),
                    const TextSpan(text: '@ 1629.55'),
                  ],
                ),
                style: TextStyle(color: textColor),
              ),
            ],
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text('2031.95', style: TextStyle(color: Colors.redAccent, fontSize: 16)),
              SizedBox(height: 4),
              Text('-9.95 (0.49%)', style: TextStyle(color: Colors.white54, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}