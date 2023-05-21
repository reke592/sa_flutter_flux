/// subclass implementation MUST have a factory fromJson
abstract class Serializable<T> {
  Map<String, dynamic> toJson();
}
