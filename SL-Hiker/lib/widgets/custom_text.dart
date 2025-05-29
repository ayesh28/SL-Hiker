import 'package:flutter/material.dart';

class CustomText extends StatefulWidget {
  final TextEditingController textController;
  final String hintText;
  final IconData prefixIcon;
  final bool isPassword;
  final bool isEnable;

   CustomText({super.key,required this.textController,
     required this.hintText,
     required this.prefixIcon,
     this.isPassword = false,
     this.isEnable = true
   });

  @override
  State<CustomText> createState() => _CustomTextState();
}

class _CustomTextState extends State<CustomText> {
  late bool isObsecure;
  bool isPasswordShow = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isObsecure = widget.isPassword;
  }


  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: widget.isEnable,
      controller: widget.textController,
      obscureText: isObsecure && !isPasswordShow,
      decoration: InputDecoration(
        fillColor: Color.fromRGBO(249, 250, 251, 1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(width: 3,color: Colors.red),
        ),
        hintText: widget.hintText,
        hintStyle: TextStyle(color: Colors.grey.shade500),
        prefixIcon: Icon(widget.prefixIcon,color: Colors.grey.shade500,),
        suffixIcon: (isObsecure)?GestureDetector(
            onTap: (){
              setState(() {
                isPasswordShow = !isPasswordShow;
              });
            },
            child: Icon(isPasswordShow?Icons.visibility_off:Icons.visibility,color:Colors.grey.shade500,)):SizedBox(),
        enabledBorder:OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: Colors.grey.shade500),
        ),
      ),
    );
  }
}
