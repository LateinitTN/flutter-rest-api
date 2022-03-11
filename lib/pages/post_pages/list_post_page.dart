import 'package:flutter/material.dart';
import 'package:flutterapi/api_services/api_routes.dart';
import 'package:flutterapi/api_services/client_helper.dart';
import 'package:flutterapi/pages/post_pages/add_post_page.dart';
import 'package:flutterapi/responses/post_response.dart';
import 'package:flutterapi/utils/message_util.dart';
import 'package:flutterapi/utils/open_page_util.dart';
import 'package:flutterapi/widgets/loading_page_widget.dart';

class ListPostPage extends StatefulWidget {
  const ListPostPage({Key? key}) : super(key: key);

  @override
  State<ListPostPage> createState() => _ListPostPageState();
}

class _ListPostPageState extends State<ListPostPage> {

  late ValueNotifier<List<PostResponse>> _listPosts;
  late ValueNotifier<bool> _loading;

  @override
  void initState() {
    super.initState();

    _listPosts = ValueNotifier([]);
    _loading = ValueNotifier(false);

    //Get List Posts
    _getListPosts();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("List Posts"),
        leading: Container(),
        actions: [
          IconButton(
              onPressed: () async {
                //Open page add post
                var result  = await openPage(AddPostPage(), context);
                if (result == "reload"){
                  _getListPosts();
                }
              }, icon: const Icon(Icons.add, color: Colors.white,))
        ],
      ),
      body: Stack(
        children: [
          //List Post
          ValueListenableBuilder(
            valueListenable: _listPosts,
            builder: (_, List<PostResponse> items, __){
              return ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index){
                  return GestureDetector(
                    onTap: () async{
                      var result  = await openPage(AddPostPage(isUpdate: true, postResponse: items[index],), context);
                      if (result == "reload"){
                        _getListPosts();
                      }
                    },
                    onDoubleTap: () async {
                      var result  = await openPage(AddPostPage(isPatch: true, postResponse: items[index],), context);
                      if (result == "reload"){
                        _getListPosts();
                      }
                    },
                    onLongPress: (){
                      showDialog<void>(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context){
                          return AlertDialog(
                            title: const Text('Delete'),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: const [
                                  Text("Are you sure want to delete this item?")
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: (){
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("No")
                              ),
                              TextButton(
                                  onPressed: (){
                                    Navigator.of(context).pop();
                                    _deletePost(items[index].id.toString());
                                  },
                                  child: const Text("Yes")
                              )
                            ],
                          );
                        }
                      );
                    },
                    child: Container(
                      color: Colors.grey.shade300,
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.only(top: 10, left: 5, right: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //User ID
                          Text("User ID: ${items[index].userId}"),
                          Text("Title: ${items[index].title}"),
                          Text("Body: ${items[index].body}"),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
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
  
  _getListPosts()  async{
    _loading.value = true;
    var response = await ClientHelper().fetchData(ApiRoutes.post);
    _listPosts.value = List<PostResponse>.from(response.map((x) => PostResponse.fromJson(x)));
    MessageUtils().logJson("List Post", response);
    _loading.value = false;
  }

  _deletePost(String id) async {
    _loading.value = true;
    var response = await ClientHelper().deleteData("${ApiRoutes.post}/$id");
    MessageUtils().logJson("Delete Post", response);
    MessageUtils().toastMessageSuccess("Success");
    _loading.value = false;
    _getListPosts();
  }
}
