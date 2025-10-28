class AiChatModel {
  String? role;
  String? content;
  String? refusal;
  String? reasoning;

  AiChatModel({this.role, this.content, this.refusal, this.reasoning});

  AiChatModel.fromJson(Map<String, dynamic> json) {
    role = json['role'];
    content = json['content'];
    refusal = json['refusal'];
    reasoning = json['reasoning'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['role'] = this.role;
    data['content'] = this.content;
    data['refusal'] = this.refusal;
    data['reasoning'] = this.reasoning;
    return data;
  }
  @override
  String toString() {
    return 'AiChatModel(role: $role, content: $content, refusal: $refusal, reasoning: $reasoning)';
  }
}