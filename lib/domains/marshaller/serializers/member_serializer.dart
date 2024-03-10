import 'package:mineral/api/server/member.dart';
import 'package:mineral/domains/marshaller/marshaller.dart';
import 'package:mineral/domains/marshaller/types/serializer.dart';

final class MemberSerializer implements SerializerContract<Member> {
  final MarshallerContract _marshaller;

  MemberSerializer(this._marshaller);

  @override
  Future<Member> serialize(Map<String, dynamic> json) => Member.fromJson(_marshaller, json);

  @override
  Map<String, dynamic> deserialize(Member object) {
    throw UnimplementedError();
  }
}
