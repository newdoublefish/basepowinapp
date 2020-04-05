// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'version.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Version _$VersionFromJson(Map<String, dynamic> json) {
  return Version()
    ..version = json['version'] as String
    ..app_url = json['app_url'] as String
    ..is_valid = json['is_valid'] as bool
    ..terminal_type = json['terminal_type'] as int
    ..release_note = json['release_note'] as String;
}

Map<String, dynamic> _$VersionToJson(Version instance) => <String, dynamic>{
      'version': instance.version,
      'app_url': instance.app_url,
      'is_valid': instance.is_valid,
      'terminal_type': instance.terminal_type,
      'release_note': instance.release_note
    };
