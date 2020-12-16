import 'package:aws_s3/aws_s3.dart';

class AWSS3Service {
  var bucketName = "perspective-photos-bucket";
  var poolId = "us-east-2:b4ddbb7-bed7-4842-8314-23062efdd40b";

  void uploadImage(image, filename) async {
    AwsS3 awsS3 = AwsS3(
        file: image,
        fileNameWithExt: filename,
        awsFolderPath: "test",
        poolId: poolId,
        bucketName: bucketName);
    var result = await awsS3.uploadFile;
    print(result);
  }
}
