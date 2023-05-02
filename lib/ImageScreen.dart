import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';


class UploadImage extends StatefulWidget {
  const UploadImage({Key? key}) : super(key: key);

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {

  File? image;
  final picker = ImagePicker();
  bool load = false;
 bool showSpinner=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Upload Image'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (image == null) {
            print('First image select');

          } else {
           uploadImage();
          }
        },
        child: Icon(
          Icons.done_outlined,
          size: 30,
        ),
      ),
      body:ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16,vertical: 20),
              height: 240.0,
              width: double.infinity,
              decoration: BoxDecoration(border: Border.all(color: Colors.black87)),
              child: image == null
                  ? Icon(
                Icons.image,
                size: 60,
              )
                  : Center(child: Image.file(image!,fit: BoxFit.cover,)),
            ),
            Padding(
              padding: const EdgeInsets.only(top:20.0),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 2),
                      elevation: 7,
                      maximumSize: Size(250, 45),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(21)),
                          side: BorderSide(color: Colors.white,width: 1.5)),
                      backgroundColor: Colors.blue),
                  onPressed: () {
                    setState(() {
                      load = true;
                    });
                    _showPicker(context: context);
                  },
                  child: Center(
                      child: load
                          ? CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      )
                          : Text(
                        'Select Image',
                        style: TextStyle(
                            fontSize: 21, color: Colors.white),
                      ))),
            ),
          ],
        ),
      ),
    );
  }
  void _showPicker({
    required BuildContext context,
  }) {
    setState(() {
      load =false;
    });
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Library'),
                onTap: () async{
                  if(await _askPermission('Gallery'))
                    getImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () async{
                  if(await _askPermission('Camera'))
                    getImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }
  Future getImage(
      ImageSource img,
      ) async {
    final pickedFile = await picker.pickImage(source: img);
    XFile? xfilePick = pickedFile;
    setState(
          () {
        if (xfilePick != null) {
          image = File(pickedFile!.path);
          //_uploadimageStorage();
        } else {
          ScaffoldMessenger.of(context).showSnackBar( // is this context <<<
              const SnackBar(content: Text('Nothing is selected')));
        }
      },
    );
    Navigator.of(context).pop();

  }

  Future<void> uploadImage() async{
    setState((){
      showSpinner =true;
    });
    
    var stream= new http.ByteStream(image!.openRead());
    stream.cast();
    var length = await image!.length();
    var uri = Uri.parse('https://fakestoreapi.com/products');
    var request =http.MultipartRequest('POST', uri);
    request.fields['title']="Static Title";
    request.fields['id']='101';
    var multiport = new http.MultipartFile('gallerFile', stream, length);
    request.files.add(multiport);
    var response= await request.send();
    if(response.statusCode==200){
      setState(() {
        showSpinner=false;
      });
      print('Image upload');
    }
    else{
      print('error');
      setState(() {
        showSpinner=false;
      });
    }
  }
}

Future<bool> _askPermission(String s) async {
  if (s == 'Camera') {
    var cameraAccess = await Permission.camera.status;
    debugPrint('cameraAccess=$cameraAccess');
    if (!cameraAccess.isGranted) {
      await Permission.camera.request();
    }
    if(cameraAccess.isGranted)
      return true;
  }
  else {
    var galleryAccess = await Permission.storage.status;
    debugPrint('galleryAccess=$galleryAccess');
    if (!galleryAccess.isGranted)
      await Permission.storage.request();
    if (galleryAccess.isGranted)
      return true;
  }

  return false;
}
