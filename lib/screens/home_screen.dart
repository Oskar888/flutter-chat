import 'package:darkchat_app/widgets/home_screen/bottomsheet_button.dart';
import 'package:darkchat_app/widgets/home_screen/chats_stream.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/auth_notifier.dart';
import '../utils/functions.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthNotifier>(context);
    final appbar = AppBar(
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
    );

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: appbar,
        body: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            SizedBox(
                height: (MediaQuery.of(context).size.height * 0.78 -
                    MediaQuery.of(context).padding.top),
                child: const ChatsStream()),
            const Expanded(child: BottomsheetButton())
          ],
        ),
      ),
    );
  }
}
