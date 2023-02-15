import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_docs_clone/extensions.dart';
import 'package:google_docs_clone/models/document_model.dart';
import 'package:google_docs_clone/models/error_model.dart';
import 'package:http/http.dart';

import '../constants.dart';

final documentRepositoryProvider = Provider<DocumentRepository>(
  (ref) {
    return DocumentRepository(
      client: Client(),
    );
  },
);

class DocumentRepository {
  final Client _client;

  DocumentRepository({required Client client}) : _client = client;

  Future<ErrorModel> createDocument(String token) async {
    ErrorModel errorModel = ErrorModel(
      message: "Some unexpected error occured",
      data: null,
    );

    try {
      var response = await _client.post(
        Uri.parse("$host/doc/create"),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "x-auth-token": token,
        },
        body: jsonEncode({
          "createdAt": DateTime.now().microsecondsSinceEpoch,
        }),
      );

      switch (response.statusCode) {
        case 200:
          errorModel = ErrorModel(
            message: null,
            data: DocumentModel.fromJson(response.body),
          );
          break;
        default:
          errorModel = ErrorModel(
            message: response.body,
            data: null,
          );
          break;
      }
    } catch (e) {
      errorModel = ErrorModel(message: "$this, $e", data: null);
      "$this, $e".logError();
      Fluttertoast.showToast(msg: "$this $e");
    }

    return errorModel;
  }

  Future<ErrorModel> getDocuments(String token) async {
    ErrorModel errorModel = ErrorModel(
      message: "Some unexpected error occured",
      data: null,
    );

    try {
      var response = await _client.get(
        Uri.parse("$host/doc/me"),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "x-auth-token": token,
        },
      );

      switch (response.statusCode) {
        case 200:
          List<DocumentModel> documents = [];
          for (int i = 0; i < jsonDecode(response.body).length; i++) {
            documents.add(DocumentModel.fromJson(
                jsonEncode(jsonDecode(response.body)[i])));
          }
          errorModel = ErrorModel(
            message: null,
            data: documents,
          );
          break;
        default:
          errorModel = ErrorModel(
            message: response.body,
            data: null,
          );
          break;
      }
    } catch (e) {
      errorModel = ErrorModel(message: "$this, $e", data: null);
      "$this, $e".logError();
      Fluttertoast.showToast(msg: "$this $e");
    }

    return errorModel;
  }
}
