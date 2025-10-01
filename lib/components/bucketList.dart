import 'package:flutter/material.dart';
import 'package:minio/models.dart';
import 'package:s3gui/components/bucketTile.dart';
import 'package:s3gui/pages/objects.dart';
import 'package:s3gui/s3.dart';

class BucketList extends StatefulWidget {
  final List<Bucket> buckets;
  const BucketList({ Key? key, required this.buckets }) : super(key: key);

  @override
  _BucketListState createState() => _BucketListState();
}

class _BucketListState extends State<BucketList> {
  @override
  Widget build(BuildContext context) {
    return contentList( widget.buckets, context);
  }
}





// Widget header(BuildContext context) => Obx(() => Container(
//     width: double.infinity,
//     color: Colors.green.shade400,
//     padding: EdgeInsets.all(16),
//     child: SafeArea(
//       child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row( children: [
//               IconButton(onPressed: () => {
//                 Navigator.of(context).pop()
//               }, icon: Icon(Icons.arrow_back, color: Colors.green.shade100,)),
//               Text(
//                 "In Use Configuration "+ applicationModel.value.selectedConfig!.name,
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Colors.green.shade100,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],),
//         const SizedBox(
//           height: 8,
//         ),
//         const Text(
//           "Launcher Page",
//           style: TextStyle(
//             fontSize: 30,
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         SizedBox(
//           height: 16,
//         )
//       ]),
//     )));


Widget contentList(List<Bucket> buckets, BuildContext context) => Expanded(
    child: Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              offset: Offset(0, -2),
              color: Colors.black12,
              blurRadius: 2,
              spreadRadius: 0)
        ],
      ),
      child:buckets.length > 0 ? ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 30),
        itemCount: buckets.length,
        itemBuilder: (context, index) {
          final bucket = buckets[index];
          return Dismissible(
              key: Key(bucket.name),
              direction: DismissDirection.endToStart,
              background: Container(
                color: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 16),
                alignment: AlignmentDirectional.centerEnd,
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
              onDismissed : (direction) async {
                await S3().deleteBucket(bucket.name);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(bucket.name+' Removed'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: BucketTile(
                bucket,
                onTap: (){
                 Future.delayed(Duration.zero ,() { Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ObjectsPage(
                        bucket: bucket.name,
                        prefix: '',
                      ),
                    ),
                  );}
                  );

              },
                ));
        },
        separatorBuilder: (context, index) => Divider(
          height: 2,
        ),
      ) : Container(),
    ));
