class TokenModel{
 var token;
 TokenModel({this.token,});
 TokenModel.fromJson(Map<String,dynamic>json){
   token= json['token'];
 }
 Map<String,dynamic> tojson(){
   return {
     'token':token,
   };
 }
}