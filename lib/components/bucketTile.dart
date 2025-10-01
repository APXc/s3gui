import 'package:flutter/material.dart';
import 'package:minio/models.dart';
class BucketTile extends StatelessWidget {

  final Bucket bucket;
  final Function onTap;
  const BucketTile(this.bucket, {required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: (){
        onTap();
      },
      title: Text(bucket.name),
      subtitle: bucket.creationDate != null ? Text(bucket.creationDate.toString()) : Text("") ,
      trailing: Icon(
        Icons.folder,
        color: Colors.purpleAccent.shade700,
      ),
      leading: AspectRatio(
        aspectRatio: 5 / 3,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.purple.shade50,
              borderRadius: BorderRadius.circular(10)),
          child: Center(
            child: Text(
              bucket.name,
              style: TextStyle(
                color: Colors.purpleAccent.shade700,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
