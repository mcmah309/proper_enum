import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:built_collection/built_collection.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:proper_enum/proper_enum.dart';
import 'package:source_gen/source_gen.dart';
import 'package:source_helper/source_helper.dart';

final class ProperEnumGenerator extends GeneratorForAnnotation<ProperEnum> {
  const ProperEnumGenerator();

  @override
  String generateForAnnotatedElement(Element element, ConstantReader annotation, BuildStep buildStep) {
    if (element is! EnumElement) {
      throw InvalidGenerationSourceError("Generator cannot generator for target.", element: element);
    }
    if (element.typeParameters.length > 1) {
      throw InvalidGenerationSourceError("Enum cannot have more than 1 type parameter.", element: element);
    }
    bool hasTypeParameter = element.typeParameters.length == 1;
    final subClasses = <(String, DartType?)>{};
    for (final (index, field) in element.fields.indexed) {
      // Last field of an enum is value
      if (index == element.fields.length - 1) {
        break;
      }
      final String className = field.name.nonPrivate.pascal;
      DartType? innerType;
      if (hasTypeParameter) {
        final type = field.type;
        if (type is! InterfaceType) {
          throw ProperEnumLogicError(
              "LogicError: All enum values should be InterfaceTypes. For ${element.displayName}");
        }
        final fieldTypes = type.typeArguments;
        if (fieldTypes.length != 1) {
          throw ProperEnumLogicError(
              "TypeArguments should match the typeParameters of the enum. For For ${element.displayName}");
        }
        if (fieldTypes[0] is! DynamicType) {
          innerType = fieldTypes[0];
        }
      }
      subClasses.add((className, innerType));
    }

    final classes = <Class>[];

    final baseClass = Class((c) => c
      ..name = element.name.nonPrivate.pascal
      ..sealed = true);
    classes.add(baseClass);

    for (final (name, innerType) in subClasses) {
      final classBuilder = ClassBuilder()
        ..modifier = ClassModifier.final$
        ..name = name
        ..implements = (ListBuilder()..add(refer(baseClass.name)));
      if (innerType != null) {
        final innerTypeReference = refer(innerType.toString());
        final fieldBuilder = FieldBuilder()
          ..name = "v"
          ..type = innerTypeReference
          ..modifier = FieldModifier.final$;
        classBuilder.fields = ListBuilder()..add(fieldBuilder.build());
        final constructor = Constructor((c) => c
          ..constant = true
          ..requiredParameters = (ListBuilder()
            ..add(Parameter((m) => m
              ..name = "v"
              ..toThis = true))));
        classBuilder.constructors = ListBuilder()..add(constructor);
      }
      classes.add(classBuilder.build());
    }
    final DartEmitter emitter = DartEmitter(useNullSafetySyntax: true);
    final fileString = classes.map((e) => e.accept(emitter).toString()).join("\n");
    return DartFormatter().format(fileString);
  }
}

class ProperEnumLogicError extends Error {
  final String msg;

  ProperEnumLogicError(this.msg);

  @override
  String toString() {
    return "ProperEnumLogicError: $msg";
  }
}
