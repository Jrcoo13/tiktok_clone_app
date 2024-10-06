import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CommentModalBottomSheet extends StatelessWidget {
  VoidCallback onTap;
  
  CommentModalBottomSheet({
    required this.onTap,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      child: Column(
        children: [
          //comment header
          Container(
            padding: const EdgeInsets.all(10),
            width: double.infinity,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 25,),
                const Text(
                  'comments',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500
                  )),
                GestureDetector(
                  onTap: onTap,
                  child: const Icon(
                    Icons.close, 
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          //comment section
          Container(
            height: 320,
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Colors.grey
            ),
          ),
          //add comment footer
          Container(
            padding: const EdgeInsets.all(10),
            height: 70,
            decoration: const BoxDecoration(
              color: Colors.white24,
            ),
            child: Row(
              children: [
                //comment textfield
                SizedBox(
                  width: 150,
                  child: TextField(
                    obscureText: false,
                    decoration: InputDecoration(
                      hintText: "Comment",
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade500),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12), 
                        borderSide: BorderSide(
                        color: Colors.grey.shade500,
                        ),
                      )
                    ),
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}