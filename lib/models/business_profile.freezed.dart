// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'business_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BusinessProfile _$BusinessProfileFromJson(Map<String, dynamic> json) {
  return _BusinessProfile.fromJson(json);
}

/// @nodoc
mixin _$BusinessProfile {
  String get id => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String? get businessName => throw _privateConstructorUsedError;
  String? get logoUrl => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String? get taxId => throw _privateConstructorUsedError;
  String get defaultCurrency => throw _privateConstructorUsedError;
  int get defaultPaymentTermsDays => throw _privateConstructorUsedError;
  String? get stripeAccountId => throw _privateConstructorUsedError;
  bool get stripeConnected => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this BusinessProfile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BusinessProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BusinessProfileCopyWith<BusinessProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BusinessProfileCopyWith<$Res> {
  factory $BusinessProfileCopyWith(
    BusinessProfile value,
    $Res Function(BusinessProfile) then,
  ) = _$BusinessProfileCopyWithImpl<$Res, BusinessProfile>;
  @useResult
  $Res call({
    String id,
    String email,
    String? businessName,
    String? logoUrl,
    String? address,
    String? taxId,
    String defaultCurrency,
    int defaultPaymentTermsDays,
    String? stripeAccountId,
    bool stripeConnected,
    DateTime createdAt,
  });
}

/// @nodoc
class _$BusinessProfileCopyWithImpl<$Res, $Val extends BusinessProfile>
    implements $BusinessProfileCopyWith<$Res> {
  _$BusinessProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BusinessProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? businessName = freezed,
    Object? logoUrl = freezed,
    Object? address = freezed,
    Object? taxId = freezed,
    Object? defaultCurrency = null,
    Object? defaultPaymentTermsDays = null,
    Object? stripeAccountId = freezed,
    Object? stripeConnected = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            businessName: freezed == businessName
                ? _value.businessName
                : businessName // ignore: cast_nullable_to_non_nullable
                      as String?,
            logoUrl: freezed == logoUrl
                ? _value.logoUrl
                : logoUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            address: freezed == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as String?,
            taxId: freezed == taxId
                ? _value.taxId
                : taxId // ignore: cast_nullable_to_non_nullable
                      as String?,
            defaultCurrency: null == defaultCurrency
                ? _value.defaultCurrency
                : defaultCurrency // ignore: cast_nullable_to_non_nullable
                      as String,
            defaultPaymentTermsDays: null == defaultPaymentTermsDays
                ? _value.defaultPaymentTermsDays
                : defaultPaymentTermsDays // ignore: cast_nullable_to_non_nullable
                      as int,
            stripeAccountId: freezed == stripeAccountId
                ? _value.stripeAccountId
                : stripeAccountId // ignore: cast_nullable_to_non_nullable
                      as String?,
            stripeConnected: null == stripeConnected
                ? _value.stripeConnected
                : stripeConnected // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BusinessProfileImplCopyWith<$Res>
    implements $BusinessProfileCopyWith<$Res> {
  factory _$$BusinessProfileImplCopyWith(
    _$BusinessProfileImpl value,
    $Res Function(_$BusinessProfileImpl) then,
  ) = __$$BusinessProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String email,
    String? businessName,
    String? logoUrl,
    String? address,
    String? taxId,
    String defaultCurrency,
    int defaultPaymentTermsDays,
    String? stripeAccountId,
    bool stripeConnected,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$BusinessProfileImplCopyWithImpl<$Res>
    extends _$BusinessProfileCopyWithImpl<$Res, _$BusinessProfileImpl>
    implements _$$BusinessProfileImplCopyWith<$Res> {
  __$$BusinessProfileImplCopyWithImpl(
    _$BusinessProfileImpl _value,
    $Res Function(_$BusinessProfileImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BusinessProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? businessName = freezed,
    Object? logoUrl = freezed,
    Object? address = freezed,
    Object? taxId = freezed,
    Object? defaultCurrency = null,
    Object? defaultPaymentTermsDays = null,
    Object? stripeAccountId = freezed,
    Object? stripeConnected = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$BusinessProfileImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        businessName: freezed == businessName
            ? _value.businessName
            : businessName // ignore: cast_nullable_to_non_nullable
                  as String?,
        logoUrl: freezed == logoUrl
            ? _value.logoUrl
            : logoUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        address: freezed == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String?,
        taxId: freezed == taxId
            ? _value.taxId
            : taxId // ignore: cast_nullable_to_non_nullable
                  as String?,
        defaultCurrency: null == defaultCurrency
            ? _value.defaultCurrency
            : defaultCurrency // ignore: cast_nullable_to_non_nullable
                  as String,
        defaultPaymentTermsDays: null == defaultPaymentTermsDays
            ? _value.defaultPaymentTermsDays
            : defaultPaymentTermsDays // ignore: cast_nullable_to_non_nullable
                  as int,
        stripeAccountId: freezed == stripeAccountId
            ? _value.stripeAccountId
            : stripeAccountId // ignore: cast_nullable_to_non_nullable
                  as String?,
        stripeConnected: null == stripeConnected
            ? _value.stripeConnected
            : stripeConnected // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BusinessProfileImpl implements _BusinessProfile {
  const _$BusinessProfileImpl({
    required this.id,
    required this.email,
    this.businessName,
    this.logoUrl,
    this.address,
    this.taxId,
    this.defaultCurrency = 'USD',
    this.defaultPaymentTermsDays = 30,
    this.stripeAccountId,
    this.stripeConnected = false,
    required this.createdAt,
  });

  factory _$BusinessProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$BusinessProfileImplFromJson(json);

  @override
  final String id;
  @override
  final String email;
  @override
  final String? businessName;
  @override
  final String? logoUrl;
  @override
  final String? address;
  @override
  final String? taxId;
  @override
  @JsonKey()
  final String defaultCurrency;
  @override
  @JsonKey()
  final int defaultPaymentTermsDays;
  @override
  final String? stripeAccountId;
  @override
  @JsonKey()
  final bool stripeConnected;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'BusinessProfile(id: $id, email: $email, businessName: $businessName, logoUrl: $logoUrl, address: $address, taxId: $taxId, defaultCurrency: $defaultCurrency, defaultPaymentTermsDays: $defaultPaymentTermsDays, stripeAccountId: $stripeAccountId, stripeConnected: $stripeConnected, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BusinessProfileImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.businessName, businessName) ||
                other.businessName == businessName) &&
            (identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.taxId, taxId) || other.taxId == taxId) &&
            (identical(other.defaultCurrency, defaultCurrency) ||
                other.defaultCurrency == defaultCurrency) &&
            (identical(
                  other.defaultPaymentTermsDays,
                  defaultPaymentTermsDays,
                ) ||
                other.defaultPaymentTermsDays == defaultPaymentTermsDays) &&
            (identical(other.stripeAccountId, stripeAccountId) ||
                other.stripeAccountId == stripeAccountId) &&
            (identical(other.stripeConnected, stripeConnected) ||
                other.stripeConnected == stripeConnected) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    email,
    businessName,
    logoUrl,
    address,
    taxId,
    defaultCurrency,
    defaultPaymentTermsDays,
    stripeAccountId,
    stripeConnected,
    createdAt,
  );

  /// Create a copy of BusinessProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BusinessProfileImplCopyWith<_$BusinessProfileImpl> get copyWith =>
      __$$BusinessProfileImplCopyWithImpl<_$BusinessProfileImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$BusinessProfileImplToJson(this);
  }
}

abstract class _BusinessProfile implements BusinessProfile {
  const factory _BusinessProfile({
    required final String id,
    required final String email,
    final String? businessName,
    final String? logoUrl,
    final String? address,
    final String? taxId,
    final String defaultCurrency,
    final int defaultPaymentTermsDays,
    final String? stripeAccountId,
    final bool stripeConnected,
    required final DateTime createdAt,
  }) = _$BusinessProfileImpl;

  factory _BusinessProfile.fromJson(Map<String, dynamic> json) =
      _$BusinessProfileImpl.fromJson;

  @override
  String get id;
  @override
  String get email;
  @override
  String? get businessName;
  @override
  String? get logoUrl;
  @override
  String? get address;
  @override
  String? get taxId;
  @override
  String get defaultCurrency;
  @override
  int get defaultPaymentTermsDays;
  @override
  String? get stripeAccountId;
  @override
  bool get stripeConnected;
  @override
  DateTime get createdAt;

  /// Create a copy of BusinessProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BusinessProfileImplCopyWith<_$BusinessProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
