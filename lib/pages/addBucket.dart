import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:s3gui/s3.dart';

class AddBucket extends StatefulWidget {
  const AddBucket({ super.key , required this.sharedPreferences });

  final SharedPreferences sharedPreferences;

  @override
  _AddBucketState createState() => _AddBucketState();
}

class _AddBucketState extends State<AddBucket> {
  final _formKey = GlobalKey<FormState>();
  final bucketNameController = TextEditingController();
  bool inRequest = false;
  
  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);

    return Scaffold(
          appBar: AppBar(title: const Text('Add Bucket', style: TextStyle(color: Colors.white))),
          body: Form(
            key: _formKey,
            child: Padding(
              padding:  const EdgeInsets.only(left: 25, right: 25)
            , child:Column(
              children: [
                TextFormField(
                  controller: bucketNameController,
                  decoration: const InputDecoration(labelText: 'Bucket Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a bucket name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15,),
                MaterialButton(
                 height: 50,
                 minWidth: 150,
                 color: Colors.deepPurpleAccent.shade700,
                 textColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // Save the bucket name to shared preferences
                      widget.sharedPreferences.setString('bucket_name', bucketNameController.text);
                      await S3().createBucket(bucketNameController.text);
                      navigator.pop();
                    }
                  },
                  child: const Text('Add Bucket'),
                ),
              ],
            ))
          ),
    );
  }
}