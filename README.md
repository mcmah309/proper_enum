# proper_enum

Example of how it should work.

```dart
//@Deprecated("use generated version instead")
@Enum
enum _WebEvent<T> {
  PageLoad,
  KeyPress<String>(),
  Click<(double, double)>(),
  Paste<String>();
}
```

```dart
// Generates Below
sealed class WebEvent {
  factory WebEvent.PageLoad() = PageLoad;

  factory WebEvent.KeyPress(String v) = KeyPress;

  factory WebEvent.Click((double, double) v) = Click;
}

final class PageLoad implements WebEvent {
  const PageLoad();
}

final class KeyPress implements WebEvent {
  final String v;

  const KeyPress(this.v);
}

final class Click implements WebEvent {
  final (double, double) v;

  const Click(this.v);
}

final class Paste implements WebEvent {
  final String v;

  const Paste(this.v);
}
```

```dart
// Example usage
void test(WebEvent state) {
  state = WebEvent.PageLoad();
  switch (state) {
    case PageLoad():
    // Do something
      break;
    case KeyPress(v:final key):
    // Do something
      break;
    case Click(:final v):
      final (x, y) = v;
      // Do something
      break;
    case Paste(v:final paste):
    // Do something
  }
}
```
