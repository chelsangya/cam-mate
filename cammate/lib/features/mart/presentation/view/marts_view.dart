import 'package:cammate/core/common/appbar/my_custom_appbar.dart';
import 'package:cammate/features/mart/presentation/view/create_mart_view.dart';
import 'package:cammate/features/mart/presentation/view/mart_detail_view.dart';
import 'package:cammate/features/mart/presentation/view_model/mart_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MartsView extends ConsumerStatefulWidget {
  const MartsView({super.key});

  @override
  ConsumerState<MartsView> createState() => _MartsViewState();
}

class _MartsViewState extends ConsumerState<MartsView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(martViewModelProvider.notifier).fetchAllMarts(context));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async => ref.read(martViewModelProvider.notifier).fetchAllMarts(context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      appBar: myCustomAppBar(context, 'Marts'),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateMartView()));
          // refresh after returning in case a new mart was created
          ref.read(martViewModelProvider.notifier).fetchAllMarts(context);
        },
        tooltip: 'Create Mart',
        elevation: 4,
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
          child: Column(
            children: [
              Expanded(
                child: Consumer(
                  builder: (context, ref2, _) {
                    final state = ref2.watch(martViewModelProvider);

                    if (state.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    // If the viewmodel set a message flag, show a one-time snackbar and clear it.
                    if (state.showMessage == true && state.message != null) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(state.message!)));
                        ref.read(martViewModelProvider.notifier).resetMessage(false);
                      });
                    }

                    final allMarts = state.marts;
                    final query = _searchController.text.trim().toLowerCase();
                    final marts =
                        query.isEmpty
                            ? allMarts
                            : allMarts.where((m) {
                              final name = m.name.toLowerCase();
                              final address = (m.address ?? '').toLowerCase();
                              final description = (m.description ?? '').toLowerCase();
                              return name.contains(query) ||
                                  address.contains(query) ||
                                  description.contains(query);
                            }).toList();

                    return RefreshIndicator(
                      onRefresh: _refresh,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: 1 + (marts.isEmpty ? 1 : marts.length),
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            // search bar at the top
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.03),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                child: Row(
                                  children: [
                                    const Icon(Icons.search, color: Colors.black45),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: TextField(
                                        controller: _searchController,
                                        decoration: const InputDecoration(
                                          hintText: 'Search marts by name or address',
                                          border: InputBorder.none,
                                          isDense: true,
                                        ),
                                        onChanged: (_) => setState(() {}),
                                      ),
                                    ),
                                    if (_searchController.text.isNotEmpty)
                                      IconButton(
                                        onPressed: () => setState(() => _searchController.clear()),
                                        icon: const Icon(Icons.clear, color: Colors.black45),
                                      )
                                    else
                                      IconButton(
                                        onPressed:
                                            () => ref
                                                .read(martViewModelProvider.notifier)
                                                .fetchAllMarts(context),
                                        icon: const Icon(Icons.refresh, color: Colors.black54),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          }

                          if (marts.isEmpty) {
                            return Column(
                              children: const [
                                SizedBox(height: 40),
                                Center(
                                  child: Icon(Icons.storefront, size: 56, color: Colors.black12),
                                ),
                                SizedBox(height: 12),
                                Center(
                                  child: Text(
                                    'No marts yet',
                                    style: TextStyle(color: Colors.black54, fontSize: 16),
                                  ),
                                ),
                              ],
                            );
                          }

                          final mart = marts[index - 1];

                          return Dismissible(
                            key: ValueKey(mart.id ?? mart.name),
                            direction:
                                mart.id != null
                                    ? DismissDirection.endToStart
                                    : DismissDirection.none,
                            background: Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.only(left: 20),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.delete, color: Colors.red),
                            ),
                            secondaryBackground: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              decoration: BoxDecoration(
                                color: Colors.red.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.delete, color: Colors.red),
                            ),
                            confirmDismiss: (direction) async {
                              if (mart.id == null) return false;
                              final confirmed = await showDialog<bool>(
                                context: context,
                                barrierDismissible: false,
                                builder:
                                    (ctx) => AlertDialog(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                                      actionsPadding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      title: const Text('Delete mart'),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const SizedBox(height: 4),
                                          Icon(
                                            Icons.delete_forever,
                                            size: 48,
                                            color: Colors.redAccent,
                                          ),
                                          const SizedBox(height: 12),
                                          Text(
                                            'Delete "${mart.name}"? This action cannot be undone.',
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(ctx, false),
                                          child: const Text('Cancel'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () => Navigator.pop(ctx, true),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.redAccent,
                                            foregroundColor: Colors.white,
                                            shape: const StadiumBorder(),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 18,
                                              vertical: 12,
                                            ),
                                          ),
                                          child: const Text('Delete'),
                                        ),
                                      ],
                                    ),
                              );

                              if (confirmed != true) return false;

                              // call delete on viewmodel and only dismiss if success
                              final success = await ref
                                  .read(martViewModelProvider.notifier)
                                  .deleteMart(mart.id!, context);
                              return success;
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.03),
                                    blurRadius: 4,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap:
                                    () => Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (_) => MartDetailView(mart: mart)),
                                    ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 26,
                                        backgroundColor: Colors.blue.shade50,
                                        child: Text(
                                          (mart.name.isNotEmpty ? mart.name[0].toUpperCase() : '?'),
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              mart.name,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              mart.address ?? mart.description ?? '',
                                              style: const TextStyle(color: Colors.black54),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 6),
                                            Row(
                                              children: [
                                                if ((mart.contactEmail ?? '').isNotEmpty)
                                                  Text(
                                                    mart.contactEmail ?? '',
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.black45,
                                                    ),
                                                  ),
                                                const Spacer(),
                                                Text(
                                                  mart.isActive == true ? 'Active' : 'Inactive',
                                                  style: TextStyle(
                                                    color:
                                                        mart.isActive == true
                                                            ? Colors.green
                                                            : Colors.red,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Icon(Icons.chevron_right, color: Color(0xFF0B2B3D)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
