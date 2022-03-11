import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterapi/api_services/api_routes.dart';
import 'package:flutterapi/api_services/client_helper.dart';
import 'package:flutterapi/responses/post_response.dart';
import 'package:flutterapi/utils/message_util.dart';
import 'package:flutterapi/utils/open_page_util.dart';

import '../../widgets/loading_page_widget.dart';

class AddPostPage extends StatefulWidget {
  bool isUpdate;
  bool isPatch;
  PostResponse? postResponse;
  AddPostPage({Key? key, this.isUpdate = false, this.isPatch = false, this.postResponse}) : super(key: key);

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {

  late TextEditingController userIdCon, titleCon, bodyCon;
  late ValueNotifier<bool> _loading;

  @override
  void initState() {
    super.initState();

    userIdCon = TextEditingController(text: widget.isUpdate || widget.isPatch? widget.postResponse?.userId.toString() : "");
    titleCon = TextEditingController(text: widget.isUpdate || widget.isPatch ? widget.postResponse?.title : "");
    bodyCon = TextEditingController(text: widget.isUpdate || widget.isPatch ? widget.postResponse?.body : "");

    _loading = ValueNotifier(false);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isUpdate ? "Update Post" : widget.isPatch ? "Patch Post" : "Add Post"),
      ),
      body: Stack(
        children: [
          //Form
          Form(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                children: [
                  //User ID
                  TextFormField(
                    controller: userIdCon,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      hintText: "User ID"
                    ),
                  ),

                  //Title
                  TextFormField(
                    controller: titleCon,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                        hintText: "Title"
                    ),
                  ),

                  //Body
                  TextFormField(
                    controller: bodyCon,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    maxLines: 10,
                    decoration: const InputDecoration(
                        hintText: "Body"
                    ),
                  ),

                  const SizedBox(height: 20),


                  Align(
                    alignment: Alignment.centerRight,
                    child: RawMaterialButton(
                      child: Text(widget.isUpdate || widget.isPatch ? "Update" : "Add", style: const TextStyle(color: Colors.white)),
                      fillColor: Colors.blue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      onPressed: ()=> _validation(),
                    ),
                  )
                ],
              ),
            ),
          ),

          //Page Loading
          ValueListenableBuilder(
              valueListenable: _loading,
              builder: (_, bool check, __){
                return LoadingPageWidget(check: check);
              }
          )
        ],
      ),
    );
  }

  _validation() async{
    String userID = userIdCon.text.toString().trim();
    String title = titleCon.text.toString().trim();
    String body = bodyCon.text.toString().trim();

    if (userID.isEmpty || title.isEmpty || body.isEmpty){
      MessageUtils().toastMessageError("Fields is required.");
    }else
      {
        if (widget.isUpdate)
          {
            _updatePost(PostResponse(id: widget.postResponse?.id, userId: int.parse(userID), title: title, body: body));
          }
        else if (widget.isPatch)
          {
            _patchPost(PostResponse(id: widget.postResponse?.id, userId: int.parse(userID), title: title, body: body));
          }
        else{
          _addPost(PostResponse(userId: int.parse(userID), title: title, body: body));
        }
      }
  }

  _addPost(PostResponse postResponse) async{
    _loading.value = true;
    var response = await ClientHelper().postData(ApiRoutes.post, json.encode(postResponse));
    MessageUtils().logJson("Add Post", response);
    MessageUtils().toastMessageSuccess("Success");
    Navigator.of(context).pop("reload");
    _loading.value = false;
  }

  _updatePost(PostResponse postResponse) async{
    _loading.value = true;
    var response = await ClientHelper().postData("${ApiRoutes.post}/${postResponse.id}", postResponse.toJson(), isPost: false);
    MessageUtils().logJson("Update Post", response);
    MessageUtils().toastMessageSuccess("Success");
    Navigator.of(context).pop("reload");
    _loading.value = false;
  }

  _patchPost(PostResponse postResponse) async{
    _loading.value = true;
    var response = await ClientHelper().patchData("${ApiRoutes.post}/${postResponse.id}", body: postResponse.toJson());
    MessageUtils().logJson("Patch Post", response);
    MessageUtils().toastMessageSuccess("Success");
    Navigator.of(context).pop("reload");
    _loading.value = false;
  }
}
