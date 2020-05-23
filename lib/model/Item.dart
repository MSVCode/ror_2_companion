
enum STACK_TYPE {LINEAR, EXPONENTIAL, HYPERBOLIC, BANDOLIER, RUSTED_KEY}
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
    STACK_TYPE stackType = map["stackType"]!=null?STACK_TYPE.values[map["stackType"]]:null;

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
  /// base proc-coefficient in scalar (0-1) | the probability to proc chain
  double procCoef;
  /// Damage from items (flat or %) that calculates from a certain type of damage
  String damage;
  /// Healing from items (flat or % or regen/s) for survivor
  String heal; 
  /// what increased by stacking
  List<ItemStatus> statusList;

  DAMAGE_TYPE damageType;
  RARITY rarity;
  List<ITEM_CATEGORY> itemCategory;

  Item({
    this.id,
    this.name,
    this.description,
    this.detail,
    this.lore,
    this.procCoef,
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

    List<dynamic> icList = map["itemCategory"];
    List<ITEM_CATEGORY> itemCategory = icList.map<ITEM_CATEGORY>((val)=>ITEM_CATEGORY.values[val ?? 0]).toList();

    DAMAGE_TYPE damageType = map["damageType"]!=null?DAMAGE_TYPE.values[map["damageType"]]:null;
    RARITY rarity = RARITY.values[map["rarity"] ?? 0];

    return Item(
      id: map["id"],
      name: map["name"],
      description: map["description"],
      detail: map["detail"],
      lore: map["lore"],
      procCoef: map["procCoef"],
      damage: map["damage"],
      heal: map["heal"],
      statusList: statusList,
      damageType: damageType,
      rarity: rarity,
      itemCategory: itemCategory,
  );
  }
}