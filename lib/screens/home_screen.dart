import 'package:darkchat_app/widgets/home_screen/bottomsheet_button.dart';
import 'package:darkchat_app/widgets/home_screen/chats_stream.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/provider/auth_notifier.dart';
import '../utils/functions.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthNotifier>(context);

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            titleSpacing: 0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(onPressed: () => (null), child: const Text('Edit')),
                Text('Hi! ${getMyUsername()}'),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.camera_alt_outlined),
                      onPressed: () {},
                    ),
                    IconButton(
                        icon: const Icon(Icons.logout_outlined),
                        onPressed: () {
                          auth.logout();
                        }),
                  ],
                ),
              ],
            ),
          ),
          body: SizedBox(
            height: MediaQuery.of(context).size.height * 0.85,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Row(
                      children: const [
                        Text('Chats',
                            style: TextStyle(
                                fontSize: 40,
                                color: Colors.white,
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const ChatsStream(),
                  ],
                ),
                const BottomsheetButton(),
              ],
            ),
          )),
    );
  }
}
