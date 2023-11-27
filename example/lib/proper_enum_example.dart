import 'package:proper_enum/proper_enum.dart';

part 'proper_enum_example.proper_enum.dart';

@ProperEnum()
enum _WebEvent<T> {
  pageLoad,
  pageUpload(),
  keyPress<String>(),
  click<(double, double)>(),
  paste<String>();
}

void main() {
  final WebEvent state = PageLoad();
  switch (state) {
    case PageLoad():
      // Do something
      break;
    case PageUpload():
      // Do something
      break;
    case KeyPress(v: final key):
      // Do something
      break;
    case Click(:final v):
      final (x, y) = v;
      // Do something
      break;
    case Paste(v: final paste):
    // Do something
  }
}