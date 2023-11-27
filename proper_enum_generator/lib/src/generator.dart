import 'package:analyzer/dart/element/element.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:proper_enum/proper_enum.dart';
import 'package:source_gen/source_gen.dart';

final class ProperEnumGenerator extends GeneratorForAnnotation<ProperEnum> {
  const ProperEnumGenerator();

  @override
  String generateForAnnotatedElement(Element element, ConstantReader annotation, BuildStep buildStep) {
    if (element is! EnumElement) {
      throw InvalidGenerationSourceError("Generator cannot target ${element.displayName}");
    }
    return "// This is from generator";
    // final Class classBuilder = Class((builder) {
    //   builder
    //     ..modifier = ClassModifier.final$
    //     ..name = name
    //     ..extend = refer(friendlyName)
    //     ..fields.add(_buildDefinitionTypeMethod(friendlyName))
    //     ..constructors.add(_generateConstructor())
    //     ..methods.addAll(_parseMethods(
    //       element,
    //       baseUrl,
    //       baseUrlVariableElement,
    //     ));
    // });
  }
}
