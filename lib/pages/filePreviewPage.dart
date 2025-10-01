import 'dart:io';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as path;
import 'package:pdfx/pdfx.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
        title: Text(fileName, style: const TextStyle(color: Colors.white)),
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
        return PdfView(
          controller: PdfController(
            document: PdfDocument.openFile(file.path),
          ),
          scrollDirection: Axis.vertical,
          pageSnapping: false, // Consente scroll fluido
          builders: PdfViewBuilders<DefaultBuilderOptions>(
            options: const DefaultBuilderOptions(
              loaderSwitchDuration: Duration(milliseconds: 300),
            ),
            documentLoaderBuilder: (_) => const Center(
              child: CircularProgressIndicator(),
            ),
            pageLoaderBuilder: (_) => const Center(
              child: CircularProgressIndicator(),
            ),
            errorBuilder: (_, error) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  Text('Errore nel caricamento del PDF: $error'),
                ],
              ),
            ),
          ),
        );
        // return PDFView(
        //   filePath: file.path,
        //   enableSwipe: true,
        //   autoSpacing: true,
        //   pageFling: true,
        // );
      
      case '.jpg':
      case '.jpeg':
      case '.png':
      case '.gif':
        return Center(
          child: Image.file(file),
        );
      
      case '.html':
        return WebViewWidget(
          controller: WebViewController()
            ..loadFile(file.path)
            ..setJavaScriptMode(JavaScriptMode.unrestricted),
        );
        
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
              MaterialButton(
                height: 50,
                minWidth: 150,
                color: Colors.deepPurpleAccent.shade700,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                onPressed: () => OpenFile.open(file.path),
                child: Text('Apri con app predefinita'),
              )
            ],
          ),
        );
    }
  }
}