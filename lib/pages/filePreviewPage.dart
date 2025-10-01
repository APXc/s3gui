import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as path;

class FilePreviewPage extends StatelessWidget {
  final File file;
  final String fileName;

  const FilePreviewPage({
    Key? key, 
    required this.file, 
    required this.fileName
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(fileName),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.open_in_new, color: Colors.white),
            onPressed: () => OpenFile.open(file.path),
            tooltip: 'Apri con app predefinita',
          )
        ],
      ),
      body: _buildPreview(),
    );
  }

  Widget _buildPreview() {
    final extension = path.extension(fileName).toLowerCase();
    
    switch (extension) {
      case '.pdf':
        return PDFView(
          filePath: file.path,
          enableSwipe: true,
          autoSpacing: true,
          pageFling: true,
        );
      
      case '.jpg':
      case '.jpeg':
      case '.png':
      case '.gif':
        return Center(
          child: Image.file(file),
        );
      
      // case '.html':
      //   return WebView(
      //     initialUrl: 'file://${file.path}',
      //     javascriptMode: JavascriptMode.unrestricted,
      //   );
      
      case '.txt':
      case '.csv':
        return FutureBuilder<String>(
          future: file.readAsString(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Text(snapshot.data!),
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        );
      
      default:
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.file_present, size: 64),
              SizedBox(height: 16),
              Text('Anteprima non disponibile per questo tipo di file'),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => OpenFile.open(file.path),
                child: Text('Apri con app predefinita'),
              )
            ],
          ),
        );
    }
  }
}