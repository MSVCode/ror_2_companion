
enum STACK_TYPE {NONE, LINEAR, EXPONENTIAL, HYPERBOLIC, BANDOLIER, RUSTED_KEY}
enum DAMAGE_TYPE {BASE, TOTAL}
enum RARITY {COMMON, UNCOMMON, LEGENDARY, BOSS, LUNAR, EQUIPMENT}
enum ITEM_CATEGORY {HEAL, DAMAGE, UTILITY, EQUIPMENT}

class ItemStatus {
  String type;
  String initialAmount;
  STACK_TYPE stackType;
  String addedAmount;

  ItemStatus({
    this.type,
    this.initialAmount,
    this.stackType,
    this.addedAmount
  });

  static fromMap(Map<String, dynamic> map) {
    STACK_TYPE stackType = STACK_TYPE.values[map["stackType"] ?? 0];

    return ItemStatus(
      type: map["type"],
      initialAmount: map["initialAmount"],
      stackType: stackType,
      addedAmount: map["addedAmount"],
    );
  }
}

class Item {
  /// in-game id
  int id;
  String name;
  /// in-game desc
  String description;
  /// detailed description
  String detail;
  String lore;
  /// base proc-chance in percent (0-100)
  double procChance;
  /// Damaging items (flat or %)
  String damage;
  /// Healing items (flat or %)
  String heal; 
  /// what increased by stacking
  List<ItemStatus> statusList;

  DAMAGE_TYPE damageType;
  RARITY rarity;
  ITEM_CATEGORY itemCategory;

  Item({
    this.id,
    this.name,
    this.description,
    this.detail,
    this.lore,
    this.procChance,
    this.damage,
    this.heal,
    this.statusList,
    this.damageType,
    this.rarity,
    this.itemCategory,
  });

  static fromMap(Map<String, dynamic> map) {
    List<dynamic> isList = map["statusList"];
    List<ItemStatus> statusList = isList.map<ItemStatus>((val)=>ItemStatus.fromMap(val)).toList();

    DAMAGE_TYPE damageType = map["damageType"]!=null?DAMAGE_TYPE.values[map["damageType"]]:null;
    RARITY rarity = RARITY.values[map["rarity"] ?? 0];
    ITEM_CATEGORY itemCategory = ITEM_CATEGORY.values[map["itemCategory"] ?? 0];

    return Item(
      id: map["id"],
      name: map["name"],
      description: map["description"],
      detail: map["detail"],
      lore: map["lore"],
      procChance: map["procChance"],
      damage: map["damage"],
      heal: map["heal"],
      statusList: statusList,
      damageType: damageType,
      rarity: rarity,
      itemCategory: itemCategory,
  );
  }
}