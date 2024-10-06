import 'package:flutter/material.dart';

// ignore: must_be_immutable
class RightPanelIcon extends StatefulWidget {
  final String imagePath;
  final String value;
  final Color activeColor;
  bool action = false;
  VoidCallback onTap;

  RightPanelIcon({
    super.key,
    required this.imagePath,
    required this.value,
    required this.activeColor,
    required this.action,
    required this.onTap
  });

  @override
  State<RightPanelIcon> createState() => _RightPanelIconState();
}

class _RightPanelIconState extends State<RightPanelIcon> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        children: [
          SizedBox(
            child: GestureDetector(
              onTap: widget.onTap,
              child: Image.asset(widget.imagePath,
                  height: 35, color: widget.action ? widget.activeColor : Colors.white),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            widget.value,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}