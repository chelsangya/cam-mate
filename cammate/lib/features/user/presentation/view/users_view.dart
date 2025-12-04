import 'package:cammate/core/common/appbar/my_custom_appbar.dart';
import 'package:cammate/features/user/presentation/view/create_user_view.dart';
import 'package:cammate/features/user/presentation/view/user_detail_view.dart';
import 'package:cammate/features/user/presentation/view_model/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UsersView extends ConsumerStatefulWidget {
  const UsersView({super.key});

  @override
  ConsumerState<UsersView> createState() => _UsersViewState();
}

class _UsersViewState extends ConsumerState<UsersView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(userViewModelProvider.notifier).fetchAllUsers());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async => ref.read(userViewModelProvider.notifier).fetchAllUsers();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      appBar: myCustomAppBar(context, 'Users'),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateUserView()));
          // refresh after returning in case a new user was created
          ref.read(userViewModelProvider.notifier).fetchAllUsers();
        },
        tooltip: 'Create User',
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
                    final state = ref2.watch(userViewModelProvider);

                    if (state.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    // If the viewmodel set a message flag, show a one-time snackbar and clear it.
                    if (state.showMessage == true && state.message != null) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(state.message!)));
                        ref.read(userViewModelProvider.notifier).resetMessage(false);
                      });
                    }

                    final allUsers = state.users;
                    final query = _searchController.text.trim().toLowerCase();
                    final users =
                        query.isEmpty
                            ? allUsers
                            : allUsers.where((m) {
                              final name = ('${m.firstName} ${m.lastName}').toLowerCase();
                              final email = m.email.toLowerCase();
                              final role = m.role.toLowerCase();
                              return name.contains(query) ||
                                  email.contains(query) ||
                                  role.contains(query);
                            }).toList();

                    return RefreshIndicator(
                      onRefresh: _refresh,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: 1 + (users.isEmpty ? 1 : users.length),
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
                                          hintText: 'Search users by name or address',
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
                                            () =>
                                                ref
                                                    .read(userViewModelProvider.notifier)
                                                    .fetchAllUsers(),
                                        icon: const Icon(Icons.refresh, color: Colors.black54),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          }

                          if (users.isEmpty) {
                            return Column(
                              children: const [
                                SizedBox(height: 40),
                                Center(
                                  child: Icon(Icons.storefront, size: 56, color: Colors.black12),
                                ),
                                SizedBox(height: 12),
                                Center(
                                  child: Text(
                                    'No users yet',
                                    style: TextStyle(color: Colors.black54, fontSize: 16),
                                  ),
                                ),
                              ],
                            );
                          }

                          final user = users[index - 1];

                          // Deletion from the UI is not supported. Show a non-dismissible row.
                          return Container(
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
                                    MaterialPageRoute(builder: (_) => UserDetailView(user: user)),
                                  ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 26,
                                      backgroundColor: Colors.blue.shade50,
                                      child: Text(
                                        (('${user.firstName} ${user.lastName}').trim().isNotEmpty
                                            ? ('${user.firstName} ${user.lastName}')
                                                .trim()[0]
                                                .toUpperCase()
                                            : '?'),
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
                                            '${user.firstName} ${user.lastName}',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            user.email,
                                            style: const TextStyle(color: Colors.black54),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 6),
                                          Row(
                                            children: [
                                              Text(
                                                user.role,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black45,
                                                ),
                                              ),
                                              const Spacer(),
                                              Text(
                                                user.isActive == true ? 'Active' : 'Inactive',
                                                style: TextStyle(
                                                  color:
                                                      user.isActive == true
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
