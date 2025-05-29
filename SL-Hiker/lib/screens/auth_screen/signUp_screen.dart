import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:self_employer/screens/auth_screen/signIn_screen.dart';

import '../../providers/auth_provider.dart';
import '../../widgets/custom_text.dart';
import '../home.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
        centerTitle: true,
      ),
      body: Consumer<UserAuthProvider>(
        builder: (BuildContext context, authProvider, Widget? child) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0,vertical: 30),
            child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomText(hintText: "Enter your Name", prefixIcon: Icons.people_alt_rounded, textController: nameController),
                    SizedBox(height: 20,),
                    CustomText(hintText: "Enter your email", prefixIcon: Icons.email_rounded, textController: emailController),
                    SizedBox(height: 20,),
                    CustomText(hintText: "Enter your password", prefixIcon: Icons.lock_rounded, textController: passwordController,isPassword: true),
                    Spacer(),
                    GestureDetector(
                        onTap: () async {
                          String email = emailController.text.trim();
                          String password = passwordController.text.trim();
                          String name = nameController.text.trim();

                          if(email.isNotEmpty && password.isNotEmpty && name.isNotEmpty){
                            bool responce = await  Provider.of<UserAuthProvider>(context,listen: false).signup(email, password, name);

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
                        child: createButton(isShowboarder: true, buttonText: "Sign Up",isLoading: authProvider.isLoading)),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Have an account? "),
                        GestureDetector(
                            onTap: (){
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SigninScreen()));
                            },
                            child: Text("Sign In",style: TextStyle(color:Color.fromRGBO(64, 124, 226, 1),fontWeight: FontWeight.w600 ),
                            )
                        ),
                      ],
                    )
                  ],
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
