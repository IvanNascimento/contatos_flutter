import 'dart:io';

import 'package:flutter/material.dart';

class CardContato extends StatefulWidget {
  final String photoUri;
  final String nome;
  final String numero;
  final String email;

  const CardContato(
      {super.key,
      required this.photoUri,
      required this.nome,
      required this.numero,
      required this.email});

  @override
  State<CardContato> createState() => _CardContatoState();
}

class _CardContatoState extends State<CardContato> {
  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(
      children: [
        ListTile(
          leading: widget.photoUri == ""
              ? const Icon(
                  Icons.person_4_sharp,
                  size: 75,
                )
              : Image.file(File(widget.photoUri)),
          title: Text("Nome: ${widget.nome}"),
          subtitle:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Número: ${widget.numero}"),
            Text("Email: ${widget.email}"),
          ]),
        )
      ],
    ));
  }
}
