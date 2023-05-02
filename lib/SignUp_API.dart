import 'dart:convert';
import 'package:restapi_example/LogIn_API.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  
  TextEditingController _email =TextEditingController();
  TextEditingController _pass =TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('SignUp API'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment:CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _email,
              decoration: InputDecoration(
                labelText: 'Email'
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _pass,
              decoration: InputDecoration(
                  labelText: 'Password'
              ),
            ),
            SizedBox(height: 40),
            InkWell(
              onTap: (){
                login(_email.text.toString(),_pass.text.toString());
              },
              child: Container(
                height: 50,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(18)
                  ),
                child: Center(child: Text('SignUp',style:TextStyle(fontSize: 21,fontWeight: FontWeight.w500,color: Colors.white))),
              ),
            ),
            SizedBox(height: 8,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Already have an account?'),
              InkWell(
                  onTap: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=> LogIn()));
                  },
                  child: Text('Login',style: TextStyle(color: Colors.lightBlue),))
              ],
            )
          ],
        ),
      ),
    );
  }

  void login(String email, String pass) async{
    try{
      Response response = await post(Uri.parse('https://reqres.in/api/register'),
      body: {
        'email':email,
        'password':pass
      }
      );
      if(response.statusCode==200){
        var data= jsonDecode(response.body.toString());
        print(data);
        print('Successfully SignUp');
      }
      else
        print('SignUp error');
    }
    catch(e){
      print(e.toString());
    }
  }

}
