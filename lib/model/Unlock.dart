
enum UNLOCK_TYPE {ITEM, SURVIVOR, SKILL}

///Unlocking item/survivor/skill
class Unlock {
  /// replaces id | it's better to be unchanged
  /// For item, the key is `item-id`
  String key;
  String name;
  String description;
  UNLOCK_TYPE unlockType;

  Unlock({
    this.key,
    this.name,
    this.description,
    this.unlockType
  });

  static fromMap(Map<String, dynamic> map) {
    UNLOCK_TYPE unlockType = UNLOCK_TYPE.values[map["type"] ?? 0];

    return Unlock(
      key: map["key"],
      name: map["name"],
      description: map["description"],
      unlockType: unlockType
    );
  }
}