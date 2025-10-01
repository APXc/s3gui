import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:minio/minio.dart';
import 'package:minio/models.dart';
import 'package:mobx/mobx.dart';
import 'package:s3gui/client.dart';
import 'dart:io';

part 's3.g.dart';

class S3 = S3Base with _$S3;

abstract class S3Base with Store {
  @observable
  List<Bucket> buckets = [];

  @observable
  Stream<ListObjectsResult> objects = const Stream.empty();

  @action
  Future<void> listBuckets() async {
    buckets = await Client().c.listBuckets();
  }

  @action
  Future<void> listObjects(String bucket, String prefix) async {
    objects = Client().c.listObjects(bucket, prefix: prefix);
  }

  @action
  Future<void> createNewDirectory(
      String bucket, String prefix, String directory) async {
    final path = '$prefix$directory/';
    await Client().c.putObject(bucket, path, const Stream.empty(), size: 0);
  }

  @action
  Future<void> uploadFile(String bucket, String path, PlatformFile file, AnimationController controller) async {
    controller.value = 1;
    await Client().c.putObject(
          bucket,
          path,
          Stream.value(file.bytes!),
          onProgress: (bytes) {
            controller.value = bytes / file.size;
          },
        );
  }

  @action
  Future<String> getObjectURL(String bucket, String path) async {
    return await Client().c.presignedGetObject(bucket, path);
  }

  @action
  Future<void> deleteObject(String bucket, String prefix, String key) async {
    final path = '$prefix$key';
    await Client().c.removeObject(bucket, path);
  }

  @action
  Future<void> deleteDirectory(String bucket, String prefix, String key) async {
    final path = '$prefix$key';
    await _removeDirectory(bucket, path);
  }

  Future<void> _removeDirectory(String bucket, String prefix) async {
    final objs = Client().c.listObjects(bucket, prefix: prefix);
    await for (final objResult in objs) {
      for (final obj in objResult.objects) {
        await Client().c.removeObject(bucket, obj.key!); // Remove files
      }
      for (final p in objResult.prefixes) {
        await _removeDirectory(bucket, p); // Remove directories
      }
    }
  }

  // --- DOWNLOAD FILE ---
  @action
  Future<String> downloadFile(String bucket, String key) async {
    // Scarica il file in una cartella temporanea e restituisce il path locale
    const tempDir = '/tmp';
    final localPath = '$tempDir/$key';
    final file = File(localPath);
    final stream = await Client().c.getObject(bucket, key);
    final sink = file.openWrite();
    await for (final chunk in stream) {
      sink.add(chunk);
    }
    await sink.close();
    return localPath;
  }

  // Pulizia file temporanei
  Future<void> cleanTempFiles() async {
    const tempDir = '/tmp';
    final dir = Directory(tempDir);
    if (await dir.exists()) {
      await for (final file in dir.list()) {
        await file.delete();
      }
    }
  }

  // --- GESTIONE VERSIONI ---
  // NOTA: Il client Minio Dart non supporta la gestione delle versioni direttamente.
  // Questi metodi sono stub/documentazione per futura estensione o backend custom.
  // Future<List<String>> listObjectVersions(String bucket, String key) async {
  //   // Implementazione custom necessaria
  // }
  // Future<void> setObjectVersion(String bucket, String key, String versionId) async {
  //   // Implementazione custom necessaria
  // }

  // --- GESTIONE METADATA ---
  // NOTA: Il client Minio Dart non supporta la gestione dei metadata direttamente.
  // Questi metodi sono stub/documentazione per futura estensione o backend custom.
  // Future<Map<String, String>> getObjectMetadata(String bucket, String key) async {
  //   // Implementazione custom necessaria
  // }
  // Future<void> setObjectMetadata(String bucket, String key, Map<String, String> metadata) async {
  //   // Implementazione custom necessaria
  // }

  // --- COPIA E SPOSTAMENTO ---
  @action
  Future<void> copyObject(String sourceBucket, String sourceKey, String destBucket, String destKey) async {
    // La copia oggetto Minio richiede CopyConditions come quarto argomento
    await Client().c.copyObject(destBucket, destKey, sourceBucket, CopyConditions());
  }

  @action
  Future<void> moveObject(String sourceBucket, String sourceKey, String destBucket, String destKey) async {
    await copyObject(sourceBucket, sourceKey, destBucket, destKey);
    await Client().c.removeObject(sourceBucket, sourceKey);
  }

  // --- CREAZIONE ED ELIMINAZIONE BUCKET ---
  // NOTA: Il client Minio Dart non supporta la creazione/eliminazione bucket direttamente.
  // Questi metodi sono stub/documentazione per futura estensione o backend custom.
   @action
  Future<void> createBucket(String bucket) async {
    MinioInvalidBucketNameError.check(bucket);
    await Client().c.makeBucket(bucket);
  }

  @action
  Future<void> deleteBucket(String bucket) async {
    await Client().c.removeBucket(bucket);
    // Implementazione custom necessaria
  }

  // --- RICERCA AVANZATA ---
  @action
  Future<List<Object>> searchObjects(String bucket, {
    String? prefix,
    String? nameContains,
    int? minSize,
    int? maxSize,
    DateTime? modifiedAfter,
    DateTime? modifiedBefore,
    // Map<String, String>? metadata, // Non supportato
  }) async {
    final results = <Object>[];
    final stream = Client().c.listObjects(bucket, prefix: prefix ?? '');
    await for (final objResult in stream) {
      for (final obj in objResult.objects) {
        bool match = true;
        if (nameContains != null && !(obj.key?.contains(nameContains) ?? false)) match = false;
        if (minSize != null && (obj.size ?? 0) < minSize) match = false;
        if (maxSize != null && (obj.size ?? 0) > maxSize) match = false;
        if (modifiedAfter != null && (obj.lastModified?.isBefore(modifiedAfter) ?? false)) match = false;
        if (modifiedBefore != null && (obj.lastModified?.isAfter(modifiedBefore) ?? false)) match = false;
        // Metadata: non supportato dal client Minio
        if (match) results.add(obj);
      }
    }
    return results;
  }
}
