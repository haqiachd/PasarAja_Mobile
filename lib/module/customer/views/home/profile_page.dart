import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pasaraja_mobile/config/themes/Typography.dart';
import 'package:pasaraja_mobile/config/widgets/action_button.dart';
import 'package:pasaraja_mobile/config/widgets/image_network_error.dart';
import 'package:pasaraja_mobile/config/widgets/image_network_placeholder.dart';
import 'package:pasaraja_mobile/config/widgets/loading_indicator.dart';
import 'package:pasaraja_mobile/config/widgets/page_error_message.dart';
import 'package:pasaraja_mobile/config/widgets/something_wrong.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/sources/provider_state.dart';
import 'package:pasaraja_mobile/module/customer/provider/home/profile_provider.dart';
import 'package:pasaraja_mobile/module/customer/widgets/customer_sub_appbar.dart';
import 'package:provider/provider.dart';


/// Customer Profile Page
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      try {
        await context.read<ProfileCustomerProvider>().fetchData();
      } catch (ex) {
        Fluttertoast.showToast(msg: PasarAjaConstant.unknownError);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: customerSubAppbar('Profil'),
      body: Consumer<ProfileCustomerProvider>(
        builder: (context, profile, child) {
          if (profile.state is OnLoadingState) {
            return const LoadingIndicator();
          }

          if (profile.state is OnFailureState) {
            return PageErrorMessage(
              onFailureState: profile.state as OnFailureState,
            );
          }

          if (profile.state is OnSuccessState) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    Stack(
                      children: [
                        // photo profile
                        _buildPhotoProfile(profile),
                        _buildEditProfile(),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Text(
                      profile.fullName,
                      style: PasarAjaTypography.sfpdBold.copyWith(
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      profile.email,
                      style: PasarAjaTypography.sfpdBold.copyWith(
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      profile.phoneNumber,
                      style: PasarAjaTypography.sfpdBold.copyWith(
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 50),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 3,
                          child: _buildButtonEdit(),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 3,
                          child: _buildButtonLogout(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }

          return const SomethingWrong();
        },
      ),
    );
  }

  Future<dynamic> _showSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return SizedBox(
          height: 150,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildPickPhotoFromCamera(),
              const SizedBox(width: 15),
              _buildPickPhotoFromGalery(),
              const SizedBox(width: 15),
              _buildDeletePhoto(),
            ],
          ),
        );
      },
    );
  }

  _buildPickPhotoFromGalery() {
    return Consumer<ProfileCustomerProvider>(
      builder: (context, prov, child) {
        return FloatingActionButton(
          onPressed: () async {
            Get.back();
            await prov.photoPicker(ImageSource.gallery);
          },
          backgroundColor: Colors.purple,
          heroTag: 'galery',
          child: const Icon(
            Icons.image_outlined,
            color: Colors.white,
          ),
        );
      },
    );
  }

  _buildPickPhotoFromCamera() {
    return Consumer<ProfileCustomerProvider>(
      builder: (context, prov, child) {
        return FloatingActionButton(
          onPressed: () async {
            Get.back();
            await prov.photoPicker(ImageSource.camera);
          },
          backgroundColor: Colors.black,
          heroTag: 'camera',
          child: const Icon(
            Icons.camera_alt_outlined,
            color: Colors.white,
          ),
        );
      },
    );
  }

  _buildDeletePhoto() {
    return Consumer<ProfileCustomerProvider>(
      builder: (context, prov, child) {
        if (!prov.photoProfile.contains('profile.png')) {
          return FloatingActionButton(
            onPressed: () async {
              Get.back();
              await prov.deletePhoto();
            },
            backgroundColor: Colors.redAccent,
            heroTag: 'hapus',
            child: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          );
        } else {
          return const Material();
        }
      },
    );
  }

  Align _buildPhotoProfile(ProfileCustomerProvider profile) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        height: 150,
        width: 150,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(150),
          child: CachedNetworkImage(
            imageUrl: profile.photoProfile,
            placeholder: (context, str) {
              return const ImageNetworkPlaceholder();
            },
            errorWidget: (context, str, obj) {
              return const ImageErrorNetwork();
            },
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Positioned _buildEditProfile() {
    return Positioned(
      bottom: 0,
      right: 0,
      left: 100,
      child: SizedBox(
        width: 30,
        height: 30,
        child: InkWell(
          onTap: () {
            _showSheet(context);
          },
          child: const Material(
            color: Colors.blueGrey,
            shape: CircleBorder(),
            elevation: 7,
            child: Icon(
              Icons.edit,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  _buildButtonEdit() {
    return Consumer<ProfileCustomerProvider>(
      builder: (context, provider, child) {
        return ActionButton(
          onPressed: ()  {
            provider.onButtonEditPressed();
          },
          title: 'Edit Akun',
          state: ActionButton.stateEnabledButton,
        );
      },
    );
  }

  _buildButtonLogout() {
    return Consumer<ProfileCustomerProvider>(
      builder: (context, provider, child) {
        return ActionButton(
          onPressed: () async {
            await provider.logout();
          },
          title: 'Logout',
          state: ActionButton.stateEnabledButton,
        );
      },
    );
  }
}
