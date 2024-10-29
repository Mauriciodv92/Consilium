import 'package:flutter/material.dart';

class LikeButton extends StatefulWidget {
  const LikeButton({super.key});

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  bool _stateLike = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          setState(() {
            _stateLike = !_stateLike;
          });
        },
        child: Text(
          "Asunto finalizado",
          style: TextStyle(
              color: _stateLike ? Colors.blue : Colors.grey,
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ));
  }
}
