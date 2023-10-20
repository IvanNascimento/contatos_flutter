class Contatos {
  List<ContatoModel> contatos = [];

  Contatos(this.contatos);

  Contatos.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      contatos = <ContatoModel>[];
      json['results'].forEach((v) {
        contatos.add(ContatoModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['results'] = contatos.map((v) => v.toJson()).toList();
    return data;
  }
}

class ContatoModel {
  String? objectId;
  String? image;
  String? name;
  String? number;
  String? email;

  ContatoModel({this.objectId, this.image, this.name, this.number, this.email});

  ContatoModel.empty();

  ContatoModel.fromJson(Map<String, dynamic> json) {
    objectId = json['objectId'];
    image = json['image'];
    name = json['name'];
    number = json['number'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['objectId'] = objectId;
    data['image'] = image;
    data['name'] = name;
    data['number'] = number;
    data['email'] = email;
    return data;
  }
}
