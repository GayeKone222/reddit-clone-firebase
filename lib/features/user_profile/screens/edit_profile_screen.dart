import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_text.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/user_profile/controller/user_profile_controller.dart';
import 'package:reddit_clone/responsive/responsive.dart';
import 'package:reddit_clone/theme/pallete.dart';

import '../../../core/utils.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key, required this.uid});

  final String uid;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  File? bannerFile;
  File? avatarFile;
  late TextEditingController nameController;
  Uint8List? bannerWebFile;
  Uint8List? avatarWebFile;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController = TextEditingController(text: ref.read(userProvider)!.name);
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void selectBannerImage() async {
    final res = await pickImage();

    if (res != null) {
      if (kIsWeb) {
        setState(() {
          bannerWebFile = res.files.first.bytes;
        });
      } else {
        setState(() {
          bannerFile = File(res.files.first.path!);
        });
      }
    }
  }

  void selectAvatarImage() async {
    final res = await pickImage();

    if (res != null) {
      if (kIsWeb) {
        setState(() {
          avatarWebFile = res.files.first.bytes;
        });
      } else {
        setState(() {
          avatarFile = File(res.files.first.path!);
        });
      }
    }
  }

  void save() {
    ref.read(userProfileControllerProvider.notifier).editUserProfile(
        bannerFile: bannerFile,
        avatarFile: avatarFile,
        bannerWebFile: bannerWebFile,
        avatarWebFile: avatarWebFile,
        context: context,
        name: nameController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(userProfileControllerProvider);
    final currentTheme = ref.watch(themeNotifierProvider);
    return ref.watch(getUserDataProvider(widget.uid)).when(
        data: (user) => Scaffold(
              backgroundColor: currentTheme.backgroundColor,
              appBar: AppBar(
                title: const Text('Edit Profile'),
                centerTitle: false,
                actions: [
                  TextButton(onPressed: () => save(), child: const Text('Save'))
                ],
              ),
              body: isLoading
                  ? const Loader()
                  : Responsive(
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 200,
                              child: Stack(
                                children: [
                                  GestureDetector(
                                    onTap: () => selectBannerImage(),
                                    child: DottedBorder(
                                      borderType: BorderType.RRect,
                                      radius: const Radius.circular(10),
                                      dashPattern: const [10, 4],
                                      strokeCap: StrokeCap.round,
                                      color: currentTheme
                                          .textTheme.bodyText2!.color!,
                                      child: Container(
                                        width: double.infinity,
                                        height: 150,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: bannerWebFile != null
                                            ? Image.memory(bannerWebFile!)
                                            : bannerFile != null
                                                ? Image.file(bannerFile!)
                                                : user.banner.isEmpty ||
                                                        user.banner ==
                                                            Constants
                                                                .bannerDefault
                                                    ? const Center(
                                                        child: Icon(
                                                          Icons
                                                              .camera_alt_outlined,
                                                          size: 40,
                                                        ),
                                                      )
                                                    : Image.network(user.banner),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                      bottom: 20,
                                      left: 20,
                                      child: GestureDetector(
                                        onTap: () => selectAvatarImage(),
                                        child: avatarWebFile != null
                                            ? CircleAvatar(
                                                backgroundImage:
                                                    MemoryImage(avatarWebFile!),
                                                radius: 32,
                                              )
                                            : avatarFile != null
                                                ? CircleAvatar(
                                                    backgroundImage:
                                                        FileImage(avatarFile!),
                                                    radius: 32,
                                                  )
                                                : CircleAvatar(
                                                    backgroundImage: NetworkImage(
                                                        user.profilePic),
                                                    radius: 32,
                                                  ),
                                      ))
                                ],
                              ),
                            ),
                            TextField(
                              controller: nameController,
                              decoration: InputDecoration(
                                  filled: true,
                                  hintText: 'Name',
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.blue),
                                      borderRadius: BorderRadius.circular(10)),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.all(18)),
                            )
                          ],
                        ),
                      ),
                  ),
            ),
        error: (error, stackTrace) => ErrorText(error: error.toString()),
        loading: () => const Loader());
  }
}
