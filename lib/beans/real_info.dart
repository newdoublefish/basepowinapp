class RealInfo {
  final String status;
  final String type;
  final String component;
  final String occurredAt;
  final String message;

  RealInfo(
      this.status, this.type, this.component, this.occurredAt, this.message);

  RealInfo.fromJson(Map<String, dynamic> json)
      : status = json['status'],
        type = json['type'],
        component = json['component'],
        occurredAt = json['occurredAt'],
        message = json['message'];

  Map<String, dynamic> toJson()=>{
    'status':status,
    'type':type,
    'component':component,
    'occurredAt':occurredAt,
    'message':message,
  };

  @override
  String toString()
  {
    return '$status,$type,$component,$occurredAt,$message';
  }
}
