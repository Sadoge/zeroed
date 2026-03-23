// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'invoice_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Invoice _$InvoiceFromJson(Map<String, dynamic> json) {
  return _Invoice.fromJson(json);
}

/// @nodoc
mixin _$Invoice {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'client_id')
  String? get clientId => throw _privateConstructorUsedError;
  @JsonKey(name: 'invoice_number')
  String get invoiceNumber => throw _privateConstructorUsedError;
  InvoiceStatus get status => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  @JsonKey(name: 'line_items')
  List<LineItem> get lineItems => throw _privateConstructorUsedError;
  @JsonKey(name: 'tax_rate')
  double? get taxRate => throw _privateConstructorUsedError;
  @JsonKey(name: 'due_date')
  DateTime get dueDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'sent_at')
  DateTime? get sentAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'paid_at')
  DateTime? get paidAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'stripe_payment_link')
  String? get stripePaymentLink => throw _privateConstructorUsedError;
  @JsonKey(name: 'pdf_url')
  String? get pdfUrl => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_recurring')
  bool get isRecurring => throw _privateConstructorUsedError;
  @JsonKey(name: 'recurrence_interval')
  String? get recurrenceInterval => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Invoice to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Invoice
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InvoiceCopyWith<Invoice> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InvoiceCopyWith<$Res> {
  factory $InvoiceCopyWith(Invoice value, $Res Function(Invoice) then) =
      _$InvoiceCopyWithImpl<$Res, Invoice>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'client_id') String? clientId,
    @JsonKey(name: 'invoice_number') String invoiceNumber,
    InvoiceStatus status,
    String currency,
    @JsonKey(name: 'line_items') List<LineItem> lineItems,
    @JsonKey(name: 'tax_rate') double? taxRate,
    @JsonKey(name: 'due_date') DateTime dueDate,
    @JsonKey(name: 'sent_at') DateTime? sentAt,
    @JsonKey(name: 'paid_at') DateTime? paidAt,
    @JsonKey(name: 'stripe_payment_link') String? stripePaymentLink,
    @JsonKey(name: 'pdf_url') String? pdfUrl,
    String? notes,
    @JsonKey(name: 'is_recurring') bool isRecurring,
    @JsonKey(name: 'recurrence_interval') String? recurrenceInterval,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
  });
}

/// @nodoc
class _$InvoiceCopyWithImpl<$Res, $Val extends Invoice>
    implements $InvoiceCopyWith<$Res> {
  _$InvoiceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Invoice
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? clientId = freezed,
    Object? invoiceNumber = null,
    Object? status = null,
    Object? currency = null,
    Object? lineItems = null,
    Object? taxRate = freezed,
    Object? dueDate = null,
    Object? sentAt = freezed,
    Object? paidAt = freezed,
    Object? stripePaymentLink = freezed,
    Object? pdfUrl = freezed,
    Object? notes = freezed,
    Object? isRecurring = null,
    Object? recurrenceInterval = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            clientId: freezed == clientId
                ? _value.clientId
                : clientId // ignore: cast_nullable_to_non_nullable
                      as String?,
            invoiceNumber: null == invoiceNumber
                ? _value.invoiceNumber
                : invoiceNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as InvoiceStatus,
            currency: null == currency
                ? _value.currency
                : currency // ignore: cast_nullable_to_non_nullable
                      as String,
            lineItems: null == lineItems
                ? _value.lineItems
                : lineItems // ignore: cast_nullable_to_non_nullable
                      as List<LineItem>,
            taxRate: freezed == taxRate
                ? _value.taxRate
                : taxRate // ignore: cast_nullable_to_non_nullable
                      as double?,
            dueDate: null == dueDate
                ? _value.dueDate
                : dueDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            sentAt: freezed == sentAt
                ? _value.sentAt
                : sentAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            paidAt: freezed == paidAt
                ? _value.paidAt
                : paidAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            stripePaymentLink: freezed == stripePaymentLink
                ? _value.stripePaymentLink
                : stripePaymentLink // ignore: cast_nullable_to_non_nullable
                      as String?,
            pdfUrl: freezed == pdfUrl
                ? _value.pdfUrl
                : pdfUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            isRecurring: null == isRecurring
                ? _value.isRecurring
                : isRecurring // ignore: cast_nullable_to_non_nullable
                      as bool,
            recurrenceInterval: freezed == recurrenceInterval
                ? _value.recurrenceInterval
                : recurrenceInterval // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$InvoiceImplCopyWith<$Res> implements $InvoiceCopyWith<$Res> {
  factory _$$InvoiceImplCopyWith(
    _$InvoiceImpl value,
    $Res Function(_$InvoiceImpl) then,
  ) = __$$InvoiceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'client_id') String? clientId,
    @JsonKey(name: 'invoice_number') String invoiceNumber,
    InvoiceStatus status,
    String currency,
    @JsonKey(name: 'line_items') List<LineItem> lineItems,
    @JsonKey(name: 'tax_rate') double? taxRate,
    @JsonKey(name: 'due_date') DateTime dueDate,
    @JsonKey(name: 'sent_at') DateTime? sentAt,
    @JsonKey(name: 'paid_at') DateTime? paidAt,
    @JsonKey(name: 'stripe_payment_link') String? stripePaymentLink,
    @JsonKey(name: 'pdf_url') String? pdfUrl,
    String? notes,
    @JsonKey(name: 'is_recurring') bool isRecurring,
    @JsonKey(name: 'recurrence_interval') String? recurrenceInterval,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
  });
}

