import 'package:flutter/material.dart';
import 'package:minio/models.dart';
import 'package:s3gui/s3.dart';
class BucketTile extends StatelessWidget {

  final Bucket bucket;
  final Function onTap;
  

  const BucketTile(this.bucket, {required this.onTap});

  @override
  Widget build(BuildContext context){
    return FutureBuilder<int>(
      future:  S3().numberObjects(bucket.name, ''),
      builder: (context, snapshot) {
        final numberOfObjects = snapshot.data ?? 0;
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ListTile(
            title: Text(bucket.name),
            subtitle: const Text('Loading...'),
            trailing: Icon(
                    Icons.folder,
                    color: Colors.amber,
                  ),
            leading: AspectRatio(
                    aspectRatio: 5 / 3,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.amber.shade50,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text(
                          bucket.name,
                          style: TextStyle(
                            color: Colors.amber.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
            onTap: () => onTap(),
          );
        } else if (snapshot.hasError) {
          return ListTile(
            title: Text(bucket.name),
            subtitle: const Text('Error loading object count'),
             trailing: Icon(
                    Icons.folder,
                    color: Colors.red,
                  ),
            leading: AspectRatio(
                    aspectRatio: 5 / 3,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text(
                          bucket.name,
                          style: TextStyle(
                            color: Colors.red.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
            onTap: () => onTap(),
          );
        } else {
          return ListTile(
                  onTap: (){
                    onTap();
                  },
                  title: Text(bucket.name),
                  subtitle: Text('$numberOfObjects objects'), //bucket.creationDate != null ? Text(bucket.creationDate.toString()) : Text("") ,
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
      },
    );
  }
}
