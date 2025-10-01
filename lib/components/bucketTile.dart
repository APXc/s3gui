import 'package:flutter/material.dart';
import 'package:minio/models.dart';
class BucketTile extends StatelessWidget {

  final Bucket bucket;
  const BucketTile(this.bucket);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(' Success Send Request'),
            duration: Duration(seconds: 2),
          ),
        );

      },
      // onTap: () => Navigator.pushNamed(context, EditExpansePage.route,
      //     arguments: expenseModel),
      title: Text(bucket.name),
      subtitle: bucket.creationDate != null ? Text(bucket.creationDate.toString()) : Text("") ,
      trailing: Icon(
        Icons.launch,
        color: Colors.grey.shade300,
      ),
      leading: AspectRatio(
        aspectRatio: 5 / 3,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(10)),
          child: Center(
            child: Text(
              bucket.name,
              style: TextStyle(
                color: Colors.green.shade900,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
