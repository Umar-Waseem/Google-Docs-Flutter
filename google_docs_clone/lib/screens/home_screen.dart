import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_docs_clone/models/document_model.dart';
import 'package:google_docs_clone/models/error_model.dart';
import 'package:google_docs_clone/utils/colors.dart';
import 'package:routemaster/routemaster.dart';

import '../repository/auth_repository.dart';
import '../repository/document_repository.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void signOut(WidgetRef ref) async {
    await ref.read(authRepositoryProvider).signOut();
    ref.read(userProvider.notifier).update((state) => null);
  }

  void createDocument(WidgetRef ref, BuildContext context) async {
    String token = ref.read(userProvider)!.token;
    final navigator = Routemaster.of(context);

    final errorModel =
        await ref.read(documentRepositoryProvider).createDocument(token);

    if (errorModel.data != null) {
      navigator.push("/document/${errorModel.data.id}");
    } else {
      Fluttertoast.showToast(
        msg: "$this ${errorModel.message!}",
        timeInSecForIosWeb: 6,
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: kBlackColor,
        backgroundColor: kWhiteColor,
        title: const Text("Home"),
        actions: [
          IconButton(
            onPressed: () {
              createDocument(ref, context);
            },
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: () => signOut(ref),
            icon: const Icon(Icons.logout, color: kRedColor),
          ),
        ],
      ),
      body: FutureBuilder<ErrorModel>(
        future: ref
            .watch(documentRepositoryProvider)
            .getDocuments(ref.read(userProvider)!.token),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width < 600 ? 2 : 5,
              ),
              itemCount: snapshot.data!.data.length,
              itemBuilder: (context, index) {
                DocumentModel document = snapshot.data!.data[index];
                return Card(
                  child: ListTile(
                    title: Text(document.title),
                    onTap: () {
                      Routemaster.of(context).push("/document/${document.id}");
                    },
                    trailing: IconButton(
                      onPressed: () async {
                        await ref
                            .read(documentRepositoryProvider)
                            .deleteDocument(
                                ref.read(userProvider)!.token, document.id);
                        ref.refresh(documentRepositoryProvider);
                      },
                      icon: const Icon(Icons.delete),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
