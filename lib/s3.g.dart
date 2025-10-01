// GENERATED CODE - DO NOT MODIFY BY HAND

part of 's3.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$S3 on S3Base, Store {
  late final _$bucketsAtom = Atom(name: 'S3Base.buckets', context: context);

  @override
  List<Bucket> get buckets {
    _$bucketsAtom.reportRead();
    return super.buckets;
  }

  @override
  set buckets(List<Bucket> value) {
    _$bucketsAtom.reportWrite(value, super.buckets, () {
      super.buckets = value;
    });
  }

  late final _$objectsAtom = Atom(name: 'S3Base.objects', context: context);

  @override
  Stream<ListObjectsResult> get objects {
    _$objectsAtom.reportRead();
    return super.objects;
  }

  @override
  set objects(Stream<ListObjectsResult> value) {
    _$objectsAtom.reportWrite(value, super.objects, () {
      super.objects = value;
    });
  }

  late final _$listBucketsAsyncAction =
      AsyncAction('S3Base.listBuckets', context: context);

  @override
  Future<void> listBuckets() {
    return _$listBucketsAsyncAction.run(() => super.listBuckets());
  }

  late final _$listObjectsAsyncAction =
      AsyncAction('S3Base.listObjects', context: context);

  @override
  Future<void> listObjects(String bucket, String prefix) {
    return _$listObjectsAsyncAction
        .run(() => super.listObjects(bucket, prefix));
  }

  late final _$numberObjectsAsyncAction =
      AsyncAction('S3Base.numberObjects', context: context);

  @override
  Future<int> numberObjects(String bucket, String prefix) {
    return _$numberObjectsAsyncAction
        .run(() => super.numberObjects(bucket, prefix));
  }

  late final _$createNewDirectoryAsyncAction =
      AsyncAction('S3Base.createNewDirectory', context: context);

  @override
  Future<void> createNewDirectory(
      String bucket, String prefix, String directory) {
    return _$createNewDirectoryAsyncAction
        .run(() => super.createNewDirectory(bucket, prefix, directory));
  }

  late final _$uploadFileAsyncAction =
      AsyncAction('S3Base.uploadFile', context: context);

  @override
  Future<void> uploadFile(String bucket, String path, PlatformFile file,
      AnimationController controller) {
    return _$uploadFileAsyncAction
        .run(() => super.uploadFile(bucket, path, file, controller));
  }

  late final _$getObjectURLAsyncAction =
      AsyncAction('S3Base.getObjectURL', context: context);

  @override
  Future<String> getObjectURL(String bucket, String path) {
    return _$getObjectURLAsyncAction
        .run(() => super.getObjectURL(bucket, path));
  }

  late final _$deleteObjectAsyncAction =
      AsyncAction('S3Base.deleteObject', context: context);

  @override
  Future<void> deleteObject(String bucket, String prefix, String key) {
    return _$deleteObjectAsyncAction
        .run(() => super.deleteObject(bucket, prefix, key));
  }

  late final _$deleteDirectoryAsyncAction =
      AsyncAction('S3Base.deleteDirectory', context: context);

  @override
  Future<void> deleteDirectory(String bucket, String prefix, String key) {
    return _$deleteDirectoryAsyncAction
        .run(() => super.deleteDirectory(bucket, prefix, key));
  }

  late final _$downloadObjectToTempAsyncAction =
      AsyncAction('S3Base.downloadObjectToTemp', context: context);

  @override
  Future<File> downloadObjectToTemp(String bucket, String key) {
    return _$downloadObjectToTempAsyncAction
        .run(() => super.downloadObjectToTemp(bucket, key));
  }

  late final _$downloadFileAsyncAction =
      AsyncAction('S3Base.downloadFile', context: context);

  @override
  Future<String> downloadFile(String bucket, String key, String path) {
    return _$downloadFileAsyncAction
        .run(() => super.downloadFile(bucket, key, path));
  }

  late final _$cleanupTempFilesAsyncAction =
      AsyncAction('S3Base.cleanupTempFiles', context: context);

  @override
  Future<void> cleanupTempFiles(
      {Duration olderThan = const Duration(days: 1)}) {
    return _$cleanupTempFilesAsyncAction
        .run(() => super.cleanupTempFiles(olderThan: olderThan));
  }

  late final _$copyObjectAsyncAction =
      AsyncAction('S3Base.copyObject', context: context);

  @override
  Future<void> copyObject(String sourceBucket, String sourceKey,
      String destBucket, String destKey) {
    return _$copyObjectAsyncAction.run(
        () => super.copyObject(sourceBucket, sourceKey, destBucket, destKey));
  }

  late final _$moveObjectAsyncAction =
      AsyncAction('S3Base.moveObject', context: context);

  @override
  Future<void> moveObject(String sourceBucket, String sourceKey,
      String destBucket, String destKey) {
    return _$moveObjectAsyncAction.run(
        () => super.moveObject(sourceBucket, sourceKey, destBucket, destKey));
  }

  late final _$createBucketAsyncAction =
      AsyncAction('S3Base.createBucket', context: context);

  @override
  Future<void> createBucket(String bucket) {
    return _$createBucketAsyncAction.run(() => super.createBucket(bucket));
  }

  late final _$deleteBucketAsyncAction =
      AsyncAction('S3Base.deleteBucket', context: context);

  @override
  Future<void> deleteBucket(String bucket) {
    return _$deleteBucketAsyncAction.run(() => super.deleteBucket(bucket));
  }

  late final _$searchObjectsAsyncAction =
      AsyncAction('S3Base.searchObjects', context: context);

  @override
  Future<List<Object>> searchObjects(String bucket,
      {String? prefix,
      String? nameContains,
      int? minSize,
      int? maxSize,
      DateTime? modifiedAfter,
      DateTime? modifiedBefore}) {
    return _$searchObjectsAsyncAction.run(() => super.searchObjects(bucket,
        prefix: prefix,
        nameContains: nameContains,
        minSize: minSize,
        maxSize: maxSize,
        modifiedAfter: modifiedAfter,
        modifiedBefore: modifiedBefore));
  }

  @override
  String toString() {
    return '''
buckets: ${buckets},
objects: ${objects}
    ''';
  }
}
