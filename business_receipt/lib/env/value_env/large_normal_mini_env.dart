enum Level { large, normal, mini }

const List<double> _textSizeList = [30, 22, 14];
const List<double> _iconSizeList = [30, 25, 18];
const List<double> _paddingList = [20, 11, 8];
const List<double> _dialogSizeList = [1500, 1000, 700];

const List<double> _printPaddingList = [15, 5, 1];
const List<double> _printTextSizeList = [25, 17, 13];
// const List<double> _printCardTextSizeList = [20, 16, 13];

double dialogSizeGlobal({required Level level}) {
  int indexLevel({required Level level}) {
    return level.index;
  }

  return _dialogSizeList[indexLevel(level: level)];
}

double textSizeGlobal({required Level level}) {
  int indexLevel({required Level level}) {
    return level.index;
  }

  return _textSizeList[indexLevel(level: level)];
}

double iconSizeGlobal({required Level level}) {
  int indexLevel({required Level level}) {
    return level.index;
  }

  return _iconSizeList[indexLevel(level: level)];
}

double paddingSizeGlobal({required Level level}) {
  int indexLevel({required Level level}) {
    return level.index;
  }

  return _paddingList[indexLevel(level: level)];
}

double printPaddingSizeGlobal({required Level level}) {
  int indexLevel({required Level level}) {
    return level.index;
  }

  return _printPaddingList[indexLevel(level: level)];
}

double printTextSizeGlobal({required Level level}) {
  int indexLevel({required Level level}) {
    return level.index;
  }

  return _printTextSizeList[indexLevel(level: level)];
  // return isCardSize ? _printCardTextSizeList[indexLevel(level: level)] : _printTextSizeList[indexLevel(level: level)];
}
