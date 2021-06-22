import 'package:flutter/material.dart';

class ToggleFlashButton extends StatelessWidget {
  const ToggleFlashButton({
    Key? key,
    @required this.toggleFlash,
    @required this.flashIsOn,
  }) : super(key: key);

  final  ToggleFlashCallBack? toggleFlash;
  final bool? flashIsOn;

  @override
  Widget build(BuildContext context) {
    return Container(
            padding: EdgeInsets.all(8),
      child: InkWell(
        onTap: () {
          toggleFlash!();
        },
        child: Icon(
          flashIsOn! ? Icons.flash_on : Icons.flash_off,
          color: flashIsOn! ? Colors.yellow : Colors.white,
          size: 35,
        ),
      ),
    );
  }
}

typedef ToggleFlashCallBack = void Function();