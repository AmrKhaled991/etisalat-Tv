import 'package:etisalatdemotv/core/utils/duration_formatter.dart';
import 'package:etisalatdemotv/core/widgets/phone_seek_bar.dart';
import 'package:etisalatdemotv/features/video/presentation/view/phone/widgets/phone_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HorizontalDisplaying extends StatefulWidget {
  const HorizontalDisplaying({super.key});

  @override
  State<HorizontalDisplaying> createState() => _HorizontalDisplayingState();
}

class _HorizontalDisplayingState extends State<HorizontalDisplaying> {
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        children: [
          Expanded(child: const PhoneSeekBar()),
          IconButton(
            onPressed: () {
              if (context.isLandscape) {
                SystemChrome.setPreferredOrientations([
                  DeviceOrientation.portraitUp,
                ]);
                SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
              } else {
                SystemChrome.setPreferredOrientations([
                  DeviceOrientation.landscapeLeft,
                  DeviceOrientation.landscapeRight,
                ]);
                SystemChrome.setEnabledSystemUIMode(
                  SystemUiMode.immersiveSticky,
                );
              }
            },
            padding: EdgeInsets.all(4),
            icon: Icon(Icons.screen_rotation_outlined, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