/// @nodoc
class __$$InvoiceImplCopyWithImpl<$Res>
    extends _$InvoiceCopyWithImpl<$Res, _$InvoiceImpl>
    implements _$$InvoiceImplCopyWith<$Res> {
  __$$InvoiceImplCopyWithImpl(
    _$InvoiceImpl _value,
    $Res Function(_$InvoiceImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Invoice
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? clientId = freezed,
    Object? invoiceNumber = null,
    Object? status = null,
    Object? currency = null,
    Object? lineItems = null,
    Object? taxRate = freezed,
    Object? dueDate = null,
    Object? sentAt = freezed,
    Object? paidAt = freezed,
    Object? stripePaymentLink = freezed,
    Object? pdfUrl = freezed,
    Object? notes = freezed,
    Object? isRecurring = null,
    Object? recurrenceInterval = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$InvoiceImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        clientId: freezed == clientId
            ? _value.clientId
            : clientId // ignore: cast_nullable_to_non_nullable
                  as String?,
        invoiceNumber: null == invoiceNumber
            ? _value.invoiceNumber
            : invoiceNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as InvoiceStatus,
        currency: null == currency
            ? _value.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String,
        lineItems: null == lineItems
            ? _value._lineItems
            : lineItems // ignore: cast_nullable_to_non_nullable
                  as List<LineItem>,
        taxRate: freezed == taxRate
            ? _value.taxRate
            : taxRate // ignore: cast_nullable_to_non_nullable
                  as double?,
        dueDate: null == dueDate
            ? _value.dueDate
            : dueDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        sentAt: freezed == sentAt
            ? _value.sentAt
            : sentAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        paidAt: freezed == paidAt
            ? _value.paidAt
            : paidAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        stripePaymentLink: freezed == stripePaymentLink
            ? _value.stripePaymentLink
            : stripePaymentLink // ignore: cast_nullable_to_non_nullable
                  as String?,
        pdfUrl: freezed == pdfUrl
            ? _value.pdfUrl
            : pdfUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        isRecurring: null == isRecurring
            ? _value.isRecurring
            : isRecurring // ignore: cast_nullable_to_non_nullable
                  as bool,
        recurrenceInterval: freezed == recurrenceInterval
            ? _value.recurrenceInterval
            : recurrenceInterval // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$InvoiceImpl extends _Invoice {
  const _$InvoiceImpl({
    required this.id,
    @JsonKey(name: 'user_id') required this.userId,
    @JsonKey(name: 'client_id') this.clientId,
    @JsonKey(name: 'invoice_number') required this.invoiceNumber,
    this.status = InvoiceStatus.draft,
    this.currency = 'USD',
    @JsonKey(name: 'line_items') final List<LineItem> lineItems = const [],
    @JsonKey(name: 'tax_rate') this.taxRate,
    @JsonKey(name: 'due_date') required this.dueDate,
    @JsonKey(name: 'sent_at') this.sentAt,
    @JsonKey(name: 'paid_at') this.paidAt,
    @JsonKey(name: 'stripe_payment_link') this.stripePaymentLink,
    @JsonKey(name: 'pdf_url') this.pdfUrl,
    this.notes,
    @JsonKey(name: 'is_recurring') this.isRecurring = false,
    @JsonKey(name: 'recurrence_interval') this.recurrenceInterval,
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'updated_at') required this.updatedAt,
  }) : _lineItems = lineItems,
       super._();

  factory _$InvoiceImpl.fromJson(Map<String, dynamic> json) =>
      _$$InvoiceImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'client_id')
  final String? clientId;
  @override
  @JsonKey(name: 'invoice_number')
  final String invoiceNumber;
  @override
  @JsonKey()
  final InvoiceStatus status;
  @override
  @JsonKey()
  final String currency;
  final List<LineItem> _lineItems;
  @override
  @JsonKey(name: 'line_items')
  List<LineItem> get lineItems {
    if (_lineItems is EqualUnmodifiableListView) return _lineItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_lineItems);
  }

  @override
  @JsonKey(name: 'tax_rate')
  final double? taxRate;
  @override
  @JsonKey(name: 'due_date')
  final DateTime dueDate;
  @override
  @JsonKey(name: 'sent_at')
  final DateTime? sentAt;
  @override
  @JsonKey(name: 'paid_at')
  final DateTime? paidAt;
  @override
  @JsonKey(name: 'stripe_payment_link')
  final String? stripePaymentLink;
  @override
  @JsonKey(name: 'pdf_url')
  final String? pdfUrl;
  @override
  final String? notes;
  @override
  @JsonKey(name: 'is_recurring')
  final bool isRecurring;
  @override
  @JsonKey(name: 'recurrence_interval')
  final String? recurrenceInterval;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'Invoice(id: $id, userId: $userId, clientId: $clientId, invoiceNumber: $invoiceNumber, status: $status, currency: $currency, lineItems: $lineItems, taxRate: $taxRate, dueDate: $dueDate, sentAt: $sentAt, paidAt: $paidAt, stripePaymentLink: $stripePaymentLink, pdfUrl: $pdfUrl, notes: $notes, isRecurring: $isRecurring, recurrenceInterval: $recurrenceInterval, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InvoiceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
            (identical(other.invoiceNumber, invoiceNumber) ||
                other.invoiceNumber == invoiceNumber) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            const DeepCollectionEquality().equals(
              other._lineItems,
              _lineItems,
            ) &&
            (identical(other.taxRate, taxRate) || other.taxRate == taxRate) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.sentAt, sentAt) || other.sentAt == sentAt) &&
            (identical(other.paidAt, paidAt) || other.paidAt == paidAt) &&
            (identical(other.stripePaymentLink, stripePaymentLink) ||
                other.stripePaymentLink == stripePaymentLink) &&
            (identical(other.pdfUrl, pdfUrl) || other.pdfUrl == pdfUrl) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.isRecurring, isRecurring) ||
                other.isRecurring == isRecurring) &&
            (identical(other.recurrenceInterval, recurrenceInterval) ||
                other.recurrenceInterval == recurrenceInterval) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    clientId,
    invoiceNumber,
    status,
    currency,
    const DeepCollectionEquality().hash(_lineItems),
    taxRate,
    dueDate,
    sentAt,
    paidAt,
    stripePaymentLink,
    pdfUrl,
    notes,
    isRecurring,
    recurrenceInterval,
    createdAt,
    updatedAt,
  );

  /// Create a copy of Invoice
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InvoiceImplCopyWith<_$InvoiceImpl> get copyWith =>
      __$$InvoiceImplCopyWithImpl<_$InvoiceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InvoiceImplToJson(this);
  }
}

