import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:provider/provider.dart';
import 'package:self_employer/screens/auth_screen/signUp_screen.dart';
import 'package:self_employer/screens/home.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_text.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
        centerTitle: true,
      ),
      body: Consumer<UserAuthProvider>(
        builder: (BuildContext context, authProvider, Widget? child) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0,vertical: 30),
            child: Form(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomText(hintText: "Enter your email", prefixIcon: Icons.email_rounded, textController: emailController),
                      SizedBox(height: 20,),
                      CustomText(hintText: "Enter your password", prefixIcon: Icons.lock_rounded, textController: passwordController,isPassword: true),
                      SizedBox(height: 10,),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Align(
                          alignment: Alignment.topRight,
                            child: Text("Forgot password?",style: TextStyle(color: Color.fromRGBO(64, 124, 226, 1) ,fontWeight: FontWeight.w600),)),
                      ),
                      SizedBox(height: 60,),
                      GestureDetector(
                          onTap: () async {
                            String email = emailController.text.trim();
                            String password = passwordController.text.trim();
                  
                            if(email.isNotEmpty && password.isNotEmpty){
                              bool responce = await  Provider.of<UserAuthProvider>(context,listen: false).signin(email, password);
                  
                              if(responce){
                                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => home(),), (Route<dynamic> route) => false);
                              }
                              else{
                                print("object");
                              }
                            }
                            else{
                              print("All field must be filed");
                            }
                  
                          },
                          child: createButton(isShowboarder: true, buttonText: "Sign In",isLoading: authProvider.isLoading)),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have an account? "),
                          GestureDetector(
                              onTap: (){
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SignupScreen()));
                              },
                              child: Text("Sign Up",style: TextStyle(color:Color.fromRGBO(64, 124, 226, 1),fontWeight: FontWeight.w600 ),)),
                        ],
                      ),
                      SizedBox(height: 100,),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            Flexible(
                              child: Container(
                                height: 1,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color:Colors.grey.shade400,
                                ),
                              ),
                            ),
                            SizedBox(width: 4,),
                            Text("OR",style: TextStyle(color:Colors.grey.shade400),),
                            SizedBox(width: 4,),
                            Flexible(
                              child: Container(
                                height: 1,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color:Colors.grey.shade400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SignInButton(
                        Buttons.Google,
                        text: "Sign in with Google",
                        onPressed: () {},
                      ),
                      SignInButton(
                        Buttons.Facebook,
                        text: "Sign in with Facebook",
                        onPressed: () {},
                      ),
                    ],
                  ),
                )
            ),
          );
        },
      ),
    );
  }

  Widget createButton({required bool isShowboarder, required String buttonText, bool? isLoading}){
    return Container(
      width: 300,
      height: 56,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          color: isShowboarder?Color.fromRGBO(64, 124, 226, 1):Colors.transparent,
          border: Border.all(width: 1,color: Color.fromRGBO(64, 124, 226, 1))
      ),
      child: Center(child:(isLoading??false)?CircularProgressIndicator(color: Colors.white,):Text(buttonText??"",style: TextStyle(fontSize: 16,color: isShowboarder?Colors.white:Color.fromRGBO(64, 124, 226, 1),fontWeight: FontWeight.w500),)),
    );
  }
}
