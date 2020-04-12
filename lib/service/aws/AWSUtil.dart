import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';


class AWSUtil{

  static Map<String, String> getHeaders(Uint8List bytes, String url){
    Map<String, String> headers=new Map();

    headers["content-length"] =  bytes.length.toString();
    headers["x-amz-storage-class"] =  "REDUCED_REDUNDANCY";
    headers["x-amz-acl"] = "public-read";
    headers["Host"] = url;
    String hash = sha256.convert(bytes.toList()).toString();
    print(sha256.convert(bytes.toList()).bytes);
    headers["x-amz-content-sha256"] = hash;

    DateTime now=DateTime.now();
    now = now.subtract(Duration(hours: 2));
    String dateTime="${now.year}0${now.month}0${now.day}T${now.hour}${now.minute}${now.second}Z";
    headers["x-amz-date"] = dateTime;

    String canonicalizedHeaderNames = _getCanonicalizeHeaderNames(headers);
    String canonicalizedHeaders = _getCanonicalizeHeaderString(headers);

    String canonicalRequest = _getCanonicalRequest("/test", "PUT", "", canonicalizedHeaderNames, canonicalizedHeaders, hash);


    String date = "${now.year}0${now.month}0${now.day}";
    String scope =  date + "/eu-central-1/s3/aws4_request";
    String stringToSign = _getStringToSign("AWS4", "HMAC-SHA256", dateTime, scope, canonicalRequest);

    print("---------------");
    print(stringToSign);

    Uint8List kSecret = utf8.encode("AWS4" + "***REMOVED***");
    Uint8List kDate = _sign(utf8.encode(date), kSecret);
    Uint8List kRegion = _sign(utf8.encode("eu-central-1"), kDate);
    Uint8List kService = _sign(utf8.encode("AWS4"), kRegion);
    Uint8List kSigning = _sign(utf8.encode("aws4_request"), kService);
    Uint8List signature = _sign(utf8.encode(stringToSign), kSigning);

    String credentialsAuthorizationHeader =
        "Credential=" + "***REMOVED***" + "/" + scope;
    String signedHeadersAuthorizationHeader =
        "SignedHeaders=" + canonicalizedHeaderNames;
    String signatureAuthorizationHeader =
        "Signature=" +_toHex(signature);

    String authorizationHeader = "AWS4" + "-" + "HMAC-SHA256" + " "
        + credentialsAuthorizationHeader + ", "
        + signedHeadersAuthorizationHeader + ", "
        + signatureAuthorizationHeader;

    headers["Authorization"] = authorizationHeader;

    return headers;
  }

  static String _getCanonicalizeHeaderNames(Map<String, String> headers){
    List<String> sortedHeaders=headers.keys.toList();
    sortedHeaders.sort((a, b) => b.toLowerCase().compareTo(a.toLowerCase()) * -1);

    String buffer = "";
    for (String header in sortedHeaders) {
      if (buffer.length > 0) {
        buffer += ";";
      }
      buffer += header.toLowerCase();
    }
    return buffer;
  }

  static String _getCanonicalizeHeaderString(Map<String, Object> headers) {
    List<String> sortedHeaders=headers.keys.toList();
    sortedHeaders.sort((a, b) => b.toLowerCase().compareTo(a.toLowerCase()) * -1);

    String buffer = "";
    for (String header in sortedHeaders) {
      buffer += header.toLowerCase() + ":" + headers[header];
      buffer += "\n";
    }

    return buffer;
  }

  static String _getCanonicalRequest(String url, String method, String parameters, String headerNames, String headers, String bodyHash){
    return method +"\n" +
           url +"\n" +
           parameters +"\n" +
           headers +"\n" +
           headerNames +"\n" +
           bodyHash;
  }


  static String _getStringToSign(String scheme, String algorithm, String dateTime, String scope, String canonicalRequest) {
    String stringToSign =
        scheme + "-" + algorithm + "\n" +
            dateTime + "\n" +
            scope + "\n" +
            _toHex(sha256.convert(utf8.encode(canonicalRequest)).bytes);
    print(sha256.convert(utf8.encode(canonicalRequest)).bytes);
    return stringToSign;
  }


  static Uint8List _sign(Uint8List data, Uint8List key){
    var hmacSha256 = new Hmac(sha256, key);
    var result = hmacSha256.convert(data);
    return result.bytes;
  }

  static String _toHex(Uint8List data) {
    String string = "";
    for (int i = 0; i < data.length; i++) {
      String hex = data[i].toRadixString(16);
      if (hex.length == 1) {
        // Append leading zero.
        string += "0";
      } else if (hex.length == 8) {
        // Remove ff prefix from negative numbers.
        hex = hex.substring(6);
      }
      string += hex;
    }
    return string.toLowerCase();
  }

}

