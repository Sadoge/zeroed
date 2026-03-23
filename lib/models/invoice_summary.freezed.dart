// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'invoice_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

InvoiceSummary _$InvoiceSummaryFromJson(Map<String, dynamic> json) {
  return _InvoiceSummary.fromJson(json);
}

/// @nodoc
mixin _$InvoiceSummary {
  double get totalOutstanding => throw _privateConstructorUsedError;
  double get totalOverdue => throw _privateConstructorUsedError;
  double get paidThisMonth => throw _privateConstructorUsedError;
  int get invoiceCount => throw _privateConstructorUsedError;
  int get overdueCount => throw _privateConstructorUsedError;

  /// Serializes this InvoiceSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InvoiceSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InvoiceSummaryCopyWith<InvoiceSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InvoiceSummaryCopyWith<$Res> {
  factory $InvoiceSummaryCopyWith(
    InvoiceSummary value,
    $Res Function(InvoiceSummary) then,
  ) = _$InvoiceSummaryCopyWithImpl<$Res, InvoiceSummary>;
  @useResult
  $Res call({
    double totalOutstanding,
    double totalOverdue,
    double paidThisMonth,
    int invoiceCount,
    int overdueCount,
  });
}

/// @nodoc
class _$InvoiceSummaryCopyWithImpl<$Res, $Val extends InvoiceSummary>
    implements $InvoiceSummaryCopyWith<$Res> {
  _$InvoiceSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InvoiceSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalOutstanding = null,
    Object? totalOverdue = null,
    Object? paidThisMonth = null,
    Object? invoiceCount = null,
    Object? overdueCount = null,
  }) {
    return _then(
      _value.copyWith(
            totalOutstanding: null == totalOutstanding
                ? _value.totalOutstanding
                : totalOutstanding // ignore: cast_nullable_to_non_nullable
                      as double,
            totalOverdue: null == totalOverdue
                ? _value.totalOverdue
                : totalOverdue // ignore: cast_nullable_to_non_nullable
                      as double,
            paidThisMonth: null == paidThisMonth
                ? _value.paidThisMonth
                : paidThisMonth // ignore: cast_nullable_to_non_nullable
                      as double,
            invoiceCount: null == invoiceCount
                ? _value.invoiceCount
                : invoiceCount // ignore: cast_nullable_to_non_nullable
                      as int,
            overdueCount: null == overdueCount
                ? _value.overdueCount
                : overdueCount // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$InvoiceSummaryImplCopyWith<$Res>
    implements $InvoiceSummaryCopyWith<$Res> {
  factory _$$InvoiceSummaryImplCopyWith(
    _$InvoiceSummaryImpl value,
    $Res Function(_$InvoiceSummaryImpl) then,
  ) = __$$InvoiceSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    double totalOutstanding,
    double totalOverdue,
    double paidThisMonth,
    int invoiceCount,
    int overdueCount,
  });
}

/// @nodoc
class __$$InvoiceSummaryImplCopyWithImpl<$Res>
    extends _$InvoiceSummaryCopyWithImpl<$Res, _$InvoiceSummaryImpl>
    implements _$$InvoiceSummaryImplCopyWith<$Res> {
  __$$InvoiceSummaryImplCopyWithImpl(
    _$InvoiceSummaryImpl _value,
    $Res Function(_$InvoiceSummaryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InvoiceSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalOutstanding = null,
    Object? totalOverdue = null,
    Object? paidThisMonth = null,
    Object? invoiceCount = null,
    Object? overdueCount = null,
  }) {
    return _then(
      _$InvoiceSummaryImpl(
        totalOutstanding: null == totalOutstanding
            ? _value.totalOutstanding
            : totalOutstanding // ignore: cast_nullable_to_non_nullable
                  as double,
        totalOverdue: null == totalOverdue
            ? _value.totalOverdue
            : totalOverdue // ignore: cast_nullable_to_non_nullable
                  as double,
        paidThisMonth: null == paidThisMonth
            ? _value.paidThisMonth
            : paidThisMonth // ignore: cast_nullable_to_non_nullable
                  as double,
        invoiceCount: null == invoiceCount
            ? _value.invoiceCount
            : invoiceCount // ignore: cast_nullable_to_non_nullable
                  as int,
        overdueCount: null == overdueCount
            ? _value.overdueCount
            : overdueCount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$InvoiceSummaryImpl implements _InvoiceSummary {
  const _$InvoiceSummaryImpl({
    this.totalOutstanding = 0,
    this.totalOverdue = 0,
    this.paidThisMonth = 0,
    this.invoiceCount = 0,
    this.overdueCount = 0,
  });

  factory _$InvoiceSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$InvoiceSummaryImplFromJson(json);

  @override
  @JsonKey()
  final double totalOutstanding;
  @override
  @JsonKey()
  final double totalOverdue;
  @override
  @JsonKey()
  final double paidThisMonth;
  @override
  @JsonKey()
  final int invoiceCount;
  @override
  @JsonKey()
  final int overdueCount;

  @override
  String toString() {
    return 'InvoiceSummary(totalOutstanding: $totalOutstanding, totalOverdue: $totalOverdue, paidThisMonth: $paidThisMonth, invoiceCount: $invoiceCount, overdueCount: $overdueCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InvoiceSummaryImpl &&
            (identical(other.totalOutstanding, totalOutstanding) ||
                other.totalOutstanding == totalOutstanding) &&
            (identical(other.totalOverdue, totalOverdue) ||
                other.totalOverdue == totalOverdue) &&
            (identical(other.paidThisMonth, paidThisMonth) ||
                other.paidThisMonth == paidThisMonth) &&
            (identical(other.invoiceCount, invoiceCount) ||
                other.invoiceCount == invoiceCount) &&
            (identical(other.overdueCount, overdueCount) ||
                other.overdueCount == overdueCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalOutstanding,
    totalOverdue,
    paidThisMonth,
    invoiceCount,
    overdueCount,
  );

  /// Create a copy of InvoiceSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InvoiceSummaryImplCopyWith<_$InvoiceSummaryImpl> get copyWith =>
      __$$InvoiceSummaryImplCopyWithImpl<_$InvoiceSummaryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$InvoiceSummaryImplToJson(this);
  }
}

abstract class _InvoiceSummary implements InvoiceSummary {
  const factory _InvoiceSummary({
    final double totalOutstanding,
    final double totalOverdue,
    final double paidThisMonth,
    final int invoiceCount,
    final int overdueCount,
  }) = _$InvoiceSummaryImpl;

  factory _InvoiceSummary.fromJson(Map<String, dynamic> json) =
      _$InvoiceSummaryImpl.fromJson;

  @override
  double get totalOutstanding;
  @override
  double get totalOverdue;
  @override
  double get paidThisMonth;
  @override
  int get invoiceCount;
  @override
  int get overdueCount;

  /// Create a copy of InvoiceSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InvoiceSummaryImplCopyWith<_$InvoiceSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
