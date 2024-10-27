import 'package:flutter/material.dart';

class c_text_field extends StatelessWidget {
  final TextEditingController? editingController;
  final bool? isobscuretext;
  final Color? icon_color;
  final TextInputType? keyboard;
  final String? assetref;
  final String? labeltext;
  final IconData? icondata;

  c_text_field(
      {super.key,
      this.keyboard,
      this.icon_color,
      this.editingController,
      this.isobscuretext,
      this.labeltext,
      this.icondata,
      this.assetref});

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: keyboard,
      controller: editingController,
      obscureText: isobscuretext!,
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                BorderSide(color: const Color.fromARGB(255, 95, 24, 19)),
          ),
          prefixIconColor: icon_color,
          labelText: labeltext,
          prefixIcon: icondata != null
              ? Icon(icondata)
              : Padding(
                  padding: EdgeInsets.all(10),
                  
                  child: Image.asset(assetref.toString()),
                ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
          )),
    );
  }
}
