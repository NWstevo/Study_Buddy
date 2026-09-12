// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weekly_view_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(activeSubjects)
final activeSubjectsProvider = ActiveSubjectsProvider._();

final class ActiveSubjectsProvider extends $FunctionalProvider<
        AsyncValue<List<Subject>>, List<Subject>, Stream<List<Subject>>>
    with $FutureModifier<List<Subject>>, $StreamProvider<List<Subject>> {
  ActiveSubjectsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'activeSubjectsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$activeSubjectsHash();

  @$internal
  @override
  $StreamProviderElement<List<Subject>> $createElement(
          $ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Subject>> create(Ref ref) {
    return activeSubjects(ref);
  }
}

String _$activeSubjectsHash() => r'afb9e9ff41140ed2983fd7952177e039a251efe9';

@ProviderFor(allTaskDefinitions)
final allTaskDefinitionsProvider = AllTaskDefinitionsProvider._();

final class AllTaskDefinitionsProvider extends $FunctionalProvider<
        AsyncValue<List<TaskDefinition>>,
        List<TaskDefinition>,
        Stream<List<TaskDefinition>>>
    with
        $FutureModifier<List<TaskDefinition>>,
        $StreamProvider<List<TaskDefinition>> {
  AllTaskDefinitionsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'allTaskDefinitionsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$allTaskDefinitionsHash();

  @$internal
  @override
  $StreamProviderElement<List<TaskDefinition>> $createElement(
          $ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<TaskDefinition>> create(Ref ref) {
    return allTaskDefinitions(ref);
  }
}

String _$allTaskDefinitionsHash() =>
    r'607e939014d96ffbda3342d311d68e142f05caff';

/// Keyed by the Monday of the week to watch (normalized so the family cache
/// doesn't churn on time-of-day differences).

@ProviderFor(weekOccurrences)
final weekOccurrencesProvider = WeekOccurrencesFamily._();

/// Keyed by the Monday of the week to watch (normalized so the family cache
/// doesn't churn on time-of-day differences).

final class WeekOccurrencesProvider extends $FunctionalProvider<
        AsyncValue<List<TaskOccurrence>>,
        List<TaskOccurrence>,
        Stream<List<TaskOccurrence>>>
    with
        $FutureModifier<List<TaskOccurrence>>,
        $StreamProvider<List<TaskOccurrence>> {
  /// Keyed by the Monday of the week to watch (normalized so the family cache
  /// doesn't churn on time-of-day differences).
  WeekOccurrencesProvider._(
      {required WeekOccurrencesFamily super.from,
      required DateTime super.argument})
      : super(
          retry: null,
          name: r'weekOccurrencesProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$weekOccurrencesHash();

  @override
  String toString() {
    return r'weekOccurrencesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<TaskOccurrence>> $createElement(
          $ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<TaskOccurrence>> create(Ref ref) {
    final argument = this.argument as DateTime;
    return weekOccurrences(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is WeekOccurrencesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$weekOccurrencesHash() => r'f4833090b362b54a17283441544bb7ff0244f1e5';

/// Keyed by the Monday of the week to watch (normalized so the family cache
/// doesn't churn on time-of-day differences).

final class WeekOccurrencesFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<TaskOccurrence>>, DateTime> {
  WeekOccurrencesFamily._()
      : super(
          retry: null,
          name: r'weekOccurrencesProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Keyed by the Monday of the week to watch (normalized so the family cache
  /// doesn't churn on time-of-day differences).

  WeekOccurrencesProvider call(
    DateTime weekStart,
  ) =>
      WeekOccurrencesProvider._(argument: weekStart, from: this);

  @override
  String toString() => r'weekOccurrencesProvider';
}

@ProviderFor(WeeklyViewController)
final weeklyViewControllerProvider = WeeklyViewControllerProvider._();

final class WeeklyViewControllerProvider
    extends $NotifierProvider<WeeklyViewController, WeeklyViewSelection> {
  WeeklyViewControllerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'weeklyViewControllerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$weeklyViewControllerHash();

  @$internal
  @override
  WeeklyViewController create() => WeeklyViewController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WeeklyViewSelection value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WeeklyViewSelection>(value),
    );
  }
}

String _$weeklyViewControllerHash() =>
    r'0eebca95390d3db5c827c3db9a9c91269835775b';

abstract class _$WeeklyViewController extends $Notifier<WeeklyViewSelection> {
  WeeklyViewSelection build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<WeeklyViewSelection, WeeklyViewSelection>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<WeeklyViewSelection, WeeklyViewSelection>,
        WeeklyViewSelection,
        Object?,
        Object?>;
    return element.handleCreate(ref, build);
  }
}
