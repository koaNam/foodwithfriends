import 'dart:convert';
import 'dart:io';

class GraphQlConstants{

  static const String _URL="anh6eEQ7PUVEQkhRSE5RTldaVVfCoF1dwpfCpMKVwqbCoMKrwqg=";

  static const String _CHAT_URL="eXdANzlBQD5ETURKTUpTVlxcVmBbW8KUwqfCmMKXwp7CmcKua8K1wqXCpMK3wrXCq8K1wrHDgg==";

  static const String _S3_URL="anh6eH1GPT94woPChXzCkcKFwpLCiMKIwpbCj8KNwpjCkMKhXsKlZ2TCncKvacKhwqXCsMK4wrjCqcK2eX9+wrPDgcK3w5LDicOKwr/Dl8OVwpLDicOXw5fCmw==";

  static get URL{
    return DECODE(_URL);
  }

  static get HEADERS{
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json",
      "x-hasura-admin-secret" : DECODE("XHd0XFd7woRGS8KC")
    };

    return headers;
  }

  static get CHAT_URL{
    return DECODE(_CHAT_URL);
  }

  static get S3_URL{
    return DECODE(_S3_URL);
  }

  static String DECODE(String stringCode){
    String code = utf8.decode(base64.decode(stringCode));

    String decode = "";
    for(int i=1; i < (code.length + 1); i++){
      int number = code.codeUnitAt(i - 1);
      number = number - i * 2;;
      decode += String.fromCharCode(number);
    }
    return decode;
  }

}