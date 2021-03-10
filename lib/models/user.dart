class ModelUser {
  String uid;
  String name;
  String email;
  String usernmame;
  String status;
  int state;
  String profilePhoto;
  bool emailVerified;
  ModelUser(this.uid,this.name,this.email,this.usernmame,this.status,this.state,this.profilePhoto,this.emailVerified);

  Map toMap(ModelUser user){
    var data = Map<String, dynamic>();
    data['uid'] = user.uid;
    data['name'] = user.name;
    data['email'] = user.email;
    data['username'] = user.usernmame;
    data['status'] = user.status;
    data['state'] = user.state;
    data['profilePhoto'] = user.profilePhoto;
    data['emailVerified'] = user.emailVerified;
    return data;
  }

  ModelUser.fromMap(Map<String,dynamic> mapData){
    this.uid = mapData['uid'];
    this.name = mapData['name'];
    this.email = mapData['email'];
    this.usernmame = mapData['username'];
    this.status = mapData['status'];
    this.state = mapData['state'];
    this.profilePhoto = mapData['profilePhoto'];
    this.emailVerified = mapData['emailVerified'];
  }
}
