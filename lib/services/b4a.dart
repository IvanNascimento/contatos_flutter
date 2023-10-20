// https://viacep.com.br/ws/01001000/json/

import 'package:contatos/models/contato.dart';
import 'package:contatos/services/interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class B4aRepository {
  final Dio _dio = Dio();

  B4aRepository() {
    _dio.options.headers["Content-Type"] = "application/json";
    _dio.options.baseUrl = "${dotenv.get("BACK4APPBASEURL")}/Contatos";
    _dio.interceptors.add(B4aInterceptor());
  }

  Future<Contatos> getContatos() async {
    Response res = await _dio.get('/');
    return Contatos.fromJson(res.data);
  }

  Future<void> criar(ContatoModel contato) async {
    try {
      Response res = await _dio.post("/", data: contato.toJson());
      debugPrint(res.data.toString());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> atualizar(ContatoModel contato) async {
    try {
      Response res =
          await _dio.put("/${contato.objectId}", data: contato.toJson());
      debugPrint(res.data.toString());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> remover(String objectId) async {
    try {
      Response res = await _dio.delete(
        "/$objectId",
      );
      debugPrint(res.data.toString());
    } catch (e) {
      rethrow;
    }
  }
}