abstract class _Invoice extends Invoice {
  const factory _Invoice({
    required final String id,
    @JsonKey(name: 'user_id') required final String userId,
    @JsonKey(name: 'client_id') final String? clientId,
    @JsonKey(name: 'invoice_number') required final String invoiceNumber,
    final InvoiceStatus status,
    final String currency,
    @JsonKey(name: 'line_items') final List<LineItem> lineItems,
    @JsonKey(name: 'tax_rate') final double? taxRate,
    @JsonKey(name: 'due_date') required final DateTime dueDate,
    @JsonKey(name: 'sent_at') final DateTime? sentAt,
    @JsonKey(name: 'paid_at') final DateTime? paidAt,
    @JsonKey(name: 'stripe_payment_link') final String? stripePaymentLink,
    @JsonKey(name: 'pdf_url') final String? pdfUrl,
    final String? notes,
    @JsonKey(name: 'is_recurring') final bool isRecurring,
    @JsonKey(name: 'recurrence_interval') final String? recurrenceInterval,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
    @JsonKey(name: 'updated_at') required final DateTime updatedAt,
  }) = _$InvoiceImpl;
  const _Invoice._() : super._();

  factory _Invoice.fromJson(Map<String, dynamic> json) = _$InvoiceImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'client_id')
  String? get clientId;
  @override
  @JsonKey(name: 'invoice_number')
  String get invoiceNumber;
  @override
  InvoiceStatus get status;
  @override
  String get currency;
  @override
  @JsonKey(name: 'line_items')
  List<LineItem> get lineItems;
  @override
  @JsonKey(name: 'tax_rate')
  double? get taxRate;
  @override
  @JsonKey(name: 'due_date')
  DateTime get dueDate;
  @override
  @JsonKey(name: 'sent_at')
  DateTime? get sentAt;
  @override
  @JsonKey(name: 'paid_at')
  DateTime? get paidAt;
  @override
  @JsonKey(name: 'stripe_payment_link')
  String? get stripePaymentLink;
  @override
  @JsonKey(name: 'pdf_url')
  String? get pdfUrl;
  @override
  String? get notes;
  @override
  @JsonKey(name: 'is_recurring')
  bool get isRecurring;
  @override
  @JsonKey(name: 'recurrence_interval')
  String? get recurrenceInterval;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;

  /// Create a copy of Invoice
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InvoiceImplCopyWith<_$InvoiceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
