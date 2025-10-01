import 'package:flutter/material.dart';
import 'package:s3gui/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:s3gui/const.dart';
import 'package:s3gui/repository/secureStore.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, required this.sharedPreferences});

  final SharedPreferences sharedPreferences;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _formKey = GlobalKey<FormState>();
  final endpointUrlController = TextEditingController();
  final accessKeyController = TextEditingController();
  final secretKeyController = TextEditingController();
  final regionTagController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStoredValues();
  }

  @override
  void dispose() {
    endpointUrlController.dispose();
    accessKeyController.dispose();
    secretKeyController.dispose();
    regionTagController.dispose();
    super.dispose();
  }

   Future<void> _loadStoredValues() async {
    final secureStorage = SecureStorage();
    
    // Prima prova a leggere da SecureStorage
    String? endpoint = await secureStorage.getString(s3EndpointURLTag);
    String? accessKey = await secureStorage.getString(s3AccessKeyTag);
    String? secretKey = await secureStorage.getString(s3SecretKeyTag);
    String? region = await secureStorage.getString(s3RegionTag);
    
    // Se non ci sono valori in SecureStorage, prova a leggere da SharedPreferences
    // Questo è utile per la migrazione da SharedPreferences a SecureStorage
    if (endpoint == null) {
      endpoint = widget.sharedPreferences.getString(s3EndpointURLTag);
      if (endpoint != null) await secureStorage.saveString(s3EndpointURLTag, endpoint);
    }
    
    if (accessKey == null) {
      accessKey = widget.sharedPreferences.getString(s3AccessKeyTag);
      if (accessKey != null) await secureStorage.saveString(s3AccessKeyTag, accessKey);
    }
    
    if (secretKey == null) {
      secretKey = widget.sharedPreferences.getString(s3SecretKeyTag);
      if (secretKey != null) await secureStorage.saveString(s3SecretKeyTag, secretKey);
    }
    
    if (region == null) {
      region = widget.sharedPreferences.getString(s3RegionTag);
      if (region != null) await secureStorage.saveString(s3RegionTag, region);
    }
    
    // Aggiorna i controller
    if (mounted) {
      setState(() {
        endpointUrlController.text = endpoint ?? '';
        accessKeyController.text = accessKey ?? '';
        secretKeyController.text = secretKey ?? '';
        regionTagController.text = region ?? '';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final secureStorage = SecureStorage();
    // final s3EndpointURL = widget.sharedPreferences.getString(s3EndpointURLTag);
    // endpointUrlController.text = s3EndpointURL ?? '';
    // final s3AccessKey = widget.sharedPreferences.getString(s3AccessKeyTag);
    // accessKeyController.text = s3AccessKey ?? '';
    // final s3SecretKey = widget.sharedPreferences.getString(s3SecretKeyTag);
    // secretKeyController.text = s3SecretKey ?? '';
    // final regionTag = widget.sharedPreferences.getString(s3RegionTag);
    //  regionTagController.text = regionTag ?? '';

    final navigator = Navigator.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        ),
      body: 
      _isLoading ? const Center(child: CircularProgressIndicator()) :
      Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.only(left: 25, right: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: endpointUrlController,
                decoration: const InputDecoration(
                  labelText: 'Endpoint URL',
                  hintText: 'eg. s3.amazon.com',
                  enabledBorder: UnderlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Endpoint URL';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: accessKeyController,
                decoration: const InputDecoration(
                  labelText: 'Acess Key',
                  enabledBorder: UnderlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Access Key';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: secretKeyController,
                decoration: const InputDecoration(
                  labelText: 'Secret Key',
                  enabledBorder: UnderlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Secret Key';
                  }
                  return null;
                },
              ),
                const SizedBox(height: 15),
              TextFormField(
                controller: regionTagController,
                decoration: const InputDecoration(
                  labelText: 'Region',
                  enabledBorder: UnderlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Secret Key';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              MaterialButton(
                 height: 50,
                 minWidth: 150,
                 color: Colors.deepPurpleAccent.shade700,
                 textColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Saving...'),
                        duration: Duration(seconds: 1)));

                       // final secureStorage = SecureStorage();
                    await secureStorage.saveString(s3EndpointURLTag, endpointUrlController.text);
                    await secureStorage.saveString(s3AccessKeyTag, accessKeyController.text);
                    await secureStorage.saveString(s3SecretKeyTag, secretKeyController.text);
                    await secureStorage.saveString(s3RegionTag, regionTagController.text);
                    // await widget.sharedPreferences.setString(
                    //     s3EndpointURLTag, endpointUrlController.text);
                    // await widget.sharedPreferences
                    //     .setString(s3AccessKeyTag, accessKeyController.text);
                    // await widget.sharedPreferences
                    //     .setString(s3SecretKeyTag, secretKeyController.text);
                    // await widget.sharedPreferences
                    //     .setString(s3RegionTag, regionTagController.text);


                    navigator.pushAndRemoveUntil<void>(
                      MaterialPageRoute<void>(
                          builder: (BuildContext context) => HomePage(
                                sharedPreferences: widget.sharedPreferences,
                              )),
                      (Route<dynamic> route) => false,
                    );
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
