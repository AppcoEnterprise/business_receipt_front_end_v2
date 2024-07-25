
//--------------millisecond delay-------------------------
Future delayMillisecond({required int millisecond}) async {
  await Future.delayed(Duration(milliseconds: millisecond));
}
