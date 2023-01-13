import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_text.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';
import 'package:reddit_clone/models/community_model.dart';
import 'package:routemaster/routemaster.dart';

class CommunityScreen extends ConsumerWidget {
  const CommunityScreen({
    super.key,
    required this.name,
  });

  final String name;

  void navigateToModtools(BuildContext context) {
    Routemaster.of(context).push('/mod-tools/$name');
  }

  void joinCommunity(WidgetRef ref, Community community, BuildContext context) {
    ref
        .read(communityControllerProvider.notifier)
        .joinCommunity(community, context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    return Scaffold(
        body: ref.watch(getCommunityByNameProvider(name)).when(
            data: (community) => NestedScrollView(
                headerSliverBuilder: (context, inneBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      expandedHeight: 150,
                      floating: true,
                      snap: true,
                      flexibleSpace: Stack(
                        children: [
                          Positioned.fill(
                              child: Image.network(community.banner,
                                  fit: BoxFit.cover))
                        ],
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.all(16),
                      sliver: SliverList(
                          delegate: SliverChildListDelegate([
                        Align(
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(
                              community.avatar,
                            ),
                            radius: 35,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'r/${community.name}',
                              style: const TextStyle(
                                  fontSize: 19, fontWeight: FontWeight.bold),
                            ),
                            community.mods.contains(user!.uuid)
                                ? OutlinedButton(
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25)),
                                    onPressed: () =>
                                        navigateToModtools(context),
                                    child: const Text('Mod tools'))
                                : OutlinedButton(
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25)),
                                    onPressed: () =>
                                        joinCommunity(ref, community, context),
                                    child: Text(
                                        community.members.contains(user!.uuid)
                                            ? 'Joined'
                                            : 'Join'))
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text('${community.members.length} members'),
                        ),
                      ])),
                    ),
                  ];
                },
                body: const Text("Displaying posts")),
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => const Loader()));
  }
}
