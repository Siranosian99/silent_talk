class AiResponseModel {
  String? conversationId;
  String? role;
  String? content;
  String? refusal;
  String? reasoning;

  AiResponseModel({this.role, this.content, this.refusal, this.reasoning,this.conversationId});

  AiResponseModel.fromJson(Map<String, dynamic> json) {
    role = json['role'];
    content = json['content'];
    refusal = json['refusal'];
    reasoning = json['reasoning'];
    conversationId = json['conversationId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['role'] = role;
    data['content'] = content;
    data['refusal'] = refusal;
    data['reasoning'] = reasoning;
    data['conversationId'] = conversationId;
    return data;
  }
  @override
  String toString() {
    return 'AiResponseModel(role: $role, content: $content, refusal: $refusal, reasoning: $reasoning,conversationId:$conversationId)';
  }
}