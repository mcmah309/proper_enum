import 'package:build/build.dart';
import 'package:proper_enum/proper_enum.dart';
import 'package:source_gen/source_gen.dart';

import 'generator.dart';

/// Creates a [PartBuilder] used to generate code for [ProperEnum] annotated
/// enums. The [options] are provided by Dart's build system and read from the
/// `build.yaml` file.
Builder properEnumGeneratorFactory(BuilderOptions options) => PartBuilder(
      [const ProperEnumGenerator()],
      '.proper_enum.dart',
    );
