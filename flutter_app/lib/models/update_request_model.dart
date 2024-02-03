class UpdateRequestModel {
  String? accessToken;
  String? refreshToken;
  String? name;
  String? address;

  UpdateRequestModel(
      {this.accessToken, this.refreshToken, this.name, this.address});

  UpdateRequestModel.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
    refreshToken = json['refreshToken'];
    name = json['name'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accessToken'] = this.accessToken;
    data['refreshToken'] = this.refreshToken;
    data['name'] = this.name;
    data['address'] = this.address;
    return data;
  }
}