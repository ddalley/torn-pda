enum TargetSortType {
  levelDes,
  levelAsc,
  respectDes,
  respectAsc,
  nameDes,
  nameAsc,
  lifeDes,
  lifeAsc,
  colorAsc,
  colorDes,
}

class TargetSort {
  TargetSortType type;
  String description;

  TargetSort({this.type}) {
    switch (type) {
      case TargetSortType.levelDes:
        description = 'Sort by level (des)';
        break;
      case TargetSortType.levelAsc:
        description = 'Sort by level (asc)';
        break;
      case TargetSortType.respectDes:
        description = 'Sort by respect (des)';
        break;
      case TargetSortType.respectAsc:
        description = 'Sort by respect (asc)';
        break;
      case TargetSortType.nameDes:
        description = 'Sort by name (des)';
        break;
      case TargetSortType.nameAsc:
        description = 'Sort by name (asc)';
        break;
      case TargetSortType.lifeDes:
        description = 'Sort by life (des)';
        break;
      case TargetSortType.lifeAsc:
        description = 'Sort by life (asc)';
        break;
      case TargetSortType.colorDes:
        description = 'Sort by color (#-R-Y-G)';
        break;
      case TargetSortType.colorAsc:
        description = 'Sort by color (G-Y-R-#)';
        break;
    }
  }
}
