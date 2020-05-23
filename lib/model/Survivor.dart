enum SKILL_TYPE { PASSIVE, PRIMARY, SECONDARY, UTILITY, SPECIAL }

/// Some skills have multiple proc coefficient
class SkillProc {
  String name;
  double procCoef;

  SkillProc({this.name, this.procCoef});

  static fromMap(Map<String, dynamic> map) {
    return SkillProc(
      name: map["type"],
      procCoef: map["procCoef"],
    );
  }
}

class Skill {
  SKILL_TYPE skillType;
  /// n-th skill/loadout | starts at 0
  int variant;

  String name;
  String description;
  double cooldown;

  /// Some skills have multiple proc coefficient
  List<SkillProc> procList;

  /// Damage modifier in scalar
  double damage;

  /// Skill notes (if available)
  List<String> noteList;

  Skill({
    this.skillType,
    this.variant,
    this.name,
    this.description,
    this.cooldown,
    this.procList,
    this.damage,
    this.noteList,
  });

  static fromMap(Map<String, dynamic> map) {
    SKILL_TYPE skillType = SKILL_TYPE.values[map["skillType"] ?? 0];

    List<dynamic> ipList = map["procList"];
    List<SkillProc> procList =
        ipList.map<SkillProc>((val) => SkillProc.fromMap(val)).toList();

    List<dynamic> inList = map["noteList"];
    List<String> noteList = inList.map<String>((val) => val).toList();

    return Skill(
      skillType: skillType,
      variant: map["variant"],
      name: map["name"],
      description: map["description"],
      cooldown: map["cooldown"],
      procList: procList,
      damage: map["damage"],
      noteList: noteList,
    );
  }
}

class Survivor {
  /// ordered-id
  int id;
  String name;

  /// in-game desc
  String description;

  /// detailed description
  String detail;

  double health;
  double addedHealth;
  double regen;
  double addedRegen;
  double damage;
  double addedDamage;
  double speed;
  double armor;

  //skills, ordered by DB (declaration order)
  List<Skill> skillList;

  Survivor({
    this.id,
    this.name,
    this.description,
    this.detail,
    this.health,
    this.addedHealth,
    this.damage,
    this.addedDamage,
    this.regen,
    this.addedRegen,
    this.speed,
    this.armor,
    this.skillList,
  });

  static fromMap(Map<String, dynamic> map) {
    List<dynamic> isList = map["skillList"];
    List<Skill> skillList =
        isList.map<Skill>((val) => Skill.fromMap(val)).toList();

    return Survivor(
      id: map["id"],
      name: map["name"],
      description: map["description"],
      detail: map["detail"],
      health: map["health"],
      addedHealth: map["addedHealth"],
      damage: map["damage"],
      addedDamage: map["addedDamage"],
      regen: map["regen"],
      addedRegen: map["addedRegen"],
      speed: map["speed"],
      armor: map["armor"],
      skillList: skillList,
    );
  }
}
