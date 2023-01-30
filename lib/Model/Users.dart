class UserModel{
  var username,phonenumber,urlimage,id,receverToken;
  UserModel({this.phonenumber,this.urlimage,this.username,this.id,this.receverToken});
UserModel.fromJson(Map<String,dynamic>json){
    id= json['id'];
    phonenumber= json['phonenumber'];
    urlimage= json['urlimage'];
    username= json['username'];
    receverToken= json['receverToken'];
}

Map<String,dynamic> tojson(){
return {
  'id':id,
  'phonenumber':phonenumber,
  'urlimage':urlimage,
  'username':username,
  'receverToken':receverToken,
};
}
}