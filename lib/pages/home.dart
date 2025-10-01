import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
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
  bool _isLoaded = false;

  @override
  void initState() {
  //   Client().init(widget.sharedPreferences);
  //  //_s3.listBuckets();
  //   setState(() {
  //       _s3.listBuckets();
  //      _isLoaded = true;
  //   });
    super.initState();
    _initApp();
  }



  Future<void> _initApp() async {
    try {
      await Client().init(widget.sharedPreferences); // IMPORTANTE: attendi init()
      await _s3.listBuckets(); // Poi carica i bucket
    } catch (e) {
      print('Errore di inizializzazione: $e');
      // Gestione errore (mostra messaggio o retry)
    } finally {
      if (mounted) {
        setState(() {
          _isLoaded = true;
        });
      }
    }
  }

  Future<void> _refreshState() async {
    setState(() {
        _isLoaded = false;
    });
    setState(() {
        _s3.listBuckets();
        _isLoaded = true;
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
            onPressed: () async {
              await _refreshState();
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
          Observer(builder: (_) {
            if (_isLoaded == false) {
              return const Expanded(
                child: Center(child: CircularProgressIndicator()),
              );
            } else if (_s3.buckets.isEmpty) {
              return const Expanded(
                child: Center(child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.archive, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('No buckets found.', style: TextStyle(fontSize: 18, color: Colors.grey)),
                  ],
                )),
              );
            } else {
              return  BucketList(buckets: _s3.buckets);
              
            }
          }),
        ],
      ),
    );
  }
}
