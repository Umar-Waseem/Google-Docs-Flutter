import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_docs_clone/extensions.dart';
import 'package:google_docs_clone/models/error_model.dart';
import 'package:google_docs_clone/utils/colors.dart';
import 'package:routemaster/routemaster.dart';

import '../models/document_model.dart';
import '../repository/auth_repository.dart';
import '../repository/document_repository.dart';

class DocumentScreen extends ConsumerStatefulWidget {
  final String id;
  const DocumentScreen({required this.id, super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends ConsumerState<DocumentScreen> {
  TextEditingController titleController =
      TextEditingController(text: "Untitled Document");

  quill.QuillController? controller = quill.QuillController.basic();

  ErrorModel? errorModel;

  @override
  void initState() {
    super.initState();
    fetchDocumentData();
  }

  void fetchDocumentData() async {
    String token = ref.read(userProvider)!.token;
    errorModel = await ref.read(documentRepositoryProvider).getDocumentById(
          token,
          widget.id,
        );
    if (errorModel!.data != null) {
      DocumentModel documentModel = errorModel!.data as DocumentModel;
      titleController.text = documentModel.title;
      setState(() {});
    } else {
      Fluttertoast.showToast(
        msg: "$this, ${errorModel!.message}",
        timeInSecForIosWeb: 6,
      );
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  void updateTitle(WidgetRef ref, String title) async {
    title.logInfo();
    String token = ref.read(userProvider)!.token;
    ref.read(documentRepositoryProvider).updateDocumentTitle(
          token: token,
          docId: widget.id,
          title: title,
        );
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton.icon(
              label: const Text("Share"),
              onPressed: () {
                Clipboard.setData(ClipboardData(
                        text: 'http://localhost:3000/#/document/${widget.id}'))
                    .then(
                  (value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Link copied!',
                        ),
                      ),
                    );
                  },
                );
              },
              icon: const Icon(Icons.lock, size: 16),
              style: ElevatedButton.styleFrom(
                foregroundColor: kWhiteColor,
                backgroundColor: kBlueColor,
              ),
            ),
          ),
        ],
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              InkWell(
                splashFactory: NoSplash.splashFactory,
                splashColor: Colors.transparent,
                onTap: () {
                  Routemaster.of(context).replace("/");
                },
                child: Image.asset(
                  "assets/images/docs-logo.png",
                  height: 30,
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 180,
                child: TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: kBlueColor,
                      ),
                    ),
                    contentPadding: EdgeInsets.only(left: 10),
                  ),
                  onSubmitted: (value) => updateTitle(ref, value),
                ),
              ),
            ],
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: kGreyColor,
                width: 0.1,
              ),
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 10),
            quill.QuillToolbar.basic(controller: controller!),
            Expanded(
              child: SizedBox(
                width: 750,
                child: Card(
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: quill.QuillEditor.basic(
                      controller: controller!,
                      readOnly: false,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
