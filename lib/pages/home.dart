import 'package:flutter/material.dart';
//import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:s3gui/pages/settings.dart';
import 'package:s3gui/pages/addBucket.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:s3gui/pages/objects.dart';
import 'package:s3gui/client.dart';
import 'package:s3gui/s3.dart';
import 'package:s3gui/components/bucketList.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.sharedPreferences});

  final SharedPreferences sharedPreferences;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _s3 = S3();

  @override
  void initState() {
    Client().init(widget.sharedPreferences);
    _s3.listBuckets();
    super.initState();
  }


  void _refreshState() {
    setState(() {
       _s3.listBuckets();
    });
   
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buckets', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            color: Colors.white,
            onPressed: () {
              _refreshState();
            },
          ),
          IconButton(
            icon: const Icon(Icons.plus_one),
            tooltip: 'New Bucket',
            color: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AddBucket(sharedPreferences: widget.sharedPreferences),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            color: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      SettingsPage(sharedPreferences: widget.sharedPreferences),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
         BucketList(buckets: _s3.buckets)
        ],
      ),
    );
  }
}
