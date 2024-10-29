import 'package:flutter/material.dart';

class imagecard extends StatelessWidget {
  const imagecard({super.key, required this.imagen});

  final String imagen;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      child: Image.network(
        imagen,
        fit: BoxFit.fill,
      ),
    );
  }
}
