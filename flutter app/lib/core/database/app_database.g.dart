// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $BusinessProfilesTable extends BusinessProfiles
    with TableInfo<$BusinessProfilesTable, BusinessProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BusinessProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumnWithTypeConverter<SyncStatus, String> syncStatus =
      GeneratedColumn<String>('sync_status', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: Constant(SyncStatus.pending.name))
          .withConverter<SyncStatus>(
              $BusinessProfilesTable.$convertersyncStatus);
  static const VerificationMeta _remoteIdMeta =
      const VerificationMeta('remoteId');
  @override
  late final GeneratedColumn<String> remoteId = GeneratedColumn<String>(
      'remote_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _businessNameMeta =
      const VerificationMeta('businessName');
  @override
  late final GeneratedColumn<String> businessName = GeneratedColumn<String>(
      'business_name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 200),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _businessNameNepaliMeta =
      const VerificationMeta('businessNameNepali');
  @override
  late final GeneratedColumn<String> businessNameNepali =
      GeneratedColumn<String>('business_name_nepali', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _panVatNumberMeta =
      const VerificationMeta('panVatNumber');
  @override
  late final GeneratedColumn<String> panVatNumber = GeneratedColumn<String>(
      'pan_vat_number', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 9, maxTextLength: 9),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _contactNumberMeta =
      const VerificationMeta('contactNumber');
  @override
  late final GeneratedColumn<String> contactNumber = GeneratedColumn<String>(
      'contact_number', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 10, maxTextLength: 15),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _shopAddressMeta =
      const VerificationMeta('shopAddress');
  @override
  late final GeneratedColumn<String> shopAddress = GeneratedColumn<String>(
      'shop_address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _logoPathMeta =
      const VerificationMeta('logoPath');
  @override
  late final GeneratedColumn<String> logoPath = GeneratedColumn<String>(
      'logo_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isCurrentMeta =
      const VerificationMeta('isCurrent');
  @override
  late final GeneratedColumn<bool> isCurrent = GeneratedColumn<bool>(
      'is_current', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_current" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        createdAt,
        updatedAt,
        syncStatus,
        remoteId,
        isDeleted,
        businessName,
        businessNameNepali,
        panVatNumber,
        contactNumber,
        shopAddress,
        logoPath,
        isCurrent
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'business_profiles';
  @override
  VerificationContext validateIntegrity(Insertable<BusinessProfile> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    context.handle(_syncStatusMeta, const VerificationResult.success());
    if (data.containsKey('remote_id')) {
      context.handle(_remoteIdMeta,
          remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    if (data.containsKey('business_name')) {
      context.handle(
          _businessNameMeta,
          businessName.isAcceptableOrUnknown(
              data['business_name']!, _businessNameMeta));
    } else if (isInserting) {
      context.missing(_businessNameMeta);
    }
    if (data.containsKey('business_name_nepali')) {
      context.handle(
          _businessNameNepaliMeta,
          businessNameNepali.isAcceptableOrUnknown(
              data['business_name_nepali']!, _businessNameNepaliMeta));
    }
    if (data.containsKey('pan_vat_number')) {
      context.handle(
          _panVatNumberMeta,
          panVatNumber.isAcceptableOrUnknown(
              data['pan_vat_number']!, _panVatNumberMeta));
    } else if (isInserting) {
      context.missing(_panVatNumberMeta);
    }
    if (data.containsKey('contact_number')) {
      context.handle(
          _contactNumberMeta,
          contactNumber.isAcceptableOrUnknown(
              data['contact_number']!, _contactNumberMeta));
    } else if (isInserting) {
      context.missing(_contactNumberMeta);
    }
    if (data.containsKey('shop_address')) {
      context.handle(
          _shopAddressMeta,
          shopAddress.isAcceptableOrUnknown(
              data['shop_address']!, _shopAddressMeta));
    }
    if (data.containsKey('logo_path')) {
      context.handle(_logoPathMeta,
          logoPath.isAcceptableOrUnknown(data['logo_path']!, _logoPathMeta));
    }
    if (data.containsKey('is_current')) {
      context.handle(_isCurrentMeta,
          isCurrent.isAcceptableOrUnknown(data['is_current']!, _isCurrentMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BusinessProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BusinessProfile(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      syncStatus: $BusinessProfilesTable.$convertersyncStatus.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}sync_status'])!),
      remoteId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}remote_id']),
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
      businessName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}business_name'])!,
      businessNameNepali: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}business_name_nepali']),
      panVatNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pan_vat_number'])!,
      contactNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}contact_number'])!,
      shopAddress: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}shop_address']),
      logoPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}logo_path']),
      isCurrent: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_current'])!,
    );
  }

  @override
  $BusinessProfilesTable createAlias(String alias) {
    return $BusinessProfilesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SyncStatus, String, String> $convertersyncStatus =
      const EnumNameConverter<SyncStatus>(SyncStatus.values);
}

class BusinessProfile extends DataClass implements Insertable<BusinessProfile> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final SyncStatus syncStatus;
  final String? remoteId;
  final bool isDeleted;
  final String businessName;
  final String? businessNameNepali;
  final String panVatNumber;
  final String contactNumber;
  final String? shopAddress;
  final String? logoPath;
  final bool isCurrent;
  const BusinessProfile(
      {required this.id,
      required this.createdAt,
      required this.updatedAt,
      required this.syncStatus,
      this.remoteId,
      required this.isDeleted,
      required this.businessName,
      this.businessNameNepali,
      required this.panVatNumber,
      required this.contactNumber,
      this.shopAddress,
      this.logoPath,
      required this.isCurrent});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    {
      map['sync_status'] = Variable<String>(
          $BusinessProfilesTable.$convertersyncStatus.toSql(syncStatus));
    }
    if (!nullToAbsent || remoteId != null) {
      map['remote_id'] = Variable<String>(remoteId);
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['business_name'] = Variable<String>(businessName);
    if (!nullToAbsent || businessNameNepali != null) {
      map['business_name_nepali'] = Variable<String>(businessNameNepali);
    }
    map['pan_vat_number'] = Variable<String>(panVatNumber);
    map['contact_number'] = Variable<String>(contactNumber);
    if (!nullToAbsent || shopAddress != null) {
      map['shop_address'] = Variable<String>(shopAddress);
    }
    if (!nullToAbsent || logoPath != null) {
      map['logo_path'] = Variable<String>(logoPath);
    }
    map['is_current'] = Variable<bool>(isCurrent);
    return map;
  }

  BusinessProfilesCompanion toCompanion(bool nullToAbsent) {
    return BusinessProfilesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncStatus: Value(syncStatus),
      remoteId: remoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteId),
      isDeleted: Value(isDeleted),
      businessName: Value(businessName),
      businessNameNepali: businessNameNepali == null && nullToAbsent
          ? const Value.absent()
          : Value(businessNameNepali),
      panVatNumber: Value(panVatNumber),
      contactNumber: Value(contactNumber),
      shopAddress: shopAddress == null && nullToAbsent
          ? const Value.absent()
          : Value(shopAddress),
      logoPath: logoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(logoPath),
      isCurrent: Value(isCurrent),
    );
  }

  factory BusinessProfile.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BusinessProfile(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncStatus: $BusinessProfilesTable.$convertersyncStatus
          .fromJson(serializer.fromJson<String>(json['syncStatus'])),
      remoteId: serializer.fromJson<String?>(json['remoteId']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      businessName: serializer.fromJson<String>(json['businessName']),
      businessNameNepali:
          serializer.fromJson<String?>(json['businessNameNepali']),
      panVatNumber: serializer.fromJson<String>(json['panVatNumber']),
      contactNumber: serializer.fromJson<String>(json['contactNumber']),
      shopAddress: serializer.fromJson<String?>(json['shopAddress']),
      logoPath: serializer.fromJson<String?>(json['logoPath']),
      isCurrent: serializer.fromJson<bool>(json['isCurrent']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncStatus': serializer.toJson<String>(
          $BusinessProfilesTable.$convertersyncStatus.toJson(syncStatus)),
      'remoteId': serializer.toJson<String?>(remoteId),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'businessName': serializer.toJson<String>(businessName),
      'businessNameNepali': serializer.toJson<String?>(businessNameNepali),
      'panVatNumber': serializer.toJson<String>(panVatNumber),
      'contactNumber': serializer.toJson<String>(contactNumber),
      'shopAddress': serializer.toJson<String?>(shopAddress),
      'logoPath': serializer.toJson<String?>(logoPath),
      'isCurrent': serializer.toJson<bool>(isCurrent),
    };
  }

  BusinessProfile copyWith(
          {String? id,
          DateTime? createdAt,
          DateTime? updatedAt,
          SyncStatus? syncStatus,
          Value<String?> remoteId = const Value.absent(),
          bool? isDeleted,
          String? businessName,
          Value<String?> businessNameNepali = const Value.absent(),
          String? panVatNumber,
          String? contactNumber,
          Value<String?> shopAddress = const Value.absent(),
          Value<String?> logoPath = const Value.absent(),
          bool? isCurrent}) =>
      BusinessProfile(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        syncStatus: syncStatus ?? this.syncStatus,
        remoteId: remoteId.present ? remoteId.value : this.remoteId,
        isDeleted: isDeleted ?? this.isDeleted,
        businessName: businessName ?? this.businessName,
        businessNameNepali: businessNameNepali.present
            ? businessNameNepali.value
            : this.businessNameNepali,
        panVatNumber: panVatNumber ?? this.panVatNumber,
        contactNumber: contactNumber ?? this.contactNumber,
        shopAddress: shopAddress.present ? shopAddress.value : this.shopAddress,
        logoPath: logoPath.present ? logoPath.value : this.logoPath,
        isCurrent: isCurrent ?? this.isCurrent,
      );
  BusinessProfile copyWithCompanion(BusinessProfilesCompanion data) {
    return BusinessProfile(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      businessName: data.businessName.present
          ? data.businessName.value
          : this.businessName,
      businessNameNepali: data.businessNameNepali.present
          ? data.businessNameNepali.value
          : this.businessNameNepali,
      panVatNumber: data.panVatNumber.present
          ? data.panVatNumber.value
          : this.panVatNumber,
      contactNumber: data.contactNumber.present
          ? data.contactNumber.value
          : this.contactNumber,
      shopAddress:
          data.shopAddress.present ? data.shopAddress.value : this.shopAddress,
      logoPath: data.logoPath.present ? data.logoPath.value : this.logoPath,
      isCurrent: data.isCurrent.present ? data.isCurrent.value : this.isCurrent,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BusinessProfile(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('remoteId: $remoteId, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('businessName: $businessName, ')
          ..write('businessNameNepali: $businessNameNepali, ')
          ..write('panVatNumber: $panVatNumber, ')
          ..write('contactNumber: $contactNumber, ')
          ..write('shopAddress: $shopAddress, ')
          ..write('logoPath: $logoPath, ')
          ..write('isCurrent: $isCurrent')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      createdAt,
      updatedAt,
      syncStatus,
      remoteId,
      isDeleted,
      businessName,
      businessNameNepali,
      panVatNumber,
      contactNumber,
      shopAddress,
      logoPath,
      isCurrent);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BusinessProfile &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus &&
          other.remoteId == this.remoteId &&
          other.isDeleted == this.isDeleted &&
          other.businessName == this.businessName &&
          other.businessNameNepali == this.businessNameNepali &&
          other.panVatNumber == this.panVatNumber &&
          other.contactNumber == this.contactNumber &&
          other.shopAddress == this.shopAddress &&
          other.logoPath == this.logoPath &&
          other.isCurrent == this.isCurrent);
}

class BusinessProfilesCompanion extends UpdateCompanion<BusinessProfile> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<SyncStatus> syncStatus;
  final Value<String?> remoteId;
  final Value<bool> isDeleted;
  final Value<String> businessName;
  final Value<String?> businessNameNepali;
  final Value<String> panVatNumber;
  final Value<String> contactNumber;
  final Value<String?> shopAddress;
  final Value<String?> logoPath;
  final Value<bool> isCurrent;
  final Value<int> rowid;
  const BusinessProfilesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.businessName = const Value.absent(),
    this.businessNameNepali = const Value.absent(),
    this.panVatNumber = const Value.absent(),
    this.contactNumber = const Value.absent(),
    this.shopAddress = const Value.absent(),
    this.logoPath = const Value.absent(),
    this.isCurrent = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BusinessProfilesCompanion.insert({
    required String id,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.isDeleted = const Value.absent(),
    required String businessName,
    this.businessNameNepali = const Value.absent(),
    required String panVatNumber,
    required String contactNumber,
    this.shopAddress = const Value.absent(),
    this.logoPath = const Value.absent(),
    this.isCurrent = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        businessName = Value(businessName),
        panVatNumber = Value(panVatNumber),
        contactNumber = Value(contactNumber);
  static Insertable<BusinessProfile> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncStatus,
    Expression<String>? remoteId,
    Expression<bool>? isDeleted,
    Expression<String>? businessName,
    Expression<String>? businessNameNepali,
    Expression<String>? panVatNumber,
    Expression<String>? contactNumber,
    Expression<String>? shopAddress,
    Expression<String>? logoPath,
    Expression<bool>? isCurrent,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (remoteId != null) 'remote_id': remoteId,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (businessName != null) 'business_name': businessName,
      if (businessNameNepali != null)
        'business_name_nepali': businessNameNepali,
      if (panVatNumber != null) 'pan_vat_number': panVatNumber,
      if (contactNumber != null) 'contact_number': contactNumber,
      if (shopAddress != null) 'shop_address': shopAddress,
      if (logoPath != null) 'logo_path': logoPath,
      if (isCurrent != null) 'is_current': isCurrent,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BusinessProfilesCompanion copyWith(
      {Value<String>? id,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<SyncStatus>? syncStatus,
      Value<String?>? remoteId,
      Value<bool>? isDeleted,
      Value<String>? businessName,
      Value<String?>? businessNameNepali,
      Value<String>? panVatNumber,
      Value<String>? contactNumber,
      Value<String?>? shopAddress,
      Value<String?>? logoPath,
      Value<bool>? isCurrent,
      Value<int>? rowid}) {
    return BusinessProfilesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      remoteId: remoteId ?? this.remoteId,
      isDeleted: isDeleted ?? this.isDeleted,
      businessName: businessName ?? this.businessName,
      businessNameNepali: businessNameNepali ?? this.businessNameNepali,
      panVatNumber: panVatNumber ?? this.panVatNumber,
      contactNumber: contactNumber ?? this.contactNumber,
      shopAddress: shopAddress ?? this.shopAddress,
      logoPath: logoPath ?? this.logoPath,
      isCurrent: isCurrent ?? this.isCurrent,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(
          $BusinessProfilesTable.$convertersyncStatus.toSql(syncStatus.value));
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (businessName.present) {
      map['business_name'] = Variable<String>(businessName.value);
    }
    if (businessNameNepali.present) {
      map['business_name_nepali'] = Variable<String>(businessNameNepali.value);
    }
    if (panVatNumber.present) {
      map['pan_vat_number'] = Variable<String>(panVatNumber.value);
    }
    if (contactNumber.present) {
      map['contact_number'] = Variable<String>(contactNumber.value);
    }
    if (shopAddress.present) {
      map['shop_address'] = Variable<String>(shopAddress.value);
    }
    if (logoPath.present) {
      map['logo_path'] = Variable<String>(logoPath.value);
    }
    if (isCurrent.present) {
      map['is_current'] = Variable<bool>(isCurrent.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BusinessProfilesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('remoteId: $remoteId, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('businessName: $businessName, ')
          ..write('businessNameNepali: $businessNameNepali, ')
          ..write('panVatNumber: $panVatNumber, ')
          ..write('contactNumber: $contactNumber, ')
          ..write('shopAddress: $shopAddress, ')
          ..write('logoPath: $logoPath, ')
          ..write('isCurrent: $isCurrent, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumnWithTypeConverter<SyncStatus, String> syncStatus =
      GeneratedColumn<String>('sync_status', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: Constant(SyncStatus.pending.name))
          .withConverter<SyncStatus>($CategoriesTable.$convertersyncStatus);
  static const VerificationMeta _remoteIdMeta =
      const VerificationMeta('remoteId');
  @override
  late final GeneratedColumn<String> remoteId = GeneratedColumn<String>(
      'remote_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _nepaliNameMeta =
      const VerificationMeta('nepaliName');
  @override
  late final GeneratedColumn<String> nepaliName = GeneratedColumn<String>(
      'nepali_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        createdAt,
        updatedAt,
        syncStatus,
        remoteId,
        isDeleted,
        name,
        nepaliName,
        description
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(Insertable<Category> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    context.handle(_syncStatusMeta, const VerificationResult.success());
    if (data.containsKey('remote_id')) {
      context.handle(_remoteIdMeta,
          remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('nepali_name')) {
      context.handle(
          _nepaliNameMeta,
          nepaliName.isAcceptableOrUnknown(
              data['nepali_name']!, _nepaliNameMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      syncStatus: $CategoriesTable.$convertersyncStatus.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!),
      remoteId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}remote_id']),
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      nepaliName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nepali_name']),
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SyncStatus, String, String> $convertersyncStatus =
      const EnumNameConverter<SyncStatus>(SyncStatus.values);
}

class Category extends DataClass implements Insertable<Category> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final SyncStatus syncStatus;
  final String? remoteId;
  final bool isDeleted;
  final String name;
  final String? nepaliName;
  final String? description;
  const Category(
      {required this.id,
      required this.createdAt,
      required this.updatedAt,
      required this.syncStatus,
      this.remoteId,
      required this.isDeleted,
      required this.name,
      this.nepaliName,
      this.description});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    {
      map['sync_status'] = Variable<String>(
          $CategoriesTable.$convertersyncStatus.toSql(syncStatus));
    }
    if (!nullToAbsent || remoteId != null) {
      map['remote_id'] = Variable<String>(remoteId);
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || nepaliName != null) {
      map['nepali_name'] = Variable<String>(nepaliName);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncStatus: Value(syncStatus),
      remoteId: remoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteId),
      isDeleted: Value(isDeleted),
      name: Value(name),
      nepaliName: nepaliName == null && nullToAbsent
          ? const Value.absent()
          : Value(nepaliName),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
    );
  }

  factory Category.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncStatus: $CategoriesTable.$convertersyncStatus
          .fromJson(serializer.fromJson<String>(json['syncStatus'])),
      remoteId: serializer.fromJson<String?>(json['remoteId']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      name: serializer.fromJson<String>(json['name']),
      nepaliName: serializer.fromJson<String?>(json['nepaliName']),
      description: serializer.fromJson<String?>(json['description']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncStatus': serializer.toJson<String>(
          $CategoriesTable.$convertersyncStatus.toJson(syncStatus)),
      'remoteId': serializer.toJson<String?>(remoteId),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'name': serializer.toJson<String>(name),
      'nepaliName': serializer.toJson<String?>(nepaliName),
      'description': serializer.toJson<String?>(description),
    };
  }

  Category copyWith(
          {String? id,
          DateTime? createdAt,
          DateTime? updatedAt,
          SyncStatus? syncStatus,
          Value<String?> remoteId = const Value.absent(),
          bool? isDeleted,
          String? name,
          Value<String?> nepaliName = const Value.absent(),
          Value<String?> description = const Value.absent()}) =>
      Category(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        syncStatus: syncStatus ?? this.syncStatus,
        remoteId: remoteId.present ? remoteId.value : this.remoteId,
        isDeleted: isDeleted ?? this.isDeleted,
        name: name ?? this.name,
        nepaliName: nepaliName.present ? nepaliName.value : this.nepaliName,
        description: description.present ? description.value : this.description,
      );
  Category copyWithCompanion(CategoriesCompanion data) {
    return Category(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      name: data.name.present ? data.name.value : this.name,
      nepaliName:
          data.nepaliName.present ? data.nepaliName.value : this.nepaliName,
      description:
          data.description.present ? data.description.value : this.description,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('remoteId: $remoteId, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('name: $name, ')
          ..write('nepaliName: $nepaliName, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, createdAt, updatedAt, syncStatus,
      remoteId, isDeleted, name, nepaliName, description);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus &&
          other.remoteId == this.remoteId &&
          other.isDeleted == this.isDeleted &&
          other.name == this.name &&
          other.nepaliName == this.nepaliName &&
          other.description == this.description);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<SyncStatus> syncStatus;
  final Value<String?> remoteId;
  final Value<bool> isDeleted;
  final Value<String> name;
  final Value<String?> nepaliName;
  final Value<String?> description;
  final Value<int> rowid;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.name = const Value.absent(),
    this.nepaliName = const Value.absent(),
    this.description = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriesCompanion.insert({
    required String id,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.isDeleted = const Value.absent(),
    required String name,
    this.nepaliName = const Value.absent(),
    this.description = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name);
  static Insertable<Category> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncStatus,
    Expression<String>? remoteId,
    Expression<bool>? isDeleted,
    Expression<String>? name,
    Expression<String>? nepaliName,
    Expression<String>? description,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (remoteId != null) 'remote_id': remoteId,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (name != null) 'name': name,
      if (nepaliName != null) 'nepali_name': nepaliName,
      if (description != null) 'description': description,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoriesCompanion copyWith(
      {Value<String>? id,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<SyncStatus>? syncStatus,
      Value<String?>? remoteId,
      Value<bool>? isDeleted,
      Value<String>? name,
      Value<String?>? nepaliName,
      Value<String?>? description,
      Value<int>? rowid}) {
    return CategoriesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      remoteId: remoteId ?? this.remoteId,
      isDeleted: isDeleted ?? this.isDeleted,
      name: name ?? this.name,
      nepaliName: nepaliName ?? this.nepaliName,
      description: description ?? this.description,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(
          $CategoriesTable.$convertersyncStatus.toSql(syncStatus.value));
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (nepaliName.present) {
      map['nepali_name'] = Variable<String>(nepaliName.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('remoteId: $remoteId, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('name: $name, ')
          ..write('nepaliName: $nepaliName, ')
          ..write('description: $description, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UnitsTable extends Units with TableInfo<$UnitsTable, Unit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UnitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumnWithTypeConverter<SyncStatus, String> syncStatus =
      GeneratedColumn<String>('sync_status', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: Constant(SyncStatus.pending.name))
          .withConverter<SyncStatus>($UnitsTable.$convertersyncStatus);
  static const VerificationMeta _remoteIdMeta =
      const VerificationMeta('remoteId');
  @override
  late final GeneratedColumn<String> remoteId = GeneratedColumn<String>(
      'remote_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _symbolMeta = const VerificationMeta('symbol');
  @override
  late final GeneratedColumn<String> symbol = GeneratedColumn<String>(
      'symbol', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 20),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _nepaliSymbolMeta =
      const VerificationMeta('nepaliSymbol');
  @override
  late final GeneratedColumn<String> nepaliSymbol = GeneratedColumn<String>(
      'nepali_symbol', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isFractionalMeta =
      const VerificationMeta('isFractional');
  @override
  late final GeneratedColumn<bool> isFractional = GeneratedColumn<bool>(
      'is_fractional', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_fractional" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        createdAt,
        updatedAt,
        syncStatus,
        remoteId,
        isDeleted,
        name,
        symbol,
        nepaliSymbol,
        isFractional
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'units';
  @override
  VerificationContext validateIntegrity(Insertable<Unit> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    context.handle(_syncStatusMeta, const VerificationResult.success());
    if (data.containsKey('remote_id')) {
      context.handle(_remoteIdMeta,
          remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('symbol')) {
      context.handle(_symbolMeta,
          symbol.isAcceptableOrUnknown(data['symbol']!, _symbolMeta));
    } else if (isInserting) {
      context.missing(_symbolMeta);
    }
    if (data.containsKey('nepali_symbol')) {
      context.handle(
          _nepaliSymbolMeta,
          nepaliSymbol.isAcceptableOrUnknown(
              data['nepali_symbol']!, _nepaliSymbolMeta));
    }
    if (data.containsKey('is_fractional')) {
      context.handle(
          _isFractionalMeta,
          isFractional.isAcceptableOrUnknown(
              data['is_fractional']!, _isFractionalMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Unit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Unit(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      syncStatus: $UnitsTable.$convertersyncStatus.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!),
      remoteId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}remote_id']),
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      symbol: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}symbol'])!,
      nepaliSymbol: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nepali_symbol']),
      isFractional: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_fractional'])!,
    );
  }

  @override
  $UnitsTable createAlias(String alias) {
    return $UnitsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SyncStatus, String, String> $convertersyncStatus =
      const EnumNameConverter<SyncStatus>(SyncStatus.values);
}

class Unit extends DataClass implements Insertable<Unit> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final SyncStatus syncStatus;
  final String? remoteId;
  final bool isDeleted;
  final String name;
  final String symbol;
  final String? nepaliSymbol;
  final bool isFractional;
  const Unit(
      {required this.id,
      required this.createdAt,
      required this.updatedAt,
      required this.syncStatus,
      this.remoteId,
      required this.isDeleted,
      required this.name,
      required this.symbol,
      this.nepaliSymbol,
      required this.isFractional});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    {
      map['sync_status'] =
          Variable<String>($UnitsTable.$convertersyncStatus.toSql(syncStatus));
    }
    if (!nullToAbsent || remoteId != null) {
      map['remote_id'] = Variable<String>(remoteId);
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['name'] = Variable<String>(name);
    map['symbol'] = Variable<String>(symbol);
    if (!nullToAbsent || nepaliSymbol != null) {
      map['nepali_symbol'] = Variable<String>(nepaliSymbol);
    }
    map['is_fractional'] = Variable<bool>(isFractional);
    return map;
  }

  UnitsCompanion toCompanion(bool nullToAbsent) {
    return UnitsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncStatus: Value(syncStatus),
      remoteId: remoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteId),
      isDeleted: Value(isDeleted),
      name: Value(name),
      symbol: Value(symbol),
      nepaliSymbol: nepaliSymbol == null && nullToAbsent
          ? const Value.absent()
          : Value(nepaliSymbol),
      isFractional: Value(isFractional),
    );
  }

  factory Unit.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Unit(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncStatus: $UnitsTable.$convertersyncStatus
          .fromJson(serializer.fromJson<String>(json['syncStatus'])),
      remoteId: serializer.fromJson<String?>(json['remoteId']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      name: serializer.fromJson<String>(json['name']),
      symbol: serializer.fromJson<String>(json['symbol']),
      nepaliSymbol: serializer.fromJson<String?>(json['nepaliSymbol']),
      isFractional: serializer.fromJson<bool>(json['isFractional']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncStatus': serializer
          .toJson<String>($UnitsTable.$convertersyncStatus.toJson(syncStatus)),
      'remoteId': serializer.toJson<String?>(remoteId),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'name': serializer.toJson<String>(name),
      'symbol': serializer.toJson<String>(symbol),
      'nepaliSymbol': serializer.toJson<String?>(nepaliSymbol),
      'isFractional': serializer.toJson<bool>(isFractional),
    };
  }

  Unit copyWith(
          {String? id,
          DateTime? createdAt,
          DateTime? updatedAt,
          SyncStatus? syncStatus,
          Value<String?> remoteId = const Value.absent(),
          bool? isDeleted,
          String? name,
          String? symbol,
          Value<String?> nepaliSymbol = const Value.absent(),
          bool? isFractional}) =>
      Unit(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        syncStatus: syncStatus ?? this.syncStatus,
        remoteId: remoteId.present ? remoteId.value : this.remoteId,
        isDeleted: isDeleted ?? this.isDeleted,
        name: name ?? this.name,
        symbol: symbol ?? this.symbol,
        nepaliSymbol:
            nepaliSymbol.present ? nepaliSymbol.value : this.nepaliSymbol,
        isFractional: isFractional ?? this.isFractional,
      );
  Unit copyWithCompanion(UnitsCompanion data) {
    return Unit(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      name: data.name.present ? data.name.value : this.name,
      symbol: data.symbol.present ? data.symbol.value : this.symbol,
      nepaliSymbol: data.nepaliSymbol.present
          ? data.nepaliSymbol.value
          : this.nepaliSymbol,
      isFractional: data.isFractional.present
          ? data.isFractional.value
          : this.isFractional,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Unit(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('remoteId: $remoteId, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('name: $name, ')
          ..write('symbol: $symbol, ')
          ..write('nepaliSymbol: $nepaliSymbol, ')
          ..write('isFractional: $isFractional')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, createdAt, updatedAt, syncStatus,
      remoteId, isDeleted, name, symbol, nepaliSymbol, isFractional);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Unit &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus &&
          other.remoteId == this.remoteId &&
          other.isDeleted == this.isDeleted &&
          other.name == this.name &&
          other.symbol == this.symbol &&
          other.nepaliSymbol == this.nepaliSymbol &&
          other.isFractional == this.isFractional);
}

class UnitsCompanion extends UpdateCompanion<Unit> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<SyncStatus> syncStatus;
  final Value<String?> remoteId;
  final Value<bool> isDeleted;
  final Value<String> name;
  final Value<String> symbol;
  final Value<String?> nepaliSymbol;
  final Value<bool> isFractional;
  final Value<int> rowid;
  const UnitsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.name = const Value.absent(),
    this.symbol = const Value.absent(),
    this.nepaliSymbol = const Value.absent(),
    this.isFractional = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UnitsCompanion.insert({
    required String id,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.isDeleted = const Value.absent(),
    required String name,
    required String symbol,
    this.nepaliSymbol = const Value.absent(),
    this.isFractional = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        symbol = Value(symbol);
  static Insertable<Unit> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncStatus,
    Expression<String>? remoteId,
    Expression<bool>? isDeleted,
    Expression<String>? name,
    Expression<String>? symbol,
    Expression<String>? nepaliSymbol,
    Expression<bool>? isFractional,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (remoteId != null) 'remote_id': remoteId,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (name != null) 'name': name,
      if (symbol != null) 'symbol': symbol,
      if (nepaliSymbol != null) 'nepali_symbol': nepaliSymbol,
      if (isFractional != null) 'is_fractional': isFractional,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UnitsCompanion copyWith(
      {Value<String>? id,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<SyncStatus>? syncStatus,
      Value<String?>? remoteId,
      Value<bool>? isDeleted,
      Value<String>? name,
      Value<String>? symbol,
      Value<String?>? nepaliSymbol,
      Value<bool>? isFractional,
      Value<int>? rowid}) {
    return UnitsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      remoteId: remoteId ?? this.remoteId,
      isDeleted: isDeleted ?? this.isDeleted,
      name: name ?? this.name,
      symbol: symbol ?? this.symbol,
      nepaliSymbol: nepaliSymbol ?? this.nepaliSymbol,
      isFractional: isFractional ?? this.isFractional,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(
          $UnitsTable.$convertersyncStatus.toSql(syncStatus.value));
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (symbol.present) {
      map['symbol'] = Variable<String>(symbol.value);
    }
    if (nepaliSymbol.present) {
      map['nepali_symbol'] = Variable<String>(nepaliSymbol.value);
    }
    if (isFractional.present) {
      map['is_fractional'] = Variable<bool>(isFractional.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UnitsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('remoteId: $remoteId, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('name: $name, ')
          ..write('symbol: $symbol, ')
          ..write('nepaliSymbol: $nepaliSymbol, ')
          ..write('isFractional: $isFractional, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ItemsTable extends Items with TableInfo<$ItemsTable, Item> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumnWithTypeConverter<SyncStatus, String> syncStatus =
      GeneratedColumn<String>('sync_status', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: Constant(SyncStatus.pending.name))
          .withConverter<SyncStatus>($ItemsTable.$convertersyncStatus);
  static const VerificationMeta _remoteIdMeta =
      const VerificationMeta('remoteId');
  @override
  late final GeneratedColumn<String> remoteId = GeneratedColumn<String>(
      'remote_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 200),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _nepaliNameMeta =
      const VerificationMeta('nepaliName');
  @override
  late final GeneratedColumn<String> nepaliName = GeneratedColumn<String>(
      'nepali_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _skuMeta = const VerificationMeta('sku');
  @override
  late final GeneratedColumn<String> sku = GeneratedColumn<String>(
      'sku', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
      'category_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pcs'));
  static const VerificationMeta _purchasePricePaisaMeta =
      const VerificationMeta('purchasePricePaisa');
  @override
  late final GeneratedColumn<int> purchasePricePaisa = GeneratedColumn<int>(
      'purchase_price_paisa', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _sellingPricePaisaMeta =
      const VerificationMeta('sellingPricePaisa');
  @override
  late final GeneratedColumn<int> sellingPricePaisa = GeneratedColumn<int>(
      'selling_price_paisa', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _stockQtyMeta =
      const VerificationMeta('stockQty');
  @override
  late final GeneratedColumn<double> stockQty = GeneratedColumn<double>(
      'stock_qty', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _lowStockThresholdMeta =
      const VerificationMeta('lowStockThreshold');
  @override
  late final GeneratedColumn<double> lowStockThreshold =
      GeneratedColumn<double>('low_stock_threshold', aliasedName, false,
          type: DriftSqlType.double,
          requiredDuringInsert: false,
          defaultValue: const Constant(5.0));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        createdAt,
        updatedAt,
        syncStatus,
        remoteId,
        isDeleted,
        name,
        nepaliName,
        sku,
        categoryId,
        unit,
        purchasePricePaisa,
        sellingPricePaisa,
        stockQty,
        lowStockThreshold,
        isActive
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'items';
  @override
  VerificationContext validateIntegrity(Insertable<Item> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    context.handle(_syncStatusMeta, const VerificationResult.success());
    if (data.containsKey('remote_id')) {
      context.handle(_remoteIdMeta,
          remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('nepali_name')) {
      context.handle(
          _nepaliNameMeta,
          nepaliName.isAcceptableOrUnknown(
              data['nepali_name']!, _nepaliNameMeta));
    }
    if (data.containsKey('sku')) {
      context.handle(
          _skuMeta, sku.isAcceptableOrUnknown(data['sku']!, _skuMeta));
    } else if (isInserting) {
      context.missing(_skuMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    }
    if (data.containsKey('purchase_price_paisa')) {
      context.handle(
          _purchasePricePaisaMeta,
          purchasePricePaisa.isAcceptableOrUnknown(
              data['purchase_price_paisa']!, _purchasePricePaisaMeta));
    }
    if (data.containsKey('selling_price_paisa')) {
      context.handle(
          _sellingPricePaisaMeta,
          sellingPricePaisa.isAcceptableOrUnknown(
              data['selling_price_paisa']!, _sellingPricePaisaMeta));
    }
    if (data.containsKey('stock_qty')) {
      context.handle(_stockQtyMeta,
          stockQty.isAcceptableOrUnknown(data['stock_qty']!, _stockQtyMeta));
    }
    if (data.containsKey('low_stock_threshold')) {
      context.handle(
          _lowStockThresholdMeta,
          lowStockThreshold.isAcceptableOrUnknown(
              data['low_stock_threshold']!, _lowStockThresholdMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Item map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Item(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      syncStatus: $ItemsTable.$convertersyncStatus.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!),
      remoteId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}remote_id']),
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      nepaliName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nepali_name']),
      sku: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sku'])!,
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category_id']),
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit'])!,
      purchasePricePaisa: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}purchase_price_paisa'])!,
      sellingPricePaisa: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}selling_price_paisa'])!,
      stockQty: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}stock_qty'])!,
      lowStockThreshold: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}low_stock_threshold'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
    );
  }

  @override
  $ItemsTable createAlias(String alias) {
    return $ItemsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SyncStatus, String, String> $convertersyncStatus =
      const EnumNameConverter<SyncStatus>(SyncStatus.values);
}

class Item extends DataClass implements Insertable<Item> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final SyncStatus syncStatus;
  final String? remoteId;
  final bool isDeleted;
  final String name;
  final String? nepaliName;
  final String sku;
  final String? categoryId;
  final String unit;
  final int purchasePricePaisa;
  final int sellingPricePaisa;
  final double stockQty;
  final double lowStockThreshold;
  final bool isActive;
  const Item(
      {required this.id,
      required this.createdAt,
      required this.updatedAt,
      required this.syncStatus,
      this.remoteId,
      required this.isDeleted,
      required this.name,
      this.nepaliName,
      required this.sku,
      this.categoryId,
      required this.unit,
      required this.purchasePricePaisa,
      required this.sellingPricePaisa,
      required this.stockQty,
      required this.lowStockThreshold,
      required this.isActive});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    {
      map['sync_status'] =
          Variable<String>($ItemsTable.$convertersyncStatus.toSql(syncStatus));
    }
    if (!nullToAbsent || remoteId != null) {
      map['remote_id'] = Variable<String>(remoteId);
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || nepaliName != null) {
      map['nepali_name'] = Variable<String>(nepaliName);
    }
    map['sku'] = Variable<String>(sku);
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    map['unit'] = Variable<String>(unit);
    map['purchase_price_paisa'] = Variable<int>(purchasePricePaisa);
    map['selling_price_paisa'] = Variable<int>(sellingPricePaisa);
    map['stock_qty'] = Variable<double>(stockQty);
    map['low_stock_threshold'] = Variable<double>(lowStockThreshold);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  ItemsCompanion toCompanion(bool nullToAbsent) {
    return ItemsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncStatus: Value(syncStatus),
      remoteId: remoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteId),
      isDeleted: Value(isDeleted),
      name: Value(name),
      nepaliName: nepaliName == null && nullToAbsent
          ? const Value.absent()
          : Value(nepaliName),
      sku: Value(sku),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      unit: Value(unit),
      purchasePricePaisa: Value(purchasePricePaisa),
      sellingPricePaisa: Value(sellingPricePaisa),
      stockQty: Value(stockQty),
      lowStockThreshold: Value(lowStockThreshold),
      isActive: Value(isActive),
    );
  }

  factory Item.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Item(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncStatus: $ItemsTable.$convertersyncStatus
          .fromJson(serializer.fromJson<String>(json['syncStatus'])),
      remoteId: serializer.fromJson<String?>(json['remoteId']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      name: serializer.fromJson<String>(json['name']),
      nepaliName: serializer.fromJson<String?>(json['nepaliName']),
      sku: serializer.fromJson<String>(json['sku']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      unit: serializer.fromJson<String>(json['unit']),
      purchasePricePaisa: serializer.fromJson<int>(json['purchasePricePaisa']),
      sellingPricePaisa: serializer.fromJson<int>(json['sellingPricePaisa']),
      stockQty: serializer.fromJson<double>(json['stockQty']),
      lowStockThreshold: serializer.fromJson<double>(json['lowStockThreshold']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncStatus': serializer
          .toJson<String>($ItemsTable.$convertersyncStatus.toJson(syncStatus)),
      'remoteId': serializer.toJson<String?>(remoteId),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'name': serializer.toJson<String>(name),
      'nepaliName': serializer.toJson<String?>(nepaliName),
      'sku': serializer.toJson<String>(sku),
      'categoryId': serializer.toJson<String?>(categoryId),
      'unit': serializer.toJson<String>(unit),
      'purchasePricePaisa': serializer.toJson<int>(purchasePricePaisa),
      'sellingPricePaisa': serializer.toJson<int>(sellingPricePaisa),
      'stockQty': serializer.toJson<double>(stockQty),
      'lowStockThreshold': serializer.toJson<double>(lowStockThreshold),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  Item copyWith(
          {String? id,
          DateTime? createdAt,
          DateTime? updatedAt,
          SyncStatus? syncStatus,
          Value<String?> remoteId = const Value.absent(),
          bool? isDeleted,
          String? name,
          Value<String?> nepaliName = const Value.absent(),
          String? sku,
          Value<String?> categoryId = const Value.absent(),
          String? unit,
          int? purchasePricePaisa,
          int? sellingPricePaisa,
          double? stockQty,
          double? lowStockThreshold,
          bool? isActive}) =>
      Item(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        syncStatus: syncStatus ?? this.syncStatus,
        remoteId: remoteId.present ? remoteId.value : this.remoteId,
        isDeleted: isDeleted ?? this.isDeleted,
        name: name ?? this.name,
        nepaliName: nepaliName.present ? nepaliName.value : this.nepaliName,
        sku: sku ?? this.sku,
        categoryId: categoryId.present ? categoryId.value : this.categoryId,
        unit: unit ?? this.unit,
        purchasePricePaisa: purchasePricePaisa ?? this.purchasePricePaisa,
        sellingPricePaisa: sellingPricePaisa ?? this.sellingPricePaisa,
        stockQty: stockQty ?? this.stockQty,
        lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
        isActive: isActive ?? this.isActive,
      );
  Item copyWithCompanion(ItemsCompanion data) {
    return Item(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      name: data.name.present ? data.name.value : this.name,
      nepaliName:
          data.nepaliName.present ? data.nepaliName.value : this.nepaliName,
      sku: data.sku.present ? data.sku.value : this.sku,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      unit: data.unit.present ? data.unit.value : this.unit,
      purchasePricePaisa: data.purchasePricePaisa.present
          ? data.purchasePricePaisa.value
          : this.purchasePricePaisa,
      sellingPricePaisa: data.sellingPricePaisa.present
          ? data.sellingPricePaisa.value
          : this.sellingPricePaisa,
      stockQty: data.stockQty.present ? data.stockQty.value : this.stockQty,
      lowStockThreshold: data.lowStockThreshold.present
          ? data.lowStockThreshold.value
          : this.lowStockThreshold,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Item(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('remoteId: $remoteId, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('name: $name, ')
          ..write('nepaliName: $nepaliName, ')
          ..write('sku: $sku, ')
          ..write('categoryId: $categoryId, ')
          ..write('unit: $unit, ')
          ..write('purchasePricePaisa: $purchasePricePaisa, ')
          ..write('sellingPricePaisa: $sellingPricePaisa, ')
          ..write('stockQty: $stockQty, ')
          ..write('lowStockThreshold: $lowStockThreshold, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      createdAt,
      updatedAt,
      syncStatus,
      remoteId,
      isDeleted,
      name,
      nepaliName,
      sku,
      categoryId,
      unit,
      purchasePricePaisa,
      sellingPricePaisa,
      stockQty,
      lowStockThreshold,
      isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Item &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus &&
          other.remoteId == this.remoteId &&
          other.isDeleted == this.isDeleted &&
          other.name == this.name &&
          other.nepaliName == this.nepaliName &&
          other.sku == this.sku &&
          other.categoryId == this.categoryId &&
          other.unit == this.unit &&
          other.purchasePricePaisa == this.purchasePricePaisa &&
          other.sellingPricePaisa == this.sellingPricePaisa &&
          other.stockQty == this.stockQty &&
          other.lowStockThreshold == this.lowStockThreshold &&
          other.isActive == this.isActive);
}

class ItemsCompanion extends UpdateCompanion<Item> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<SyncStatus> syncStatus;
  final Value<String?> remoteId;
  final Value<bool> isDeleted;
  final Value<String> name;
  final Value<String?> nepaliName;
  final Value<String> sku;
  final Value<String?> categoryId;
  final Value<String> unit;
  final Value<int> purchasePricePaisa;
  final Value<int> sellingPricePaisa;
  final Value<double> stockQty;
  final Value<double> lowStockThreshold;
  final Value<bool> isActive;
  final Value<int> rowid;
  const ItemsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.name = const Value.absent(),
    this.nepaliName = const Value.absent(),
    this.sku = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.unit = const Value.absent(),
    this.purchasePricePaisa = const Value.absent(),
    this.sellingPricePaisa = const Value.absent(),
    this.stockQty = const Value.absent(),
    this.lowStockThreshold = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ItemsCompanion.insert({
    required String id,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.isDeleted = const Value.absent(),
    required String name,
    this.nepaliName = const Value.absent(),
    required String sku,
    this.categoryId = const Value.absent(),
    this.unit = const Value.absent(),
    this.purchasePricePaisa = const Value.absent(),
    this.sellingPricePaisa = const Value.absent(),
    this.stockQty = const Value.absent(),
    this.lowStockThreshold = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        sku = Value(sku);
  static Insertable<Item> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncStatus,
    Expression<String>? remoteId,
    Expression<bool>? isDeleted,
    Expression<String>? name,
    Expression<String>? nepaliName,
    Expression<String>? sku,
    Expression<String>? categoryId,
    Expression<String>? unit,
    Expression<int>? purchasePricePaisa,
    Expression<int>? sellingPricePaisa,
    Expression<double>? stockQty,
    Expression<double>? lowStockThreshold,
    Expression<bool>? isActive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (remoteId != null) 'remote_id': remoteId,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (name != null) 'name': name,
      if (nepaliName != null) 'nepali_name': nepaliName,
      if (sku != null) 'sku': sku,
      if (categoryId != null) 'category_id': categoryId,
      if (unit != null) 'unit': unit,
      if (purchasePricePaisa != null)
        'purchase_price_paisa': purchasePricePaisa,
      if (sellingPricePaisa != null) 'selling_price_paisa': sellingPricePaisa,
      if (stockQty != null) 'stock_qty': stockQty,
      if (lowStockThreshold != null) 'low_stock_threshold': lowStockThreshold,
      if (isActive != null) 'is_active': isActive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ItemsCompanion copyWith(
      {Value<String>? id,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<SyncStatus>? syncStatus,
      Value<String?>? remoteId,
      Value<bool>? isDeleted,
      Value<String>? name,
      Value<String?>? nepaliName,
      Value<String>? sku,
      Value<String?>? categoryId,
      Value<String>? unit,
      Value<int>? purchasePricePaisa,
      Value<int>? sellingPricePaisa,
      Value<double>? stockQty,
      Value<double>? lowStockThreshold,
      Value<bool>? isActive,
      Value<int>? rowid}) {
    return ItemsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      remoteId: remoteId ?? this.remoteId,
      isDeleted: isDeleted ?? this.isDeleted,
      name: name ?? this.name,
      nepaliName: nepaliName ?? this.nepaliName,
      sku: sku ?? this.sku,
      categoryId: categoryId ?? this.categoryId,
      unit: unit ?? this.unit,
      purchasePricePaisa: purchasePricePaisa ?? this.purchasePricePaisa,
      sellingPricePaisa: sellingPricePaisa ?? this.sellingPricePaisa,
      stockQty: stockQty ?? this.stockQty,
      lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
      isActive: isActive ?? this.isActive,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(
          $ItemsTable.$convertersyncStatus.toSql(syncStatus.value));
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (nepaliName.present) {
      map['nepali_name'] = Variable<String>(nepaliName.value);
    }
    if (sku.present) {
      map['sku'] = Variable<String>(sku.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (purchasePricePaisa.present) {
      map['purchase_price_paisa'] = Variable<int>(purchasePricePaisa.value);
    }
    if (sellingPricePaisa.present) {
      map['selling_price_paisa'] = Variable<int>(sellingPricePaisa.value);
    }
    if (stockQty.present) {
      map['stock_qty'] = Variable<double>(stockQty.value);
    }
    if (lowStockThreshold.present) {
      map['low_stock_threshold'] = Variable<double>(lowStockThreshold.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ItemsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('remoteId: $remoteId, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('name: $name, ')
          ..write('nepaliName: $nepaliName, ')
          ..write('sku: $sku, ')
          ..write('categoryId: $categoryId, ')
          ..write('unit: $unit, ')
          ..write('purchasePricePaisa: $purchasePricePaisa, ')
          ..write('sellingPricePaisa: $sellingPricePaisa, ')
          ..write('stockQty: $stockQty, ')
          ..write('lowStockThreshold: $lowStockThreshold, ')
          ..write('isActive: $isActive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InventoriesTable extends Inventories
    with TableInfo<$InventoriesTable, Inventory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InventoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumnWithTypeConverter<SyncStatus, String> syncStatus =
      GeneratedColumn<String>('sync_status', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: Constant(SyncStatus.pending.name))
          .withConverter<SyncStatus>($InventoriesTable.$convertersyncStatus);
  static const VerificationMeta _remoteIdMeta =
      const VerificationMeta('remoteId');
  @override
  late final GeneratedColumn<String> remoteId = GeneratedColumn<String>(
      'remote_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 200),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _skuMeta = const VerificationMeta('sku');
  @override
  late final GeneratedColumn<String> sku = GeneratedColumn<String>(
      'sku', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pcs'));
  static const VerificationMeta _unitPriceMeta =
      const VerificationMeta('unitPrice');
  @override
  late final GeneratedColumn<double> unitPrice = GeneratedColumn<double>(
      'unit_price', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _costPriceMeta =
      const VerificationMeta('costPrice');
  @override
  late final GeneratedColumn<double> costPrice = GeneratedColumn<double>(
      'cost_price', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _stockQuantityMeta =
      const VerificationMeta('stockQuantity');
  @override
  late final GeneratedColumn<double> stockQuantity = GeneratedColumn<double>(
      'stock_quantity', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        createdAt,
        updatedAt,
        syncStatus,
        remoteId,
        isDeleted,
        name,
        sku,
        unit,
        unitPrice,
        costPrice,
        stockQuantity,
        isActive
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inventories';
  @override
  VerificationContext validateIntegrity(Insertable<Inventory> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    context.handle(_syncStatusMeta, const VerificationResult.success());
    if (data.containsKey('remote_id')) {
      context.handle(_remoteIdMeta,
          remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('sku')) {
      context.handle(
          _skuMeta, sku.isAcceptableOrUnknown(data['sku']!, _skuMeta));
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    }
    if (data.containsKey('unit_price')) {
      context.handle(_unitPriceMeta,
          unitPrice.isAcceptableOrUnknown(data['unit_price']!, _unitPriceMeta));
    }
    if (data.containsKey('cost_price')) {
      context.handle(_costPriceMeta,
          costPrice.isAcceptableOrUnknown(data['cost_price']!, _costPriceMeta));
    }
    if (data.containsKey('stock_quantity')) {
      context.handle(
          _stockQuantityMeta,
          stockQuantity.isAcceptableOrUnknown(
              data['stock_quantity']!, _stockQuantityMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Inventory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Inventory(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      syncStatus: $InventoriesTable.$convertersyncStatus.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}sync_status'])!),
      remoteId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}remote_id']),
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      sku: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sku']),
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit'])!,
      unitPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}unit_price'])!,
      costPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}cost_price'])!,
      stockQuantity: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}stock_quantity'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
    );
  }

  @override
  $InventoriesTable createAlias(String alias) {
    return $InventoriesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SyncStatus, String, String> $convertersyncStatus =
      const EnumNameConverter<SyncStatus>(SyncStatus.values);
}

class Inventory extends DataClass implements Insertable<Inventory> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final SyncStatus syncStatus;
  final String? remoteId;
  final bool isDeleted;
  final String name;
  final String? sku;
  final String unit;
  final double unitPrice;
  final double costPrice;
  final double stockQuantity;
  final bool isActive;
  const Inventory(
      {required this.id,
      required this.createdAt,
      required this.updatedAt,
      required this.syncStatus,
      this.remoteId,
      required this.isDeleted,
      required this.name,
      this.sku,
      required this.unit,
      required this.unitPrice,
      required this.costPrice,
      required this.stockQuantity,
      required this.isActive});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    {
      map['sync_status'] = Variable<String>(
          $InventoriesTable.$convertersyncStatus.toSql(syncStatus));
    }
    if (!nullToAbsent || remoteId != null) {
      map['remote_id'] = Variable<String>(remoteId);
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || sku != null) {
      map['sku'] = Variable<String>(sku);
    }
    map['unit'] = Variable<String>(unit);
    map['unit_price'] = Variable<double>(unitPrice);
    map['cost_price'] = Variable<double>(costPrice);
    map['stock_quantity'] = Variable<double>(stockQuantity);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  InventoriesCompanion toCompanion(bool nullToAbsent) {
    return InventoriesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncStatus: Value(syncStatus),
      remoteId: remoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteId),
      isDeleted: Value(isDeleted),
      name: Value(name),
      sku: sku == null && nullToAbsent ? const Value.absent() : Value(sku),
      unit: Value(unit),
      unitPrice: Value(unitPrice),
      costPrice: Value(costPrice),
      stockQuantity: Value(stockQuantity),
      isActive: Value(isActive),
    );
  }

  factory Inventory.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Inventory(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncStatus: $InventoriesTable.$convertersyncStatus
          .fromJson(serializer.fromJson<String>(json['syncStatus'])),
      remoteId: serializer.fromJson<String?>(json['remoteId']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      name: serializer.fromJson<String>(json['name']),
      sku: serializer.fromJson<String?>(json['sku']),
      unit: serializer.fromJson<String>(json['unit']),
      unitPrice: serializer.fromJson<double>(json['unitPrice']),
      costPrice: serializer.fromJson<double>(json['costPrice']),
      stockQuantity: serializer.fromJson<double>(json['stockQuantity']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncStatus': serializer.toJson<String>(
          $InventoriesTable.$convertersyncStatus.toJson(syncStatus)),
      'remoteId': serializer.toJson<String?>(remoteId),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'name': serializer.toJson<String>(name),
      'sku': serializer.toJson<String?>(sku),
      'unit': serializer.toJson<String>(unit),
      'unitPrice': serializer.toJson<double>(unitPrice),
      'costPrice': serializer.toJson<double>(costPrice),
      'stockQuantity': serializer.toJson<double>(stockQuantity),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  Inventory copyWith(
          {String? id,
          DateTime? createdAt,
          DateTime? updatedAt,
          SyncStatus? syncStatus,
          Value<String?> remoteId = const Value.absent(),
          bool? isDeleted,
          String? name,
          Value<String?> sku = const Value.absent(),
          String? unit,
          double? unitPrice,
          double? costPrice,
          double? stockQuantity,
          bool? isActive}) =>
      Inventory(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        syncStatus: syncStatus ?? this.syncStatus,
        remoteId: remoteId.present ? remoteId.value : this.remoteId,
        isDeleted: isDeleted ?? this.isDeleted,
        name: name ?? this.name,
        sku: sku.present ? sku.value : this.sku,
        unit: unit ?? this.unit,
        unitPrice: unitPrice ?? this.unitPrice,
        costPrice: costPrice ?? this.costPrice,
        stockQuantity: stockQuantity ?? this.stockQuantity,
        isActive: isActive ?? this.isActive,
      );
  Inventory copyWithCompanion(InventoriesCompanion data) {
    return Inventory(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      name: data.name.present ? data.name.value : this.name,
      sku: data.sku.present ? data.sku.value : this.sku,
      unit: data.unit.present ? data.unit.value : this.unit,
      unitPrice: data.unitPrice.present ? data.unitPrice.value : this.unitPrice,
      costPrice: data.costPrice.present ? data.costPrice.value : this.costPrice,
      stockQuantity: data.stockQuantity.present
          ? data.stockQuantity.value
          : this.stockQuantity,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Inventory(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('remoteId: $remoteId, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('name: $name, ')
          ..write('sku: $sku, ')
          ..write('unit: $unit, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('costPrice: $costPrice, ')
          ..write('stockQuantity: $stockQuantity, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      createdAt,
      updatedAt,
      syncStatus,
      remoteId,
      isDeleted,
      name,
      sku,
      unit,
      unitPrice,
      costPrice,
      stockQuantity,
      isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Inventory &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus &&
          other.remoteId == this.remoteId &&
          other.isDeleted == this.isDeleted &&
          other.name == this.name &&
          other.sku == this.sku &&
          other.unit == this.unit &&
          other.unitPrice == this.unitPrice &&
          other.costPrice == this.costPrice &&
          other.stockQuantity == this.stockQuantity &&
          other.isActive == this.isActive);
}

class InventoriesCompanion extends UpdateCompanion<Inventory> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<SyncStatus> syncStatus;
  final Value<String?> remoteId;
  final Value<bool> isDeleted;
  final Value<String> name;
  final Value<String?> sku;
  final Value<String> unit;
  final Value<double> unitPrice;
  final Value<double> costPrice;
  final Value<double> stockQuantity;
  final Value<bool> isActive;
  final Value<int> rowid;
  const InventoriesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.name = const Value.absent(),
    this.sku = const Value.absent(),
    this.unit = const Value.absent(),
    this.unitPrice = const Value.absent(),
    this.costPrice = const Value.absent(),
    this.stockQuantity = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InventoriesCompanion.insert({
    required String id,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.isDeleted = const Value.absent(),
    required String name,
    this.sku = const Value.absent(),
    this.unit = const Value.absent(),
    this.unitPrice = const Value.absent(),
    this.costPrice = const Value.absent(),
    this.stockQuantity = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name);
  static Insertable<Inventory> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncStatus,
    Expression<String>? remoteId,
    Expression<bool>? isDeleted,
    Expression<String>? name,
    Expression<String>? sku,
    Expression<String>? unit,
    Expression<double>? unitPrice,
    Expression<double>? costPrice,
    Expression<double>? stockQuantity,
    Expression<bool>? isActive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (remoteId != null) 'remote_id': remoteId,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (name != null) 'name': name,
      if (sku != null) 'sku': sku,
      if (unit != null) 'unit': unit,
      if (unitPrice != null) 'unit_price': unitPrice,
      if (costPrice != null) 'cost_price': costPrice,
      if (stockQuantity != null) 'stock_quantity': stockQuantity,
      if (isActive != null) 'is_active': isActive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InventoriesCompanion copyWith(
      {Value<String>? id,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<SyncStatus>? syncStatus,
      Value<String?>? remoteId,
      Value<bool>? isDeleted,
      Value<String>? name,
      Value<String?>? sku,
      Value<String>? unit,
      Value<double>? unitPrice,
      Value<double>? costPrice,
      Value<double>? stockQuantity,
      Value<bool>? isActive,
      Value<int>? rowid}) {
    return InventoriesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      remoteId: remoteId ?? this.remoteId,
      isDeleted: isDeleted ?? this.isDeleted,
      name: name ?? this.name,
      sku: sku ?? this.sku,
      unit: unit ?? this.unit,
      unitPrice: unitPrice ?? this.unitPrice,
      costPrice: costPrice ?? this.costPrice,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      isActive: isActive ?? this.isActive,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(
          $InventoriesTable.$convertersyncStatus.toSql(syncStatus.value));
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (sku.present) {
      map['sku'] = Variable<String>(sku.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (unitPrice.present) {
      map['unit_price'] = Variable<double>(unitPrice.value);
    }
    if (costPrice.present) {
      map['cost_price'] = Variable<double>(costPrice.value);
    }
    if (stockQuantity.present) {
      map['stock_quantity'] = Variable<double>(stockQuantity.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InventoriesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('remoteId: $remoteId, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('name: $name, ')
          ..write('sku: $sku, ')
          ..write('unit: $unit, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('costPrice: $costPrice, ')
          ..write('stockQuantity: $stockQuantity, ')
          ..write('isActive: $isActive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SuppliersTable extends Suppliers
    with TableInfo<$SuppliersTable, Supplier> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SuppliersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumnWithTypeConverter<SyncStatus, String> syncStatus =
      GeneratedColumn<String>('sync_status', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: Constant(SyncStatus.pending.name))
          .withConverter<SyncStatus>($SuppliersTable.$convertersyncStatus);
  static const VerificationMeta _remoteIdMeta =
      const VerificationMeta('remoteId');
  @override
  late final GeneratedColumn<String> remoteId = GeneratedColumn<String>(
      'remote_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 200),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _panVatMeta = const VerificationMeta('panVat');
  @override
  late final GeneratedColumn<String> panVat = GeneratedColumn<String>(
      'pan_vat', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _contactPersonMeta =
      const VerificationMeta('contactPerson');
  @override
  late final GeneratedColumn<String> contactPerson = GeneratedColumn<String>(
      'contact_person', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        createdAt,
        updatedAt,
        syncStatus,
        remoteId,
        isDeleted,
        name,
        phone,
        panVat,
        address,
        contactPerson
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'suppliers';
  @override
  VerificationContext validateIntegrity(Insertable<Supplier> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    context.handle(_syncStatusMeta, const VerificationResult.success());
    if (data.containsKey('remote_id')) {
      context.handle(_remoteIdMeta,
          remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    if (data.containsKey('pan_vat')) {
      context.handle(_panVatMeta,
          panVat.isAcceptableOrUnknown(data['pan_vat']!, _panVatMeta));
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    }
    if (data.containsKey('contact_person')) {
      context.handle(
          _contactPersonMeta,
          contactPerson.isAcceptableOrUnknown(
              data['contact_person']!, _contactPersonMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Supplier map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Supplier(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      syncStatus: $SuppliersTable.$convertersyncStatus.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!),
      remoteId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}remote_id']),
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone']),
      panVat: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pan_vat']),
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address']),
      contactPerson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}contact_person']),
    );
  }

  @override
  $SuppliersTable createAlias(String alias) {
    return $SuppliersTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SyncStatus, String, String> $convertersyncStatus =
      const EnumNameConverter<SyncStatus>(SyncStatus.values);
}

class Supplier extends DataClass implements Insertable<Supplier> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final SyncStatus syncStatus;
  final String? remoteId;
  final bool isDeleted;
  final String name;
  final String? phone;
  final String? panVat;
  final String? address;
  final String? contactPerson;
  const Supplier(
      {required this.id,
      required this.createdAt,
      required this.updatedAt,
      required this.syncStatus,
      this.remoteId,
      required this.isDeleted,
      required this.name,
      this.phone,
      this.panVat,
      this.address,
      this.contactPerson});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    {
      map['sync_status'] = Variable<String>(
          $SuppliersTable.$convertersyncStatus.toSql(syncStatus));
    }
    if (!nullToAbsent || remoteId != null) {
      map['remote_id'] = Variable<String>(remoteId);
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || panVat != null) {
      map['pan_vat'] = Variable<String>(panVat);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || contactPerson != null) {
      map['contact_person'] = Variable<String>(contactPerson);
    }
    return map;
  }

  SuppliersCompanion toCompanion(bool nullToAbsent) {
    return SuppliersCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncStatus: Value(syncStatus),
      remoteId: remoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteId),
      isDeleted: Value(isDeleted),
      name: Value(name),
      phone:
          phone == null && nullToAbsent ? const Value.absent() : Value(phone),
      panVat:
          panVat == null && nullToAbsent ? const Value.absent() : Value(panVat),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      contactPerson: contactPerson == null && nullToAbsent
          ? const Value.absent()
          : Value(contactPerson),
    );
  }

  factory Supplier.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Supplier(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncStatus: $SuppliersTable.$convertersyncStatus
          .fromJson(serializer.fromJson<String>(json['syncStatus'])),
      remoteId: serializer.fromJson<String?>(json['remoteId']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String?>(json['phone']),
      panVat: serializer.fromJson<String?>(json['panVat']),
      address: serializer.fromJson<String?>(json['address']),
      contactPerson: serializer.fromJson<String?>(json['contactPerson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncStatus': serializer.toJson<String>(
          $SuppliersTable.$convertersyncStatus.toJson(syncStatus)),
      'remoteId': serializer.toJson<String?>(remoteId),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String?>(phone),
      'panVat': serializer.toJson<String?>(panVat),
      'address': serializer.toJson<String?>(address),
      'contactPerson': serializer.toJson<String?>(contactPerson),
    };
  }

  Supplier copyWith(
          {String? id,
          DateTime? createdAt,
          DateTime? updatedAt,
          SyncStatus? syncStatus,
          Value<String?> remoteId = const Value.absent(),
          bool? isDeleted,
          String? name,
          Value<String?> phone = const Value.absent(),
          Value<String?> panVat = const Value.absent(),
          Value<String?> address = const Value.absent(),
          Value<String?> contactPerson = const Value.absent()}) =>
      Supplier(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        syncStatus: syncStatus ?? this.syncStatus,
        remoteId: remoteId.present ? remoteId.value : this.remoteId,
        isDeleted: isDeleted ?? this.isDeleted,
        name: name ?? this.name,
        phone: phone.present ? phone.value : this.phone,
        panVat: panVat.present ? panVat.value : this.panVat,
        address: address.present ? address.value : this.address,
        contactPerson:
            contactPerson.present ? contactPerson.value : this.contactPerson,
      );
  Supplier copyWithCompanion(SuppliersCompanion data) {
    return Supplier(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      panVat: data.panVat.present ? data.panVat.value : this.panVat,
      address: data.address.present ? data.address.value : this.address,
      contactPerson: data.contactPerson.present
          ? data.contactPerson.value
          : this.contactPerson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Supplier(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('remoteId: $remoteId, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('panVat: $panVat, ')
          ..write('address: $address, ')
          ..write('contactPerson: $contactPerson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, createdAt, updatedAt, syncStatus,
      remoteId, isDeleted, name, phone, panVat, address, contactPerson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Supplier &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus &&
          other.remoteId == this.remoteId &&
          other.isDeleted == this.isDeleted &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.panVat == this.panVat &&
          other.address == this.address &&
          other.contactPerson == this.contactPerson);
}

class SuppliersCompanion extends UpdateCompanion<Supplier> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<SyncStatus> syncStatus;
  final Value<String?> remoteId;
  final Value<bool> isDeleted;
  final Value<String> name;
  final Value<String?> phone;
  final Value<String?> panVat;
  final Value<String?> address;
  final Value<String?> contactPerson;
  final Value<int> rowid;
  const SuppliersCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.panVat = const Value.absent(),
    this.address = const Value.absent(),
    this.contactPerson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SuppliersCompanion.insert({
    required String id,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.isDeleted = const Value.absent(),
    required String name,
    this.phone = const Value.absent(),
    this.panVat = const Value.absent(),
    this.address = const Value.absent(),
    this.contactPerson = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name);
  static Insertable<Supplier> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncStatus,
    Expression<String>? remoteId,
    Expression<bool>? isDeleted,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? panVat,
    Expression<String>? address,
    Expression<String>? contactPerson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (remoteId != null) 'remote_id': remoteId,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (panVat != null) 'pan_vat': panVat,
      if (address != null) 'address': address,
      if (contactPerson != null) 'contact_person': contactPerson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SuppliersCompanion copyWith(
      {Value<String>? id,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<SyncStatus>? syncStatus,
      Value<String?>? remoteId,
      Value<bool>? isDeleted,
      Value<String>? name,
      Value<String?>? phone,
      Value<String?>? panVat,
      Value<String?>? address,
      Value<String?>? contactPerson,
      Value<int>? rowid}) {
    return SuppliersCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      remoteId: remoteId ?? this.remoteId,
      isDeleted: isDeleted ?? this.isDeleted,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      panVat: panVat ?? this.panVat,
      address: address ?? this.address,
      contactPerson: contactPerson ?? this.contactPerson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(
          $SuppliersTable.$convertersyncStatus.toSql(syncStatus.value));
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (panVat.present) {
      map['pan_vat'] = Variable<String>(panVat.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (contactPerson.present) {
      map['contact_person'] = Variable<String>(contactPerson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SuppliersCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('remoteId: $remoteId, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('panVat: $panVat, ')
          ..write('address: $address, ')
          ..write('contactPerson: $contactPerson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CustomersTable extends Customers
    with TableInfo<$CustomersTable, Customer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumnWithTypeConverter<SyncStatus, String> syncStatus =
      GeneratedColumn<String>('sync_status', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: Constant(SyncStatus.pending.name))
          .withConverter<SyncStatus>($CustomersTable.$convertersyncStatus);
  static const VerificationMeta _remoteIdMeta =
      const VerificationMeta('remoteId');
  @override
  late final GeneratedColumn<String> remoteId = GeneratedColumn<String>(
      'remote_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 200),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _panVatMeta = const VerificationMeta('panVat');
  @override
  late final GeneratedColumn<String> panVat = GeneratedColumn<String>(
      'pan_vat', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        createdAt,
        updatedAt,
        syncStatus,
        remoteId,
        isDeleted,
        name,
        phone,
        panVat,
        address
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'customers';
  @override
  VerificationContext validateIntegrity(Insertable<Customer> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    context.handle(_syncStatusMeta, const VerificationResult.success());
    if (data.containsKey('remote_id')) {
      context.handle(_remoteIdMeta,
          remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    if (data.containsKey('pan_vat')) {
      context.handle(_panVatMeta,
          panVat.isAcceptableOrUnknown(data['pan_vat']!, _panVatMeta));
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Customer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Customer(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      syncStatus: $CustomersTable.$convertersyncStatus.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!),
      remoteId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}remote_id']),
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone']),
      panVat: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pan_vat']),
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address']),
    );
  }

  @override
  $CustomersTable createAlias(String alias) {
    return $CustomersTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SyncStatus, String, String> $convertersyncStatus =
      const EnumNameConverter<SyncStatus>(SyncStatus.values);
}

class Customer extends DataClass implements Insertable<Customer> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final SyncStatus syncStatus;
  final String? remoteId;
  final bool isDeleted;
  final String name;
  final String? phone;
  final String? panVat;
  final String? address;
  const Customer(
      {required this.id,
      required this.createdAt,
      required this.updatedAt,
      required this.syncStatus,
      this.remoteId,
      required this.isDeleted,
      required this.name,
      this.phone,
      this.panVat,
      this.address});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    {
      map['sync_status'] = Variable<String>(
          $CustomersTable.$convertersyncStatus.toSql(syncStatus));
    }
    if (!nullToAbsent || remoteId != null) {
      map['remote_id'] = Variable<String>(remoteId);
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || panVat != null) {
      map['pan_vat'] = Variable<String>(panVat);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    return map;
  }

  CustomersCompanion toCompanion(bool nullToAbsent) {
    return CustomersCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncStatus: Value(syncStatus),
      remoteId: remoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteId),
      isDeleted: Value(isDeleted),
      name: Value(name),
      phone:
          phone == null && nullToAbsent ? const Value.absent() : Value(phone),
      panVat:
          panVat == null && nullToAbsent ? const Value.absent() : Value(panVat),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
    );
  }

  factory Customer.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Customer(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncStatus: $CustomersTable.$convertersyncStatus
          .fromJson(serializer.fromJson<String>(json['syncStatus'])),
      remoteId: serializer.fromJson<String?>(json['remoteId']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String?>(json['phone']),
      panVat: serializer.fromJson<String?>(json['panVat']),
      address: serializer.fromJson<String?>(json['address']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncStatus': serializer.toJson<String>(
          $CustomersTable.$convertersyncStatus.toJson(syncStatus)),
      'remoteId': serializer.toJson<String?>(remoteId),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String?>(phone),
      'panVat': serializer.toJson<String?>(panVat),
      'address': serializer.toJson<String?>(address),
    };
  }

  Customer copyWith(
          {String? id,
          DateTime? createdAt,
          DateTime? updatedAt,
          SyncStatus? syncStatus,
          Value<String?> remoteId = const Value.absent(),
          bool? isDeleted,
          String? name,
          Value<String?> phone = const Value.absent(),
          Value<String?> panVat = const Value.absent(),
          Value<String?> address = const Value.absent()}) =>
      Customer(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        syncStatus: syncStatus ?? this.syncStatus,
        remoteId: remoteId.present ? remoteId.value : this.remoteId,
        isDeleted: isDeleted ?? this.isDeleted,
        name: name ?? this.name,
        phone: phone.present ? phone.value : this.phone,
        panVat: panVat.present ? panVat.value : this.panVat,
        address: address.present ? address.value : this.address,
      );
  Customer copyWithCompanion(CustomersCompanion data) {
    return Customer(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      panVat: data.panVat.present ? data.panVat.value : this.panVat,
      address: data.address.present ? data.address.value : this.address,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Customer(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('remoteId: $remoteId, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('panVat: $panVat, ')
          ..write('address: $address')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, createdAt, updatedAt, syncStatus,
      remoteId, isDeleted, name, phone, panVat, address);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Customer &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus &&
          other.remoteId == this.remoteId &&
          other.isDeleted == this.isDeleted &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.panVat == this.panVat &&
          other.address == this.address);
}

class CustomersCompanion extends UpdateCompanion<Customer> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<SyncStatus> syncStatus;
  final Value<String?> remoteId;
  final Value<bool> isDeleted;
  final Value<String> name;
  final Value<String?> phone;
  final Value<String?> panVat;
  final Value<String?> address;
  final Value<int> rowid;
  const CustomersCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.panVat = const Value.absent(),
    this.address = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CustomersCompanion.insert({
    required String id,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.isDeleted = const Value.absent(),
    required String name,
    this.phone = const Value.absent(),
    this.panVat = const Value.absent(),
    this.address = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name);
  static Insertable<Customer> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncStatus,
    Expression<String>? remoteId,
    Expression<bool>? isDeleted,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? panVat,
    Expression<String>? address,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (remoteId != null) 'remote_id': remoteId,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (panVat != null) 'pan_vat': panVat,
      if (address != null) 'address': address,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CustomersCompanion copyWith(
      {Value<String>? id,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<SyncStatus>? syncStatus,
      Value<String?>? remoteId,
      Value<bool>? isDeleted,
      Value<String>? name,
      Value<String?>? phone,
      Value<String?>? panVat,
      Value<String?>? address,
      Value<int>? rowid}) {
    return CustomersCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      remoteId: remoteId ?? this.remoteId,
      isDeleted: isDeleted ?? this.isDeleted,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      panVat: panVat ?? this.panVat,
      address: address ?? this.address,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(
          $CustomersTable.$convertersyncStatus.toSql(syncStatus.value));
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (panVat.present) {
      map['pan_vat'] = Variable<String>(panVat.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomersCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('remoteId: $remoteId, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('panVat: $panVat, ')
          ..write('address: $address, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StockLedgerTable extends StockLedger
    with TableInfo<$StockLedgerTable, StockLedgerData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StockLedgerTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumnWithTypeConverter<SyncStatus, String> syncStatus =
      GeneratedColumn<String>('sync_status', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: Constant(SyncStatus.pending.name))
          .withConverter<SyncStatus>($StockLedgerTable.$convertersyncStatus);
  static const VerificationMeta _remoteIdMeta =
      const VerificationMeta('remoteId');
  @override
  late final GeneratedColumn<String> remoteId = GeneratedColumn<String>(
      'remote_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
      'item_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _qtyChangeMeta =
      const VerificationMeta('qtyChange');
  @override
  late final GeneratedColumn<double> qtyChange = GeneratedColumn<double>(
      'qty_change', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
      'reason', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _refTypeMeta =
      const VerificationMeta('refType');
  @override
  late final GeneratedColumn<String> refType = GeneratedColumn<String>(
      'ref_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _refIdMeta = const VerificationMeta('refId');
  @override
  late final GeneratedColumn<String> refId = GeneratedColumn<String>(
      'ref_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        createdAt,
        updatedAt,
        syncStatus,
        remoteId,
        isDeleted,
        itemId,
        qtyChange,
        reason,
        refType,
        refId,
        notes
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stock_ledger';
  @override
  VerificationContext validateIntegrity(Insertable<StockLedgerData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    context.handle(_syncStatusMeta, const VerificationResult.success());
    if (data.containsKey('remote_id')) {
      context.handle(_remoteIdMeta,
          remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    if (data.containsKey('item_id')) {
      context.handle(_itemIdMeta,
          itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta));
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('qty_change')) {
      context.handle(_qtyChangeMeta,
          qtyChange.isAcceptableOrUnknown(data['qty_change']!, _qtyChangeMeta));
    } else if (isInserting) {
      context.missing(_qtyChangeMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(_reasonMeta,
          reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta));
    } else if (isInserting) {
      context.missing(_reasonMeta);
    }
    if (data.containsKey('ref_type')) {
      context.handle(_refTypeMeta,
          refType.isAcceptableOrUnknown(data['ref_type']!, _refTypeMeta));
    } else if (isInserting) {
      context.missing(_refTypeMeta);
    }
    if (data.containsKey('ref_id')) {
      context.handle(
          _refIdMeta, refId.isAcceptableOrUnknown(data['ref_id']!, _refIdMeta));
    } else if (isInserting) {
      context.missing(_refIdMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StockLedgerData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StockLedgerData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      syncStatus: $StockLedgerTable.$convertersyncStatus.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}sync_status'])!),
      remoteId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}remote_id']),
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
      itemId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}item_id'])!,
      qtyChange: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}qty_change'])!,
      reason: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reason'])!,
      refType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}ref_type'])!,
      refId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}ref_id'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
    );
  }

  @override
  $StockLedgerTable createAlias(String alias) {
    return $StockLedgerTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SyncStatus, String, String> $convertersyncStatus =
      const EnumNameConverter<SyncStatus>(SyncStatus.values);
}

class StockLedgerData extends DataClass implements Insertable<StockLedgerData> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final SyncStatus syncStatus;
  final String? remoteId;
  final bool isDeleted;
  final String itemId;
  final double qtyChange;
  final String reason;
  final String refType;
  final String refId;
  final String? notes;
  const StockLedgerData(
      {required this.id,
      required this.createdAt,
      required this.updatedAt,
      required this.syncStatus,
      this.remoteId,
      required this.isDeleted,
      required this.itemId,
      required this.qtyChange,
      required this.reason,
      required this.refType,
      required this.refId,
      this.notes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    {
      map['sync_status'] = Variable<String>(
          $StockLedgerTable.$convertersyncStatus.toSql(syncStatus));
    }
    if (!nullToAbsent || remoteId != null) {
      map['remote_id'] = Variable<String>(remoteId);
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['item_id'] = Variable<String>(itemId);
    map['qty_change'] = Variable<double>(qtyChange);
    map['reason'] = Variable<String>(reason);
    map['ref_type'] = Variable<String>(refType);
    map['ref_id'] = Variable<String>(refId);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  StockLedgerCompanion toCompanion(bool nullToAbsent) {
    return StockLedgerCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncStatus: Value(syncStatus),
      remoteId: remoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteId),
      isDeleted: Value(isDeleted),
      itemId: Value(itemId),
      qtyChange: Value(qtyChange),
      reason: Value(reason),
      refType: Value(refType),
      refId: Value(refId),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
    );
  }

  factory StockLedgerData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StockLedgerData(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncStatus: $StockLedgerTable.$convertersyncStatus
          .fromJson(serializer.fromJson<String>(json['syncStatus'])),
      remoteId: serializer.fromJson<String?>(json['remoteId']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      itemId: serializer.fromJson<String>(json['itemId']),
      qtyChange: serializer.fromJson<double>(json['qtyChange']),
      reason: serializer.fromJson<String>(json['reason']),
      refType: serializer.fromJson<String>(json['refType']),
      refId: serializer.fromJson<String>(json['refId']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncStatus': serializer.toJson<String>(
          $StockLedgerTable.$convertersyncStatus.toJson(syncStatus)),
      'remoteId': serializer.toJson<String?>(remoteId),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'itemId': serializer.toJson<String>(itemId),
      'qtyChange': serializer.toJson<double>(qtyChange),
      'reason': serializer.toJson<String>(reason),
      'refType': serializer.toJson<String>(refType),
      'refId': serializer.toJson<String>(refId),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  StockLedgerData copyWith(
          {String? id,
          DateTime? createdAt,
          DateTime? updatedAt,
          SyncStatus? syncStatus,
          Value<String?> remoteId = const Value.absent(),
          bool? isDeleted,
          String? itemId,
          double? qtyChange,
          String? reason,
          String? refType,
          String? refId,
          Value<String?> notes = const Value.absent()}) =>
      StockLedgerData(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        syncStatus: syncStatus ?? this.syncStatus,
        remoteId: remoteId.present ? remoteId.value : this.remoteId,
        isDeleted: isDeleted ?? this.isDeleted,
        itemId: itemId ?? this.itemId,
        qtyChange: qtyChange ?? this.qtyChange,
        reason: reason ?? this.reason,
        refType: refType ?? this.refType,
        refId: refId ?? this.refId,
        notes: notes.present ? notes.value : this.notes,
      );
  StockLedgerData copyWithCompanion(StockLedgerCompanion data) {
    return StockLedgerData(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      qtyChange: data.qtyChange.present ? data.qtyChange.value : this.qtyChange,
      reason: data.reason.present ? data.reason.value : this.reason,
      refType: data.refType.present ? data.refType.value : this.refType,
      refId: data.refId.present ? data.refId.value : this.refId,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StockLedgerData(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('remoteId: $remoteId, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('itemId: $itemId, ')
          ..write('qtyChange: $qtyChange, ')
          ..write('reason: $reason, ')
          ..write('refType: $refType, ')
          ..write('refId: $refId, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, createdAt, updatedAt, syncStatus,
      remoteId, isDeleted, itemId, qtyChange, reason, refType, refId, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StockLedgerData &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus &&
          other.remoteId == this.remoteId &&
          other.isDeleted == this.isDeleted &&
          other.itemId == this.itemId &&
          other.qtyChange == this.qtyChange &&
          other.reason == this.reason &&
          other.refType == this.refType &&
          other.refId == this.refId &&
          other.notes == this.notes);
}

class StockLedgerCompanion extends UpdateCompanion<StockLedgerData> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<SyncStatus> syncStatus;
  final Value<String?> remoteId;
  final Value<bool> isDeleted;
  final Value<String> itemId;
  final Value<double> qtyChange;
  final Value<String> reason;
  final Value<String> refType;
  final Value<String> refId;
  final Value<String?> notes;
  final Value<int> rowid;
  const StockLedgerCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.itemId = const Value.absent(),
    this.qtyChange = const Value.absent(),
    this.reason = const Value.absent(),
    this.refType = const Value.absent(),
    this.refId = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StockLedgerCompanion.insert({
    required String id,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.isDeleted = const Value.absent(),
    required String itemId,
    required double qtyChange,
    required String reason,
    required String refType,
    required String refId,
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        itemId = Value(itemId),
        qtyChange = Value(qtyChange),
        reason = Value(reason),
        refType = Value(refType),
        refId = Value(refId);
  static Insertable<StockLedgerData> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncStatus,
    Expression<String>? remoteId,
    Expression<bool>? isDeleted,
    Expression<String>? itemId,
    Expression<double>? qtyChange,
    Expression<String>? reason,
    Expression<String>? refType,
    Expression<String>? refId,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (remoteId != null) 'remote_id': remoteId,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (itemId != null) 'item_id': itemId,
      if (qtyChange != null) 'qty_change': qtyChange,
      if (reason != null) 'reason': reason,
      if (refType != null) 'ref_type': refType,
      if (refId != null) 'ref_id': refId,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StockLedgerCompanion copyWith(
      {Value<String>? id,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<SyncStatus>? syncStatus,
      Value<String?>? remoteId,
      Value<bool>? isDeleted,
      Value<String>? itemId,
      Value<double>? qtyChange,
      Value<String>? reason,
      Value<String>? refType,
      Value<String>? refId,
      Value<String?>? notes,
      Value<int>? rowid}) {
    return StockLedgerCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      remoteId: remoteId ?? this.remoteId,
      isDeleted: isDeleted ?? this.isDeleted,
      itemId: itemId ?? this.itemId,
      qtyChange: qtyChange ?? this.qtyChange,
      reason: reason ?? this.reason,
      refType: refType ?? this.refType,
      refId: refId ?? this.refId,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(
          $StockLedgerTable.$convertersyncStatus.toSql(syncStatus.value));
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (qtyChange.present) {
      map['qty_change'] = Variable<double>(qtyChange.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (refType.present) {
      map['ref_type'] = Variable<String>(refType.value);
    }
    if (refId.present) {
      map['ref_id'] = Variable<String>(refId.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StockLedgerCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('remoteId: $remoteId, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('itemId: $itemId, ')
          ..write('qtyChange: $qtyChange, ')
          ..write('reason: $reason, ')
          ..write('refType: $refType, ')
          ..write('refId: $refId, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StockAdjustmentsTable extends StockAdjustments
    with TableInfo<$StockAdjustmentsTable, StockAdjustment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StockAdjustmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumnWithTypeConverter<SyncStatus, String> syncStatus =
      GeneratedColumn<String>('sync_status', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: Constant(SyncStatus.pending.name))
          .withConverter<SyncStatus>(
              $StockAdjustmentsTable.$convertersyncStatus);
  static const VerificationMeta _remoteIdMeta =
      const VerificationMeta('remoteId');
  @override
  late final GeneratedColumn<String> remoteId = GeneratedColumn<String>(
      'remote_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
      'item_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _previousQtyMeta =
      const VerificationMeta('previousQty');
  @override
  late final GeneratedColumn<double> previousQty = GeneratedColumn<double>(
      'previous_qty', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _adjustmentQtyMeta =
      const VerificationMeta('adjustmentQty');
  @override
  late final GeneratedColumn<double> adjustmentQty = GeneratedColumn<double>(
      'adjustment_qty', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _newQtyMeta = const VerificationMeta('newQty');
  @override
  late final GeneratedColumn<double> newQty = GeneratedColumn<double>(
      'new_qty', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
      'reason', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        createdAt,
        updatedAt,
        syncStatus,
        remoteId,
        isDeleted,
        itemId,
        previousQty,
        adjustmentQty,
        newQty,
        reason,
        notes
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stock_adjustments';
  @override
  VerificationContext validateIntegrity(Insertable<StockAdjustment> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    context.handle(_syncStatusMeta, const VerificationResult.success());
    if (data.containsKey('remote_id')) {
      context.handle(_remoteIdMeta,
          remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    if (data.containsKey('item_id')) {
      context.handle(_itemIdMeta,
          itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta));
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('previous_qty')) {
      context.handle(
          _previousQtyMeta,
          previousQty.isAcceptableOrUnknown(
              data['previous_qty']!, _previousQtyMeta));
    } else if (isInserting) {
      context.missing(_previousQtyMeta);
    }
    if (data.containsKey('adjustment_qty')) {
      context.handle(
          _adjustmentQtyMeta,
          adjustmentQty.isAcceptableOrUnknown(
              data['adjustment_qty']!, _adjustmentQtyMeta));
    } else if (isInserting) {
      context.missing(_adjustmentQtyMeta);
    }
    if (data.containsKey('new_qty')) {
      context.handle(_newQtyMeta,
          newQty.isAcceptableOrUnknown(data['new_qty']!, _newQtyMeta));
    } else if (isInserting) {
      context.missing(_newQtyMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(_reasonMeta,
          reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta));
    } else if (isInserting) {
      context.missing(_reasonMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StockAdjustment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StockAdjustment(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      syncStatus: $StockAdjustmentsTable.$convertersyncStatus.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}sync_status'])!),
      remoteId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}remote_id']),
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
      itemId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}item_id'])!,
      previousQty: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}previous_qty'])!,
      adjustmentQty: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}adjustment_qty'])!,
      newQty: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}new_qty'])!,
      reason: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reason'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
    );
  }

  @override
  $StockAdjustmentsTable createAlias(String alias) {
    return $StockAdjustmentsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SyncStatus, String, String> $convertersyncStatus =
      const EnumNameConverter<SyncStatus>(SyncStatus.values);
}

class StockAdjustment extends DataClass implements Insertable<StockAdjustment> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final SyncStatus syncStatus;
  final String? remoteId;
  final bool isDeleted;
  final String itemId;
  final double previousQty;
  final double adjustmentQty;
  final double newQty;
  final String reason;
  final String? notes;
  const StockAdjustment(
      {required this.id,
      required this.createdAt,
      required this.updatedAt,
      required this.syncStatus,
      this.remoteId,
      required this.isDeleted,
      required this.itemId,
      required this.previousQty,
      required this.adjustmentQty,
      required this.newQty,
      required this.reason,
      this.notes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    {
      map['sync_status'] = Variable<String>(
          $StockAdjustmentsTable.$convertersyncStatus.toSql(syncStatus));
    }
    if (!nullToAbsent || remoteId != null) {
      map['remote_id'] = Variable<String>(remoteId);
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['item_id'] = Variable<String>(itemId);
    map['previous_qty'] = Variable<double>(previousQty);
    map['adjustment_qty'] = Variable<double>(adjustmentQty);
    map['new_qty'] = Variable<double>(newQty);
    map['reason'] = Variable<String>(reason);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  StockAdjustmentsCompanion toCompanion(bool nullToAbsent) {
    return StockAdjustmentsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncStatus: Value(syncStatus),
      remoteId: remoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteId),
      isDeleted: Value(isDeleted),
      itemId: Value(itemId),
      previousQty: Value(previousQty),
      adjustmentQty: Value(adjustmentQty),
      newQty: Value(newQty),
      reason: Value(reason),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
    );
  }

  factory StockAdjustment.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StockAdjustment(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncStatus: $StockAdjustmentsTable.$convertersyncStatus
          .fromJson(serializer.fromJson<String>(json['syncStatus'])),
      remoteId: serializer.fromJson<String?>(json['remoteId']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      itemId: serializer.fromJson<String>(json['itemId']),
      previousQty: serializer.fromJson<double>(json['previousQty']),
      adjustmentQty: serializer.fromJson<double>(json['adjustmentQty']),
      newQty: serializer.fromJson<double>(json['newQty']),
      reason: serializer.fromJson<String>(json['reason']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncStatus': serializer.toJson<String>(
          $StockAdjustmentsTable.$convertersyncStatus.toJson(syncStatus)),
      'remoteId': serializer.toJson<String?>(remoteId),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'itemId': serializer.toJson<String>(itemId),
      'previousQty': serializer.toJson<double>(previousQty),
      'adjustmentQty': serializer.toJson<double>(adjustmentQty),
      'newQty': serializer.toJson<double>(newQty),
      'reason': serializer.toJson<String>(reason),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  StockAdjustment copyWith(
          {String? id,
          DateTime? createdAt,
          DateTime? updatedAt,
          SyncStatus? syncStatus,
          Value<String?> remoteId = const Value.absent(),
          bool? isDeleted,
          String? itemId,
          double? previousQty,
          double? adjustmentQty,
          double? newQty,
          String? reason,
          Value<String?> notes = const Value.absent()}) =>
      StockAdjustment(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        syncStatus: syncStatus ?? this.syncStatus,
        remoteId: remoteId.present ? remoteId.value : this.remoteId,
        isDeleted: isDeleted ?? this.isDeleted,
        itemId: itemId ?? this.itemId,
        previousQty: previousQty ?? this.previousQty,
        adjustmentQty: adjustmentQty ?? this.adjustmentQty,
        newQty: newQty ?? this.newQty,
        reason: reason ?? this.reason,
        notes: notes.present ? notes.value : this.notes,
      );
  StockAdjustment copyWithCompanion(StockAdjustmentsCompanion data) {
    return StockAdjustment(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      previousQty:
          data.previousQty.present ? data.previousQty.value : this.previousQty,
      adjustmentQty: data.adjustmentQty.present
          ? data.adjustmentQty.value
          : this.adjustmentQty,
      newQty: data.newQty.present ? data.newQty.value : this.newQty,
      reason: data.reason.present ? data.reason.value : this.reason,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StockAdjustment(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('remoteId: $remoteId, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('itemId: $itemId, ')
          ..write('previousQty: $previousQty, ')
          ..write('adjustmentQty: $adjustmentQty, ')
          ..write('newQty: $newQty, ')
          ..write('reason: $reason, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      createdAt,
      updatedAt,
      syncStatus,
      remoteId,
      isDeleted,
      itemId,
      previousQty,
      adjustmentQty,
      newQty,
      reason,
      notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StockAdjustment &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus &&
          other.remoteId == this.remoteId &&
          other.isDeleted == this.isDeleted &&
          other.itemId == this.itemId &&
          other.previousQty == this.previousQty &&
          other.adjustmentQty == this.adjustmentQty &&
          other.newQty == this.newQty &&
          other.reason == this.reason &&
          other.notes == this.notes);
}

class StockAdjustmentsCompanion extends UpdateCompanion<StockAdjustment> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<SyncStatus> syncStatus;
  final Value<String?> remoteId;
  final Value<bool> isDeleted;
  final Value<String> itemId;
  final Value<double> previousQty;
  final Value<double> adjustmentQty;
  final Value<double> newQty;
  final Value<String> reason;
  final Value<String?> notes;
  final Value<int> rowid;
  const StockAdjustmentsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.itemId = const Value.absent(),
    this.previousQty = const Value.absent(),
    this.adjustmentQty = const Value.absent(),
    this.newQty = const Value.absent(),
    this.reason = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StockAdjustmentsCompanion.insert({
    required String id,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.isDeleted = const Value.absent(),
    required String itemId,
    required double previousQty,
    required double adjustmentQty,
    required double newQty,
    required String reason,
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        itemId = Value(itemId),
        previousQty = Value(previousQty),
        adjustmentQty = Value(adjustmentQty),
        newQty = Value(newQty),
        reason = Value(reason);
  static Insertable<StockAdjustment> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncStatus,
    Expression<String>? remoteId,
    Expression<bool>? isDeleted,
    Expression<String>? itemId,
    Expression<double>? previousQty,
    Expression<double>? adjustmentQty,
    Expression<double>? newQty,
    Expression<String>? reason,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (remoteId != null) 'remote_id': remoteId,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (itemId != null) 'item_id': itemId,
      if (previousQty != null) 'previous_qty': previousQty,
      if (adjustmentQty != null) 'adjustment_qty': adjustmentQty,
      if (newQty != null) 'new_qty': newQty,
      if (reason != null) 'reason': reason,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StockAdjustmentsCompanion copyWith(
      {Value<String>? id,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<SyncStatus>? syncStatus,
      Value<String?>? remoteId,
      Value<bool>? isDeleted,
      Value<String>? itemId,
      Value<double>? previousQty,
      Value<double>? adjustmentQty,
      Value<double>? newQty,
      Value<String>? reason,
      Value<String?>? notes,
      Value<int>? rowid}) {
    return StockAdjustmentsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      remoteId: remoteId ?? this.remoteId,
      isDeleted: isDeleted ?? this.isDeleted,
      itemId: itemId ?? this.itemId,
      previousQty: previousQty ?? this.previousQty,
      adjustmentQty: adjustmentQty ?? this.adjustmentQty,
      newQty: newQty ?? this.newQty,
      reason: reason ?? this.reason,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(
          $StockAdjustmentsTable.$convertersyncStatus.toSql(syncStatus.value));
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (previousQty.present) {
      map['previous_qty'] = Variable<double>(previousQty.value);
    }
    if (adjustmentQty.present) {
      map['adjustment_qty'] = Variable<double>(adjustmentQty.value);
    }
    if (newQty.present) {
      map['new_qty'] = Variable<double>(newQty.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StockAdjustmentsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('remoteId: $remoteId, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('itemId: $itemId, ')
          ..write('previousQty: $previousQty, ')
          ..write('adjustmentQty: $adjustmentQty, ')
          ..write('newQty: $newQty, ')
          ..write('reason: $reason, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PurchasesTable extends Purchases
    with TableInfo<$PurchasesTable, Purchase> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PurchasesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumnWithTypeConverter<SyncStatus, String> syncStatus =
      GeneratedColumn<String>('sync_status', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: Constant(SyncStatus.pending.name))
          .withConverter<SyncStatus>($PurchasesTable.$convertersyncStatus);
  static const VerificationMeta _remoteIdMeta =
      const VerificationMeta('remoteId');
  @override
  late final GeneratedColumn<String> remoteId = GeneratedColumn<String>(
      'remote_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _supplierIdMeta =
      const VerificationMeta('supplierId');
  @override
  late final GeneratedColumn<String> supplierId = GeneratedColumn<String>(
      'supplier_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _supplierNameMeta =
      const VerificationMeta('supplierName');
  @override
  late final GeneratedColumn<String> supplierName = GeneratedColumn<String>(
      'supplier_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _supplierPanMeta =
      const VerificationMeta('supplierPan');
  @override
  late final GeneratedColumn<String> supplierPan = GeneratedColumn<String>(
      'supplier_pan', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _billNumberMeta =
      const VerificationMeta('billNumber');
  @override
  late final GeneratedColumn<String> billNumber = GeneratedColumn<String>(
      'bill_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _purchaseDateMeta =
      const VerificationMeta('purchaseDate');
  @override
  late final GeneratedColumn<DateTime> purchaseDate = GeneratedColumn<DateTime>(
      'purchase_date', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _subtotalPaisaMeta =
      const VerificationMeta('subtotalPaisa');
  @override
  late final GeneratedColumn<int> subtotalPaisa = GeneratedColumn<int>(
      'subtotal_paisa', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _discountPaisaMeta =
      const VerificationMeta('discountPaisa');
  @override
  late final GeneratedColumn<int> discountPaisa = GeneratedColumn<int>(
      'discount_paisa', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _taxablePaisaMeta =
      const VerificationMeta('taxablePaisa');
  @override
  late final GeneratedColumn<int> taxablePaisa = GeneratedColumn<int>(
      'taxable_paisa', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _vatPaisaMeta =
      const VerificationMeta('vatPaisa');
  @override
  late final GeneratedColumn<int> vatPaisa = GeneratedColumn<int>(
      'vat_paisa', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _totalPaisaMeta =
      const VerificationMeta('totalPaisa');
  @override
  late final GeneratedColumn<int> totalPaisa = GeneratedColumn<int>(
      'total_paisa', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _remarksMeta =
      const VerificationMeta('remarks');
  @override
  late final GeneratedColumn<String> remarks = GeneratedColumn<String>(
      'remarks', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isReturnedMeta =
      const VerificationMeta('isReturned');
  @override
  late final GeneratedColumn<bool> isReturned = GeneratedColumn<bool>(
      'is_returned', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_returned" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        createdAt,
        updatedAt,
        syncStatus,
        remoteId,
        isDeleted,
        supplierId,
        supplierName,
        supplierPan,
        billNumber,
        purchaseDate,
        subtotalPaisa,
        discountPaisa,
        taxablePaisa,
        vatPaisa,
        totalPaisa,
        remarks,
        isReturned
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'purchases';
  @override
  VerificationContext validateIntegrity(Insertable<Purchase> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    context.handle(_syncStatusMeta, const VerificationResult.success());
    if (data.containsKey('remote_id')) {
      context.handle(_remoteIdMeta,
          remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    if (data.containsKey('supplier_id')) {
      context.handle(
          _supplierIdMeta,
          supplierId.isAcceptableOrUnknown(
              data['supplier_id']!, _supplierIdMeta));
    }
    if (data.containsKey('supplier_name')) {
      context.handle(
          _supplierNameMeta,
          supplierName.isAcceptableOrUnknown(
              data['supplier_name']!, _supplierNameMeta));
    } else if (isInserting) {
      context.missing(_supplierNameMeta);
    }
    if (data.containsKey('supplier_pan')) {
      context.handle(
          _supplierPanMeta,
          supplierPan.isAcceptableOrUnknown(
              data['supplier_pan']!, _supplierPanMeta));
    }
    if (data.containsKey('bill_number')) {
      context.handle(
          _billNumberMeta,
          billNumber.isAcceptableOrUnknown(
              data['bill_number']!, _billNumberMeta));
    }
    if (data.containsKey('purchase_date')) {
      context.handle(
          _purchaseDateMeta,
          purchaseDate.isAcceptableOrUnknown(
              data['purchase_date']!, _purchaseDateMeta));
    }
    if (data.containsKey('subtotal_paisa')) {
      context.handle(
          _subtotalPaisaMeta,
          subtotalPaisa.isAcceptableOrUnknown(
              data['subtotal_paisa']!, _subtotalPaisaMeta));
    }
    if (data.containsKey('discount_paisa')) {
      context.handle(
          _discountPaisaMeta,
          discountPaisa.isAcceptableOrUnknown(
              data['discount_paisa']!, _discountPaisaMeta));
    }
    if (data.containsKey('taxable_paisa')) {
      context.handle(
          _taxablePaisaMeta,
          taxablePaisa.isAcceptableOrUnknown(
              data['taxable_paisa']!, _taxablePaisaMeta));
    }
    if (data.containsKey('vat_paisa')) {
      context.handle(_vatPaisaMeta,
          vatPaisa.isAcceptableOrUnknown(data['vat_paisa']!, _vatPaisaMeta));
    }
    if (data.containsKey('total_paisa')) {
      context.handle(
          _totalPaisaMeta,
          totalPaisa.isAcceptableOrUnknown(
              data['total_paisa']!, _totalPaisaMeta));
    }
    if (data.containsKey('remarks')) {
      context.handle(_remarksMeta,
          remarks.isAcceptableOrUnknown(data['remarks']!, _remarksMeta));
    }
    if (data.containsKey('is_returned')) {
      context.handle(
          _isReturnedMeta,
          isReturned.isAcceptableOrUnknown(
              data['is_returned']!, _isReturnedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Purchase map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Purchase(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      syncStatus: $PurchasesTable.$convertersyncStatus.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!),
      remoteId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}remote_id']),
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
      supplierId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}supplier_id']),
      supplierName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}supplier_name'])!,
      supplierPan: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}supplier_pan']),
      billNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bill_number']),
      purchaseDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}purchase_date'])!,
      subtotalPaisa: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}subtotal_paisa'])!,
      discountPaisa: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}discount_paisa'])!,
      taxablePaisa: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}taxable_paisa'])!,
      vatPaisa: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}vat_paisa'])!,
      totalPaisa: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_paisa'])!,
      remarks: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}remarks']),
      isReturned: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_returned'])!,
    );
  }

  @override
  $PurchasesTable createAlias(String alias) {
    return $PurchasesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SyncStatus, String, String> $convertersyncStatus =
      const EnumNameConverter<SyncStatus>(SyncStatus.values);
}

class Purchase extends DataClass implements Insertable<Purchase> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final SyncStatus syncStatus;
  final String? remoteId;
  final bool isDeleted;
  final String? supplierId;
  final String supplierName;
  final String? supplierPan;
  final String? billNumber;
  final DateTime purchaseDate;
  final int subtotalPaisa;
  final int discountPaisa;
  final int taxablePaisa;
  final int vatPaisa;
  final int totalPaisa;
  final String? remarks;
  final bool isReturned;
  const Purchase(
      {required this.id,
      required this.createdAt,
      required this.updatedAt,
      required this.syncStatus,
      this.remoteId,
      required this.isDeleted,
      this.supplierId,
      required this.supplierName,
      this.supplierPan,
      this.billNumber,
      required this.purchaseDate,
      required this.subtotalPaisa,
      required this.discountPaisa,
      required this.taxablePaisa,
      required this.vatPaisa,
      required this.totalPaisa,
      this.remarks,
      required this.isReturned});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    {
      map['sync_status'] = Variable<String>(
          $PurchasesTable.$convertersyncStatus.toSql(syncStatus));
    }
    if (!nullToAbsent || remoteId != null) {
      map['remote_id'] = Variable<String>(remoteId);
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    if (!nullToAbsent || supplierId != null) {
      map['supplier_id'] = Variable<String>(supplierId);
    }
    map['supplier_name'] = Variable<String>(supplierName);
    if (!nullToAbsent || supplierPan != null) {
      map['supplier_pan'] = Variable<String>(supplierPan);
    }
    if (!nullToAbsent || billNumber != null) {
      map['bill_number'] = Variable<String>(billNumber);
    }
    map['purchase_date'] = Variable<DateTime>(purchaseDate);
    map['subtotal_paisa'] = Variable<int>(subtotalPaisa);
    map['discount_paisa'] = Variable<int>(discountPaisa);
    map['taxable_paisa'] = Variable<int>(taxablePaisa);
    map['vat_paisa'] = Variable<int>(vatPaisa);
    map['total_paisa'] = Variable<int>(totalPaisa);
    if (!nullToAbsent || remarks != null) {
      map['remarks'] = Variable<String>(remarks);
    }
    map['is_returned'] = Variable<bool>(isReturned);
    return map;
  }

  PurchasesCompanion toCompanion(bool nullToAbsent) {
    return PurchasesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncStatus: Value(syncStatus),
      remoteId: remoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteId),
      isDeleted: Value(isDeleted),
      supplierId: supplierId == null && nullToAbsent
          ? const Value.absent()
          : Value(supplierId),
      supplierName: Value(supplierName),
      supplierPan: supplierPan == null && nullToAbsent
          ? const Value.absent()
          : Value(supplierPan),
      billNumber: billNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(billNumber),
      purchaseDate: Value(purchaseDate),
      subtotalPaisa: Value(subtotalPaisa),
      discountPaisa: Value(discountPaisa),
      taxablePaisa: Value(taxablePaisa),
      vatPaisa: Value(vatPaisa),
      totalPaisa: Value(totalPaisa),
      remarks: remarks == null && nullToAbsent
          ? const Value.absent()
          : Value(remarks),
      isReturned: Value(isReturned),
    );
  }

  factory Purchase.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Purchase(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncStatus: $PurchasesTable.$convertersyncStatus
          .fromJson(serializer.fromJson<String>(json['syncStatus'])),
      remoteId: serializer.fromJson<String?>(json['remoteId']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      supplierId: serializer.fromJson<String?>(json['supplierId']),
      supplierName: serializer.fromJson<String>(json['supplierName']),
      supplierPan: serializer.fromJson<String?>(json['supplierPan']),
      billNumber: serializer.fromJson<String?>(json['billNumber']),
      purchaseDate: serializer.fromJson<DateTime>(json['purchaseDate']),
      subtotalPaisa: serializer.fromJson<int>(json['subtotalPaisa']),
      discountPaisa: serializer.fromJson<int>(json['discountPaisa']),
      taxablePaisa: serializer.fromJson<int>(json['taxablePaisa']),
      vatPaisa: serializer.fromJson<int>(json['vatPaisa']),
      totalPaisa: serializer.fromJson<int>(json['totalPaisa']),
      remarks: serializer.fromJson<String?>(json['remarks']),
      isReturned: serializer.fromJson<bool>(json['isReturned']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncStatus': serializer.toJson<String>(
          $PurchasesTable.$convertersyncStatus.toJson(syncStatus)),
      'remoteId': serializer.toJson<String?>(remoteId),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'supplierId': serializer.toJson<String?>(supplierId),
      'supplierName': serializer.toJson<String>(supplierName),
      'supplierPan': serializer.toJson<String?>(supplierPan),
      'billNumber': serializer.toJson<String?>(billNumber),
      'purchaseDate': serializer.toJson<DateTime>(purchaseDate),
      'subtotalPaisa': serializer.toJson<int>(subtotalPaisa),
      'discountPaisa': serializer.toJson<int>(discountPaisa),
      'taxablePaisa': serializer.toJson<int>(taxablePaisa),
      'vatPaisa': serializer.toJson<int>(vatPaisa),
      'totalPaisa': serializer.toJson<int>(totalPaisa),
      'remarks': serializer.toJson<String?>(remarks),
      'isReturned': serializer.toJson<bool>(isReturned),
    };
  }

  Purchase copyWith(
          {String? id,
          DateTime? createdAt,
          DateTime? updatedAt,
          SyncStatus? syncStatus,
          Value<String?> remoteId = const Value.absent(),
          bool? isDeleted,
          Value<String?> supplierId = const Value.absent(),
          String? supplierName,
          Value<String?> supplierPan = const Value.absent(),
          Value<String?> billNumber = const Value.absent(),
          DateTime? purchaseDate,
          int? subtotalPaisa,
          int? discountPaisa,
          int? taxablePaisa,
          int? vatPaisa,
          int? totalPaisa,
          Value<String?> remarks = const Value.absent(),
          bool? isReturned}) =>
      Purchase(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        syncStatus: syncStatus ?? this.syncStatus,
        remoteId: remoteId.present ? remoteId.value : this.remoteId,
        isDeleted: isDeleted ?? this.isDeleted,
        supplierId: supplierId.present ? supplierId.value : this.supplierId,
        supplierName: supplierName ?? this.supplierName,
        supplierPan: supplierPan.present ? supplierPan.value : this.supplierPan,
        billNumber: billNumber.present ? billNumber.value : this.billNumber,
        purchaseDate: purchaseDate ?? this.purchaseDate,
        subtotalPaisa: subtotalPaisa ?? this.subtotalPaisa,
        discountPaisa: discountPaisa ?? this.discountPaisa,
        taxablePaisa: taxablePaisa ?? this.taxablePaisa,
        vatPaisa: vatPaisa ?? this.vatPaisa,
        totalPaisa: totalPaisa ?? this.totalPaisa,
        remarks: remarks.present ? remarks.value : this.remarks,
        isReturned: isReturned ?? this.isReturned,
      );
  Purchase copyWithCompanion(PurchasesCompanion data) {
    return Purchase(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      supplierId:
          data.supplierId.present ? data.supplierId.value : this.supplierId,
      supplierName: data.supplierName.present
          ? data.supplierName.value
          : this.supplierName,
      supplierPan:
          data.supplierPan.present ? data.supplierPan.value : this.supplierPan,
      billNumber:
          data.billNumber.present ? data.billNumber.value : this.billNumber,
      purchaseDate: data.purchaseDate.present
          ? data.purchaseDate.value
          : this.purchaseDate,
      subtotalPaisa: data.subtotalPaisa.present
          ? data.subtotalPaisa.value
          : this.subtotalPaisa,
      discountPaisa: data.discountPaisa.present
          ? data.discountPaisa.value
          : this.discountPaisa,
      taxablePaisa: data.taxablePaisa.present
          ? data.taxablePaisa.value
          : this.taxablePaisa,
      vatPaisa: data.vatPaisa.present ? data.vatPaisa.value : this.vatPaisa,
      totalPaisa:
          data.totalPaisa.present ? data.totalPaisa.value : this.totalPaisa,
      remarks: data.remarks.present ? data.remarks.value : this.remarks,
      isReturned:
          data.isReturned.present ? data.isReturned.value : this.isReturned,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Purchase(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('remoteId: $remoteId, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('supplierId: $supplierId, ')
          ..write('supplierName: $supplierName, ')
          ..write('supplierPan: $supplierPan, ')
          ..write('billNumber: $billNumber, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('subtotalPaisa: $subtotalPaisa, ')
          ..write('discountPaisa: $discountPaisa, ')
          ..write('taxablePaisa: $taxablePaisa, ')
          ..write('vatPaisa: $vatPaisa, ')
          ..write('totalPaisa: $totalPaisa, ')
          ..write('remarks: $remarks, ')
          ..write('isReturned: $isReturned')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      createdAt,
      updatedAt,
      syncStatus,
      remoteId,
      isDeleted,
      supplierId,
      supplierName,
      supplierPan,
      billNumber,
      purchaseDate,
      subtotalPaisa,
      discountPaisa,
      taxablePaisa,
      vatPaisa,
      totalPaisa,
      remarks,
      isReturned);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Purchase &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus &&
          other.remoteId == this.remoteId &&
          other.isDeleted == this.isDeleted &&
          other.supplierId == this.supplierId &&
          other.supplierName == this.supplierName &&
          other.supplierPan == this.supplierPan &&
          other.billNumber == this.billNumber &&
          other.purchaseDate == this.purchaseDate &&
          other.subtotalPaisa == this.subtotalPaisa &&
          other.discountPaisa == this.discountPaisa &&
          other.taxablePaisa == this.taxablePaisa &&
          other.vatPaisa == this.vatPaisa &&
          other.totalPaisa == this.totalPaisa &&
          other.remarks == this.remarks &&
          other.isReturned == this.isReturned);
}

class PurchasesCompanion extends UpdateCompanion<Purchase> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<SyncStatus> syncStatus;
  final Value<String?> remoteId;
  final Value<bool> isDeleted;
  final Value<String?> supplierId;
  final Value<String> supplierName;
  final Value<String?> supplierPan;
  final Value<String?> billNumber;
  final Value<DateTime> purchaseDate;
  final Value<int> subtotalPaisa;
  final Value<int> discountPaisa;
  final Value<int> taxablePaisa;
  final Value<int> vatPaisa;
  final Value<int> totalPaisa;
  final Value<String?> remarks;
  final Value<bool> isReturned;
  final Value<int> rowid;
  const PurchasesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.supplierId = const Value.absent(),
    this.supplierName = const Value.absent(),
    this.supplierPan = const Value.absent(),
    this.billNumber = const Value.absent(),
    this.purchaseDate = const Value.absent(),
    this.subtotalPaisa = const Value.absent(),
    this.discountPaisa = const Value.absent(),
    this.taxablePaisa = const Value.absent(),
    this.vatPaisa = const Value.absent(),
    this.totalPaisa = const Value.absent(),
    this.remarks = const Value.absent(),
    this.isReturned = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PurchasesCompanion.insert({
    required String id,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.supplierId = const Value.absent(),
    required String supplierName,
    this.supplierPan = const Value.absent(),
    this.billNumber = const Value.absent(),
    this.purchaseDate = const Value.absent(),
    this.subtotalPaisa = const Value.absent(),
    this.discountPaisa = const Value.absent(),
    this.taxablePaisa = const Value.absent(),
    this.vatPaisa = const Value.absent(),
    this.totalPaisa = const Value.absent(),
    this.remarks = const Value.absent(),
    this.isReturned = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        supplierName = Value(supplierName);
  static Insertable<Purchase> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncStatus,
    Expression<String>? remoteId,
    Expression<bool>? isDeleted,
    Expression<String>? supplierId,
    Expression<String>? supplierName,
    Expression<String>? supplierPan,
    Expression<String>? billNumber,
    Expression<DateTime>? purchaseDate,
    Expression<int>? subtotalPaisa,
    Expression<int>? discountPaisa,
    Expression<int>? taxablePaisa,
    Expression<int>? vatPaisa,
    Expression<int>? totalPaisa,
    Expression<String>? remarks,
    Expression<bool>? isReturned,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (remoteId != null) 'remote_id': remoteId,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (supplierId != null) 'supplier_id': supplierId,
      if (supplierName != null) 'supplier_name': supplierName,
      if (supplierPan != null) 'supplier_pan': supplierPan,
      if (billNumber != null) 'bill_number': billNumber,
      if (purchaseDate != null) 'purchase_date': purchaseDate,
      if (subtotalPaisa != null) 'subtotal_paisa': subtotalPaisa,
      if (discountPaisa != null) 'discount_paisa': discountPaisa,
      if (taxablePaisa != null) 'taxable_paisa': taxablePaisa,
      if (vatPaisa != null) 'vat_paisa': vatPaisa,
      if (totalPaisa != null) 'total_paisa': totalPaisa,
      if (remarks != null) 'remarks': remarks,
      if (isReturned != null) 'is_returned': isReturned,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PurchasesCompanion copyWith(
      {Value<String>? id,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<SyncStatus>? syncStatus,
      Value<String?>? remoteId,
      Value<bool>? isDeleted,
      Value<String?>? supplierId,
      Value<String>? supplierName,
      Value<String?>? supplierPan,
      Value<String?>? billNumber,
      Value<DateTime>? purchaseDate,
      Value<int>? subtotalPaisa,
      Value<int>? discountPaisa,
      Value<int>? taxablePaisa,
      Value<int>? vatPaisa,
      Value<int>? totalPaisa,
      Value<String?>? remarks,
      Value<bool>? isReturned,
      Value<int>? rowid}) {
    return PurchasesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      remoteId: remoteId ?? this.remoteId,
      isDeleted: isDeleted ?? this.isDeleted,
      supplierId: supplierId ?? this.supplierId,
      supplierName: supplierName ?? this.supplierName,
      supplierPan: supplierPan ?? this.supplierPan,
      billNumber: billNumber ?? this.billNumber,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      subtotalPaisa: subtotalPaisa ?? this.subtotalPaisa,
      discountPaisa: discountPaisa ?? this.discountPaisa,
      taxablePaisa: taxablePaisa ?? this.taxablePaisa,
      vatPaisa: vatPaisa ?? this.vatPaisa,
      totalPaisa: totalPaisa ?? this.totalPaisa,
      remarks: remarks ?? this.remarks,
      isReturned: isReturned ?? this.isReturned,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(
          $PurchasesTable.$convertersyncStatus.toSql(syncStatus.value));
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (supplierId.present) {
      map['supplier_id'] = Variable<String>(supplierId.value);
    }
    if (supplierName.present) {
      map['supplier_name'] = Variable<String>(supplierName.value);
    }
    if (supplierPan.present) {
      map['supplier_pan'] = Variable<String>(supplierPan.value);
    }
    if (billNumber.present) {
      map['bill_number'] = Variable<String>(billNumber.value);
    }
    if (purchaseDate.present) {
      map['purchase_date'] = Variable<DateTime>(purchaseDate.value);
    }
    if (subtotalPaisa.present) {
      map['subtotal_paisa'] = Variable<int>(subtotalPaisa.value);
    }
    if (discountPaisa.present) {
      map['discount_paisa'] = Variable<int>(discountPaisa.value);
    }
    if (taxablePaisa.present) {
      map['taxable_paisa'] = Variable<int>(taxablePaisa.value);
    }
    if (vatPaisa.present) {
      map['vat_paisa'] = Variable<int>(vatPaisa.value);
    }
    if (totalPaisa.present) {
      map['total_paisa'] = Variable<int>(totalPaisa.value);
    }
    if (remarks.present) {
      map['remarks'] = Variable<String>(remarks.value);
    }
    if (isReturned.present) {
      map['is_returned'] = Variable<bool>(isReturned.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PurchasesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('remoteId: $remoteId, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('supplierId: $supplierId, ')
          ..write('supplierName: $supplierName, ')
          ..write('supplierPan: $supplierPan, ')
          ..write('billNumber: $billNumber, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('subtotalPaisa: $subtotalPaisa, ')
          ..write('discountPaisa: $discountPaisa, ')
          ..write('taxablePaisa: $taxablePaisa, ')
          ..write('vatPaisa: $vatPaisa, ')
          ..write('totalPaisa: $totalPaisa, ')
          ..write('remarks: $remarks, ')
          ..write('isReturned: $isReturned, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PurchaseItemsTable extends PurchaseItems
    with TableInfo<$PurchaseItemsTable, PurchaseItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PurchaseItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumnWithTypeConverter<SyncStatus, String> syncStatus =
      GeneratedColumn<String>('sync_status', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: Constant(SyncStatus.pending.name))
          .withConverter<SyncStatus>($PurchaseItemsTable.$convertersyncStatus);
  static const VerificationMeta _remoteIdMeta =
      const VerificationMeta('remoteId');
  @override
  late final GeneratedColumn<String> remoteId = GeneratedColumn<String>(
      'remote_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _purchaseIdMeta =
      const VerificationMeta('purchaseId');
  @override
  late final GeneratedColumn<String> purchaseId = GeneratedColumn<String>(
      'purchase_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
      'item_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _itemNameMeta =
      const VerificationMeta('itemName');
  @override
  late final GeneratedColumn<String> itemName = GeneratedColumn<String>(
      'item_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pcs'));
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
      'quantity', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _ratePaisaMeta =
      const VerificationMeta('ratePaisa');
  @override
  late final GeneratedColumn<int> ratePaisa = GeneratedColumn<int>(
      'rate_paisa', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _discountPaisaMeta =
      const VerificationMeta('discountPaisa');
  @override
  late final GeneratedColumn<int> discountPaisa = GeneratedColumn<int>(
      'discount_paisa', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _taxablePaisaMeta =
      const VerificationMeta('taxablePaisa');
  @override
  late final GeneratedColumn<int> taxablePaisa = GeneratedColumn<int>(
      'taxable_paisa', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _vatPaisaMeta =
      const VerificationMeta('vatPaisa');
  @override
  late final GeneratedColumn<int> vatPaisa = GeneratedColumn<int>(
      'vat_paisa', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lineTotalPaisaMeta =
      const VerificationMeta('lineTotalPaisa');
  @override
  late final GeneratedColumn<int> lineTotalPaisa = GeneratedColumn<int>(
      'line_total_paisa', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        createdAt,
        updatedAt,
        syncStatus,
        remoteId,
        isDeleted,
        purchaseId,
        itemId,
        itemName,
        unit,
        quantity,
        ratePaisa,
        discountPaisa,
        taxablePaisa,
        vatPaisa,
        lineTotalPaisa
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'purchase_items';
  @override
  VerificationContext validateIntegrity(Insertable<PurchaseItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    context.handle(_syncStatusMeta, const VerificationResult.success());
    if (data.containsKey('remote_id')) {
      context.handle(_remoteIdMeta,
          remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    if (data.containsKey('purchase_id')) {
      context.handle(
          _purchaseIdMeta,
          purchaseId.isAcceptableOrUnknown(
              data['purchase_id']!, _purchaseIdMeta));
    } else if (isInserting) {
      context.missing(_purchaseIdMeta);
    }
    if (data.containsKey('item_id')) {
      context.handle(_itemIdMeta,
          itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta));
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('item_name')) {
      context.handle(_itemNameMeta,
          itemName.isAcceptableOrUnknown(data['item_name']!, _itemNameMeta));
    } else if (isInserting) {
      context.missing(_itemNameMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('rate_paisa')) {
      context.handle(_ratePaisaMeta,
          ratePaisa.isAcceptableOrUnknown(data['rate_paisa']!, _ratePaisaMeta));
    } else if (isInserting) {
      context.missing(_ratePaisaMeta);
    }
    if (data.containsKey('discount_paisa')) {
      context.handle(
          _discountPaisaMeta,
          discountPaisa.isAcceptableOrUnknown(
              data['discount_paisa']!, _discountPaisaMeta));
    }
    if (data.containsKey('taxable_paisa')) {
      context.handle(
          _taxablePaisaMeta,
          taxablePaisa.isAcceptableOrUnknown(
              data['taxable_paisa']!, _taxablePaisaMeta));
    } else if (isInserting) {
      context.missing(_taxablePaisaMeta);
    }
    if (data.containsKey('vat_paisa')) {
      context.handle(_vatPaisaMeta,
          vatPaisa.isAcceptableOrUnknown(data['vat_paisa']!, _vatPaisaMeta));
    }
    if (data.containsKey('line_total_paisa')) {
      context.handle(
          _lineTotalPaisaMeta,
          lineTotalPaisa.isAcceptableOrUnknown(
              data['line_total_paisa']!, _lineTotalPaisaMeta));
    } else if (isInserting) {
      context.missing(_lineTotalPaisaMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PurchaseItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PurchaseItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      syncStatus: $PurchaseItemsTable.$convertersyncStatus.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}sync_status'])!),
      remoteId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}remote_id']),
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
      purchaseId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}purchase_id'])!,
      itemId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}item_id'])!,
      itemName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}item_name'])!,
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}quantity'])!,
      ratePaisa: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}rate_paisa'])!,
      discountPaisa: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}discount_paisa'])!,
      taxablePaisa: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}taxable_paisa'])!,
      vatPaisa: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}vat_paisa'])!,
      lineTotalPaisa: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}line_total_paisa'])!,
    );
  }

  @override
  $PurchaseItemsTable createAlias(String alias) {
    return $PurchaseItemsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SyncStatus, String, String> $convertersyncStatus =
      const EnumNameConverter<SyncStatus>(SyncStatus.values);
}

class PurchaseItem extends DataClass implements Insertable<PurchaseItem> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final SyncStatus syncStatus;
  final String? remoteId;
  final bool isDeleted;
  final String purchaseId;
  final String itemId;
  final String itemName;
  final String unit;
  final double quantity;
  final int ratePaisa;
  final int discountPaisa;
  final int taxablePaisa;
  final int vatPaisa;
  final int lineTotalPaisa;
  const PurchaseItem(
      {required this.id,
      required this.createdAt,
      required this.updatedAt,
      required this.syncStatus,
      this.remoteId,
      required this.isDeleted,
      required this.purchaseId,
      required this.itemId,
      required this.itemName,
      required this.unit,
      required this.quantity,
      required this.ratePaisa,
      required this.discountPaisa,
      required this.taxablePaisa,
      required this.vatPaisa,
      required this.lineTotalPaisa});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    {
      map['sync_status'] = Variable<String>(
          $PurchaseItemsTable.$convertersyncStatus.toSql(syncStatus));
    }
    if (!nullToAbsent || remoteId != null) {
      map['remote_id'] = Variable<String>(remoteId);
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['purchase_id'] = Variable<String>(purchaseId);
    map['item_id'] = Variable<String>(itemId);
    map['item_name'] = Variable<String>(itemName);
    map['unit'] = Variable<String>(unit);
    map['quantity'] = Variable<double>(quantity);
    map['rate_paisa'] = Variable<int>(ratePaisa);
    map['discount_paisa'] = Variable<int>(discountPaisa);
    map['taxable_paisa'] = Variable<int>(taxablePaisa);
    map['vat_paisa'] = Variable<int>(vatPaisa);
    map['line_total_paisa'] = Variable<int>(lineTotalPaisa);
    return map;
  }

  PurchaseItemsCompanion toCompanion(bool nullToAbsent) {
    return PurchaseItemsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncStatus: Value(syncStatus),
      remoteId: remoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteId),
      isDeleted: Value(isDeleted),
      purchaseId: Value(purchaseId),
      itemId: Value(itemId),
      itemName: Value(itemName),
      unit: Value(unit),
      quantity: Value(quantity),
      ratePaisa: Value(ratePaisa),
      discountPaisa: Value(discountPaisa),
      taxablePaisa: Value(taxablePaisa),
      vatPaisa: Value(vatPaisa),
      lineTotalPaisa: Value(lineTotalPaisa),
    );
  }

  factory PurchaseItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PurchaseItem(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncStatus: $PurchaseItemsTable.$convertersyncStatus
          .fromJson(serializer.fromJson<String>(json['syncStatus'])),
      remoteId: serializer.fromJson<String?>(json['remoteId']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      purchaseId: serializer.fromJson<String>(json['purchaseId']),
      itemId: serializer.fromJson<String>(json['itemId']),
      itemName: serializer.fromJson<String>(json['itemName']),
      unit: serializer.fromJson<String>(json['unit']),
      quantity: serializer.fromJson<double>(json['quantity']),
      ratePaisa: serializer.fromJson<int>(json['ratePaisa']),
      discountPaisa: serializer.fromJson<int>(json['discountPaisa']),
      taxablePaisa: serializer.fromJson<int>(json['taxablePaisa']),
      vatPaisa: serializer.fromJson<int>(json['vatPaisa']),
      lineTotalPaisa: serializer.fromJson<int>(json['lineTotalPaisa']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncStatus': serializer.toJson<String>(
          $PurchaseItemsTable.$convertersyncStatus.toJson(syncStatus)),
      'remoteId': serializer.toJson<String?>(remoteId),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'purchaseId': serializer.toJson<String>(purchaseId),
      'itemId': serializer.toJson<String>(itemId),
      'itemName': serializer.toJson<String>(itemName),
      'unit': serializer.toJson<String>(unit),
      'quantity': serializer.toJson<double>(quantity),
      'ratePaisa': serializer.toJson<int>(ratePaisa),
      'discountPaisa': serializer.toJson<int>(discountPaisa),
      'taxablePaisa': serializer.toJson<int>(taxablePaisa),
      'vatPaisa': serializer.toJson<int>(vatPaisa),
      'lineTotalPaisa': serializer.toJson<int>(lineTotalPaisa),
    };
  }

  PurchaseItem copyWith(
          {String? id,
          DateTime? createdAt,
          DateTime? updatedAt,
          SyncStatus? syncStatus,
          Value<String?> remoteId = const Value.absent(),
          bool? isDeleted,
          String? purchaseId,
          String? itemId,
          String? itemName,
          String? unit,
          double? quantity,
          int? ratePaisa,
          int? discountPaisa,
          int? taxablePaisa,
          int? vatPaisa,
          int? lineTotalPaisa}) =>
      PurchaseItem(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        syncStatus: syncStatus ?? this.syncStatus,
        remoteId: remoteId.present ? remoteId.value : this.remoteId,
        isDeleted: isDeleted ?? this.isDeleted,
        purchaseId: purchaseId ?? this.purchaseId,
        itemId: itemId ?? this.itemId,
        itemName: itemName ?? this.itemName,
        unit: unit ?? this.unit,
        quantity: quantity ?? this.quantity,
        ratePaisa: ratePaisa ?? this.ratePaisa,
        discountPaisa: discountPaisa ?? this.discountPaisa,
        taxablePaisa: taxablePaisa ?? this.taxablePaisa,
        vatPaisa: vatPaisa ?? this.vatPaisa,
        lineTotalPaisa: lineTotalPaisa ?? this.lineTotalPaisa,
      );
  PurchaseItem copyWithCompanion(PurchaseItemsCompanion data) {
    return PurchaseItem(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      purchaseId:
          data.purchaseId.present ? data.purchaseId.value : this.purchaseId,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      itemName: data.itemName.present ? data.itemName.value : this.itemName,
      unit: data.unit.present ? data.unit.value : this.unit,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      ratePaisa: data.ratePaisa.present ? data.ratePaisa.value : this.ratePaisa,
      discountPaisa: data.discountPaisa.present
          ? data.discountPaisa.value
          : this.discountPaisa,
      taxablePaisa: data.taxablePaisa.present
          ? data.taxablePaisa.value
          : this.taxablePaisa,
      vatPaisa: data.vatPaisa.present ? data.vatPaisa.value : this.vatPaisa,
      lineTotalPaisa: data.lineTotalPaisa.present
          ? data.lineTotalPaisa.value
          : this.lineTotalPaisa,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PurchaseItem(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('remoteId: $remoteId, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('purchaseId: $purchaseId, ')
          ..write('itemId: $itemId, ')
          ..write('itemName: $itemName, ')
          ..write('unit: $unit, ')
          ..write('quantity: $quantity, ')
          ..write('ratePaisa: $ratePaisa, ')
          ..write('discountPaisa: $discountPaisa, ')
          ..write('taxablePaisa: $taxablePaisa, ')
          ..write('vatPaisa: $vatPaisa, ')
          ..write('lineTotalPaisa: $lineTotalPaisa')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      createdAt,
      updatedAt,
      syncStatus,
      remoteId,
      isDeleted,
      purchaseId,
      itemId,
      itemName,
      unit,
      quantity,
      ratePaisa,
      discountPaisa,
      taxablePaisa,
      vatPaisa,
      lineTotalPaisa);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PurchaseItem &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus &&
          other.remoteId == this.remoteId &&
          other.isDeleted == this.isDeleted &&
          other.purchaseId == this.purchaseId &&
          other.itemId == this.itemId &&
          other.itemName == this.itemName &&
          other.unit == this.unit &&
          other.quantity == this.quantity &&
          other.ratePaisa == this.ratePaisa &&
          other.discountPaisa == this.discountPaisa &&
          other.taxablePaisa == this.taxablePaisa &&
          other.vatPaisa == this.vatPaisa &&
          other.lineTotalPaisa == this.lineTotalPaisa);
}

class PurchaseItemsCompanion extends UpdateCompanion<PurchaseItem> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<SyncStatus> syncStatus;
  final Value<String?> remoteId;
  final Value<bool> isDeleted;
  final Value<String> purchaseId;
  final Value<String> itemId;
  final Value<String> itemName;
  final Value<String> unit;
  final Value<double> quantity;
  final Value<int> ratePaisa;
  final Value<int> discountPaisa;
  final Value<int> taxablePaisa;
  final Value<int> vatPaisa;
  final Value<int> lineTotalPaisa;
  final Value<int> rowid;
  const PurchaseItemsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.purchaseId = const Value.absent(),
    this.itemId = const Value.absent(),
    this.itemName = const Value.absent(),
    this.unit = const Value.absent(),
    this.quantity = const Value.absent(),
    this.ratePaisa = const Value.absent(),
    this.discountPaisa = const Value.absent(),
    this.taxablePaisa = const Value.absent(),
    this.vatPaisa = const Value.absent(),
    this.lineTotalPaisa = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PurchaseItemsCompanion.insert({
    required String id,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.isDeleted = const Value.absent(),
    required String purchaseId,
    required String itemId,
    required String itemName,
    this.unit = const Value.absent(),
    required double quantity,
    required int ratePaisa,
    this.discountPaisa = const Value.absent(),
    required int taxablePaisa,
    this.vatPaisa = const Value.absent(),
    required int lineTotalPaisa,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        purchaseId = Value(purchaseId),
        itemId = Value(itemId),
        itemName = Value(itemName),
        quantity = Value(quantity),
        ratePaisa = Value(ratePaisa),
        taxablePaisa = Value(taxablePaisa),
        lineTotalPaisa = Value(lineTotalPaisa);
  static Insertable<PurchaseItem> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncStatus,
    Expression<String>? remoteId,
    Expression<bool>? isDeleted,
    Expression<String>? purchaseId,
    Expression<String>? itemId,
    Expression<String>? itemName,
    Expression<String>? unit,
    Expression<double>? quantity,
    Expression<int>? ratePaisa,
    Expression<int>? discountPaisa,
    Expression<int>? taxablePaisa,
    Expression<int>? vatPaisa,
    Expression<int>? lineTotalPaisa,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (remoteId != null) 'remote_id': remoteId,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (purchaseId != null) 'purchase_id': purchaseId,
      if (itemId != null) 'item_id': itemId,
      if (itemName != null) 'item_name': itemName,
      if (unit != null) 'unit': unit,
      if (quantity != null) 'quantity': quantity,
      if (ratePaisa != null) 'rate_paisa': ratePaisa,
      if (discountPaisa != null) 'discount_paisa': discountPaisa,
      if (taxablePaisa != null) 'taxable_paisa': taxablePaisa,
      if (vatPaisa != null) 'vat_paisa': vatPaisa,
      if (lineTotalPaisa != null) 'line_total_paisa': lineTotalPaisa,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PurchaseItemsCompanion copyWith(
      {Value<String>? id,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<SyncStatus>? syncStatus,
      Value<String?>? remoteId,
      Value<bool>? isDeleted,
      Value<String>? purchaseId,
      Value<String>? itemId,
      Value<String>? itemName,
      Value<String>? unit,
      Value<double>? quantity,
      Value<int>? ratePaisa,
      Value<int>? discountPaisa,
      Value<int>? taxablePaisa,
      Value<int>? vatPaisa,
      Value<int>? lineTotalPaisa,
      Value<int>? rowid}) {
    return PurchaseItemsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      remoteId: remoteId ?? this.remoteId,
      isDeleted: isDeleted ?? this.isDeleted,
      purchaseId: purchaseId ?? this.purchaseId,
      itemId: itemId ?? this.itemId,
      itemName: itemName ?? this.itemName,
      unit: unit ?? this.unit,
      quantity: quantity ?? this.quantity,
      ratePaisa: ratePaisa ?? this.ratePaisa,
      discountPaisa: discountPaisa ?? this.discountPaisa,
      taxablePaisa: taxablePaisa ?? this.taxablePaisa,
      vatPaisa: vatPaisa ?? this.vatPaisa,
      lineTotalPaisa: lineTotalPaisa ?? this.lineTotalPaisa,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(
          $PurchaseItemsTable.$convertersyncStatus.toSql(syncStatus.value));
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (purchaseId.present) {
      map['purchase_id'] = Variable<String>(purchaseId.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (itemName.present) {
      map['item_name'] = Variable<String>(itemName.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (ratePaisa.present) {
      map['rate_paisa'] = Variable<int>(ratePaisa.value);
    }
    if (discountPaisa.present) {
      map['discount_paisa'] = Variable<int>(discountPaisa.value);
    }
    if (taxablePaisa.present) {
      map['taxable_paisa'] = Variable<int>(taxablePaisa.value);
    }
    if (vatPaisa.present) {
      map['vat_paisa'] = Variable<int>(vatPaisa.value);
    }
    if (lineTotalPaisa.present) {
      map['line_total_paisa'] = Variable<int>(lineTotalPaisa.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PurchaseItemsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('remoteId: $remoteId, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('purchaseId: $purchaseId, ')
          ..write('itemId: $itemId, ')
          ..write('itemName: $itemName, ')
          ..write('unit: $unit, ')
          ..write('quantity: $quantity, ')
          ..write('ratePaisa: $ratePaisa, ')
          ..write('discountPaisa: $discountPaisa, ')
          ..write('taxablePaisa: $taxablePaisa, ')
          ..write('vatPaisa: $vatPaisa, ')
          ..write('lineTotalPaisa: $lineTotalPaisa, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SalesTable extends Sales with TableInfo<$SalesTable, Sale> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SalesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumnWithTypeConverter<SyncStatus, String> syncStatus =
      GeneratedColumn<String>('sync_status', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: Constant(SyncStatus.pending.name))
          .withConverter<SyncStatus>($SalesTable.$convertersyncStatus);
  static const VerificationMeta _remoteIdMeta =
      const VerificationMeta('remoteId');
  @override
  late final GeneratedColumn<String> remoteId = GeneratedColumn<String>(
      'remote_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _invoiceNumberMeta =
      const VerificationMeta('invoiceNumber');
  @override
  late final GeneratedColumn<String> invoiceNumber = GeneratedColumn<String>(
      'invoice_number', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _customerIdMeta =
      const VerificationMeta('customerId');
  @override
  late final GeneratedColumn<String> customerId = GeneratedColumn<String>(
      'customer_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _customerNameMeta =
      const VerificationMeta('customerName');
  @override
  late final GeneratedColumn<String> customerName = GeneratedColumn<String>(
      'customer_name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Cash Customer / नगद ग्राहक'));
  static const VerificationMeta _customerPanMeta =
      const VerificationMeta('customerPan');
  @override
  late final GeneratedColumn<String> customerPan = GeneratedColumn<String>(
      'customer_pan', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _customerPhoneMeta =
      const VerificationMeta('customerPhone');
  @override
  late final GeneratedColumn<String> customerPhone = GeneratedColumn<String>(
      'customer_phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _invoiceDateMeta =
      const VerificationMeta('invoiceDate');
  @override
  late final GeneratedColumn<DateTime> invoiceDate = GeneratedColumn<DateTime>(
      'invoice_date', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _subtotalPaisaMeta =
      const VerificationMeta('subtotalPaisa');
  @override
  late final GeneratedColumn<int> subtotalPaisa = GeneratedColumn<int>(
      'subtotal_paisa', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _discountPaisaMeta =
      const VerificationMeta('discountPaisa');
  @override
  late final GeneratedColumn<int> discountPaisa = GeneratedColumn<int>(
      'discount_paisa', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _taxablePaisaMeta =
      const VerificationMeta('taxablePaisa');
  @override
  late final GeneratedColumn<int> taxablePaisa = GeneratedColumn<int>(
      'taxable_paisa', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _vatPaisaMeta =
      const VerificationMeta('vatPaisa');
  @override
  late final GeneratedColumn<int> vatPaisa = GeneratedColumn<int>(
      'vat_paisa', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _totalPaisaMeta =
      const VerificationMeta('totalPaisa');
  @override
  late final GeneratedColumn<int> totalPaisa = GeneratedColumn<int>(
      'total_paisa', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _tenderedPaisaMeta =
      const VerificationMeta('tenderedPaisa');
  @override
  late final GeneratedColumn<int> tenderedPaisa = GeneratedColumn<int>(
      'tendered_paisa', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _changePaisaMeta =
      const VerificationMeta('changePaisa');
  @override
  late final GeneratedColumn<int> changePaisa = GeneratedColumn<int>(
      'change_paisa', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _paymentModeMeta =
      const VerificationMeta('paymentMode');
  @override
  late final GeneratedColumn<String> paymentMode = GeneratedColumn<String>(
      'payment_mode', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('CASH'));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('VERIFIED'));
  static const VerificationMeta _isVoidedMeta =
      const VerificationMeta('isVoided');
  @override
  late final GeneratedColumn<bool> isVoided = GeneratedColumn<bool>(
      'is_voided', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_voided" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        createdAt,
        updatedAt,
        syncStatus,
        remoteId,
        isDeleted,
        invoiceNumber,
        customerId,
        customerName,
        customerPan,
        customerPhone,
        invoiceDate,
        subtotalPaisa,
        discountPaisa,
        taxablePaisa,
        vatPaisa,
        totalPaisa,
        tenderedPaisa,
        changePaisa,
        paymentMode,
        notes,
        status,
        isVoided
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sales';
  @override
  VerificationContext validateIntegrity(Insertable<Sale> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    context.handle(_syncStatusMeta, const VerificationResult.success());
    if (data.containsKey('remote_id')) {
      context.handle(_remoteIdMeta,
          remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    if (data.containsKey('invoice_number')) {
      context.handle(
          _invoiceNumberMeta,
          invoiceNumber.isAcceptableOrUnknown(
              data['invoice_number']!, _invoiceNumberMeta));
    } else if (isInserting) {
      context.missing(_invoiceNumberMeta);
    }
    if (data.containsKey('customer_id')) {
      context.handle(
          _customerIdMeta,
          customerId.isAcceptableOrUnknown(
              data['customer_id']!, _customerIdMeta));
    }
    if (data.containsKey('customer_name')) {
      context.handle(
          _customerNameMeta,
          customerName.isAcceptableOrUnknown(
              data['customer_name']!, _customerNameMeta));
    }
    if (data.containsKey('customer_pan')) {
      context.handle(
          _customerPanMeta,
          customerPan.isAcceptableOrUnknown(
              data['customer_pan']!, _customerPanMeta));
    }
    if (data.containsKey('customer_phone')) {
      context.handle(
          _customerPhoneMeta,
          customerPhone.isAcceptableOrUnknown(
              data['customer_phone']!, _customerPhoneMeta));
    }
    if (data.containsKey('invoice_date')) {
      context.handle(
          _invoiceDateMeta,
          invoiceDate.isAcceptableOrUnknown(
              data['invoice_date']!, _invoiceDateMeta));
    }
    if (data.containsKey('subtotal_paisa')) {
      context.handle(
          _subtotalPaisaMeta,
          subtotalPaisa.isAcceptableOrUnknown(
              data['subtotal_paisa']!, _subtotalPaisaMeta));
    } else if (isInserting) {
      context.missing(_subtotalPaisaMeta);
    }
    if (data.containsKey('discount_paisa')) {
      context.handle(
          _discountPaisaMeta,
          discountPaisa.isAcceptableOrUnknown(
              data['discount_paisa']!, _discountPaisaMeta));
    }
    if (data.containsKey('taxable_paisa')) {
      context.handle(
          _taxablePaisaMeta,
          taxablePaisa.isAcceptableOrUnknown(
              data['taxable_paisa']!, _taxablePaisaMeta));
    } else if (isInserting) {
      context.missing(_taxablePaisaMeta);
    }
    if (data.containsKey('vat_paisa')) {
      context.handle(_vatPaisaMeta,
          vatPaisa.isAcceptableOrUnknown(data['vat_paisa']!, _vatPaisaMeta));
    }
    if (data.containsKey('total_paisa')) {
      context.handle(
          _totalPaisaMeta,
          totalPaisa.isAcceptableOrUnknown(
              data['total_paisa']!, _totalPaisaMeta));
    } else if (isInserting) {
      context.missing(_totalPaisaMeta);
    }
    if (data.containsKey('tendered_paisa')) {
      context.handle(
          _tenderedPaisaMeta,
          tenderedPaisa.isAcceptableOrUnknown(
              data['tendered_paisa']!, _tenderedPaisaMeta));
    }
    if (data.containsKey('change_paisa')) {
      context.handle(
          _changePaisaMeta,
          changePaisa.isAcceptableOrUnknown(
              data['change_paisa']!, _changePaisaMeta));
    }
    if (data.containsKey('payment_mode')) {
      context.handle(
          _paymentModeMeta,
          paymentMode.isAcceptableOrUnknown(
              data['payment_mode']!, _paymentModeMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('is_voided')) {
      context.handle(_isVoidedMeta,
          isVoided.isAcceptableOrUnknown(data['is_voided']!, _isVoidedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Sale map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Sale(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      syncStatus: $SalesTable.$convertersyncStatus.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!),
      remoteId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}remote_id']),
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
      invoiceNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}invoice_number'])!,
      customerId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}customer_id']),
      customerName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}customer_name'])!,
      customerPan: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}customer_pan']),
      customerPhone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}customer_phone']),
      invoiceDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}invoice_date'])!,
      subtotalPaisa: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}subtotal_paisa'])!,
      discountPaisa: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}discount_paisa'])!,
      taxablePaisa: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}taxable_paisa'])!,
      vatPaisa: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}vat_paisa'])!,
      totalPaisa: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_paisa'])!,
      tenderedPaisa: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tendered_paisa'])!,
      changePaisa: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}change_paisa'])!,
      paymentMode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payment_mode'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      isVoided: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_voided'])!,
    );
  }

  @override
  $SalesTable createAlias(String alias) {
    return $SalesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SyncStatus, String, String> $convertersyncStatus =
      const EnumNameConverter<SyncStatus>(SyncStatus.values);
}

class Sale extends DataClass implements Insertable<Sale> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final SyncStatus syncStatus;
  final String? remoteId;
  final bool isDeleted;
  final String invoiceNumber;
  final String? customerId;
  final String customerName;
  final String? customerPan;
  final String? customerPhone;
  final DateTime invoiceDate;
  final int subtotalPaisa;
  final int discountPaisa;
  final int taxablePaisa;
  final int vatPaisa;
  final int totalPaisa;
  final int tenderedPaisa;
  final int changePaisa;
  final String paymentMode;
  final String? notes;
  final String status;
  final bool isVoided;
  const Sale(
      {required this.id,
      required this.createdAt,
      required this.updatedAt,
      required this.syncStatus,
      this.remoteId,
      required this.isDeleted,
      required this.invoiceNumber,
      this.customerId,
      required this.customerName,
      this.customerPan,
      this.customerPhone,
      required this.invoiceDate,
      required this.subtotalPaisa,
      required this.discountPaisa,
      required this.taxablePaisa,
      required this.vatPaisa,
      required this.totalPaisa,
      required this.tenderedPaisa,
      required this.changePaisa,
      required this.paymentMode,
      this.notes,
      required this.status,
      required this.isVoided});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    {
      map['sync_status'] =
          Variable<String>($SalesTable.$convertersyncStatus.toSql(syncStatus));
    }
    if (!nullToAbsent || remoteId != null) {
      map['remote_id'] = Variable<String>(remoteId);
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['invoice_number'] = Variable<String>(invoiceNumber);
    if (!nullToAbsent || customerId != null) {
      map['customer_id'] = Variable<String>(customerId);
    }
    map['customer_name'] = Variable<String>(customerName);
    if (!nullToAbsent || customerPan != null) {
      map['customer_pan'] = Variable<String>(customerPan);
    }
    if (!nullToAbsent || customerPhone != null) {
      map['customer_phone'] = Variable<String>(customerPhone);
    }
    map['invoice_date'] = Variable<DateTime>(invoiceDate);
    map['subtotal_paisa'] = Variable<int>(subtotalPaisa);
    map['discount_paisa'] = Variable<int>(discountPaisa);
    map['taxable_paisa'] = Variable<int>(taxablePaisa);
    map['vat_paisa'] = Variable<int>(vatPaisa);
    map['total_paisa'] = Variable<int>(totalPaisa);
    map['tendered_paisa'] = Variable<int>(tenderedPaisa);
    map['change_paisa'] = Variable<int>(changePaisa);
    map['payment_mode'] = Variable<String>(paymentMode);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['status'] = Variable<String>(status);
    map['is_voided'] = Variable<bool>(isVoided);
    return map;
  }

  SalesCompanion toCompanion(bool nullToAbsent) {
    return SalesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncStatus: Value(syncStatus),
      remoteId: remoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteId),
      isDeleted: Value(isDeleted),
      invoiceNumber: Value(invoiceNumber),
      customerId: customerId == null && nullToAbsent
          ? const Value.absent()
          : Value(customerId),
      customerName: Value(customerName),
      customerPan: customerPan == null && nullToAbsent
          ? const Value.absent()
          : Value(customerPan),
      customerPhone: customerPhone == null && nullToAbsent
          ? const Value.absent()
          : Value(customerPhone),
      invoiceDate: Value(invoiceDate),
      subtotalPaisa: Value(subtotalPaisa),
      discountPaisa: Value(discountPaisa),
      taxablePaisa: Value(taxablePaisa),
      vatPaisa: Value(vatPaisa),
      totalPaisa: Value(totalPaisa),
      tenderedPaisa: Value(tenderedPaisa),
      changePaisa: Value(changePaisa),
      paymentMode: Value(paymentMode),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      status: Value(status),
      isVoided: Value(isVoided),
    );
  }

  factory Sale.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Sale(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncStatus: $SalesTable.$convertersyncStatus
          .fromJson(serializer.fromJson<String>(json['syncStatus'])),
      remoteId: serializer.fromJson<String?>(json['remoteId']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      invoiceNumber: serializer.fromJson<String>(json['invoiceNumber']),
      customerId: serializer.fromJson<String?>(json['customerId']),
      customerName: serializer.fromJson<String>(json['customerName']),
      customerPan: serializer.fromJson<String?>(json['customerPan']),
      customerPhone: serializer.fromJson<String?>(json['customerPhone']),
      invoiceDate: serializer.fromJson<DateTime>(json['invoiceDate']),
      subtotalPaisa: serializer.fromJson<int>(json['subtotalPaisa']),
      discountPaisa: serializer.fromJson<int>(json['discountPaisa']),
      taxablePaisa: serializer.fromJson<int>(json['taxablePaisa']),
      vatPaisa: serializer.fromJson<int>(json['vatPaisa']),
      totalPaisa: serializer.fromJson<int>(json['totalPaisa']),
      tenderedPaisa: serializer.fromJson<int>(json['tenderedPaisa']),
      changePaisa: serializer.fromJson<int>(json['changePaisa']),
      paymentMode: serializer.fromJson<String>(json['paymentMode']),
      notes: serializer.fromJson<String?>(json['notes']),
      status: serializer.fromJson<String>(json['status']),
      isVoided: serializer.fromJson<bool>(json['isVoided']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncStatus': serializer
          .toJson<String>($SalesTable.$convertersyncStatus.toJson(syncStatus)),
      'remoteId': serializer.toJson<String?>(remoteId),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'invoiceNumber': serializer.toJson<String>(invoiceNumber),
      'customerId': serializer.toJson<String?>(customerId),
      'customerName': serializer.toJson<String>(customerName),
      'customerPan': serializer.toJson<String?>(customerPan),
      'customerPhone': serializer.toJson<String?>(customerPhone),
      'invoiceDate': serializer.toJson<DateTime>(invoiceDate),
      'subtotalPaisa': serializer.toJson<int>(subtotalPaisa),
      'discountPaisa': serializer.toJson<int>(discountPaisa),
      'taxablePaisa': serializer.toJson<int>(taxablePaisa),
      'vatPaisa': serializer.toJson<int>(vatPaisa),
      'totalPaisa': serializer.toJson<int>(totalPaisa),
      'tenderedPaisa': serializer.toJson<int>(tenderedPaisa),
      'changePaisa': serializer.toJson<int>(changePaisa),
      'paymentMode': serializer.toJson<String>(paymentMode),
      'notes': serializer.toJson<String?>(notes),
      'status': serializer.toJson<String>(status),
      'isVoided': serializer.toJson<bool>(isVoided),
    };
  }

  Sale copyWith(
          {String? id,
          DateTime? createdAt,
          DateTime? updatedAt,
          SyncStatus? syncStatus,
          Value<String?> remoteId = const Value.absent(),
          bool? isDeleted,
          String? invoiceNumber,
          Value<String?> customerId = const Value.absent(),
          String? customerName,
          Value<String?> customerPan = const Value.absent(),
          Value<String?> customerPhone = const Value.absent(),
          DateTime? invoiceDate,
          int? subtotalPaisa,
          int? discountPaisa,
          int? taxablePaisa,
          int? vatPaisa,
          int? totalPaisa,
          int? tenderedPaisa,
          int? changePaisa,
          String? paymentMode,
          Value<String?> notes = const Value.absent(),
          String? status,
          bool? isVoided}) =>
      Sale(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        syncStatus: syncStatus ?? this.syncStatus,
        remoteId: remoteId.present ? remoteId.value : this.remoteId,
        isDeleted: isDeleted ?? this.isDeleted,
        invoiceNumber: invoiceNumber ?? this.invoiceNumber,
        customerId: customerId.present ? customerId.value : this.customerId,
        customerName: customerName ?? this.customerName,
        customerPan: customerPan.present ? customerPan.value : this.customerPan,
        customerPhone:
            customerPhone.present ? customerPhone.value : this.customerPhone,
        invoiceDate: invoiceDate ?? this.invoiceDate,
        subtotalPaisa: subtotalPaisa ?? this.subtotalPaisa,
        discountPaisa: discountPaisa ?? this.discountPaisa,
        taxablePaisa: taxablePaisa ?? this.taxablePaisa,
        vatPaisa: vatPaisa ?? this.vatPaisa,
        totalPaisa: totalPaisa ?? this.totalPaisa,
        tenderedPaisa: tenderedPaisa ?? this.tenderedPaisa,
        changePaisa: changePaisa ?? this.changePaisa,
        paymentMode: paymentMode ?? this.paymentMode,
        notes: notes.present ? notes.value : this.notes,
        status: status ?? this.status,
        isVoided: isVoided ?? this.isVoided,
      );
  Sale copyWithCompanion(SalesCompanion data) {
    return Sale(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      invoiceNumber: data.invoiceNumber.present
          ? data.invoiceNumber.value
          : this.invoiceNumber,
      customerId:
          data.customerId.present ? data.customerId.value : this.customerId,
      customerName: data.customerName.present
          ? data.customerName.value
          : this.customerName,
      customerPan:
          data.customerPan.present ? data.customerPan.value : this.customerPan,
      customerPhone: data.customerPhone.present
          ? data.customerPhone.value
          : this.customerPhone,
      invoiceDate:
          data.invoiceDate.present ? data.invoiceDate.value : this.invoiceDate,
      subtotalPaisa: data.subtotalPaisa.present
          ? data.subtotalPaisa.value
          : this.subtotalPaisa,
      discountPaisa: data.discountPaisa.present
          ? data.discountPaisa.value
          : this.discountPaisa,
      taxablePaisa: data.taxablePaisa.present
          ? data.taxablePaisa.value
          : this.taxablePaisa,
      vatPaisa: data.vatPaisa.present ? data.vatPaisa.value : this.vatPaisa,
      totalPaisa:
          data.totalPaisa.present ? data.totalPaisa.value : this.totalPaisa,
      tenderedPaisa: data.tenderedPaisa.present
          ? data.tenderedPaisa.value
          : this.tenderedPaisa,
      changePaisa:
          data.changePaisa.present ? data.changePaisa.value : this.changePaisa,
      paymentMode:
          data.paymentMode.present ? data.paymentMode.value : this.paymentMode,
      notes: data.notes.present ? data.notes.value : this.notes,
      status: data.status.present ? data.status.value : this.status,
      isVoided: data.isVoided.present ? data.isVoided.value : this.isVoided,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Sale(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('remoteId: $remoteId, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('invoiceNumber: $invoiceNumber, ')
          ..write('customerId: $customerId, ')
          ..write('customerName: $customerName, ')
          ..write('customerPan: $customerPan, ')
          ..write('customerPhone: $customerPhone, ')
          ..write('invoiceDate: $invoiceDate, ')
          ..write('subtotalPaisa: $subtotalPaisa, ')
          ..write('discountPaisa: $discountPaisa, ')
          ..write('taxablePaisa: $taxablePaisa, ')
          ..write('vatPaisa: $vatPaisa, ')
          ..write('totalPaisa: $totalPaisa, ')
          ..write('tenderedPaisa: $tenderedPaisa, ')
          ..write('changePaisa: $changePaisa, ')
          ..write('paymentMode: $paymentMode, ')
          ..write('notes: $notes, ')
          ..write('status: $status, ')
          ..write('isVoided: $isVoided')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        createdAt,
        updatedAt,
        syncStatus,
        remoteId,
        isDeleted,
        invoiceNumber,
        customerId,
        customerName,
        customerPan,
        customerPhone,
        invoiceDate,
        subtotalPaisa,
        discountPaisa,
        taxablePaisa,
        vatPaisa,
        totalPaisa,
        tenderedPaisa,
        changePaisa,
        paymentMode,
        notes,
        status,
        isVoided
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Sale &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus &&
          other.remoteId == this.remoteId &&
          other.isDeleted == this.isDeleted &&
          other.invoiceNumber == this.invoiceNumber &&
          other.customerId == this.customerId &&
          other.customerName == this.customerName &&
          other.customerPan == this.customerPan &&
          other.customerPhone == this.customerPhone &&
          other.invoiceDate == this.invoiceDate &&
          other.subtotalPaisa == this.subtotalPaisa &&
          other.discountPaisa == this.discountPaisa &&
          other.taxablePaisa == this.taxablePaisa &&
          other.vatPaisa == this.vatPaisa &&
          other.totalPaisa == this.totalPaisa &&
          other.tenderedPaisa == this.tenderedPaisa &&
          other.changePaisa == this.changePaisa &&
          other.paymentMode == this.paymentMode &&
          other.notes == this.notes &&
          other.status == this.status &&
          other.isVoided == this.isVoided);
}

class SalesCompanion extends UpdateCompanion<Sale> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<SyncStatus> syncStatus;
  final Value<String?> remoteId;
  final Value<bool> isDeleted;
  final Value<String> invoiceNumber;
  final Value<String?> customerId;
  final Value<String> customerName;
  final Value<String?> customerPan;
  final Value<String?> customerPhone;
  final Value<DateTime> invoiceDate;
  final Value<int> subtotalPaisa;
  final Value<int> discountPaisa;
  final Value<int> taxablePaisa;
  final Value<int> vatPaisa;
  final Value<int> totalPaisa;
  final Value<int> tenderedPaisa;
  final Value<int> changePaisa;
  final Value<String> paymentMode;
  final Value<String?> notes;
  final Value<String> status;
  final Value<bool> isVoided;
  final Value<int> rowid;
  const SalesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.invoiceNumber = const Value.absent(),
    this.customerId = const Value.absent(),
    this.customerName = const Value.absent(),
    this.customerPan = const Value.absent(),
    this.customerPhone = const Value.absent(),
    this.invoiceDate = const Value.absent(),
    this.subtotalPaisa = const Value.absent(),
    this.discountPaisa = const Value.absent(),
    this.taxablePaisa = const Value.absent(),
    this.vatPaisa = const Value.absent(),
    this.totalPaisa = const Value.absent(),
    this.tenderedPaisa = const Value.absent(),
    this.changePaisa = const Value.absent(),
    this.paymentMode = const Value.absent(),
    this.notes = const Value.absent(),
    this.status = const Value.absent(),
    this.isVoided = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SalesCompanion.insert({
    required String id,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.isDeleted = const Value.absent(),
    required String invoiceNumber,
    this.customerId = const Value.absent(),
    this.customerName = const Value.absent(),
    this.customerPan = const Value.absent(),
    this.customerPhone = const Value.absent(),
    this.invoiceDate = const Value.absent(),
    required int subtotalPaisa,
    this.discountPaisa = const Value.absent(),
    required int taxablePaisa,
    this.vatPaisa = const Value.absent(),
    required int totalPaisa,
    this.tenderedPaisa = const Value.absent(),
    this.changePaisa = const Value.absent(),
    this.paymentMode = const Value.absent(),
    this.notes = const Value.absent(),
    this.status = const Value.absent(),
    this.isVoided = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        invoiceNumber = Value(invoiceNumber),
        subtotalPaisa = Value(subtotalPaisa),
        taxablePaisa = Value(taxablePaisa),
        totalPaisa = Value(totalPaisa);
  static Insertable<Sale> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncStatus,
    Expression<String>? remoteId,
    Expression<bool>? isDeleted,
    Expression<String>? invoiceNumber,
    Expression<String>? customerId,
    Expression<String>? customerName,
    Expression<String>? customerPan,
    Expression<String>? customerPhone,
    Expression<DateTime>? invoiceDate,
    Expression<int>? subtotalPaisa,
    Expression<int>? discountPaisa,
    Expression<int>? taxablePaisa,
    Expression<int>? vatPaisa,
    Expression<int>? totalPaisa,
    Expression<int>? tenderedPaisa,
    Expression<int>? changePaisa,
    Expression<String>? paymentMode,
    Expression<String>? notes,
    Expression<String>? status,
    Expression<bool>? isVoided,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (remoteId != null) 'remote_id': remoteId,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (invoiceNumber != null) 'invoice_number': invoiceNumber,
      if (customerId != null) 'customer_id': customerId,
      if (customerName != null) 'customer_name': customerName,
      if (customerPan != null) 'customer_pan': customerPan,
      if (customerPhone != null) 'customer_phone': customerPhone,
      if (invoiceDate != null) 'invoice_date': invoiceDate,
      if (subtotalPaisa != null) 'subtotal_paisa': subtotalPaisa,
      if (discountPaisa != null) 'discount_paisa': discountPaisa,
      if (taxablePaisa != null) 'taxable_paisa': taxablePaisa,
      if (vatPaisa != null) 'vat_paisa': vatPaisa,
      if (totalPaisa != null) 'total_paisa': totalPaisa,
      if (tenderedPaisa != null) 'tendered_paisa': tenderedPaisa,
      if (changePaisa != null) 'change_paisa': changePaisa,
      if (paymentMode != null) 'payment_mode': paymentMode,
      if (notes != null) 'notes': notes,
      if (status != null) 'status': status,
      if (isVoided != null) 'is_voided': isVoided,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SalesCompanion copyWith(
      {Value<String>? id,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<SyncStatus>? syncStatus,
      Value<String?>? remoteId,
      Value<bool>? isDeleted,
      Value<String>? invoiceNumber,
      Value<String?>? customerId,
      Value<String>? customerName,
      Value<String?>? customerPan,
      Value<String?>? customerPhone,
      Value<DateTime>? invoiceDate,
      Value<int>? subtotalPaisa,
      Value<int>? discountPaisa,
      Value<int>? taxablePaisa,
      Value<int>? vatPaisa,
      Value<int>? totalPaisa,
      Value<int>? tenderedPaisa,
      Value<int>? changePaisa,
      Value<String>? paymentMode,
      Value<String?>? notes,
      Value<String>? status,
      Value<bool>? isVoided,
      Value<int>? rowid}) {
    return SalesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      remoteId: remoteId ?? this.remoteId,
      isDeleted: isDeleted ?? this.isDeleted,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      customerPan: customerPan ?? this.customerPan,
      customerPhone: customerPhone ?? this.customerPhone,
      invoiceDate: invoiceDate ?? this.invoiceDate,
      subtotalPaisa: subtotalPaisa ?? this.subtotalPaisa,
      discountPaisa: discountPaisa ?? this.discountPaisa,
      taxablePaisa: taxablePaisa ?? this.taxablePaisa,
      vatPaisa: vatPaisa ?? this.vatPaisa,
      totalPaisa: totalPaisa ?? this.totalPaisa,
      tenderedPaisa: tenderedPaisa ?? this.tenderedPaisa,
      changePaisa: changePaisa ?? this.changePaisa,
      paymentMode: paymentMode ?? this.paymentMode,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      isVoided: isVoided ?? this.isVoided,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(
          $SalesTable.$convertersyncStatus.toSql(syncStatus.value));
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (invoiceNumber.present) {
      map['invoice_number'] = Variable<String>(invoiceNumber.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<String>(customerId.value);
    }
    if (customerName.present) {
      map['customer_name'] = Variable<String>(customerName.value);
    }
    if (customerPan.present) {
      map['customer_pan'] = Variable<String>(customerPan.value);
    }
    if (customerPhone.present) {
      map['customer_phone'] = Variable<String>(customerPhone.value);
    }
    if (invoiceDate.present) {
      map['invoice_date'] = Variable<DateTime>(invoiceDate.value);
    }
    if (subtotalPaisa.present) {
      map['subtotal_paisa'] = Variable<int>(subtotalPaisa.value);
    }
    if (discountPaisa.present) {
      map['discount_paisa'] = Variable<int>(discountPaisa.value);
    }
    if (taxablePaisa.present) {
      map['taxable_paisa'] = Variable<int>(taxablePaisa.value);
    }
    if (vatPaisa.present) {
      map['vat_paisa'] = Variable<int>(vatPaisa.value);
    }
    if (totalPaisa.present) {
      map['total_paisa'] = Variable<int>(totalPaisa.value);
    }
    if (tenderedPaisa.present) {
      map['tendered_paisa'] = Variable<int>(tenderedPaisa.value);
    }
    if (changePaisa.present) {
      map['change_paisa'] = Variable<int>(changePaisa.value);
    }
    if (paymentMode.present) {
      map['payment_mode'] = Variable<String>(paymentMode.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (isVoided.present) {
      map['is_voided'] = Variable<bool>(isVoided.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SalesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('remoteId: $remoteId, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('invoiceNumber: $invoiceNumber, ')
          ..write('customerId: $customerId, ')
          ..write('customerName: $customerName, ')
          ..write('customerPan: $customerPan, ')
          ..write('customerPhone: $customerPhone, ')
          ..write('invoiceDate: $invoiceDate, ')
          ..write('subtotalPaisa: $subtotalPaisa, ')
          ..write('discountPaisa: $discountPaisa, ')
          ..write('taxablePaisa: $taxablePaisa, ')
          ..write('vatPaisa: $vatPaisa, ')
          ..write('totalPaisa: $totalPaisa, ')
          ..write('tenderedPaisa: $tenderedPaisa, ')
          ..write('changePaisa: $changePaisa, ')
          ..write('paymentMode: $paymentMode, ')
          ..write('notes: $notes, ')
          ..write('status: $status, ')
          ..write('isVoided: $isVoided, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SaleItemsTable extends SaleItems
    with TableInfo<$SaleItemsTable, SaleItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SaleItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumnWithTypeConverter<SyncStatus, String> syncStatus =
      GeneratedColumn<String>('sync_status', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: Constant(SyncStatus.pending.name))
          .withConverter<SyncStatus>($SaleItemsTable.$convertersyncStatus);
  static const VerificationMeta _remoteIdMeta =
      const VerificationMeta('remoteId');
  @override
  late final GeneratedColumn<String> remoteId = GeneratedColumn<String>(
      'remote_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _saleIdMeta = const VerificationMeta('saleId');
  @override
  late final GeneratedColumn<String> saleId = GeneratedColumn<String>(
      'sale_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
      'item_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _itemNameMeta =
      const VerificationMeta('itemName');
  @override
  late final GeneratedColumn<String> itemName = GeneratedColumn<String>(
      'item_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pcs'));
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
      'quantity', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _ratePaisaMeta =
      const VerificationMeta('ratePaisa');
  @override
  late final GeneratedColumn<int> ratePaisa = GeneratedColumn<int>(
      'rate_paisa', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _discountPaisaMeta =
      const VerificationMeta('discountPaisa');
  @override
  late final GeneratedColumn<int> discountPaisa = GeneratedColumn<int>(
      'discount_paisa', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _taxablePaisaMeta =
      const VerificationMeta('taxablePaisa');
  @override
  late final GeneratedColumn<int> taxablePaisa = GeneratedColumn<int>(
      'taxable_paisa', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _vatPaisaMeta =
      const VerificationMeta('vatPaisa');
  @override
  late final GeneratedColumn<int> vatPaisa = GeneratedColumn<int>(
      'vat_paisa', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lineTotalPaisaMeta =
      const VerificationMeta('lineTotalPaisa');
  @override
  late final GeneratedColumn<int> lineTotalPaisa = GeneratedColumn<int>(
      'line_total_paisa', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        createdAt,
        updatedAt,
        syncStatus,
        remoteId,
        isDeleted,
        saleId,
        itemId,
        itemName,
        unit,
        quantity,
        ratePaisa,
        discountPaisa,
        taxablePaisa,
        vatPaisa,
        lineTotalPaisa
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sale_items';
  @override
  VerificationContext validateIntegrity(Insertable<SaleItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    context.handle(_syncStatusMeta, const VerificationResult.success());
    if (data.containsKey('remote_id')) {
      context.handle(_remoteIdMeta,
          remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    if (data.containsKey('sale_id')) {
      context.handle(_saleIdMeta,
          saleId.isAcceptableOrUnknown(data['sale_id']!, _saleIdMeta));
    } else if (isInserting) {
      context.missing(_saleIdMeta);
    }
    if (data.containsKey('item_id')) {
      context.handle(_itemIdMeta,
          itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta));
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('item_name')) {
      context.handle(_itemNameMeta,
          itemName.isAcceptableOrUnknown(data['item_name']!, _itemNameMeta));
    } else if (isInserting) {
      context.missing(_itemNameMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('rate_paisa')) {
      context.handle(_ratePaisaMeta,
          ratePaisa.isAcceptableOrUnknown(data['rate_paisa']!, _ratePaisaMeta));
    } else if (isInserting) {
      context.missing(_ratePaisaMeta);
    }
    if (data.containsKey('discount_paisa')) {
      context.handle(
          _discountPaisaMeta,
          discountPaisa.isAcceptableOrUnknown(
              data['discount_paisa']!, _discountPaisaMeta));
    }
    if (data.containsKey('taxable_paisa')) {
      context.handle(
          _taxablePaisaMeta,
          taxablePaisa.isAcceptableOrUnknown(
              data['taxable_paisa']!, _taxablePaisaMeta));
    } else if (isInserting) {
      context.missing(_taxablePaisaMeta);
    }
    if (data.containsKey('vat_paisa')) {
      context.handle(_vatPaisaMeta,
          vatPaisa.isAcceptableOrUnknown(data['vat_paisa']!, _vatPaisaMeta));
    }
    if (data.containsKey('line_total_paisa')) {
      context.handle(
          _lineTotalPaisaMeta,
          lineTotalPaisa.isAcceptableOrUnknown(
              data['line_total_paisa']!, _lineTotalPaisaMeta));
    } else if (isInserting) {
      context.missing(_lineTotalPaisaMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SaleItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SaleItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      syncStatus: $SaleItemsTable.$convertersyncStatus.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!),
      remoteId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}remote_id']),
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
      saleId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sale_id'])!,
      itemId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}item_id'])!,
      itemName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}item_name'])!,
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}quantity'])!,
      ratePaisa: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}rate_paisa'])!,
      discountPaisa: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}discount_paisa'])!,
      taxablePaisa: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}taxable_paisa'])!,
      vatPaisa: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}vat_paisa'])!,
      lineTotalPaisa: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}line_total_paisa'])!,
    );
  }

  @override
  $SaleItemsTable createAlias(String alias) {
    return $SaleItemsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SyncStatus, String, String> $convertersyncStatus =
      const EnumNameConverter<SyncStatus>(SyncStatus.values);
}

class SaleItem extends DataClass implements Insertable<SaleItem> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final SyncStatus syncStatus;
  final String? remoteId;
  final bool isDeleted;
  final String saleId;
  final String itemId;
  final String itemName;
  final String unit;
  final double quantity;
  final int ratePaisa;
  final int discountPaisa;
  final int taxablePaisa;
  final int vatPaisa;
  final int lineTotalPaisa;
  const SaleItem(
      {required this.id,
      required this.createdAt,
      required this.updatedAt,
      required this.syncStatus,
      this.remoteId,
      required this.isDeleted,
      required this.saleId,
      required this.itemId,
      required this.itemName,
      required this.unit,
      required this.quantity,
      required this.ratePaisa,
      required this.discountPaisa,
      required this.taxablePaisa,
      required this.vatPaisa,
      required this.lineTotalPaisa});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    {
      map['sync_status'] = Variable<String>(
          $SaleItemsTable.$convertersyncStatus.toSql(syncStatus));
    }
    if (!nullToAbsent || remoteId != null) {
      map['remote_id'] = Variable<String>(remoteId);
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['sale_id'] = Variable<String>(saleId);
    map['item_id'] = Variable<String>(itemId);
    map['item_name'] = Variable<String>(itemName);
    map['unit'] = Variable<String>(unit);
    map['quantity'] = Variable<double>(quantity);
    map['rate_paisa'] = Variable<int>(ratePaisa);
    map['discount_paisa'] = Variable<int>(discountPaisa);
    map['taxable_paisa'] = Variable<int>(taxablePaisa);
    map['vat_paisa'] = Variable<int>(vatPaisa);
    map['line_total_paisa'] = Variable<int>(lineTotalPaisa);
    return map;
  }

  SaleItemsCompanion toCompanion(bool nullToAbsent) {
    return SaleItemsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncStatus: Value(syncStatus),
      remoteId: remoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteId),
      isDeleted: Value(isDeleted),
      saleId: Value(saleId),
      itemId: Value(itemId),
      itemName: Value(itemName),
      unit: Value(unit),
      quantity: Value(quantity),
      ratePaisa: Value(ratePaisa),
      discountPaisa: Value(discountPaisa),
      taxablePaisa: Value(taxablePaisa),
      vatPaisa: Value(vatPaisa),
      lineTotalPaisa: Value(lineTotalPaisa),
    );
  }

  factory SaleItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SaleItem(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncStatus: $SaleItemsTable.$convertersyncStatus
          .fromJson(serializer.fromJson<String>(json['syncStatus'])),
      remoteId: serializer.fromJson<String?>(json['remoteId']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      saleId: serializer.fromJson<String>(json['saleId']),
      itemId: serializer.fromJson<String>(json['itemId']),
      itemName: serializer.fromJson<String>(json['itemName']),
      unit: serializer.fromJson<String>(json['unit']),
      quantity: serializer.fromJson<double>(json['quantity']),
      ratePaisa: serializer.fromJson<int>(json['ratePaisa']),
      discountPaisa: serializer.fromJson<int>(json['discountPaisa']),
      taxablePaisa: serializer.fromJson<int>(json['taxablePaisa']),
      vatPaisa: serializer.fromJson<int>(json['vatPaisa']),
      lineTotalPaisa: serializer.fromJson<int>(json['lineTotalPaisa']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncStatus': serializer.toJson<String>(
          $SaleItemsTable.$convertersyncStatus.toJson(syncStatus)),
      'remoteId': serializer.toJson<String?>(remoteId),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'saleId': serializer.toJson<String>(saleId),
      'itemId': serializer.toJson<String>(itemId),
      'itemName': serializer.toJson<String>(itemName),
      'unit': serializer.toJson<String>(unit),
      'quantity': serializer.toJson<double>(quantity),
      'ratePaisa': serializer.toJson<int>(ratePaisa),
      'discountPaisa': serializer.toJson<int>(discountPaisa),
      'taxablePaisa': serializer.toJson<int>(taxablePaisa),
      'vatPaisa': serializer.toJson<int>(vatPaisa),
      'lineTotalPaisa': serializer.toJson<int>(lineTotalPaisa),
    };
  }

  SaleItem copyWith(
          {String? id,
          DateTime? createdAt,
          DateTime? updatedAt,
          SyncStatus? syncStatus,
          Value<String?> remoteId = const Value.absent(),
          bool? isDeleted,
          String? saleId,
          String? itemId,
          String? itemName,
          String? unit,
          double? quantity,
          int? ratePaisa,
          int? discountPaisa,
          int? taxablePaisa,
          int? vatPaisa,
          int? lineTotalPaisa}) =>
      SaleItem(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        syncStatus: syncStatus ?? this.syncStatus,
        remoteId: remoteId.present ? remoteId.value : this.remoteId,
        isDeleted: isDeleted ?? this.isDeleted,
        saleId: saleId ?? this.saleId,
        itemId: itemId ?? this.itemId,
        itemName: itemName ?? this.itemName,
        unit: unit ?? this.unit,
        quantity: quantity ?? this.quantity,
        ratePaisa: ratePaisa ?? this.ratePaisa,
        discountPaisa: discountPaisa ?? this.discountPaisa,
        taxablePaisa: taxablePaisa ?? this.taxablePaisa,
        vatPaisa: vatPaisa ?? this.vatPaisa,
        lineTotalPaisa: lineTotalPaisa ?? this.lineTotalPaisa,
      );
  SaleItem copyWithCompanion(SaleItemsCompanion data) {
    return SaleItem(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      saleId: data.saleId.present ? data.saleId.value : this.saleId,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      itemName: data.itemName.present ? data.itemName.value : this.itemName,
      unit: data.unit.present ? data.unit.value : this.unit,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      ratePaisa: data.ratePaisa.present ? data.ratePaisa.value : this.ratePaisa,
      discountPaisa: data.discountPaisa.present
          ? data.discountPaisa.value
          : this.discountPaisa,
      taxablePaisa: data.taxablePaisa.present
          ? data.taxablePaisa.value
          : this.taxablePaisa,
      vatPaisa: data.vatPaisa.present ? data.vatPaisa.value : this.vatPaisa,
      lineTotalPaisa: data.lineTotalPaisa.present
          ? data.lineTotalPaisa.value
          : this.lineTotalPaisa,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SaleItem(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('remoteId: $remoteId, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('saleId: $saleId, ')
          ..write('itemId: $itemId, ')
          ..write('itemName: $itemName, ')
          ..write('unit: $unit, ')
          ..write('quantity: $quantity, ')
          ..write('ratePaisa: $ratePaisa, ')
          ..write('discountPaisa: $discountPaisa, ')
          ..write('taxablePaisa: $taxablePaisa, ')
          ..write('vatPaisa: $vatPaisa, ')
          ..write('lineTotalPaisa: $lineTotalPaisa')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      createdAt,
      updatedAt,
      syncStatus,
      remoteId,
      isDeleted,
      saleId,
      itemId,
      itemName,
      unit,
      quantity,
      ratePaisa,
      discountPaisa,
      taxablePaisa,
      vatPaisa,
      lineTotalPaisa);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SaleItem &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus &&
          other.remoteId == this.remoteId &&
          other.isDeleted == this.isDeleted &&
          other.saleId == this.saleId &&
          other.itemId == this.itemId &&
          other.itemName == this.itemName &&
          other.unit == this.unit &&
          other.quantity == this.quantity &&
          other.ratePaisa == this.ratePaisa &&
          other.discountPaisa == this.discountPaisa &&
          other.taxablePaisa == this.taxablePaisa &&
          other.vatPaisa == this.vatPaisa &&
          other.lineTotalPaisa == this.lineTotalPaisa);
}

class SaleItemsCompanion extends UpdateCompanion<SaleItem> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<SyncStatus> syncStatus;
  final Value<String?> remoteId;
  final Value<bool> isDeleted;
  final Value<String> saleId;
  final Value<String> itemId;
  final Value<String> itemName;
  final Value<String> unit;
  final Value<double> quantity;
  final Value<int> ratePaisa;
  final Value<int> discountPaisa;
  final Value<int> taxablePaisa;
  final Value<int> vatPaisa;
  final Value<int> lineTotalPaisa;
  final Value<int> rowid;
  const SaleItemsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.saleId = const Value.absent(),
    this.itemId = const Value.absent(),
    this.itemName = const Value.absent(),
    this.unit = const Value.absent(),
    this.quantity = const Value.absent(),
    this.ratePaisa = const Value.absent(),
    this.discountPaisa = const Value.absent(),
    this.taxablePaisa = const Value.absent(),
    this.vatPaisa = const Value.absent(),
    this.lineTotalPaisa = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SaleItemsCompanion.insert({
    required String id,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.isDeleted = const Value.absent(),
    required String saleId,
    required String itemId,
    required String itemName,
    this.unit = const Value.absent(),
    required double quantity,
    required int ratePaisa,
    this.discountPaisa = const Value.absent(),
    required int taxablePaisa,
    this.vatPaisa = const Value.absent(),
    required int lineTotalPaisa,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        saleId = Value(saleId),
        itemId = Value(itemId),
        itemName = Value(itemName),
        quantity = Value(quantity),
        ratePaisa = Value(ratePaisa),
        taxablePaisa = Value(taxablePaisa),
        lineTotalPaisa = Value(lineTotalPaisa);
  static Insertable<SaleItem> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncStatus,
    Expression<String>? remoteId,
    Expression<bool>? isDeleted,
    Expression<String>? saleId,
    Expression<String>? itemId,
    Expression<String>? itemName,
    Expression<String>? unit,
    Expression<double>? quantity,
    Expression<int>? ratePaisa,
    Expression<int>? discountPaisa,
    Expression<int>? taxablePaisa,
    Expression<int>? vatPaisa,
    Expression<int>? lineTotalPaisa,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (remoteId != null) 'remote_id': remoteId,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (saleId != null) 'sale_id': saleId,
      if (itemId != null) 'item_id': itemId,
      if (itemName != null) 'item_name': itemName,
      if (unit != null) 'unit': unit,
      if (quantity != null) 'quantity': quantity,
      if (ratePaisa != null) 'rate_paisa': ratePaisa,
      if (discountPaisa != null) 'discount_paisa': discountPaisa,
      if (taxablePaisa != null) 'taxable_paisa': taxablePaisa,
      if (vatPaisa != null) 'vat_paisa': vatPaisa,
      if (lineTotalPaisa != null) 'line_total_paisa': lineTotalPaisa,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SaleItemsCompanion copyWith(
      {Value<String>? id,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<SyncStatus>? syncStatus,
      Value<String?>? remoteId,
      Value<bool>? isDeleted,
      Value<String>? saleId,
      Value<String>? itemId,
      Value<String>? itemName,
      Value<String>? unit,
      Value<double>? quantity,
      Value<int>? ratePaisa,
      Value<int>? discountPaisa,
      Value<int>? taxablePaisa,
      Value<int>? vatPaisa,
      Value<int>? lineTotalPaisa,
      Value<int>? rowid}) {
    return SaleItemsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      remoteId: remoteId ?? this.remoteId,
      isDeleted: isDeleted ?? this.isDeleted,
      saleId: saleId ?? this.saleId,
      itemId: itemId ?? this.itemId,
      itemName: itemName ?? this.itemName,
      unit: unit ?? this.unit,
      quantity: quantity ?? this.quantity,
      ratePaisa: ratePaisa ?? this.ratePaisa,
      discountPaisa: discountPaisa ?? this.discountPaisa,
      taxablePaisa: taxablePaisa ?? this.taxablePaisa,
      vatPaisa: vatPaisa ?? this.vatPaisa,
      lineTotalPaisa: lineTotalPaisa ?? this.lineTotalPaisa,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(
          $SaleItemsTable.$convertersyncStatus.toSql(syncStatus.value));
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (saleId.present) {
      map['sale_id'] = Variable<String>(saleId.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (itemName.present) {
      map['item_name'] = Variable<String>(itemName.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (ratePaisa.present) {
      map['rate_paisa'] = Variable<int>(ratePaisa.value);
    }
    if (discountPaisa.present) {
      map['discount_paisa'] = Variable<int>(discountPaisa.value);
    }
    if (taxablePaisa.present) {
      map['taxable_paisa'] = Variable<int>(taxablePaisa.value);
    }
    if (vatPaisa.present) {
      map['vat_paisa'] = Variable<int>(vatPaisa.value);
    }
    if (lineTotalPaisa.present) {
      map['line_total_paisa'] = Variable<int>(lineTotalPaisa.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SaleItemsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('remoteId: $remoteId, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('saleId: $saleId, ')
          ..write('itemId: $itemId, ')
          ..write('itemName: $itemName, ')
          ..write('unit: $unit, ')
          ..write('quantity: $quantity, ')
          ..write('ratePaisa: $ratePaisa, ')
          ..write('discountPaisa: $discountPaisa, ')
          ..write('taxablePaisa: $taxablePaisa, ')
          ..write('vatPaisa: $vatPaisa, ')
          ..write('lineTotalPaisa: $lineTotalPaisa, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BillMetadataTable extends BillMetadata
    with TableInfo<$BillMetadataTable, BillMetadataData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BillMetadataTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumnWithTypeConverter<SyncStatus, String> syncStatus =
      GeneratedColumn<String>('sync_status', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: Constant(SyncStatus.pending.name))
          .withConverter<SyncStatus>($BillMetadataTable.$convertersyncStatus);
  static const VerificationMeta _remoteIdMeta =
      const VerificationMeta('remoteId');
  @override
  late final GeneratedColumn<String> remoteId = GeneratedColumn<String>(
      'remote_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _saleIdMeta = const VerificationMeta('saleId');
  @override
  late final GeneratedColumn<String> saleId = GeneratedColumn<String>(
      'sale_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _billNumberMeta =
      const VerificationMeta('billNumber');
  @override
  late final GeneratedColumn<String> billNumber = GeneratedColumn<String>(
      'bill_number', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _pdfFilePathMeta =
      const VerificationMeta('pdfFilePath');
  @override
  late final GeneratedColumn<String> pdfFilePath = GeneratedColumn<String>(
      'pdf_file_path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _qrDataMeta = const VerificationMeta('qrData');
  @override
  late final GeneratedColumn<String> qrData = GeneratedColumn<String>(
      'qr_data', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _printCountMeta =
      const VerificationMeta('printCount');
  @override
  late final GeneratedColumn<int> printCount = GeneratedColumn<int>(
      'print_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        createdAt,
        updatedAt,
        syncStatus,
        remoteId,
        isDeleted,
        saleId,
        billNumber,
        pdfFilePath,
        qrData,
        printCount
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bill_metadata';
  @override
  VerificationContext validateIntegrity(Insertable<BillMetadataData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    context.handle(_syncStatusMeta, const VerificationResult.success());
    if (data.containsKey('remote_id')) {
      context.handle(_remoteIdMeta,
          remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    if (data.containsKey('sale_id')) {
      context.handle(_saleIdMeta,
          saleId.isAcceptableOrUnknown(data['sale_id']!, _saleIdMeta));
    } else if (isInserting) {
      context.missing(_saleIdMeta);
    }
    if (data.containsKey('bill_number')) {
      context.handle(
          _billNumberMeta,
          billNumber.isAcceptableOrUnknown(
              data['bill_number']!, _billNumberMeta));
    } else if (isInserting) {
      context.missing(_billNumberMeta);
    }
    if (data.containsKey('pdf_file_path')) {
      context.handle(
          _pdfFilePathMeta,
          pdfFilePath.isAcceptableOrUnknown(
              data['pdf_file_path']!, _pdfFilePathMeta));
    } else if (isInserting) {
      context.missing(_pdfFilePathMeta);
    }
    if (data.containsKey('qr_data')) {
      context.handle(_qrDataMeta,
          qrData.isAcceptableOrUnknown(data['qr_data']!, _qrDataMeta));
    } else if (isInserting) {
      context.missing(_qrDataMeta);
    }
    if (data.containsKey('print_count')) {
      context.handle(
          _printCountMeta,
          printCount.isAcceptableOrUnknown(
              data['print_count']!, _printCountMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BillMetadataData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BillMetadataData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      syncStatus: $BillMetadataTable.$convertersyncStatus.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}sync_status'])!),
      remoteId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}remote_id']),
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
      saleId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sale_id'])!,
      billNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bill_number'])!,
      pdfFilePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pdf_file_path'])!,
      qrData: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}qr_data'])!,
      printCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}print_count'])!,
    );
  }

  @override
  $BillMetadataTable createAlias(String alias) {
    return $BillMetadataTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SyncStatus, String, String> $convertersyncStatus =
      const EnumNameConverter<SyncStatus>(SyncStatus.values);
}

class BillMetadataData extends DataClass
    implements Insertable<BillMetadataData> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final SyncStatus syncStatus;
  final String? remoteId;
  final bool isDeleted;
  final String saleId;
  final String billNumber;
  final String pdfFilePath;
  final String qrData;
  final int printCount;
  const BillMetadataData(
      {required this.id,
      required this.createdAt,
      required this.updatedAt,
      required this.syncStatus,
      this.remoteId,
      required this.isDeleted,
      required this.saleId,
      required this.billNumber,
      required this.pdfFilePath,
      required this.qrData,
      required this.printCount});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    {
      map['sync_status'] = Variable<String>(
          $BillMetadataTable.$convertersyncStatus.toSql(syncStatus));
    }
    if (!nullToAbsent || remoteId != null) {
      map['remote_id'] = Variable<String>(remoteId);
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['sale_id'] = Variable<String>(saleId);
    map['bill_number'] = Variable<String>(billNumber);
    map['pdf_file_path'] = Variable<String>(pdfFilePath);
    map['qr_data'] = Variable<String>(qrData);
    map['print_count'] = Variable<int>(printCount);
    return map;
  }

  BillMetadataCompanion toCompanion(bool nullToAbsent) {
    return BillMetadataCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncStatus: Value(syncStatus),
      remoteId: remoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteId),
      isDeleted: Value(isDeleted),
      saleId: Value(saleId),
      billNumber: Value(billNumber),
      pdfFilePath: Value(pdfFilePath),
      qrData: Value(qrData),
      printCount: Value(printCount),
    );
  }

  factory BillMetadataData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BillMetadataData(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncStatus: $BillMetadataTable.$convertersyncStatus
          .fromJson(serializer.fromJson<String>(json['syncStatus'])),
      remoteId: serializer.fromJson<String?>(json['remoteId']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      saleId: serializer.fromJson<String>(json['saleId']),
      billNumber: serializer.fromJson<String>(json['billNumber']),
      pdfFilePath: serializer.fromJson<String>(json['pdfFilePath']),
      qrData: serializer.fromJson<String>(json['qrData']),
      printCount: serializer.fromJson<int>(json['printCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncStatus': serializer.toJson<String>(
          $BillMetadataTable.$convertersyncStatus.toJson(syncStatus)),
      'remoteId': serializer.toJson<String?>(remoteId),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'saleId': serializer.toJson<String>(saleId),
      'billNumber': serializer.toJson<String>(billNumber),
      'pdfFilePath': serializer.toJson<String>(pdfFilePath),
      'qrData': serializer.toJson<String>(qrData),
      'printCount': serializer.toJson<int>(printCount),
    };
  }

  BillMetadataData copyWith(
          {String? id,
          DateTime? createdAt,
          DateTime? updatedAt,
          SyncStatus? syncStatus,
          Value<String?> remoteId = const Value.absent(),
          bool? isDeleted,
          String? saleId,
          String? billNumber,
          String? pdfFilePath,
          String? qrData,
          int? printCount}) =>
      BillMetadataData(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        syncStatus: syncStatus ?? this.syncStatus,
        remoteId: remoteId.present ? remoteId.value : this.remoteId,
        isDeleted: isDeleted ?? this.isDeleted,
        saleId: saleId ?? this.saleId,
        billNumber: billNumber ?? this.billNumber,
        pdfFilePath: pdfFilePath ?? this.pdfFilePath,
        qrData: qrData ?? this.qrData,
        printCount: printCount ?? this.printCount,
      );
  BillMetadataData copyWithCompanion(BillMetadataCompanion data) {
    return BillMetadataData(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      saleId: data.saleId.present ? data.saleId.value : this.saleId,
      billNumber:
          data.billNumber.present ? data.billNumber.value : this.billNumber,
      pdfFilePath:
          data.pdfFilePath.present ? data.pdfFilePath.value : this.pdfFilePath,
      qrData: data.qrData.present ? data.qrData.value : this.qrData,
      printCount:
          data.printCount.present ? data.printCount.value : this.printCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BillMetadataData(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('remoteId: $remoteId, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('saleId: $saleId, ')
          ..write('billNumber: $billNumber, ')
          ..write('pdfFilePath: $pdfFilePath, ')
          ..write('qrData: $qrData, ')
          ..write('printCount: $printCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, createdAt, updatedAt, syncStatus,
      remoteId, isDeleted, saleId, billNumber, pdfFilePath, qrData, printCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BillMetadataData &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus &&
          other.remoteId == this.remoteId &&
          other.isDeleted == this.isDeleted &&
          other.saleId == this.saleId &&
          other.billNumber == this.billNumber &&
          other.pdfFilePath == this.pdfFilePath &&
          other.qrData == this.qrData &&
          other.printCount == this.printCount);
}

class BillMetadataCompanion extends UpdateCompanion<BillMetadataData> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<SyncStatus> syncStatus;
  final Value<String?> remoteId;
  final Value<bool> isDeleted;
  final Value<String> saleId;
  final Value<String> billNumber;
  final Value<String> pdfFilePath;
  final Value<String> qrData;
  final Value<int> printCount;
  final Value<int> rowid;
  const BillMetadataCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.saleId = const Value.absent(),
    this.billNumber = const Value.absent(),
    this.pdfFilePath = const Value.absent(),
    this.qrData = const Value.absent(),
    this.printCount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BillMetadataCompanion.insert({
    required String id,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.isDeleted = const Value.absent(),
    required String saleId,
    required String billNumber,
    required String pdfFilePath,
    required String qrData,
    this.printCount = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        saleId = Value(saleId),
        billNumber = Value(billNumber),
        pdfFilePath = Value(pdfFilePath),
        qrData = Value(qrData);
  static Insertable<BillMetadataData> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncStatus,
    Expression<String>? remoteId,
    Expression<bool>? isDeleted,
    Expression<String>? saleId,
    Expression<String>? billNumber,
    Expression<String>? pdfFilePath,
    Expression<String>? qrData,
    Expression<int>? printCount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (remoteId != null) 'remote_id': remoteId,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (saleId != null) 'sale_id': saleId,
      if (billNumber != null) 'bill_number': billNumber,
      if (pdfFilePath != null) 'pdf_file_path': pdfFilePath,
      if (qrData != null) 'qr_data': qrData,
      if (printCount != null) 'print_count': printCount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BillMetadataCompanion copyWith(
      {Value<String>? id,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<SyncStatus>? syncStatus,
      Value<String?>? remoteId,
      Value<bool>? isDeleted,
      Value<String>? saleId,
      Value<String>? billNumber,
      Value<String>? pdfFilePath,
      Value<String>? qrData,
      Value<int>? printCount,
      Value<int>? rowid}) {
    return BillMetadataCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      remoteId: remoteId ?? this.remoteId,
      isDeleted: isDeleted ?? this.isDeleted,
      saleId: saleId ?? this.saleId,
      billNumber: billNumber ?? this.billNumber,
      pdfFilePath: pdfFilePath ?? this.pdfFilePath,
      qrData: qrData ?? this.qrData,
      printCount: printCount ?? this.printCount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(
          $BillMetadataTable.$convertersyncStatus.toSql(syncStatus.value));
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (saleId.present) {
      map['sale_id'] = Variable<String>(saleId.value);
    }
    if (billNumber.present) {
      map['bill_number'] = Variable<String>(billNumber.value);
    }
    if (pdfFilePath.present) {
      map['pdf_file_path'] = Variable<String>(pdfFilePath.value);
    }
    if (qrData.present) {
      map['qr_data'] = Variable<String>(qrData.value);
    }
    if (printCount.present) {
      map['print_count'] = Variable<int>(printCount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BillMetadataCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('remoteId: $remoteId, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('saleId: $saleId, ')
          ..write('billNumber: $billNumber, ')
          ..write('pdfFilePath: $pdfFilePath, ')
          ..write('qrData: $qrData, ')
          ..write('printCount: $printCount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BillSequenceTable extends BillSequence
    with TableInfo<$BillSequenceTable, BillSequenceData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BillSequenceTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _sequenceTypeMeta =
      const VerificationMeta('sequenceType');
  @override
  late final GeneratedColumn<String> sequenceType = GeneratedColumn<String>(
      'sequence_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fiscalYearMeta =
      const VerificationMeta('fiscalYear');
  @override
  late final GeneratedColumn<String> fiscalYear = GeneratedColumn<String>(
      'fiscal_year', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _prefixMeta = const VerificationMeta('prefix');
  @override
  late final GeneratedColumn<String> prefix = GeneratedColumn<String>(
      'prefix', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('SB'));
  static const VerificationMeta _currentNumberMeta =
      const VerificationMeta('currentNumber');
  @override
  late final GeneratedColumn<int> currentNumber = GeneratedColumn<int>(
      'current_number', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [sequenceType, fiscalYear, prefix, currentNumber, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bill_sequence';
  @override
  VerificationContext validateIntegrity(Insertable<BillSequenceData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('sequence_type')) {
      context.handle(
          _sequenceTypeMeta,
          sequenceType.isAcceptableOrUnknown(
              data['sequence_type']!, _sequenceTypeMeta));
    } else if (isInserting) {
      context.missing(_sequenceTypeMeta);
    }
    if (data.containsKey('fiscal_year')) {
      context.handle(
          _fiscalYearMeta,
          fiscalYear.isAcceptableOrUnknown(
              data['fiscal_year']!, _fiscalYearMeta));
    } else if (isInserting) {
      context.missing(_fiscalYearMeta);
    }
    if (data.containsKey('prefix')) {
      context.handle(_prefixMeta,
          prefix.isAcceptableOrUnknown(data['prefix']!, _prefixMeta));
    }
    if (data.containsKey('current_number')) {
      context.handle(
          _currentNumberMeta,
          currentNumber.isAcceptableOrUnknown(
              data['current_number']!, _currentNumberMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {sequenceType, fiscalYear};
  @override
  BillSequenceData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BillSequenceData(
      sequenceType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sequence_type'])!,
      fiscalYear: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}fiscal_year'])!,
      prefix: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}prefix'])!,
      currentNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}current_number'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $BillSequenceTable createAlias(String alias) {
    return $BillSequenceTable(attachedDatabase, alias);
  }
}

class BillSequenceData extends DataClass
    implements Insertable<BillSequenceData> {
  final String sequenceType;
  final String fiscalYear;
  final String prefix;
  final int currentNumber;
  final DateTime updatedAt;
  const BillSequenceData(
      {required this.sequenceType,
      required this.fiscalYear,
      required this.prefix,
      required this.currentNumber,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['sequence_type'] = Variable<String>(sequenceType);
    map['fiscal_year'] = Variable<String>(fiscalYear);
    map['prefix'] = Variable<String>(prefix);
    map['current_number'] = Variable<int>(currentNumber);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  BillSequenceCompanion toCompanion(bool nullToAbsent) {
    return BillSequenceCompanion(
      sequenceType: Value(sequenceType),
      fiscalYear: Value(fiscalYear),
      prefix: Value(prefix),
      currentNumber: Value(currentNumber),
      updatedAt: Value(updatedAt),
    );
  }

  factory BillSequenceData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BillSequenceData(
      sequenceType: serializer.fromJson<String>(json['sequenceType']),
      fiscalYear: serializer.fromJson<String>(json['fiscalYear']),
      prefix: serializer.fromJson<String>(json['prefix']),
      currentNumber: serializer.fromJson<int>(json['currentNumber']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'sequenceType': serializer.toJson<String>(sequenceType),
      'fiscalYear': serializer.toJson<String>(fiscalYear),
      'prefix': serializer.toJson<String>(prefix),
      'currentNumber': serializer.toJson<int>(currentNumber),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  BillSequenceData copyWith(
          {String? sequenceType,
          String? fiscalYear,
          String? prefix,
          int? currentNumber,
          DateTime? updatedAt}) =>
      BillSequenceData(
        sequenceType: sequenceType ?? this.sequenceType,
        fiscalYear: fiscalYear ?? this.fiscalYear,
        prefix: prefix ?? this.prefix,
        currentNumber: currentNumber ?? this.currentNumber,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  BillSequenceData copyWithCompanion(BillSequenceCompanion data) {
    return BillSequenceData(
      sequenceType: data.sequenceType.present
          ? data.sequenceType.value
          : this.sequenceType,
      fiscalYear:
          data.fiscalYear.present ? data.fiscalYear.value : this.fiscalYear,
      prefix: data.prefix.present ? data.prefix.value : this.prefix,
      currentNumber: data.currentNumber.present
          ? data.currentNumber.value
          : this.currentNumber,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BillSequenceData(')
          ..write('sequenceType: $sequenceType, ')
          ..write('fiscalYear: $fiscalYear, ')
          ..write('prefix: $prefix, ')
          ..write('currentNumber: $currentNumber, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(sequenceType, fiscalYear, prefix, currentNumber, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BillSequenceData &&
          other.sequenceType == this.sequenceType &&
          other.fiscalYear == this.fiscalYear &&
          other.prefix == this.prefix &&
          other.currentNumber == this.currentNumber &&
          other.updatedAt == this.updatedAt);
}

class BillSequenceCompanion extends UpdateCompanion<BillSequenceData> {
  final Value<String> sequenceType;
  final Value<String> fiscalYear;
  final Value<String> prefix;
  final Value<int> currentNumber;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const BillSequenceCompanion({
    this.sequenceType = const Value.absent(),
    this.fiscalYear = const Value.absent(),
    this.prefix = const Value.absent(),
    this.currentNumber = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BillSequenceCompanion.insert({
    required String sequenceType,
    required String fiscalYear,
    this.prefix = const Value.absent(),
    this.currentNumber = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : sequenceType = Value(sequenceType),
        fiscalYear = Value(fiscalYear);
  static Insertable<BillSequenceData> custom({
    Expression<String>? sequenceType,
    Expression<String>? fiscalYear,
    Expression<String>? prefix,
    Expression<int>? currentNumber,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (sequenceType != null) 'sequence_type': sequenceType,
      if (fiscalYear != null) 'fiscal_year': fiscalYear,
      if (prefix != null) 'prefix': prefix,
      if (currentNumber != null) 'current_number': currentNumber,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BillSequenceCompanion copyWith(
      {Value<String>? sequenceType,
      Value<String>? fiscalYear,
      Value<String>? prefix,
      Value<int>? currentNumber,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return BillSequenceCompanion(
      sequenceType: sequenceType ?? this.sequenceType,
      fiscalYear: fiscalYear ?? this.fiscalYear,
      prefix: prefix ?? this.prefix,
      currentNumber: currentNumber ?? this.currentNumber,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (sequenceType.present) {
      map['sequence_type'] = Variable<String>(sequenceType.value);
    }
    if (fiscalYear.present) {
      map['fiscal_year'] = Variable<String>(fiscalYear.value);
    }
    if (prefix.present) {
      map['prefix'] = Variable<String>(prefix.value);
    }
    if (currentNumber.present) {
      map['current_number'] = Variable<int>(currentNumber.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BillSequenceCompanion(')
          ..write('sequenceType: $sequenceType, ')
          ..write('fiscalYear: $fiscalYear, ')
          ..write('prefix: $prefix, ')
          ..write('currentNumber: $currentNumber, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BackupLogsTable extends BackupLogs
    with TableInfo<$BackupLogsTable, BackupLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BackupLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumnWithTypeConverter<SyncStatus, String> syncStatus =
      GeneratedColumn<String>('sync_status', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: Constant(SyncStatus.pending.name))
          .withConverter<SyncStatus>($BackupLogsTable.$convertersyncStatus);
  static const VerificationMeta _remoteIdMeta =
      const VerificationMeta('remoteId');
  @override
  late final GeneratedColumn<String> remoteId = GeneratedColumn<String>(
      'remote_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _startedAtMeta =
      const VerificationMeta('startedAt');
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
      'started_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _finishedAtMeta =
      const VerificationMeta('finishedAt');
  @override
  late final GeneratedColumn<DateTime> finishedAt = GeneratedColumn<DateTime>(
      'finished_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 32),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _locationMeta =
      const VerificationMeta('location');
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
      'location', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 32),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _fileNameMeta =
      const VerificationMeta('fileName');
  @override
  late final GeneratedColumn<String> fileName = GeneratedColumn<String>(
      'file_name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 255),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _sizeBytesMeta =
      const VerificationMeta('sizeBytes');
  @override
  late final GeneratedColumn<int> sizeBytes = GeneratedColumn<int>(
      'size_bytes', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _errorMessageMeta =
      const VerificationMeta('errorMessage');
  @override
  late final GeneratedColumn<String> errorMessage = GeneratedColumn<String>(
      'error_message', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _googleAccountEmailMeta =
      const VerificationMeta('googleAccountEmail');
  @override
  late final GeneratedColumn<String> googleAccountEmail =
      GeneratedColumn<String>('google_account_email', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        createdAt,
        updatedAt,
        syncStatus,
        remoteId,
        isDeleted,
        startedAt,
        finishedAt,
        status,
        location,
        fileName,
        sizeBytes,
        errorMessage,
        googleAccountEmail
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'backup_logs';
  @override
  VerificationContext validateIntegrity(Insertable<BackupLog> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    context.handle(_syncStatusMeta, const VerificationResult.success());
    if (data.containsKey('remote_id')) {
      context.handle(_remoteIdMeta,
          remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    if (data.containsKey('started_at')) {
      context.handle(_startedAtMeta,
          startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta));
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('finished_at')) {
      context.handle(
          _finishedAtMeta,
          finishedAt.isAcceptableOrUnknown(
              data['finished_at']!, _finishedAtMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('location')) {
      context.handle(_locationMeta,
          location.isAcceptableOrUnknown(data['location']!, _locationMeta));
    } else if (isInserting) {
      context.missing(_locationMeta);
    }
    if (data.containsKey('file_name')) {
      context.handle(_fileNameMeta,
          fileName.isAcceptableOrUnknown(data['file_name']!, _fileNameMeta));
    } else if (isInserting) {
      context.missing(_fileNameMeta);
    }
    if (data.containsKey('size_bytes')) {
      context.handle(_sizeBytesMeta,
          sizeBytes.isAcceptableOrUnknown(data['size_bytes']!, _sizeBytesMeta));
    }
    if (data.containsKey('error_message')) {
      context.handle(
          _errorMessageMeta,
          errorMessage.isAcceptableOrUnknown(
              data['error_message']!, _errorMessageMeta));
    }
    if (data.containsKey('google_account_email')) {
      context.handle(
          _googleAccountEmailMeta,
          googleAccountEmail.isAcceptableOrUnknown(
              data['google_account_email']!, _googleAccountEmailMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BackupLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BackupLog(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      syncStatus: $BackupLogsTable.$convertersyncStatus.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!),
      remoteId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}remote_id']),
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
      startedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}started_at'])!,
      finishedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}finished_at']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      location: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}location'])!,
      fileName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}file_name'])!,
      sizeBytes: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}size_bytes'])!,
      errorMessage: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}error_message']),
      googleAccountEmail: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}google_account_email']),
    );
  }

  @override
  $BackupLogsTable createAlias(String alias) {
    return $BackupLogsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SyncStatus, String, String> $convertersyncStatus =
      const EnumNameConverter<SyncStatus>(SyncStatus.values);
}

class BackupLog extends DataClass implements Insertable<BackupLog> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final SyncStatus syncStatus;
  final String? remoteId;
  final bool isDeleted;

  /// When the backup/restore operation was initiated.
  final DateTime startedAt;

  /// When the backup/restore operation completed (or failed).
  final DateTime? finishedAt;

  /// Status of the operation: 'success', 'failed', 'in_progress', etc.
  final String status;

  /// Destination / source: 'local' or 'drive'.
  final String location;

  /// Filename of the backup archive (e.g. sajilo_backup_20261108_120000.zip).
  final String fileName;

  /// Size of the backup archive in bytes.
  final int sizeBytes;

  /// Human-readable error message if operation failed.
  final String? errorMessage;

  /// Connected Google account email if location is 'drive'.
  final String? googleAccountEmail;
  const BackupLog(
      {required this.id,
      required this.createdAt,
      required this.updatedAt,
      required this.syncStatus,
      this.remoteId,
      required this.isDeleted,
      required this.startedAt,
      this.finishedAt,
      required this.status,
      required this.location,
      required this.fileName,
      required this.sizeBytes,
      this.errorMessage,
      this.googleAccountEmail});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    {
      map['sync_status'] = Variable<String>(
          $BackupLogsTable.$convertersyncStatus.toSql(syncStatus));
    }
    if (!nullToAbsent || remoteId != null) {
      map['remote_id'] = Variable<String>(remoteId);
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || finishedAt != null) {
      map['finished_at'] = Variable<DateTime>(finishedAt);
    }
    map['status'] = Variable<String>(status);
    map['location'] = Variable<String>(location);
    map['file_name'] = Variable<String>(fileName);
    map['size_bytes'] = Variable<int>(sizeBytes);
    if (!nullToAbsent || errorMessage != null) {
      map['error_message'] = Variable<String>(errorMessage);
    }
    if (!nullToAbsent || googleAccountEmail != null) {
      map['google_account_email'] = Variable<String>(googleAccountEmail);
    }
    return map;
  }

  BackupLogsCompanion toCompanion(bool nullToAbsent) {
    return BackupLogsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncStatus: Value(syncStatus),
      remoteId: remoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteId),
      isDeleted: Value(isDeleted),
      startedAt: Value(startedAt),
      finishedAt: finishedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(finishedAt),
      status: Value(status),
      location: Value(location),
      fileName: Value(fileName),
      sizeBytes: Value(sizeBytes),
      errorMessage: errorMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(errorMessage),
      googleAccountEmail: googleAccountEmail == null && nullToAbsent
          ? const Value.absent()
          : Value(googleAccountEmail),
    );
  }

  factory BackupLog.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BackupLog(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncStatus: $BackupLogsTable.$convertersyncStatus
          .fromJson(serializer.fromJson<String>(json['syncStatus'])),
      remoteId: serializer.fromJson<String?>(json['remoteId']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      finishedAt: serializer.fromJson<DateTime?>(json['finishedAt']),
      status: serializer.fromJson<String>(json['status']),
      location: serializer.fromJson<String>(json['location']),
      fileName: serializer.fromJson<String>(json['fileName']),
      sizeBytes: serializer.fromJson<int>(json['sizeBytes']),
      errorMessage: serializer.fromJson<String?>(json['errorMessage']),
      googleAccountEmail:
          serializer.fromJson<String?>(json['googleAccountEmail']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncStatus': serializer.toJson<String>(
          $BackupLogsTable.$convertersyncStatus.toJson(syncStatus)),
      'remoteId': serializer.toJson<String?>(remoteId),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'finishedAt': serializer.toJson<DateTime?>(finishedAt),
      'status': serializer.toJson<String>(status),
      'location': serializer.toJson<String>(location),
      'fileName': serializer.toJson<String>(fileName),
      'sizeBytes': serializer.toJson<int>(sizeBytes),
      'errorMessage': serializer.toJson<String?>(errorMessage),
      'googleAccountEmail': serializer.toJson<String?>(googleAccountEmail),
    };
  }

  BackupLog copyWith(
          {String? id,
          DateTime? createdAt,
          DateTime? updatedAt,
          SyncStatus? syncStatus,
          Value<String?> remoteId = const Value.absent(),
          bool? isDeleted,
          DateTime? startedAt,
          Value<DateTime?> finishedAt = const Value.absent(),
          String? status,
          String? location,
          String? fileName,
          int? sizeBytes,
          Value<String?> errorMessage = const Value.absent(),
          Value<String?> googleAccountEmail = const Value.absent()}) =>
      BackupLog(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        syncStatus: syncStatus ?? this.syncStatus,
        remoteId: remoteId.present ? remoteId.value : this.remoteId,
        isDeleted: isDeleted ?? this.isDeleted,
        startedAt: startedAt ?? this.startedAt,
        finishedAt: finishedAt.present ? finishedAt.value : this.finishedAt,
        status: status ?? this.status,
        location: location ?? this.location,
        fileName: fileName ?? this.fileName,
        sizeBytes: sizeBytes ?? this.sizeBytes,
        errorMessage:
            errorMessage.present ? errorMessage.value : this.errorMessage,
        googleAccountEmail: googleAccountEmail.present
            ? googleAccountEmail.value
            : this.googleAccountEmail,
      );
  BackupLog copyWithCompanion(BackupLogsCompanion data) {
    return BackupLog(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      finishedAt:
          data.finishedAt.present ? data.finishedAt.value : this.finishedAt,
      status: data.status.present ? data.status.value : this.status,
      location: data.location.present ? data.location.value : this.location,
      fileName: data.fileName.present ? data.fileName.value : this.fileName,
      sizeBytes: data.sizeBytes.present ? data.sizeBytes.value : this.sizeBytes,
      errorMessage: data.errorMessage.present
          ? data.errorMessage.value
          : this.errorMessage,
      googleAccountEmail: data.googleAccountEmail.present
          ? data.googleAccountEmail.value
          : this.googleAccountEmail,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BackupLog(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('remoteId: $remoteId, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('startedAt: $startedAt, ')
          ..write('finishedAt: $finishedAt, ')
          ..write('status: $status, ')
          ..write('location: $location, ')
          ..write('fileName: $fileName, ')
          ..write('sizeBytes: $sizeBytes, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('googleAccountEmail: $googleAccountEmail')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      createdAt,
      updatedAt,
      syncStatus,
      remoteId,
      isDeleted,
      startedAt,
      finishedAt,
      status,
      location,
      fileName,
      sizeBytes,
      errorMessage,
      googleAccountEmail);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BackupLog &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus &&
          other.remoteId == this.remoteId &&
          other.isDeleted == this.isDeleted &&
          other.startedAt == this.startedAt &&
          other.finishedAt == this.finishedAt &&
          other.status == this.status &&
          other.location == this.location &&
          other.fileName == this.fileName &&
          other.sizeBytes == this.sizeBytes &&
          other.errorMessage == this.errorMessage &&
          other.googleAccountEmail == this.googleAccountEmail);
}

class BackupLogsCompanion extends UpdateCompanion<BackupLog> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<SyncStatus> syncStatus;
  final Value<String?> remoteId;
  final Value<bool> isDeleted;
  final Value<DateTime> startedAt;
  final Value<DateTime?> finishedAt;
  final Value<String> status;
  final Value<String> location;
  final Value<String> fileName;
  final Value<int> sizeBytes;
  final Value<String?> errorMessage;
  final Value<String?> googleAccountEmail;
  final Value<int> rowid;
  const BackupLogsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.finishedAt = const Value.absent(),
    this.status = const Value.absent(),
    this.location = const Value.absent(),
    this.fileName = const Value.absent(),
    this.sizeBytes = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.googleAccountEmail = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BackupLogsCompanion.insert({
    required String id,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.isDeleted = const Value.absent(),
    required DateTime startedAt,
    this.finishedAt = const Value.absent(),
    required String status,
    required String location,
    required String fileName,
    this.sizeBytes = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.googleAccountEmail = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        startedAt = Value(startedAt),
        status = Value(status),
        location = Value(location),
        fileName = Value(fileName);
  static Insertable<BackupLog> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncStatus,
    Expression<String>? remoteId,
    Expression<bool>? isDeleted,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? finishedAt,
    Expression<String>? status,
    Expression<String>? location,
    Expression<String>? fileName,
    Expression<int>? sizeBytes,
    Expression<String>? errorMessage,
    Expression<String>? googleAccountEmail,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (remoteId != null) 'remote_id': remoteId,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (startedAt != null) 'started_at': startedAt,
      if (finishedAt != null) 'finished_at': finishedAt,
      if (status != null) 'status': status,
      if (location != null) 'location': location,
      if (fileName != null) 'file_name': fileName,
      if (sizeBytes != null) 'size_bytes': sizeBytes,
      if (errorMessage != null) 'error_message': errorMessage,
      if (googleAccountEmail != null)
        'google_account_email': googleAccountEmail,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BackupLogsCompanion copyWith(
      {Value<String>? id,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<SyncStatus>? syncStatus,
      Value<String?>? remoteId,
      Value<bool>? isDeleted,
      Value<DateTime>? startedAt,
      Value<DateTime?>? finishedAt,
      Value<String>? status,
      Value<String>? location,
      Value<String>? fileName,
      Value<int>? sizeBytes,
      Value<String?>? errorMessage,
      Value<String?>? googleAccountEmail,
      Value<int>? rowid}) {
    return BackupLogsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      remoteId: remoteId ?? this.remoteId,
      isDeleted: isDeleted ?? this.isDeleted,
      startedAt: startedAt ?? this.startedAt,
      finishedAt: finishedAt ?? this.finishedAt,
      status: status ?? this.status,
      location: location ?? this.location,
      fileName: fileName ?? this.fileName,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      errorMessage: errorMessage ?? this.errorMessage,
      googleAccountEmail: googleAccountEmail ?? this.googleAccountEmail,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(
          $BackupLogsTable.$convertersyncStatus.toSql(syncStatus.value));
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (finishedAt.present) {
      map['finished_at'] = Variable<DateTime>(finishedAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (fileName.present) {
      map['file_name'] = Variable<String>(fileName.value);
    }
    if (sizeBytes.present) {
      map['size_bytes'] = Variable<int>(sizeBytes.value);
    }
    if (errorMessage.present) {
      map['error_message'] = Variable<String>(errorMessage.value);
    }
    if (googleAccountEmail.present) {
      map['google_account_email'] = Variable<String>(googleAccountEmail.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BackupLogsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('remoteId: $remoteId, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('startedAt: $startedAt, ')
          ..write('finishedAt: $finishedAt, ')
          ..write('status: $status, ')
          ..write('location: $location, ')
          ..write('fileName: $fileName, ')
          ..write('sizeBytes: $sizeBytes, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('googleAccountEmail: $googleAccountEmail, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PartyLedgerTable extends PartyLedger
    with TableInfo<$PartyLedgerTable, PartyLedgerData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PartyLedgerTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumnWithTypeConverter<SyncStatus, String> syncStatus =
      GeneratedColumn<String>('sync_status', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: Constant(SyncStatus.pending.name))
          .withConverter<SyncStatus>($PartyLedgerTable.$convertersyncStatus);
  static const VerificationMeta _remoteIdMeta =
      const VerificationMeta('remoteId');
  @override
  late final GeneratedColumn<String> remoteId = GeneratedColumn<String>(
      'remote_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _partyTypeMeta =
      const VerificationMeta('partyType');
  @override
  late final GeneratedColumn<String> partyType = GeneratedColumn<String>(
      'party_type', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 20),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _partyIdMeta =
      const VerificationMeta('partyId');
  @override
  late final GeneratedColumn<String> partyId = GeneratedColumn<String>(
      'party_id', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 64),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _entryTypeMeta =
      const VerificationMeta('entryType');
  @override
  late final GeneratedColumn<String> entryType = GeneratedColumn<String>(
      'entry_type', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 32),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _amountPaisaMeta =
      const VerificationMeta('amountPaisa');
  @override
  late final GeneratedColumn<int> amountPaisa = GeneratedColumn<int>(
      'amount_paisa', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _balanceAfterPaisaMeta =
      const VerificationMeta('balanceAfterPaisa');
  @override
  late final GeneratedColumn<int> balanceAfterPaisa = GeneratedColumn<int>(
      'balance_after_paisa', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _refIdMeta = const VerificationMeta('refId');
  @override
  late final GeneratedColumn<String> refId = GeneratedColumn<String>(
      'ref_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _refNumberMeta =
      const VerificationMeta('refNumber');
  @override
  late final GeneratedColumn<String> refNumber = GeneratedColumn<String>(
      'ref_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _entryDateMeta =
      const VerificationMeta('entryDate');
  @override
  late final GeneratedColumn<DateTime> entryDate = GeneratedColumn<DateTime>(
      'entry_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        createdAt,
        updatedAt,
        syncStatus,
        remoteId,
        isDeleted,
        partyType,
        partyId,
        entryType,
        amountPaisa,
        balanceAfterPaisa,
        refId,
        refNumber,
        notes,
        entryDate
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'party_ledger';
  @override
  VerificationContext validateIntegrity(Insertable<PartyLedgerData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    context.handle(_syncStatusMeta, const VerificationResult.success());
    if (data.containsKey('remote_id')) {
      context.handle(_remoteIdMeta,
          remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    if (data.containsKey('party_type')) {
      context.handle(_partyTypeMeta,
          partyType.isAcceptableOrUnknown(data['party_type']!, _partyTypeMeta));
    } else if (isInserting) {
      context.missing(_partyTypeMeta);
    }
    if (data.containsKey('party_id')) {
      context.handle(_partyIdMeta,
          partyId.isAcceptableOrUnknown(data['party_id']!, _partyIdMeta));
    } else if (isInserting) {
      context.missing(_partyIdMeta);
    }
    if (data.containsKey('entry_type')) {
      context.handle(_entryTypeMeta,
          entryType.isAcceptableOrUnknown(data['entry_type']!, _entryTypeMeta));
    } else if (isInserting) {
      context.missing(_entryTypeMeta);
    }
    if (data.containsKey('amount_paisa')) {
      context.handle(
          _amountPaisaMeta,
          amountPaisa.isAcceptableOrUnknown(
              data['amount_paisa']!, _amountPaisaMeta));
    } else if (isInserting) {
      context.missing(_amountPaisaMeta);
    }
    if (data.containsKey('balance_after_paisa')) {
      context.handle(
          _balanceAfterPaisaMeta,
          balanceAfterPaisa.isAcceptableOrUnknown(
              data['balance_after_paisa']!, _balanceAfterPaisaMeta));
    } else if (isInserting) {
      context.missing(_balanceAfterPaisaMeta);
    }
    if (data.containsKey('ref_id')) {
      context.handle(
          _refIdMeta, refId.isAcceptableOrUnknown(data['ref_id']!, _refIdMeta));
    }
    if (data.containsKey('ref_number')) {
      context.handle(_refNumberMeta,
          refNumber.isAcceptableOrUnknown(data['ref_number']!, _refNumberMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('entry_date')) {
      context.handle(_entryDateMeta,
          entryDate.isAcceptableOrUnknown(data['entry_date']!, _entryDateMeta));
    } else if (isInserting) {
      context.missing(_entryDateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PartyLedgerData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PartyLedgerData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      syncStatus: $PartyLedgerTable.$convertersyncStatus.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}sync_status'])!),
      remoteId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}remote_id']),
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
      partyType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}party_type'])!,
      partyId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}party_id'])!,
      entryType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entry_type'])!,
      amountPaisa: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}amount_paisa'])!,
      balanceAfterPaisa: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}balance_after_paisa'])!,
      refId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}ref_id']),
      refNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}ref_number']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      entryDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}entry_date'])!,
    );
  }

  @override
  $PartyLedgerTable createAlias(String alias) {
    return $PartyLedgerTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SyncStatus, String, String> $convertersyncStatus =
      const EnumNameConverter<SyncStatus>(SyncStatus.values);
}

class PartyLedgerData extends DataClass implements Insertable<PartyLedgerData> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final SyncStatus syncStatus;
  final String? remoteId;
  final bool isDeleted;

  /// 'customer' or 'supplier'
  final String partyType;

  /// Reference to Customers.id or Suppliers.id
  final String partyId;

  /// Transaction type: 'sale_credit', 'purchase_credit', 'payment_received', 'payment_made', 'opening_balance', 'adjustment'
  final String entryType;

  /// Transaction amount in integer paisa (always positive)
  final int amountPaisa;

  /// Running balance in integer paisa immediately after this transaction.
  /// For customers: positive means customer owes shopkeeper (Receivable / लिन बाँकी).
  /// For suppliers: positive means shopkeeper owes supplier (Payable / तिर्न बाँकी).
  final int balanceAfterPaisa;

  /// Reference to Sales.id, Purchases.id, or PartyPayments.id
  final String? refId;

  /// Reference bill number or receipt number (e.g. 'SB-2082-0001', 'REC-001')
  final String? refNumber;

  /// Optional remarks or notes (कैफियत)
  final String? notes;

  /// Date and time of the transaction (stored in UTC)
  final DateTime entryDate;
  const PartyLedgerData(
      {required this.id,
      required this.createdAt,
      required this.updatedAt,
      required this.syncStatus,
      this.remoteId,
      required this.isDeleted,
      required this.partyType,
      required this.partyId,
      required this.entryType,
      required this.amountPaisa,
      required this.balanceAfterPaisa,
      this.refId,
      this.refNumber,
      this.notes,
      required this.entryDate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    {
      map['sync_status'] = Variable<String>(
          $PartyLedgerTable.$convertersyncStatus.toSql(syncStatus));
    }
    if (!nullToAbsent || remoteId != null) {
      map['remote_id'] = Variable<String>(remoteId);
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['party_type'] = Variable<String>(partyType);
    map['party_id'] = Variable<String>(partyId);
    map['entry_type'] = Variable<String>(entryType);
    map['amount_paisa'] = Variable<int>(amountPaisa);
    map['balance_after_paisa'] = Variable<int>(balanceAfterPaisa);
    if (!nullToAbsent || refId != null) {
      map['ref_id'] = Variable<String>(refId);
    }
    if (!nullToAbsent || refNumber != null) {
      map['ref_number'] = Variable<String>(refNumber);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['entry_date'] = Variable<DateTime>(entryDate);
    return map;
  }

  PartyLedgerCompanion toCompanion(bool nullToAbsent) {
    return PartyLedgerCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncStatus: Value(syncStatus),
      remoteId: remoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteId),
      isDeleted: Value(isDeleted),
      partyType: Value(partyType),
      partyId: Value(partyId),
      entryType: Value(entryType),
      amountPaisa: Value(amountPaisa),
      balanceAfterPaisa: Value(balanceAfterPaisa),
      refId:
          refId == null && nullToAbsent ? const Value.absent() : Value(refId),
      refNumber: refNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(refNumber),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      entryDate: Value(entryDate),
    );
  }

  factory PartyLedgerData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PartyLedgerData(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncStatus: $PartyLedgerTable.$convertersyncStatus
          .fromJson(serializer.fromJson<String>(json['syncStatus'])),
      remoteId: serializer.fromJson<String?>(json['remoteId']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      partyType: serializer.fromJson<String>(json['partyType']),
      partyId: serializer.fromJson<String>(json['partyId']),
      entryType: serializer.fromJson<String>(json['entryType']),
      amountPaisa: serializer.fromJson<int>(json['amountPaisa']),
      balanceAfterPaisa: serializer.fromJson<int>(json['balanceAfterPaisa']),
      refId: serializer.fromJson<String?>(json['refId']),
      refNumber: serializer.fromJson<String?>(json['refNumber']),
      notes: serializer.fromJson<String?>(json['notes']),
      entryDate: serializer.fromJson<DateTime>(json['entryDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncStatus': serializer.toJson<String>(
          $PartyLedgerTable.$convertersyncStatus.toJson(syncStatus)),
      'remoteId': serializer.toJson<String?>(remoteId),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'partyType': serializer.toJson<String>(partyType),
      'partyId': serializer.toJson<String>(partyId),
      'entryType': serializer.toJson<String>(entryType),
      'amountPaisa': serializer.toJson<int>(amountPaisa),
      'balanceAfterPaisa': serializer.toJson<int>(balanceAfterPaisa),
      'refId': serializer.toJson<String?>(refId),
      'refNumber': serializer.toJson<String?>(refNumber),
      'notes': serializer.toJson<String?>(notes),
      'entryDate': serializer.toJson<DateTime>(entryDate),
    };
  }

  PartyLedgerData copyWith(
          {String? id,
          DateTime? createdAt,
          DateTime? updatedAt,
          SyncStatus? syncStatus,
          Value<String?> remoteId = const Value.absent(),
          bool? isDeleted,
          String? partyType,
          String? partyId,
          String? entryType,
          int? amountPaisa,
          int? balanceAfterPaisa,
          Value<String?> refId = const Value.absent(),
          Value<String?> refNumber = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          DateTime? entryDate}) =>
      PartyLedgerData(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        syncStatus: syncStatus ?? this.syncStatus,
        remoteId: remoteId.present ? remoteId.value : this.remoteId,
        isDeleted: isDeleted ?? this.isDeleted,
        partyType: partyType ?? this.partyType,
        partyId: partyId ?? this.partyId,
        entryType: entryType ?? this.entryType,
        amountPaisa: amountPaisa ?? this.amountPaisa,
        balanceAfterPaisa: balanceAfterPaisa ?? this.balanceAfterPaisa,
        refId: refId.present ? refId.value : this.refId,
        refNumber: refNumber.present ? refNumber.value : this.refNumber,
        notes: notes.present ? notes.value : this.notes,
        entryDate: entryDate ?? this.entryDate,
      );
  PartyLedgerData copyWithCompanion(PartyLedgerCompanion data) {
    return PartyLedgerData(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      partyType: data.partyType.present ? data.partyType.value : this.partyType,
      partyId: data.partyId.present ? data.partyId.value : this.partyId,
      entryType: data.entryType.present ? data.entryType.value : this.entryType,
      amountPaisa:
          data.amountPaisa.present ? data.amountPaisa.value : this.amountPaisa,
      balanceAfterPaisa: data.balanceAfterPaisa.present
          ? data.balanceAfterPaisa.value
          : this.balanceAfterPaisa,
      refId: data.refId.present ? data.refId.value : this.refId,
      refNumber: data.refNumber.present ? data.refNumber.value : this.refNumber,
      notes: data.notes.present ? data.notes.value : this.notes,
      entryDate: data.entryDate.present ? data.entryDate.value : this.entryDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PartyLedgerData(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('remoteId: $remoteId, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('partyType: $partyType, ')
          ..write('partyId: $partyId, ')
          ..write('entryType: $entryType, ')
          ..write('amountPaisa: $amountPaisa, ')
          ..write('balanceAfterPaisa: $balanceAfterPaisa, ')
          ..write('refId: $refId, ')
          ..write('refNumber: $refNumber, ')
          ..write('notes: $notes, ')
          ..write('entryDate: $entryDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      createdAt,
      updatedAt,
      syncStatus,
      remoteId,
      isDeleted,
      partyType,
      partyId,
      entryType,
      amountPaisa,
      balanceAfterPaisa,
      refId,
      refNumber,
      notes,
      entryDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PartyLedgerData &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus &&
          other.remoteId == this.remoteId &&
          other.isDeleted == this.isDeleted &&
          other.partyType == this.partyType &&
          other.partyId == this.partyId &&
          other.entryType == this.entryType &&
          other.amountPaisa == this.amountPaisa &&
          other.balanceAfterPaisa == this.balanceAfterPaisa &&
          other.refId == this.refId &&
          other.refNumber == this.refNumber &&
          other.notes == this.notes &&
          other.entryDate == this.entryDate);
}

class PartyLedgerCompanion extends UpdateCompanion<PartyLedgerData> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<SyncStatus> syncStatus;
  final Value<String?> remoteId;
  final Value<bool> isDeleted;
  final Value<String> partyType;
  final Value<String> partyId;
  final Value<String> entryType;
  final Value<int> amountPaisa;
  final Value<int> balanceAfterPaisa;
  final Value<String?> refId;
  final Value<String?> refNumber;
  final Value<String?> notes;
  final Value<DateTime> entryDate;
  final Value<int> rowid;
  const PartyLedgerCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.partyType = const Value.absent(),
    this.partyId = const Value.absent(),
    this.entryType = const Value.absent(),
    this.amountPaisa = const Value.absent(),
    this.balanceAfterPaisa = const Value.absent(),
    this.refId = const Value.absent(),
    this.refNumber = const Value.absent(),
    this.notes = const Value.absent(),
    this.entryDate = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PartyLedgerCompanion.insert({
    required String id,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.isDeleted = const Value.absent(),
    required String partyType,
    required String partyId,
    required String entryType,
    required int amountPaisa,
    required int balanceAfterPaisa,
    this.refId = const Value.absent(),
    this.refNumber = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime entryDate,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        partyType = Value(partyType),
        partyId = Value(partyId),
        entryType = Value(entryType),
        amountPaisa = Value(amountPaisa),
        balanceAfterPaisa = Value(balanceAfterPaisa),
        entryDate = Value(entryDate);
  static Insertable<PartyLedgerData> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncStatus,
    Expression<String>? remoteId,
    Expression<bool>? isDeleted,
    Expression<String>? partyType,
    Expression<String>? partyId,
    Expression<String>? entryType,
    Expression<int>? amountPaisa,
    Expression<int>? balanceAfterPaisa,
    Expression<String>? refId,
    Expression<String>? refNumber,
    Expression<String>? notes,
    Expression<DateTime>? entryDate,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (remoteId != null) 'remote_id': remoteId,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (partyType != null) 'party_type': partyType,
      if (partyId != null) 'party_id': partyId,
      if (entryType != null) 'entry_type': entryType,
      if (amountPaisa != null) 'amount_paisa': amountPaisa,
      if (balanceAfterPaisa != null) 'balance_after_paisa': balanceAfterPaisa,
      if (refId != null) 'ref_id': refId,
      if (refNumber != null) 'ref_number': refNumber,
      if (notes != null) 'notes': notes,
      if (entryDate != null) 'entry_date': entryDate,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PartyLedgerCompanion copyWith(
      {Value<String>? id,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<SyncStatus>? syncStatus,
      Value<String?>? remoteId,
      Value<bool>? isDeleted,
      Value<String>? partyType,
      Value<String>? partyId,
      Value<String>? entryType,
      Value<int>? amountPaisa,
      Value<int>? balanceAfterPaisa,
      Value<String?>? refId,
      Value<String?>? refNumber,
      Value<String?>? notes,
      Value<DateTime>? entryDate,
      Value<int>? rowid}) {
    return PartyLedgerCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      remoteId: remoteId ?? this.remoteId,
      isDeleted: isDeleted ?? this.isDeleted,
      partyType: partyType ?? this.partyType,
      partyId: partyId ?? this.partyId,
      entryType: entryType ?? this.entryType,
      amountPaisa: amountPaisa ?? this.amountPaisa,
      balanceAfterPaisa: balanceAfterPaisa ?? this.balanceAfterPaisa,
      refId: refId ?? this.refId,
      refNumber: refNumber ?? this.refNumber,
      notes: notes ?? this.notes,
      entryDate: entryDate ?? this.entryDate,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(
          $PartyLedgerTable.$convertersyncStatus.toSql(syncStatus.value));
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (partyType.present) {
      map['party_type'] = Variable<String>(partyType.value);
    }
    if (partyId.present) {
      map['party_id'] = Variable<String>(partyId.value);
    }
    if (entryType.present) {
      map['entry_type'] = Variable<String>(entryType.value);
    }
    if (amountPaisa.present) {
      map['amount_paisa'] = Variable<int>(amountPaisa.value);
    }
    if (balanceAfterPaisa.present) {
      map['balance_after_paisa'] = Variable<int>(balanceAfterPaisa.value);
    }
    if (refId.present) {
      map['ref_id'] = Variable<String>(refId.value);
    }
    if (refNumber.present) {
      map['ref_number'] = Variable<String>(refNumber.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (entryDate.present) {
      map['entry_date'] = Variable<DateTime>(entryDate.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PartyLedgerCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('remoteId: $remoteId, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('partyType: $partyType, ')
          ..write('partyId: $partyId, ')
          ..write('entryType: $entryType, ')
          ..write('amountPaisa: $amountPaisa, ')
          ..write('balanceAfterPaisa: $balanceAfterPaisa, ')
          ..write('refId: $refId, ')
          ..write('refNumber: $refNumber, ')
          ..write('notes: $notes, ')
          ..write('entryDate: $entryDate, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PartyPaymentsTable extends PartyPayments
    with TableInfo<$PartyPaymentsTable, PartyPayment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PartyPaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumnWithTypeConverter<SyncStatus, String> syncStatus =
      GeneratedColumn<String>('sync_status', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: Constant(SyncStatus.pending.name))
          .withConverter<SyncStatus>($PartyPaymentsTable.$convertersyncStatus);
  static const VerificationMeta _remoteIdMeta =
      const VerificationMeta('remoteId');
  @override
  late final GeneratedColumn<String> remoteId = GeneratedColumn<String>(
      'remote_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _partyTypeMeta =
      const VerificationMeta('partyType');
  @override
  late final GeneratedColumn<String> partyType = GeneratedColumn<String>(
      'party_type', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 20),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _partyIdMeta =
      const VerificationMeta('partyId');
  @override
  late final GeneratedColumn<String> partyId = GeneratedColumn<String>(
      'party_id', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 64),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _amountPaisaMeta =
      const VerificationMeta('amountPaisa');
  @override
  late final GeneratedColumn<int> amountPaisa = GeneratedColumn<int>(
      'amount_paisa', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _paymentModeMeta =
      const VerificationMeta('paymentMode');
  @override
  late final GeneratedColumn<String> paymentMode = GeneratedColumn<String>(
      'payment_mode', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 32),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _receiptNumberMeta =
      const VerificationMeta('receiptNumber');
  @override
  late final GeneratedColumn<String> receiptNumber = GeneratedColumn<String>(
      'receipt_number', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 64),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _paymentDateMeta =
      const VerificationMeta('paymentDate');
  @override
  late final GeneratedColumn<DateTime> paymentDate = GeneratedColumn<DateTime>(
      'payment_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        createdAt,
        updatedAt,
        syncStatus,
        remoteId,
        isDeleted,
        partyType,
        partyId,
        amountPaisa,
        paymentMode,
        receiptNumber,
        paymentDate,
        notes
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'party_payments';
  @override
  VerificationContext validateIntegrity(Insertable<PartyPayment> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    context.handle(_syncStatusMeta, const VerificationResult.success());
    if (data.containsKey('remote_id')) {
      context.handle(_remoteIdMeta,
          remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    if (data.containsKey('party_type')) {
      context.handle(_partyTypeMeta,
          partyType.isAcceptableOrUnknown(data['party_type']!, _partyTypeMeta));
    } else if (isInserting) {
      context.missing(_partyTypeMeta);
    }
    if (data.containsKey('party_id')) {
      context.handle(_partyIdMeta,
          partyId.isAcceptableOrUnknown(data['party_id']!, _partyIdMeta));
    } else if (isInserting) {
      context.missing(_partyIdMeta);
    }
    if (data.containsKey('amount_paisa')) {
      context.handle(
          _amountPaisaMeta,
          amountPaisa.isAcceptableOrUnknown(
              data['amount_paisa']!, _amountPaisaMeta));
    } else if (isInserting) {
      context.missing(_amountPaisaMeta);
    }
    if (data.containsKey('payment_mode')) {
      context.handle(
          _paymentModeMeta,
          paymentMode.isAcceptableOrUnknown(
              data['payment_mode']!, _paymentModeMeta));
    } else if (isInserting) {
      context.missing(_paymentModeMeta);
    }
    if (data.containsKey('receipt_number')) {
      context.handle(
          _receiptNumberMeta,
          receiptNumber.isAcceptableOrUnknown(
              data['receipt_number']!, _receiptNumberMeta));
    } else if (isInserting) {
      context.missing(_receiptNumberMeta);
    }
    if (data.containsKey('payment_date')) {
      context.handle(
          _paymentDateMeta,
          paymentDate.isAcceptableOrUnknown(
              data['payment_date']!, _paymentDateMeta));
    } else if (isInserting) {
      context.missing(_paymentDateMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PartyPayment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PartyPayment(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      syncStatus: $PartyPaymentsTable.$convertersyncStatus.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}sync_status'])!),
      remoteId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}remote_id']),
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
      partyType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}party_type'])!,
      partyId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}party_id'])!,
      amountPaisa: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}amount_paisa'])!,
      paymentMode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payment_mode'])!,
      receiptNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}receipt_number'])!,
      paymentDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}payment_date'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
    );
  }

  @override
  $PartyPaymentsTable createAlias(String alias) {
    return $PartyPaymentsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SyncStatus, String, String> $convertersyncStatus =
      const EnumNameConverter<SyncStatus>(SyncStatus.values);
}

class PartyPayment extends DataClass implements Insertable<PartyPayment> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final SyncStatus syncStatus;
  final String? remoteId;
  final bool isDeleted;

  /// 'customer' (received from customer) or 'supplier' (paid to supplier)
  final String partyType;

  /// Reference to Customers.id or Suppliers.id
  final String partyId;

  /// Amount settled in integer paisa
  final int amountPaisa;

  /// Payment mode: 'cash', 'fonepay', 'bank_transfer', 'cheque'
  final String paymentMode;

  /// Unique serial receipt number (e.g. 'REC-2082-0001')
  final String receiptNumber;

  /// Transaction timestamp (stored in UTC)
  final DateTime paymentDate;

  /// Optional remarks or notes
  final String? notes;
  const PartyPayment(
      {required this.id,
      required this.createdAt,
      required this.updatedAt,
      required this.syncStatus,
      this.remoteId,
      required this.isDeleted,
      required this.partyType,
      required this.partyId,
      required this.amountPaisa,
      required this.paymentMode,
      required this.receiptNumber,
      required this.paymentDate,
      this.notes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    {
      map['sync_status'] = Variable<String>(
          $PartyPaymentsTable.$convertersyncStatus.toSql(syncStatus));
    }
    if (!nullToAbsent || remoteId != null) {
      map['remote_id'] = Variable<String>(remoteId);
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['party_type'] = Variable<String>(partyType);
    map['party_id'] = Variable<String>(partyId);
    map['amount_paisa'] = Variable<int>(amountPaisa);
    map['payment_mode'] = Variable<String>(paymentMode);
    map['receipt_number'] = Variable<String>(receiptNumber);
    map['payment_date'] = Variable<DateTime>(paymentDate);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  PartyPaymentsCompanion toCompanion(bool nullToAbsent) {
    return PartyPaymentsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncStatus: Value(syncStatus),
      remoteId: remoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteId),
      isDeleted: Value(isDeleted),
      partyType: Value(partyType),
      partyId: Value(partyId),
      amountPaisa: Value(amountPaisa),
      paymentMode: Value(paymentMode),
      receiptNumber: Value(receiptNumber),
      paymentDate: Value(paymentDate),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
    );
  }

  factory PartyPayment.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PartyPayment(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncStatus: $PartyPaymentsTable.$convertersyncStatus
          .fromJson(serializer.fromJson<String>(json['syncStatus'])),
      remoteId: serializer.fromJson<String?>(json['remoteId']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      partyType: serializer.fromJson<String>(json['partyType']),
      partyId: serializer.fromJson<String>(json['partyId']),
      amountPaisa: serializer.fromJson<int>(json['amountPaisa']),
      paymentMode: serializer.fromJson<String>(json['paymentMode']),
      receiptNumber: serializer.fromJson<String>(json['receiptNumber']),
      paymentDate: serializer.fromJson<DateTime>(json['paymentDate']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncStatus': serializer.toJson<String>(
          $PartyPaymentsTable.$convertersyncStatus.toJson(syncStatus)),
      'remoteId': serializer.toJson<String?>(remoteId),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'partyType': serializer.toJson<String>(partyType),
      'partyId': serializer.toJson<String>(partyId),
      'amountPaisa': serializer.toJson<int>(amountPaisa),
      'paymentMode': serializer.toJson<String>(paymentMode),
      'receiptNumber': serializer.toJson<String>(receiptNumber),
      'paymentDate': serializer.toJson<DateTime>(paymentDate),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  PartyPayment copyWith(
          {String? id,
          DateTime? createdAt,
          DateTime? updatedAt,
          SyncStatus? syncStatus,
          Value<String?> remoteId = const Value.absent(),
          bool? isDeleted,
          String? partyType,
          String? partyId,
          int? amountPaisa,
          String? paymentMode,
          String? receiptNumber,
          DateTime? paymentDate,
          Value<String?> notes = const Value.absent()}) =>
      PartyPayment(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        syncStatus: syncStatus ?? this.syncStatus,
        remoteId: remoteId.present ? remoteId.value : this.remoteId,
        isDeleted: isDeleted ?? this.isDeleted,
        partyType: partyType ?? this.partyType,
        partyId: partyId ?? this.partyId,
        amountPaisa: amountPaisa ?? this.amountPaisa,
        paymentMode: paymentMode ?? this.paymentMode,
        receiptNumber: receiptNumber ?? this.receiptNumber,
        paymentDate: paymentDate ?? this.paymentDate,
        notes: notes.present ? notes.value : this.notes,
      );
  PartyPayment copyWithCompanion(PartyPaymentsCompanion data) {
    return PartyPayment(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      partyType: data.partyType.present ? data.partyType.value : this.partyType,
      partyId: data.partyId.present ? data.partyId.value : this.partyId,
      amountPaisa:
          data.amountPaisa.present ? data.amountPaisa.value : this.amountPaisa,
      paymentMode:
          data.paymentMode.present ? data.paymentMode.value : this.paymentMode,
      receiptNumber: data.receiptNumber.present
          ? data.receiptNumber.value
          : this.receiptNumber,
      paymentDate:
          data.paymentDate.present ? data.paymentDate.value : this.paymentDate,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PartyPayment(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('remoteId: $remoteId, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('partyType: $partyType, ')
          ..write('partyId: $partyId, ')
          ..write('amountPaisa: $amountPaisa, ')
          ..write('paymentMode: $paymentMode, ')
          ..write('receiptNumber: $receiptNumber, ')
          ..write('paymentDate: $paymentDate, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      createdAt,
      updatedAt,
      syncStatus,
      remoteId,
      isDeleted,
      partyType,
      partyId,
      amountPaisa,
      paymentMode,
      receiptNumber,
      paymentDate,
      notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PartyPayment &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus &&
          other.remoteId == this.remoteId &&
          other.isDeleted == this.isDeleted &&
          other.partyType == this.partyType &&
          other.partyId == this.partyId &&
          other.amountPaisa == this.amountPaisa &&
          other.paymentMode == this.paymentMode &&
          other.receiptNumber == this.receiptNumber &&
          other.paymentDate == this.paymentDate &&
          other.notes == this.notes);
}

class PartyPaymentsCompanion extends UpdateCompanion<PartyPayment> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<SyncStatus> syncStatus;
  final Value<String?> remoteId;
  final Value<bool> isDeleted;
  final Value<String> partyType;
  final Value<String> partyId;
  final Value<int> amountPaisa;
  final Value<String> paymentMode;
  final Value<String> receiptNumber;
  final Value<DateTime> paymentDate;
  final Value<String?> notes;
  final Value<int> rowid;
  const PartyPaymentsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.partyType = const Value.absent(),
    this.partyId = const Value.absent(),
    this.amountPaisa = const Value.absent(),
    this.paymentMode = const Value.absent(),
    this.receiptNumber = const Value.absent(),
    this.paymentDate = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PartyPaymentsCompanion.insert({
    required String id,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.isDeleted = const Value.absent(),
    required String partyType,
    required String partyId,
    required int amountPaisa,
    required String paymentMode,
    required String receiptNumber,
    required DateTime paymentDate,
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        partyType = Value(partyType),
        partyId = Value(partyId),
        amountPaisa = Value(amountPaisa),
        paymentMode = Value(paymentMode),
        receiptNumber = Value(receiptNumber),
        paymentDate = Value(paymentDate);
  static Insertable<PartyPayment> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncStatus,
    Expression<String>? remoteId,
    Expression<bool>? isDeleted,
    Expression<String>? partyType,
    Expression<String>? partyId,
    Expression<int>? amountPaisa,
    Expression<String>? paymentMode,
    Expression<String>? receiptNumber,
    Expression<DateTime>? paymentDate,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (remoteId != null) 'remote_id': remoteId,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (partyType != null) 'party_type': partyType,
      if (partyId != null) 'party_id': partyId,
      if (amountPaisa != null) 'amount_paisa': amountPaisa,
      if (paymentMode != null) 'payment_mode': paymentMode,
      if (receiptNumber != null) 'receipt_number': receiptNumber,
      if (paymentDate != null) 'payment_date': paymentDate,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PartyPaymentsCompanion copyWith(
      {Value<String>? id,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<SyncStatus>? syncStatus,
      Value<String?>? remoteId,
      Value<bool>? isDeleted,
      Value<String>? partyType,
      Value<String>? partyId,
      Value<int>? amountPaisa,
      Value<String>? paymentMode,
      Value<String>? receiptNumber,
      Value<DateTime>? paymentDate,
      Value<String?>? notes,
      Value<int>? rowid}) {
    return PartyPaymentsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      remoteId: remoteId ?? this.remoteId,
      isDeleted: isDeleted ?? this.isDeleted,
      partyType: partyType ?? this.partyType,
      partyId: partyId ?? this.partyId,
      amountPaisa: amountPaisa ?? this.amountPaisa,
      paymentMode: paymentMode ?? this.paymentMode,
      receiptNumber: receiptNumber ?? this.receiptNumber,
      paymentDate: paymentDate ?? this.paymentDate,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(
          $PartyPaymentsTable.$convertersyncStatus.toSql(syncStatus.value));
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (partyType.present) {
      map['party_type'] = Variable<String>(partyType.value);
    }
    if (partyId.present) {
      map['party_id'] = Variable<String>(partyId.value);
    }
    if (amountPaisa.present) {
      map['amount_paisa'] = Variable<int>(amountPaisa.value);
    }
    if (paymentMode.present) {
      map['payment_mode'] = Variable<String>(paymentMode.value);
    }
    if (receiptNumber.present) {
      map['receipt_number'] = Variable<String>(receiptNumber.value);
    }
    if (paymentDate.present) {
      map['payment_date'] = Variable<DateTime>(paymentDate.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PartyPaymentsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('remoteId: $remoteId, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('partyType: $partyType, ')
          ..write('partyId: $partyId, ')
          ..write('amountPaisa: $amountPaisa, ')
          ..write('paymentMode: $paymentMode, ')
          ..write('receiptNumber: $receiptNumber, ')
          ..write('paymentDate: $paymentDate, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalAuthTable extends LocalAuth
    with TableInfo<$LocalAuthTable, LocalAuthData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalAuthTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumnWithTypeConverter<SyncStatus, String> syncStatus =
      GeneratedColumn<String>('sync_status', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: Constant(SyncStatus.pending.name))
          .withConverter<SyncStatus>($LocalAuthTable.$convertersyncStatus);
  static const VerificationMeta _remoteIdMeta =
      const VerificationMeta('remoteId');
  @override
  late final GeneratedColumn<String> remoteId = GeneratedColumn<String>(
      'remote_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _usernameMeta =
      const VerificationMeta('username');
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
      'username', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _passwordHashMeta =
      const VerificationMeta('passwordHash');
  @override
  late final GeneratedColumn<String> passwordHash = GeneratedColumn<String>(
      'password_hash', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _passwordSaltMeta =
      const VerificationMeta('passwordSalt');
  @override
  late final GeneratedColumn<String> passwordSalt = GeneratedColumn<String>(
      'password_salt', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _securityQuestionMeta =
      const VerificationMeta('securityQuestion');
  @override
  late final GeneratedColumn<String> securityQuestion = GeneratedColumn<String>(
      'security_question', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('What is your shop name?'));
  static const VerificationMeta _securityAnswerHashMeta =
      const VerificationMeta('securityAnswerHash');
  @override
  late final GeneratedColumn<String> securityAnswerHash =
      GeneratedColumn<String>('security_answer_hash', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _failedAttemptsMeta =
      const VerificationMeta('failedAttempts');
  @override
  late final GeneratedColumn<int> failedAttempts = GeneratedColumn<int>(
      'failed_attempts', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lockedUntilMeta =
      const VerificationMeta('lockedUntil');
  @override
  late final GeneratedColumn<DateTime> lockedUntil = GeneratedColumn<DateTime>(
      'locked_until', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _displayNameMeta =
      const VerificationMeta('displayName');
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
      'display_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        createdAt,
        updatedAt,
        syncStatus,
        remoteId,
        isDeleted,
        username,
        passwordHash,
        passwordSalt,
        securityQuestion,
        securityAnswerHash,
        failedAttempts,
        lockedUntil,
        displayName
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_auth';
  @override
  VerificationContext validateIntegrity(Insertable<LocalAuthData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    context.handle(_syncStatusMeta, const VerificationResult.success());
    if (data.containsKey('remote_id')) {
      context.handle(_remoteIdMeta,
          remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    if (data.containsKey('username')) {
      context.handle(_usernameMeta,
          username.isAcceptableOrUnknown(data['username']!, _usernameMeta));
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('password_hash')) {
      context.handle(
          _passwordHashMeta,
          passwordHash.isAcceptableOrUnknown(
              data['password_hash']!, _passwordHashMeta));
    } else if (isInserting) {
      context.missing(_passwordHashMeta);
    }
    if (data.containsKey('password_salt')) {
      context.handle(
          _passwordSaltMeta,
          passwordSalt.isAcceptableOrUnknown(
              data['password_salt']!, _passwordSaltMeta));
    } else if (isInserting) {
      context.missing(_passwordSaltMeta);
    }
    if (data.containsKey('security_question')) {
      context.handle(
          _securityQuestionMeta,
          securityQuestion.isAcceptableOrUnknown(
              data['security_question']!, _securityQuestionMeta));
    }
    if (data.containsKey('security_answer_hash')) {
      context.handle(
          _securityAnswerHashMeta,
          securityAnswerHash.isAcceptableOrUnknown(
              data['security_answer_hash']!, _securityAnswerHashMeta));
    }
    if (data.containsKey('failed_attempts')) {
      context.handle(
          _failedAttemptsMeta,
          failedAttempts.isAcceptableOrUnknown(
              data['failed_attempts']!, _failedAttemptsMeta));
    }
    if (data.containsKey('locked_until')) {
      context.handle(
          _lockedUntilMeta,
          lockedUntil.isAcceptableOrUnknown(
              data['locked_until']!, _lockedUntilMeta));
    }
    if (data.containsKey('display_name')) {
      context.handle(
          _displayNameMeta,
          displayName.isAcceptableOrUnknown(
              data['display_name']!, _displayNameMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalAuthData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalAuthData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      syncStatus: $LocalAuthTable.$convertersyncStatus.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!),
      remoteId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}remote_id']),
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
      username: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}username'])!,
      passwordHash: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}password_hash'])!,
      passwordSalt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}password_salt'])!,
      securityQuestion: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}security_question'])!,
      securityAnswerHash: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}security_answer_hash']),
      failedAttempts: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}failed_attempts'])!,
      lockedUntil: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}locked_until']),
      displayName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}display_name']),
    );
  }

  @override
  $LocalAuthTable createAlias(String alias) {
    return $LocalAuthTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SyncStatus, String, String> $convertersyncStatus =
      const EnumNameConverter<SyncStatus>(SyncStatus.values);
}

class LocalAuthData extends DataClass implements Insertable<LocalAuthData> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final SyncStatus syncStatus;
  final String? remoteId;
  final bool isDeleted;
  final String username;
  final String passwordHash;
  final String passwordSalt;
  final String securityQuestion;
  final String? securityAnswerHash;
  final int failedAttempts;
  final DateTime? lockedUntil;
  final String? displayName;
  const LocalAuthData(
      {required this.id,
      required this.createdAt,
      required this.updatedAt,
      required this.syncStatus,
      this.remoteId,
      required this.isDeleted,
      required this.username,
      required this.passwordHash,
      required this.passwordSalt,
      required this.securityQuestion,
      this.securityAnswerHash,
      required this.failedAttempts,
      this.lockedUntil,
      this.displayName});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    {
      map['sync_status'] = Variable<String>(
          $LocalAuthTable.$convertersyncStatus.toSql(syncStatus));
    }
    if (!nullToAbsent || remoteId != null) {
      map['remote_id'] = Variable<String>(remoteId);
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['username'] = Variable<String>(username);
    map['password_hash'] = Variable<String>(passwordHash);
    map['password_salt'] = Variable<String>(passwordSalt);
    map['security_question'] = Variable<String>(securityQuestion);
    if (!nullToAbsent || securityAnswerHash != null) {
      map['security_answer_hash'] = Variable<String>(securityAnswerHash);
    }
    map['failed_attempts'] = Variable<int>(failedAttempts);
    if (!nullToAbsent || lockedUntil != null) {
      map['locked_until'] = Variable<DateTime>(lockedUntil);
    }
    if (!nullToAbsent || displayName != null) {
      map['display_name'] = Variable<String>(displayName);
    }
    return map;
  }

  LocalAuthCompanion toCompanion(bool nullToAbsent) {
    return LocalAuthCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncStatus: Value(syncStatus),
      remoteId: remoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteId),
      isDeleted: Value(isDeleted),
      username: Value(username),
      passwordHash: Value(passwordHash),
      passwordSalt: Value(passwordSalt),
      securityQuestion: Value(securityQuestion),
      securityAnswerHash: securityAnswerHash == null && nullToAbsent
          ? const Value.absent()
          : Value(securityAnswerHash),
      failedAttempts: Value(failedAttempts),
      lockedUntil: lockedUntil == null && nullToAbsent
          ? const Value.absent()
          : Value(lockedUntil),
      displayName: displayName == null && nullToAbsent
          ? const Value.absent()
          : Value(displayName),
    );
  }

  factory LocalAuthData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalAuthData(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncStatus: $LocalAuthTable.$convertersyncStatus
          .fromJson(serializer.fromJson<String>(json['syncStatus'])),
      remoteId: serializer.fromJson<String?>(json['remoteId']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      username: serializer.fromJson<String>(json['username']),
      passwordHash: serializer.fromJson<String>(json['passwordHash']),
      passwordSalt: serializer.fromJson<String>(json['passwordSalt']),
      securityQuestion: serializer.fromJson<String>(json['securityQuestion']),
      securityAnswerHash:
          serializer.fromJson<String?>(json['securityAnswerHash']),
      failedAttempts: serializer.fromJson<int>(json['failedAttempts']),
      lockedUntil: serializer.fromJson<DateTime?>(json['lockedUntil']),
      displayName: serializer.fromJson<String?>(json['displayName']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncStatus': serializer.toJson<String>(
          $LocalAuthTable.$convertersyncStatus.toJson(syncStatus)),
      'remoteId': serializer.toJson<String?>(remoteId),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'username': serializer.toJson<String>(username),
      'passwordHash': serializer.toJson<String>(passwordHash),
      'passwordSalt': serializer.toJson<String>(passwordSalt),
      'securityQuestion': serializer.toJson<String>(securityQuestion),
      'securityAnswerHash': serializer.toJson<String?>(securityAnswerHash),
      'failedAttempts': serializer.toJson<int>(failedAttempts),
      'lockedUntil': serializer.toJson<DateTime?>(lockedUntil),
      'displayName': serializer.toJson<String?>(displayName),
    };
  }

  LocalAuthData copyWith(
          {String? id,
          DateTime? createdAt,
          DateTime? updatedAt,
          SyncStatus? syncStatus,
          Value<String?> remoteId = const Value.absent(),
          bool? isDeleted,
          String? username,
          String? passwordHash,
          String? passwordSalt,
          String? securityQuestion,
          Value<String?> securityAnswerHash = const Value.absent(),
          int? failedAttempts,
          Value<DateTime?> lockedUntil = const Value.absent(),
          Value<String?> displayName = const Value.absent()}) =>
      LocalAuthData(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        syncStatus: syncStatus ?? this.syncStatus,
        remoteId: remoteId.present ? remoteId.value : this.remoteId,
        isDeleted: isDeleted ?? this.isDeleted,
        username: username ?? this.username,
        passwordHash: passwordHash ?? this.passwordHash,
        passwordSalt: passwordSalt ?? this.passwordSalt,
        securityQuestion: securityQuestion ?? this.securityQuestion,
        securityAnswerHash: securityAnswerHash.present
            ? securityAnswerHash.value
            : this.securityAnswerHash,
        failedAttempts: failedAttempts ?? this.failedAttempts,
        lockedUntil: lockedUntil.present ? lockedUntil.value : this.lockedUntil,
        displayName: displayName.present ? displayName.value : this.displayName,
      );
  LocalAuthData copyWithCompanion(LocalAuthCompanion data) {
    return LocalAuthData(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      username: data.username.present ? data.username.value : this.username,
      passwordHash: data.passwordHash.present
          ? data.passwordHash.value
          : this.passwordHash,
      passwordSalt: data.passwordSalt.present
          ? data.passwordSalt.value
          : this.passwordSalt,
      securityQuestion: data.securityQuestion.present
          ? data.securityQuestion.value
          : this.securityQuestion,
      securityAnswerHash: data.securityAnswerHash.present
          ? data.securityAnswerHash.value
          : this.securityAnswerHash,
      failedAttempts: data.failedAttempts.present
          ? data.failedAttempts.value
          : this.failedAttempts,
      lockedUntil:
          data.lockedUntil.present ? data.lockedUntil.value : this.lockedUntil,
      displayName:
          data.displayName.present ? data.displayName.value : this.displayName,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalAuthData(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('remoteId: $remoteId, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('username: $username, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('passwordSalt: $passwordSalt, ')
          ..write('securityQuestion: $securityQuestion, ')
          ..write('securityAnswerHash: $securityAnswerHash, ')
          ..write('failedAttempts: $failedAttempts, ')
          ..write('lockedUntil: $lockedUntil, ')
          ..write('displayName: $displayName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      createdAt,
      updatedAt,
      syncStatus,
      remoteId,
      isDeleted,
      username,
      passwordHash,
      passwordSalt,
      securityQuestion,
      securityAnswerHash,
      failedAttempts,
      lockedUntil,
      displayName);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalAuthData &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus &&
          other.remoteId == this.remoteId &&
          other.isDeleted == this.isDeleted &&
          other.username == this.username &&
          other.passwordHash == this.passwordHash &&
          other.passwordSalt == this.passwordSalt &&
          other.securityQuestion == this.securityQuestion &&
          other.securityAnswerHash == this.securityAnswerHash &&
          other.failedAttempts == this.failedAttempts &&
          other.lockedUntil == this.lockedUntil &&
          other.displayName == this.displayName);
}

class LocalAuthCompanion extends UpdateCompanion<LocalAuthData> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<SyncStatus> syncStatus;
  final Value<String?> remoteId;
  final Value<bool> isDeleted;
  final Value<String> username;
  final Value<String> passwordHash;
  final Value<String> passwordSalt;
  final Value<String> securityQuestion;
  final Value<String?> securityAnswerHash;
  final Value<int> failedAttempts;
  final Value<DateTime?> lockedUntil;
  final Value<String?> displayName;
  final Value<int> rowid;
  const LocalAuthCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.username = const Value.absent(),
    this.passwordHash = const Value.absent(),
    this.passwordSalt = const Value.absent(),
    this.securityQuestion = const Value.absent(),
    this.securityAnswerHash = const Value.absent(),
    this.failedAttempts = const Value.absent(),
    this.lockedUntil = const Value.absent(),
    this.displayName = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalAuthCompanion.insert({
    required String id,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.isDeleted = const Value.absent(),
    required String username,
    required String passwordHash,
    required String passwordSalt,
    this.securityQuestion = const Value.absent(),
    this.securityAnswerHash = const Value.absent(),
    this.failedAttempts = const Value.absent(),
    this.lockedUntil = const Value.absent(),
    this.displayName = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        username = Value(username),
        passwordHash = Value(passwordHash),
        passwordSalt = Value(passwordSalt);
  static Insertable<LocalAuthData> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncStatus,
    Expression<String>? remoteId,
    Expression<bool>? isDeleted,
    Expression<String>? username,
    Expression<String>? passwordHash,
    Expression<String>? passwordSalt,
    Expression<String>? securityQuestion,
    Expression<String>? securityAnswerHash,
    Expression<int>? failedAttempts,
    Expression<DateTime>? lockedUntil,
    Expression<String>? displayName,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (remoteId != null) 'remote_id': remoteId,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (username != null) 'username': username,
      if (passwordHash != null) 'password_hash': passwordHash,
      if (passwordSalt != null) 'password_salt': passwordSalt,
      if (securityQuestion != null) 'security_question': securityQuestion,
      if (securityAnswerHash != null)
        'security_answer_hash': securityAnswerHash,
      if (failedAttempts != null) 'failed_attempts': failedAttempts,
      if (lockedUntil != null) 'locked_until': lockedUntil,
      if (displayName != null) 'display_name': displayName,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalAuthCompanion copyWith(
      {Value<String>? id,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<SyncStatus>? syncStatus,
      Value<String?>? remoteId,
      Value<bool>? isDeleted,
      Value<String>? username,
      Value<String>? passwordHash,
      Value<String>? passwordSalt,
      Value<String>? securityQuestion,
      Value<String?>? securityAnswerHash,
      Value<int>? failedAttempts,
      Value<DateTime?>? lockedUntil,
      Value<String?>? displayName,
      Value<int>? rowid}) {
    return LocalAuthCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      remoteId: remoteId ?? this.remoteId,
      isDeleted: isDeleted ?? this.isDeleted,
      username: username ?? this.username,
      passwordHash: passwordHash ?? this.passwordHash,
      passwordSalt: passwordSalt ?? this.passwordSalt,
      securityQuestion: securityQuestion ?? this.securityQuestion,
      securityAnswerHash: securityAnswerHash ?? this.securityAnswerHash,
      failedAttempts: failedAttempts ?? this.failedAttempts,
      lockedUntil: lockedUntil ?? this.lockedUntil,
      displayName: displayName ?? this.displayName,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(
          $LocalAuthTable.$convertersyncStatus.toSql(syncStatus.value));
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (passwordHash.present) {
      map['password_hash'] = Variable<String>(passwordHash.value);
    }
    if (passwordSalt.present) {
      map['password_salt'] = Variable<String>(passwordSalt.value);
    }
    if (securityQuestion.present) {
      map['security_question'] = Variable<String>(securityQuestion.value);
    }
    if (securityAnswerHash.present) {
      map['security_answer_hash'] = Variable<String>(securityAnswerHash.value);
    }
    if (failedAttempts.present) {
      map['failed_attempts'] = Variable<int>(failedAttempts.value);
    }
    if (lockedUntil.present) {
      map['locked_until'] = Variable<DateTime>(lockedUntil.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalAuthCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('remoteId: $remoteId, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('username: $username, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('passwordSalt: $passwordSalt, ')
          ..write('securityQuestion: $securityQuestion, ')
          ..write('securityAnswerHash: $securityAnswerHash, ')
          ..write('failedAttempts: $failedAttempts, ')
          ..write('lockedUntil: $lockedUntil, ')
          ..write('displayName: $displayName, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PrinterSettingsTable extends PrinterSettings
    with TableInfo<$PrinterSettingsTable, PrinterSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PrinterSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumnWithTypeConverter<SyncStatus, String> syncStatus =
      GeneratedColumn<String>('sync_status', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: Constant(SyncStatus.pending.name))
          .withConverter<SyncStatus>(
              $PrinterSettingsTable.$convertersyncStatus);
  static const VerificationMeta _remoteIdMeta =
      const VerificationMeta('remoteId');
  @override
  late final GeneratedColumn<String> remoteId = GeneratedColumn<String>(
      'remote_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _defaultFormatMeta =
      const VerificationMeta('defaultFormat');
  @override
  late final GeneratedColumn<String> defaultFormat = GeneratedColumn<String>(
      'default_format', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('a4_pdf'));
  static const VerificationMeta _connectionTypeMeta =
      const VerificationMeta('connectionType');
  @override
  late final GeneratedColumn<String> connectionType = GeneratedColumn<String>(
      'connection_type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('network'));
  static const VerificationMeta _ipAddressMeta =
      const VerificationMeta('ipAddress');
  @override
  late final GeneratedColumn<String> ipAddress = GeneratedColumn<String>(
      'ip_address', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('192.168.1.100'));
  static const VerificationMeta _portMeta = const VerificationMeta('port');
  @override
  late final GeneratedColumn<int> port = GeneratedColumn<int>(
      'port', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(9100));
  static const VerificationMeta _usbPrinterNameMeta =
      const VerificationMeta('usbPrinterName');
  @override
  late final GeneratedColumn<String> usbPrinterName = GeneratedColumn<String>(
      'usb_printer_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _paperWidthMeta =
      const VerificationMeta('paperWidth');
  @override
  late final GeneratedColumn<int> paperWidth = GeneratedColumn<int>(
      'paper_width', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(80));
  static const VerificationMeta _printCopiesMeta =
      const VerificationMeta('printCopies');
  @override
  late final GeneratedColumn<int> printCopies = GeneratedColumn<int>(
      'print_copies', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _autoPrintAfterSaleMeta =
      const VerificationMeta('autoPrintAfterSale');
  @override
  late final GeneratedColumn<bool> autoPrintAfterSale = GeneratedColumn<bool>(
      'auto_print_after_sale', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("auto_print_after_sale" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _showNepaliHeaderMeta =
      const VerificationMeta('showNepaliHeader');
  @override
  late final GeneratedColumn<bool> showNepaliHeader = GeneratedColumn<bool>(
      'show_nepali_header', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("show_nepali_header" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _showQrCodeMeta =
      const VerificationMeta('showQrCode');
  @override
  late final GeneratedColumn<bool> showQrCode = GeneratedColumn<bool>(
      'show_qr_code', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("show_qr_code" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _showFooterBrandingMeta =
      const VerificationMeta('showFooterBranding');
  @override
  late final GeneratedColumn<bool> showFooterBranding = GeneratedColumn<bool>(
      'show_footer_branding', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("show_footer_branding" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _enableRasterNepaliMeta =
      const VerificationMeta('enableRasterNepali');
  @override
  late final GeneratedColumn<bool> enableRasterNepali = GeneratedColumn<bool>(
      'enable_raster_nepali', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("enable_raster_nepali" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _cutPaperMeta =
      const VerificationMeta('cutPaper');
  @override
  late final GeneratedColumn<bool> cutPaper = GeneratedColumn<bool>(
      'cut_paper', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("cut_paper" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _feedLinesMeta =
      const VerificationMeta('feedLines');
  @override
  late final GeneratedColumn<int> feedLines = GeneratedColumn<int>(
      'feed_lines', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(3));
  static const VerificationMeta _dpiMeta = const VerificationMeta('dpi');
  @override
  late final GeneratedColumn<int> dpi = GeneratedColumn<int>(
      'dpi', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(203));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        createdAt,
        updatedAt,
        syncStatus,
        remoteId,
        isDeleted,
        defaultFormat,
        connectionType,
        ipAddress,
        port,
        usbPrinterName,
        paperWidth,
        printCopies,
        autoPrintAfterSale,
        showNepaliHeader,
        showQrCode,
        showFooterBranding,
        enableRasterNepali,
        cutPaper,
        feedLines,
        dpi
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'printer_settings';
  @override
  VerificationContext validateIntegrity(Insertable<PrinterSetting> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    context.handle(_syncStatusMeta, const VerificationResult.success());
    if (data.containsKey('remote_id')) {
      context.handle(_remoteIdMeta,
          remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    if (data.containsKey('default_format')) {
      context.handle(
          _defaultFormatMeta,
          defaultFormat.isAcceptableOrUnknown(
              data['default_format']!, _defaultFormatMeta));
    }
    if (data.containsKey('connection_type')) {
      context.handle(
          _connectionTypeMeta,
          connectionType.isAcceptableOrUnknown(
              data['connection_type']!, _connectionTypeMeta));
    }
    if (data.containsKey('ip_address')) {
      context.handle(_ipAddressMeta,
          ipAddress.isAcceptableOrUnknown(data['ip_address']!, _ipAddressMeta));
    }
    if (data.containsKey('port')) {
      context.handle(
          _portMeta, port.isAcceptableOrUnknown(data['port']!, _portMeta));
    }
    if (data.containsKey('usb_printer_name')) {
      context.handle(
          _usbPrinterNameMeta,
          usbPrinterName.isAcceptableOrUnknown(
              data['usb_printer_name']!, _usbPrinterNameMeta));
    }
    if (data.containsKey('paper_width')) {
      context.handle(
          _paperWidthMeta,
          paperWidth.isAcceptableOrUnknown(
              data['paper_width']!, _paperWidthMeta));
    }
    if (data.containsKey('print_copies')) {
      context.handle(
          _printCopiesMeta,
          printCopies.isAcceptableOrUnknown(
              data['print_copies']!, _printCopiesMeta));
    }
    if (data.containsKey('auto_print_after_sale')) {
      context.handle(
          _autoPrintAfterSaleMeta,
          autoPrintAfterSale.isAcceptableOrUnknown(
              data['auto_print_after_sale']!, _autoPrintAfterSaleMeta));
    }
    if (data.containsKey('show_nepali_header')) {
      context.handle(
          _showNepaliHeaderMeta,
          showNepaliHeader.isAcceptableOrUnknown(
              data['show_nepali_header']!, _showNepaliHeaderMeta));
    }
    if (data.containsKey('show_qr_code')) {
      context.handle(
          _showQrCodeMeta,
          showQrCode.isAcceptableOrUnknown(
              data['show_qr_code']!, _showQrCodeMeta));
    }
    if (data.containsKey('show_footer_branding')) {
      context.handle(
          _showFooterBrandingMeta,
          showFooterBranding.isAcceptableOrUnknown(
              data['show_footer_branding']!, _showFooterBrandingMeta));
    }
    if (data.containsKey('enable_raster_nepali')) {
      context.handle(
          _enableRasterNepaliMeta,
          enableRasterNepali.isAcceptableOrUnknown(
              data['enable_raster_nepali']!, _enableRasterNepaliMeta));
    }
    if (data.containsKey('cut_paper')) {
      context.handle(_cutPaperMeta,
          cutPaper.isAcceptableOrUnknown(data['cut_paper']!, _cutPaperMeta));
    }
    if (data.containsKey('feed_lines')) {
      context.handle(_feedLinesMeta,
          feedLines.isAcceptableOrUnknown(data['feed_lines']!, _feedLinesMeta));
    }
    if (data.containsKey('dpi')) {
      context.handle(
          _dpiMeta, dpi.isAcceptableOrUnknown(data['dpi']!, _dpiMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PrinterSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PrinterSetting(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      syncStatus: $PrinterSettingsTable.$convertersyncStatus.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}sync_status'])!),
      remoteId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}remote_id']),
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
      defaultFormat: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}default_format'])!,
      connectionType: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}connection_type'])!,
      ipAddress: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}ip_address'])!,
      port: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}port'])!,
      usbPrinterName: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}usb_printer_name']),
      paperWidth: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}paper_width'])!,
      printCopies: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}print_copies'])!,
      autoPrintAfterSale: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}auto_print_after_sale'])!,
      showNepaliHeader: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}show_nepali_header'])!,
      showQrCode: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}show_qr_code'])!,
      showFooterBranding: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}show_footer_branding'])!,
      enableRasterNepali: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}enable_raster_nepali'])!,
      cutPaper: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}cut_paper'])!,
      feedLines: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}feed_lines'])!,
      dpi: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}dpi'])!,
    );
  }

  @override
  $PrinterSettingsTable createAlias(String alias) {
    return $PrinterSettingsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SyncStatus, String, String> $convertersyncStatus =
      const EnumNameConverter<SyncStatus>(SyncStatus.values);
}

class PrinterSetting extends DataClass implements Insertable<PrinterSetting> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final SyncStatus syncStatus;
  final String? remoteId;
  final bool isDeleted;

  /// Default print format: 'a4_pdf', 'thermal_58', 'thermal_80'
  final String defaultFormat;

  /// Connection type: 'network' or 'usb'
  final String connectionType;

  /// Network printer IP address (e.g., 192.168.1.100)
  final String ipAddress;

  /// Raw ESC/POS port (default standard 9100)
  final int port;

  /// OS printer name for USB connected thermal printer
  final String? usbPrinterName;

  /// Paper width in millimeters: 58 or 80
  final int paperWidth;

  /// Number of copies to print per bill (1 - 3)
  final int printCopies;

  /// Auto-trigger print immediately after a POS bill is saved
  final bool autoPrintAfterSale;

  /// Show Nepali business name on header
  final bool showNepaliHeader;

  /// Show fiscal QR code
  final bool showQrCode;

  /// Show "Powered by Sajilo Billing | NextGen Innovations" footer
  final bool showFooterBranding;

  /// Render receipt with Devanagari text as high-res raster bitmap (GS v 0)
  final bool enableRasterNepali;

  /// Send paper cut command after print
  final bool cutPaper;

  /// Number of trailing blank line feeds before cutting
  final int feedLines;

  /// Printer resolution in dots per inch (typically 203 or 300)
  final int dpi;
  const PrinterSetting(
      {required this.id,
      required this.createdAt,
      required this.updatedAt,
      required this.syncStatus,
      this.remoteId,
      required this.isDeleted,
      required this.defaultFormat,
      required this.connectionType,
      required this.ipAddress,
      required this.port,
      this.usbPrinterName,
      required this.paperWidth,
      required this.printCopies,
      required this.autoPrintAfterSale,
      required this.showNepaliHeader,
      required this.showQrCode,
      required this.showFooterBranding,
      required this.enableRasterNepali,
      required this.cutPaper,
      required this.feedLines,
      required this.dpi});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    {
      map['sync_status'] = Variable<String>(
          $PrinterSettingsTable.$convertersyncStatus.toSql(syncStatus));
    }
    if (!nullToAbsent || remoteId != null) {
      map['remote_id'] = Variable<String>(remoteId);
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['default_format'] = Variable<String>(defaultFormat);
    map['connection_type'] = Variable<String>(connectionType);
    map['ip_address'] = Variable<String>(ipAddress);
    map['port'] = Variable<int>(port);
    if (!nullToAbsent || usbPrinterName != null) {
      map['usb_printer_name'] = Variable<String>(usbPrinterName);
    }
    map['paper_width'] = Variable<int>(paperWidth);
    map['print_copies'] = Variable<int>(printCopies);
    map['auto_print_after_sale'] = Variable<bool>(autoPrintAfterSale);
    map['show_nepali_header'] = Variable<bool>(showNepaliHeader);
    map['show_qr_code'] = Variable<bool>(showQrCode);
    map['show_footer_branding'] = Variable<bool>(showFooterBranding);
    map['enable_raster_nepali'] = Variable<bool>(enableRasterNepali);
    map['cut_paper'] = Variable<bool>(cutPaper);
    map['feed_lines'] = Variable<int>(feedLines);
    map['dpi'] = Variable<int>(dpi);
    return map;
  }

  PrinterSettingsCompanion toCompanion(bool nullToAbsent) {
    return PrinterSettingsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncStatus: Value(syncStatus),
      remoteId: remoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteId),
      isDeleted: Value(isDeleted),
      defaultFormat: Value(defaultFormat),
      connectionType: Value(connectionType),
      ipAddress: Value(ipAddress),
      port: Value(port),
      usbPrinterName: usbPrinterName == null && nullToAbsent
          ? const Value.absent()
          : Value(usbPrinterName),
      paperWidth: Value(paperWidth),
      printCopies: Value(printCopies),
      autoPrintAfterSale: Value(autoPrintAfterSale),
      showNepaliHeader: Value(showNepaliHeader),
      showQrCode: Value(showQrCode),
      showFooterBranding: Value(showFooterBranding),
      enableRasterNepali: Value(enableRasterNepali),
      cutPaper: Value(cutPaper),
      feedLines: Value(feedLines),
      dpi: Value(dpi),
    );
  }

  factory PrinterSetting.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PrinterSetting(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncStatus: $PrinterSettingsTable.$convertersyncStatus
          .fromJson(serializer.fromJson<String>(json['syncStatus'])),
      remoteId: serializer.fromJson<String?>(json['remoteId']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      defaultFormat: serializer.fromJson<String>(json['defaultFormat']),
      connectionType: serializer.fromJson<String>(json['connectionType']),
      ipAddress: serializer.fromJson<String>(json['ipAddress']),
      port: serializer.fromJson<int>(json['port']),
      usbPrinterName: serializer.fromJson<String?>(json['usbPrinterName']),
      paperWidth: serializer.fromJson<int>(json['paperWidth']),
      printCopies: serializer.fromJson<int>(json['printCopies']),
      autoPrintAfterSale: serializer.fromJson<bool>(json['autoPrintAfterSale']),
      showNepaliHeader: serializer.fromJson<bool>(json['showNepaliHeader']),
      showQrCode: serializer.fromJson<bool>(json['showQrCode']),
      showFooterBranding: serializer.fromJson<bool>(json['showFooterBranding']),
      enableRasterNepali: serializer.fromJson<bool>(json['enableRasterNepali']),
      cutPaper: serializer.fromJson<bool>(json['cutPaper']),
      feedLines: serializer.fromJson<int>(json['feedLines']),
      dpi: serializer.fromJson<int>(json['dpi']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncStatus': serializer.toJson<String>(
          $PrinterSettingsTable.$convertersyncStatus.toJson(syncStatus)),
      'remoteId': serializer.toJson<String?>(remoteId),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'defaultFormat': serializer.toJson<String>(defaultFormat),
      'connectionType': serializer.toJson<String>(connectionType),
      'ipAddress': serializer.toJson<String>(ipAddress),
      'port': serializer.toJson<int>(port),
      'usbPrinterName': serializer.toJson<String?>(usbPrinterName),
      'paperWidth': serializer.toJson<int>(paperWidth),
      'printCopies': serializer.toJson<int>(printCopies),
      'autoPrintAfterSale': serializer.toJson<bool>(autoPrintAfterSale),
      'showNepaliHeader': serializer.toJson<bool>(showNepaliHeader),
      'showQrCode': serializer.toJson<bool>(showQrCode),
      'showFooterBranding': serializer.toJson<bool>(showFooterBranding),
      'enableRasterNepali': serializer.toJson<bool>(enableRasterNepali),
      'cutPaper': serializer.toJson<bool>(cutPaper),
      'feedLines': serializer.toJson<int>(feedLines),
      'dpi': serializer.toJson<int>(dpi),
    };
  }

  PrinterSetting copyWith(
          {String? id,
          DateTime? createdAt,
          DateTime? updatedAt,
          SyncStatus? syncStatus,
          Value<String?> remoteId = const Value.absent(),
          bool? isDeleted,
          String? defaultFormat,
          String? connectionType,
          String? ipAddress,
          int? port,
          Value<String?> usbPrinterName = const Value.absent(),
          int? paperWidth,
          int? printCopies,
          bool? autoPrintAfterSale,
          bool? showNepaliHeader,
          bool? showQrCode,
          bool? showFooterBranding,
          bool? enableRasterNepali,
          bool? cutPaper,
          int? feedLines,
          int? dpi}) =>
      PrinterSetting(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        syncStatus: syncStatus ?? this.syncStatus,
        remoteId: remoteId.present ? remoteId.value : this.remoteId,
        isDeleted: isDeleted ?? this.isDeleted,
        defaultFormat: defaultFormat ?? this.defaultFormat,
        connectionType: connectionType ?? this.connectionType,
        ipAddress: ipAddress ?? this.ipAddress,
        port: port ?? this.port,
        usbPrinterName:
            usbPrinterName.present ? usbPrinterName.value : this.usbPrinterName,
        paperWidth: paperWidth ?? this.paperWidth,
        printCopies: printCopies ?? this.printCopies,
        autoPrintAfterSale: autoPrintAfterSale ?? this.autoPrintAfterSale,
        showNepaliHeader: showNepaliHeader ?? this.showNepaliHeader,
        showQrCode: showQrCode ?? this.showQrCode,
        showFooterBranding: showFooterBranding ?? this.showFooterBranding,
        enableRasterNepali: enableRasterNepali ?? this.enableRasterNepali,
        cutPaper: cutPaper ?? this.cutPaper,
        feedLines: feedLines ?? this.feedLines,
        dpi: dpi ?? this.dpi,
      );
  PrinterSetting copyWithCompanion(PrinterSettingsCompanion data) {
    return PrinterSetting(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      defaultFormat: data.defaultFormat.present
          ? data.defaultFormat.value
          : this.defaultFormat,
      connectionType: data.connectionType.present
          ? data.connectionType.value
          : this.connectionType,
      ipAddress: data.ipAddress.present ? data.ipAddress.value : this.ipAddress,
      port: data.port.present ? data.port.value : this.port,
      usbPrinterName: data.usbPrinterName.present
          ? data.usbPrinterName.value
          : this.usbPrinterName,
      paperWidth:
          data.paperWidth.present ? data.paperWidth.value : this.paperWidth,
      printCopies:
          data.printCopies.present ? data.printCopies.value : this.printCopies,
      autoPrintAfterSale: data.autoPrintAfterSale.present
          ? data.autoPrintAfterSale.value
          : this.autoPrintAfterSale,
      showNepaliHeader: data.showNepaliHeader.present
          ? data.showNepaliHeader.value
          : this.showNepaliHeader,
      showQrCode:
          data.showQrCode.present ? data.showQrCode.value : this.showQrCode,
      showFooterBranding: data.showFooterBranding.present
          ? data.showFooterBranding.value
          : this.showFooterBranding,
      enableRasterNepali: data.enableRasterNepali.present
          ? data.enableRasterNepali.value
          : this.enableRasterNepali,
      cutPaper: data.cutPaper.present ? data.cutPaper.value : this.cutPaper,
      feedLines: data.feedLines.present ? data.feedLines.value : this.feedLines,
      dpi: data.dpi.present ? data.dpi.value : this.dpi,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PrinterSetting(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('remoteId: $remoteId, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('defaultFormat: $defaultFormat, ')
          ..write('connectionType: $connectionType, ')
          ..write('ipAddress: $ipAddress, ')
          ..write('port: $port, ')
          ..write('usbPrinterName: $usbPrinterName, ')
          ..write('paperWidth: $paperWidth, ')
          ..write('printCopies: $printCopies, ')
          ..write('autoPrintAfterSale: $autoPrintAfterSale, ')
          ..write('showNepaliHeader: $showNepaliHeader, ')
          ..write('showQrCode: $showQrCode, ')
          ..write('showFooterBranding: $showFooterBranding, ')
          ..write('enableRasterNepali: $enableRasterNepali, ')
          ..write('cutPaper: $cutPaper, ')
          ..write('feedLines: $feedLines, ')
          ..write('dpi: $dpi')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        createdAt,
        updatedAt,
        syncStatus,
        remoteId,
        isDeleted,
        defaultFormat,
        connectionType,
        ipAddress,
        port,
        usbPrinterName,
        paperWidth,
        printCopies,
        autoPrintAfterSale,
        showNepaliHeader,
        showQrCode,
        showFooterBranding,
        enableRasterNepali,
        cutPaper,
        feedLines,
        dpi
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PrinterSetting &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus &&
          other.remoteId == this.remoteId &&
          other.isDeleted == this.isDeleted &&
          other.defaultFormat == this.defaultFormat &&
          other.connectionType == this.connectionType &&
          other.ipAddress == this.ipAddress &&
          other.port == this.port &&
          other.usbPrinterName == this.usbPrinterName &&
          other.paperWidth == this.paperWidth &&
          other.printCopies == this.printCopies &&
          other.autoPrintAfterSale == this.autoPrintAfterSale &&
          other.showNepaliHeader == this.showNepaliHeader &&
          other.showQrCode == this.showQrCode &&
          other.showFooterBranding == this.showFooterBranding &&
          other.enableRasterNepali == this.enableRasterNepali &&
          other.cutPaper == this.cutPaper &&
          other.feedLines == this.feedLines &&
          other.dpi == this.dpi);
}

class PrinterSettingsCompanion extends UpdateCompanion<PrinterSetting> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<SyncStatus> syncStatus;
  final Value<String?> remoteId;
  final Value<bool> isDeleted;
  final Value<String> defaultFormat;
  final Value<String> connectionType;
  final Value<String> ipAddress;
  final Value<int> port;
  final Value<String?> usbPrinterName;
  final Value<int> paperWidth;
  final Value<int> printCopies;
  final Value<bool> autoPrintAfterSale;
  final Value<bool> showNepaliHeader;
  final Value<bool> showQrCode;
  final Value<bool> showFooterBranding;
  final Value<bool> enableRasterNepali;
  final Value<bool> cutPaper;
  final Value<int> feedLines;
  final Value<int> dpi;
  final Value<int> rowid;
  const PrinterSettingsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.defaultFormat = const Value.absent(),
    this.connectionType = const Value.absent(),
    this.ipAddress = const Value.absent(),
    this.port = const Value.absent(),
    this.usbPrinterName = const Value.absent(),
    this.paperWidth = const Value.absent(),
    this.printCopies = const Value.absent(),
    this.autoPrintAfterSale = const Value.absent(),
    this.showNepaliHeader = const Value.absent(),
    this.showQrCode = const Value.absent(),
    this.showFooterBranding = const Value.absent(),
    this.enableRasterNepali = const Value.absent(),
    this.cutPaper = const Value.absent(),
    this.feedLines = const Value.absent(),
    this.dpi = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PrinterSettingsCompanion.insert({
    required String id,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.defaultFormat = const Value.absent(),
    this.connectionType = const Value.absent(),
    this.ipAddress = const Value.absent(),
    this.port = const Value.absent(),
    this.usbPrinterName = const Value.absent(),
    this.paperWidth = const Value.absent(),
    this.printCopies = const Value.absent(),
    this.autoPrintAfterSale = const Value.absent(),
    this.showNepaliHeader = const Value.absent(),
    this.showQrCode = const Value.absent(),
    this.showFooterBranding = const Value.absent(),
    this.enableRasterNepali = const Value.absent(),
    this.cutPaper = const Value.absent(),
    this.feedLines = const Value.absent(),
    this.dpi = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<PrinterSetting> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncStatus,
    Expression<String>? remoteId,
    Expression<bool>? isDeleted,
    Expression<String>? defaultFormat,
    Expression<String>? connectionType,
    Expression<String>? ipAddress,
    Expression<int>? port,
    Expression<String>? usbPrinterName,
    Expression<int>? paperWidth,
    Expression<int>? printCopies,
    Expression<bool>? autoPrintAfterSale,
    Expression<bool>? showNepaliHeader,
    Expression<bool>? showQrCode,
    Expression<bool>? showFooterBranding,
    Expression<bool>? enableRasterNepali,
    Expression<bool>? cutPaper,
    Expression<int>? feedLines,
    Expression<int>? dpi,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (remoteId != null) 'remote_id': remoteId,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (defaultFormat != null) 'default_format': defaultFormat,
      if (connectionType != null) 'connection_type': connectionType,
      if (ipAddress != null) 'ip_address': ipAddress,
      if (port != null) 'port': port,
      if (usbPrinterName != null) 'usb_printer_name': usbPrinterName,
      if (paperWidth != null) 'paper_width': paperWidth,
      if (printCopies != null) 'print_copies': printCopies,
      if (autoPrintAfterSale != null)
        'auto_print_after_sale': autoPrintAfterSale,
      if (showNepaliHeader != null) 'show_nepali_header': showNepaliHeader,
      if (showQrCode != null) 'show_qr_code': showQrCode,
      if (showFooterBranding != null)
        'show_footer_branding': showFooterBranding,
      if (enableRasterNepali != null)
        'enable_raster_nepali': enableRasterNepali,
      if (cutPaper != null) 'cut_paper': cutPaper,
      if (feedLines != null) 'feed_lines': feedLines,
      if (dpi != null) 'dpi': dpi,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PrinterSettingsCompanion copyWith(
      {Value<String>? id,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<SyncStatus>? syncStatus,
      Value<String?>? remoteId,
      Value<bool>? isDeleted,
      Value<String>? defaultFormat,
      Value<String>? connectionType,
      Value<String>? ipAddress,
      Value<int>? port,
      Value<String?>? usbPrinterName,
      Value<int>? paperWidth,
      Value<int>? printCopies,
      Value<bool>? autoPrintAfterSale,
      Value<bool>? showNepaliHeader,
      Value<bool>? showQrCode,
      Value<bool>? showFooterBranding,
      Value<bool>? enableRasterNepali,
      Value<bool>? cutPaper,
      Value<int>? feedLines,
      Value<int>? dpi,
      Value<int>? rowid}) {
    return PrinterSettingsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      remoteId: remoteId ?? this.remoteId,
      isDeleted: isDeleted ?? this.isDeleted,
      defaultFormat: defaultFormat ?? this.defaultFormat,
      connectionType: connectionType ?? this.connectionType,
      ipAddress: ipAddress ?? this.ipAddress,
      port: port ?? this.port,
      usbPrinterName: usbPrinterName ?? this.usbPrinterName,
      paperWidth: paperWidth ?? this.paperWidth,
      printCopies: printCopies ?? this.printCopies,
      autoPrintAfterSale: autoPrintAfterSale ?? this.autoPrintAfterSale,
      showNepaliHeader: showNepaliHeader ?? this.showNepaliHeader,
      showQrCode: showQrCode ?? this.showQrCode,
      showFooterBranding: showFooterBranding ?? this.showFooterBranding,
      enableRasterNepali: enableRasterNepali ?? this.enableRasterNepali,
      cutPaper: cutPaper ?? this.cutPaper,
      feedLines: feedLines ?? this.feedLines,
      dpi: dpi ?? this.dpi,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(
          $PrinterSettingsTable.$convertersyncStatus.toSql(syncStatus.value));
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (defaultFormat.present) {
      map['default_format'] = Variable<String>(defaultFormat.value);
    }
    if (connectionType.present) {
      map['connection_type'] = Variable<String>(connectionType.value);
    }
    if (ipAddress.present) {
      map['ip_address'] = Variable<String>(ipAddress.value);
    }
    if (port.present) {
      map['port'] = Variable<int>(port.value);
    }
    if (usbPrinterName.present) {
      map['usb_printer_name'] = Variable<String>(usbPrinterName.value);
    }
    if (paperWidth.present) {
      map['paper_width'] = Variable<int>(paperWidth.value);
    }
    if (printCopies.present) {
      map['print_copies'] = Variable<int>(printCopies.value);
    }
    if (autoPrintAfterSale.present) {
      map['auto_print_after_sale'] = Variable<bool>(autoPrintAfterSale.value);
    }
    if (showNepaliHeader.present) {
      map['show_nepali_header'] = Variable<bool>(showNepaliHeader.value);
    }
    if (showQrCode.present) {
      map['show_qr_code'] = Variable<bool>(showQrCode.value);
    }
    if (showFooterBranding.present) {
      map['show_footer_branding'] = Variable<bool>(showFooterBranding.value);
    }
    if (enableRasterNepali.present) {
      map['enable_raster_nepali'] = Variable<bool>(enableRasterNepali.value);
    }
    if (cutPaper.present) {
      map['cut_paper'] = Variable<bool>(cutPaper.value);
    }
    if (feedLines.present) {
      map['feed_lines'] = Variable<int>(feedLines.value);
    }
    if (dpi.present) {
      map['dpi'] = Variable<int>(dpi.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PrinterSettingsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('remoteId: $remoteId, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('defaultFormat: $defaultFormat, ')
          ..write('connectionType: $connectionType, ')
          ..write('ipAddress: $ipAddress, ')
          ..write('port: $port, ')
          ..write('usbPrinterName: $usbPrinterName, ')
          ..write('paperWidth: $paperWidth, ')
          ..write('printCopies: $printCopies, ')
          ..write('autoPrintAfterSale: $autoPrintAfterSale, ')
          ..write('showNepaliHeader: $showNepaliHeader, ')
          ..write('showQrCode: $showQrCode, ')
          ..write('showFooterBranding: $showFooterBranding, ')
          ..write('enableRasterNepali: $enableRasterNepali, ')
          ..write('cutPaper: $cutPaper, ')
          ..write('feedLines: $feedLines, ')
          ..write('dpi: $dpi, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncQueueItemsTable extends SyncQueueItems
    with TableInfo<$SyncQueueItemsTable, SyncQueueItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _opTypeMeta = const VerificationMeta('opType');
  @override
  late final GeneratedColumn<String> opType = GeneratedColumn<String>(
      'op_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _payloadJsonMeta =
      const VerificationMeta('payloadJson');
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
      'payload_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _idempotencyKeyMeta =
      const VerificationMeta('idempotencyKey');
  @override
  late final GeneratedColumn<String> idempotencyKey = GeneratedColumn<String>(
      'idempotency_key', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('PENDING'));
  static const VerificationMeta _attemptsMeta =
      const VerificationMeta('attempts');
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
      'attempts', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lastErrorMeta =
      const VerificationMeta('lastError');
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
      'last_error', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _syncedAtMeta =
      const VerificationMeta('syncedAt');
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
      'synced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _serverResponseJsonMeta =
      const VerificationMeta('serverResponseJson');
  @override
  late final GeneratedColumn<String> serverResponseJson =
      GeneratedColumn<String>('server_response_json', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        opType,
        payloadJson,
        idempotencyKey,
        status,
        attempts,
        lastError,
        createdAt,
        syncedAt,
        serverResponseJson
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue_items';
  @override
  VerificationContext validateIntegrity(Insertable<SyncQueueItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('op_type')) {
      context.handle(_opTypeMeta,
          opType.isAcceptableOrUnknown(data['op_type']!, _opTypeMeta));
    } else if (isInserting) {
      context.missing(_opTypeMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
          _payloadJsonMeta,
          payloadJson.isAcceptableOrUnknown(
              data['payload_json']!, _payloadJsonMeta));
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    if (data.containsKey('idempotency_key')) {
      context.handle(
          _idempotencyKeyMeta,
          idempotencyKey.isAcceptableOrUnknown(
              data['idempotency_key']!, _idempotencyKeyMeta));
    } else if (isInserting) {
      context.missing(_idempotencyKeyMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('attempts')) {
      context.handle(_attemptsMeta,
          attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta));
    }
    if (data.containsKey('last_error')) {
      context.handle(_lastErrorMeta,
          lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('synced_at')) {
      context.handle(_syncedAtMeta,
          syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta));
    }
    if (data.containsKey('server_response_json')) {
      context.handle(
          _serverResponseJsonMeta,
          serverResponseJson.isAcceptableOrUnknown(
              data['server_response_json']!, _serverResponseJsonMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncQueueItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueueItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      opType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}op_type'])!,
      payloadJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payload_json'])!,
      idempotencyKey: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}idempotency_key'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      attempts: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}attempts'])!,
      lastError: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_error']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      syncedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}synced_at']),
      serverResponseJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}server_response_json']),
    );
  }

  @override
  $SyncQueueItemsTable createAlias(String alias) {
    return $SyncQueueItemsTable(attachedDatabase, alias);
  }
}

class SyncQueueItem extends DataClass implements Insertable<SyncQueueItem> {
  final int id;
  final String opType;
  final String payloadJson;
  final String idempotencyKey;
  final String status;
  final int attempts;
  final String? lastError;
  final DateTime createdAt;
  final DateTime? syncedAt;
  final String? serverResponseJson;
  const SyncQueueItem(
      {required this.id,
      required this.opType,
      required this.payloadJson,
      required this.idempotencyKey,
      required this.status,
      required this.attempts,
      this.lastError,
      required this.createdAt,
      this.syncedAt,
      this.serverResponseJson});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['op_type'] = Variable<String>(opType);
    map['payload_json'] = Variable<String>(payloadJson);
    map['idempotency_key'] = Variable<String>(idempotencyKey);
    map['status'] = Variable<String>(status);
    map['attempts'] = Variable<int>(attempts);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    if (!nullToAbsent || serverResponseJson != null) {
      map['server_response_json'] = Variable<String>(serverResponseJson);
    }
    return map;
  }

  SyncQueueItemsCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueItemsCompanion(
      id: Value(id),
      opType: Value(opType),
      payloadJson: Value(payloadJson),
      idempotencyKey: Value(idempotencyKey),
      status: Value(status),
      attempts: Value(attempts),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      createdAt: Value(createdAt),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
      serverResponseJson: serverResponseJson == null && nullToAbsent
          ? const Value.absent()
          : Value(serverResponseJson),
    );
  }

  factory SyncQueueItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncQueueItem(
      id: serializer.fromJson<int>(json['id']),
      opType: serializer.fromJson<String>(json['opType']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      idempotencyKey: serializer.fromJson<String>(json['idempotencyKey']),
      status: serializer.fromJson<String>(json['status']),
      attempts: serializer.fromJson<int>(json['attempts']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
      serverResponseJson:
          serializer.fromJson<String?>(json['serverResponseJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'opType': serializer.toJson<String>(opType),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'idempotencyKey': serializer.toJson<String>(idempotencyKey),
      'status': serializer.toJson<String>(status),
      'attempts': serializer.toJson<int>(attempts),
      'lastError': serializer.toJson<String?>(lastError),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
      'serverResponseJson': serializer.toJson<String?>(serverResponseJson),
    };
  }

  SyncQueueItem copyWith(
          {int? id,
          String? opType,
          String? payloadJson,
          String? idempotencyKey,
          String? status,
          int? attempts,
          Value<String?> lastError = const Value.absent(),
          DateTime? createdAt,
          Value<DateTime?> syncedAt = const Value.absent(),
          Value<String?> serverResponseJson = const Value.absent()}) =>
      SyncQueueItem(
        id: id ?? this.id,
        opType: opType ?? this.opType,
        payloadJson: payloadJson ?? this.payloadJson,
        idempotencyKey: idempotencyKey ?? this.idempotencyKey,
        status: status ?? this.status,
        attempts: attempts ?? this.attempts,
        lastError: lastError.present ? lastError.value : this.lastError,
        createdAt: createdAt ?? this.createdAt,
        syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
        serverResponseJson: serverResponseJson.present
            ? serverResponseJson.value
            : this.serverResponseJson,
      );
  SyncQueueItem copyWithCompanion(SyncQueueItemsCompanion data) {
    return SyncQueueItem(
      id: data.id.present ? data.id.value : this.id,
      opType: data.opType.present ? data.opType.value : this.opType,
      payloadJson:
          data.payloadJson.present ? data.payloadJson.value : this.payloadJson,
      idempotencyKey: data.idempotencyKey.present
          ? data.idempotencyKey.value
          : this.idempotencyKey,
      status: data.status.present ? data.status.value : this.status,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
      serverResponseJson: data.serverResponseJson.present
          ? data.serverResponseJson.value
          : this.serverResponseJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueItem(')
          ..write('id: $id, ')
          ..write('opType: $opType, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('status: $status, ')
          ..write('attempts: $attempts, ')
          ..write('lastError: $lastError, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('serverResponseJson: $serverResponseJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, opType, payloadJson, idempotencyKey,
      status, attempts, lastError, createdAt, syncedAt, serverResponseJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueItem &&
          other.id == this.id &&
          other.opType == this.opType &&
          other.payloadJson == this.payloadJson &&
          other.idempotencyKey == this.idempotencyKey &&
          other.status == this.status &&
          other.attempts == this.attempts &&
          other.lastError == this.lastError &&
          other.createdAt == this.createdAt &&
          other.syncedAt == this.syncedAt &&
          other.serverResponseJson == this.serverResponseJson);
}

class SyncQueueItemsCompanion extends UpdateCompanion<SyncQueueItem> {
  final Value<int> id;
  final Value<String> opType;
  final Value<String> payloadJson;
  final Value<String> idempotencyKey;
  final Value<String> status;
  final Value<int> attempts;
  final Value<String?> lastError;
  final Value<DateTime> createdAt;
  final Value<DateTime?> syncedAt;
  final Value<String?> serverResponseJson;
  const SyncQueueItemsCompanion({
    this.id = const Value.absent(),
    this.opType = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.idempotencyKey = const Value.absent(),
    this.status = const Value.absent(),
    this.attempts = const Value.absent(),
    this.lastError = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.serverResponseJson = const Value.absent(),
  });
  SyncQueueItemsCompanion.insert({
    this.id = const Value.absent(),
    required String opType,
    required String payloadJson,
    required String idempotencyKey,
    this.status = const Value.absent(),
    this.attempts = const Value.absent(),
    this.lastError = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.serverResponseJson = const Value.absent(),
  })  : opType = Value(opType),
        payloadJson = Value(payloadJson),
        idempotencyKey = Value(idempotencyKey);
  static Insertable<SyncQueueItem> custom({
    Expression<int>? id,
    Expression<String>? opType,
    Expression<String>? payloadJson,
    Expression<String>? idempotencyKey,
    Expression<String>? status,
    Expression<int>? attempts,
    Expression<String>? lastError,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? syncedAt,
    Expression<String>? serverResponseJson,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (opType != null) 'op_type': opType,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (idempotencyKey != null) 'idempotency_key': idempotencyKey,
      if (status != null) 'status': status,
      if (attempts != null) 'attempts': attempts,
      if (lastError != null) 'last_error': lastError,
      if (createdAt != null) 'created_at': createdAt,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (serverResponseJson != null)
        'server_response_json': serverResponseJson,
    });
  }

  SyncQueueItemsCompanion copyWith(
      {Value<int>? id,
      Value<String>? opType,
      Value<String>? payloadJson,
      Value<String>? idempotencyKey,
      Value<String>? status,
      Value<int>? attempts,
      Value<String?>? lastError,
      Value<DateTime>? createdAt,
      Value<DateTime?>? syncedAt,
      Value<String?>? serverResponseJson}) {
    return SyncQueueItemsCompanion(
      id: id ?? this.id,
      opType: opType ?? this.opType,
      payloadJson: payloadJson ?? this.payloadJson,
      idempotencyKey: idempotencyKey ?? this.idempotencyKey,
      status: status ?? this.status,
      attempts: attempts ?? this.attempts,
      lastError: lastError ?? this.lastError,
      createdAt: createdAt ?? this.createdAt,
      syncedAt: syncedAt ?? this.syncedAt,
      serverResponseJson: serverResponseJson ?? this.serverResponseJson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (opType.present) {
      map['op_type'] = Variable<String>(opType.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (idempotencyKey.present) {
      map['idempotency_key'] = Variable<String>(idempotencyKey.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (serverResponseJson.present) {
      map['server_response_json'] = Variable<String>(serverResponseJson.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueItemsCompanion(')
          ..write('id: $id, ')
          ..write('opType: $opType, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('status: $status, ')
          ..write('attempts: $attempts, ')
          ..write('lastError: $lastError, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('serverResponseJson: $serverResponseJson')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $BusinessProfilesTable businessProfiles =
      $BusinessProfilesTable(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $UnitsTable units = $UnitsTable(this);
  late final $ItemsTable items = $ItemsTable(this);
  late final $InventoriesTable inventories = $InventoriesTable(this);
  late final $SuppliersTable suppliers = $SuppliersTable(this);
  late final $CustomersTable customers = $CustomersTable(this);
  late final $StockLedgerTable stockLedger = $StockLedgerTable(this);
  late final $StockAdjustmentsTable stockAdjustments =
      $StockAdjustmentsTable(this);
  late final $PurchasesTable purchases = $PurchasesTable(this);
  late final $PurchaseItemsTable purchaseItems = $PurchaseItemsTable(this);
  late final $SalesTable sales = $SalesTable(this);
  late final $SaleItemsTable saleItems = $SaleItemsTable(this);
  late final $BillMetadataTable billMetadata = $BillMetadataTable(this);
  late final $BillSequenceTable billSequence = $BillSequenceTable(this);
  late final $BackupLogsTable backupLogs = $BackupLogsTable(this);
  late final $PartyLedgerTable partyLedger = $PartyLedgerTable(this);
  late final $PartyPaymentsTable partyPayments = $PartyPaymentsTable(this);
  late final $LocalAuthTable localAuth = $LocalAuthTable(this);
  late final $PrinterSettingsTable printerSettings =
      $PrinterSettingsTable(this);
  late final $SyncQueueItemsTable syncQueueItems = $SyncQueueItemsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        businessProfiles,
        categories,
        units,
        items,
        inventories,
        suppliers,
        customers,
        stockLedger,
        stockAdjustments,
        purchases,
        purchaseItems,
        sales,
        saleItems,
        billMetadata,
        billSequence,
        backupLogs,
        partyLedger,
        partyPayments,
        localAuth,
        printerSettings,
        syncQueueItems
      ];
}

typedef $$BusinessProfilesTableCreateCompanionBuilder
    = BusinessProfilesCompanion Function({
  required String id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<SyncStatus> syncStatus,
  Value<String?> remoteId,
  Value<bool> isDeleted,
  required String businessName,
  Value<String?> businessNameNepali,
  required String panVatNumber,
  required String contactNumber,
  Value<String?> shopAddress,
  Value<String?> logoPath,
  Value<bool> isCurrent,
  Value<int> rowid,
});
typedef $$BusinessProfilesTableUpdateCompanionBuilder
    = BusinessProfilesCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<SyncStatus> syncStatus,
  Value<String?> remoteId,
  Value<bool> isDeleted,
  Value<String> businessName,
  Value<String?> businessNameNepali,
  Value<String> panVatNumber,
  Value<String> contactNumber,
  Value<String?> shopAddress,
  Value<String?> logoPath,
  Value<bool> isCurrent,
  Value<int> rowid,
});

class $$BusinessProfilesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BusinessProfilesTable,
    BusinessProfile,
    $$BusinessProfilesTableFilterComposer,
    $$BusinessProfilesTableOrderingComposer,
    $$BusinessProfilesTableCreateCompanionBuilder,
    $$BusinessProfilesTableUpdateCompanionBuilder> {
  $$BusinessProfilesTableTableManager(
      _$AppDatabase db, $BusinessProfilesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$BusinessProfilesTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$BusinessProfilesTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<SyncStatus> syncStatus = const Value.absent(),
            Value<String?> remoteId = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<String> businessName = const Value.absent(),
            Value<String?> businessNameNepali = const Value.absent(),
            Value<String> panVatNumber = const Value.absent(),
            Value<String> contactNumber = const Value.absent(),
            Value<String?> shopAddress = const Value.absent(),
            Value<String?> logoPath = const Value.absent(),
            Value<bool> isCurrent = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BusinessProfilesCompanion(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            remoteId: remoteId,
            isDeleted: isDeleted,
            businessName: businessName,
            businessNameNepali: businessNameNepali,
            panVatNumber: panVatNumber,
            contactNumber: contactNumber,
            shopAddress: shopAddress,
            logoPath: logoPath,
            isCurrent: isCurrent,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<SyncStatus> syncStatus = const Value.absent(),
            Value<String?> remoteId = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            required String businessName,
            Value<String?> businessNameNepali = const Value.absent(),
            required String panVatNumber,
            required String contactNumber,
            Value<String?> shopAddress = const Value.absent(),
            Value<String?> logoPath = const Value.absent(),
            Value<bool> isCurrent = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BusinessProfilesCompanion.insert(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            remoteId: remoteId,
            isDeleted: isDeleted,
            businessName: businessName,
            businessNameNepali: businessNameNepali,
            panVatNumber: panVatNumber,
            contactNumber: contactNumber,
            shopAddress: shopAddress,
            logoPath: logoPath,
            isCurrent: isCurrent,
            rowid: rowid,
          ),
        ));
}

class $$BusinessProfilesTableFilterComposer
    extends FilterComposer<_$AppDatabase, $BusinessProfilesTable> {
  $$BusinessProfilesTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<SyncStatus, SyncStatus, String>
      get syncStatus => $state.composableBuilder(
          column: $state.table.syncStatus,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnFilters<String> get remoteId => $state.composableBuilder(
      column: $state.table.remoteId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isDeleted => $state.composableBuilder(
      column: $state.table.isDeleted,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get businessName => $state.composableBuilder(
      column: $state.table.businessName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get businessNameNepali => $state.composableBuilder(
      column: $state.table.businessNameNepali,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get panVatNumber => $state.composableBuilder(
      column: $state.table.panVatNumber,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get contactNumber => $state.composableBuilder(
      column: $state.table.contactNumber,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get shopAddress => $state.composableBuilder(
      column: $state.table.shopAddress,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get logoPath => $state.composableBuilder(
      column: $state.table.logoPath,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isCurrent => $state.composableBuilder(
      column: $state.table.isCurrent,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$BusinessProfilesTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $BusinessProfilesTable> {
  $$BusinessProfilesTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get syncStatus => $state.composableBuilder(
      column: $state.table.syncStatus,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get remoteId => $state.composableBuilder(
      column: $state.table.remoteId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isDeleted => $state.composableBuilder(
      column: $state.table.isDeleted,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get businessName => $state.composableBuilder(
      column: $state.table.businessName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get businessNameNepali => $state.composableBuilder(
      column: $state.table.businessNameNepali,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get panVatNumber => $state.composableBuilder(
      column: $state.table.panVatNumber,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get contactNumber => $state.composableBuilder(
      column: $state.table.contactNumber,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get shopAddress => $state.composableBuilder(
      column: $state.table.shopAddress,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get logoPath => $state.composableBuilder(
      column: $state.table.logoPath,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isCurrent => $state.composableBuilder(
      column: $state.table.isCurrent,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$CategoriesTableCreateCompanionBuilder = CategoriesCompanion Function({
  required String id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<SyncStatus> syncStatus,
  Value<String?> remoteId,
  Value<bool> isDeleted,
  required String name,
  Value<String?> nepaliName,
  Value<String?> description,
  Value<int> rowid,
});
typedef $$CategoriesTableUpdateCompanionBuilder = CategoriesCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<SyncStatus> syncStatus,
  Value<String?> remoteId,
  Value<bool> isDeleted,
  Value<String> name,
  Value<String?> nepaliName,
  Value<String?> description,
  Value<int> rowid,
});

class $$CategoriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CategoriesTable,
    Category,
    $$CategoriesTableFilterComposer,
    $$CategoriesTableOrderingComposer,
    $$CategoriesTableCreateCompanionBuilder,
    $$CategoriesTableUpdateCompanionBuilder> {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$CategoriesTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$CategoriesTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<SyncStatus> syncStatus = const Value.absent(),
            Value<String?> remoteId = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> nepaliName = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CategoriesCompanion(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            remoteId: remoteId,
            isDeleted: isDeleted,
            name: name,
            nepaliName: nepaliName,
            description: description,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<SyncStatus> syncStatus = const Value.absent(),
            Value<String?> remoteId = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            required String name,
            Value<String?> nepaliName = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CategoriesCompanion.insert(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            remoteId: remoteId,
            isDeleted: isDeleted,
            name: name,
            nepaliName: nepaliName,
            description: description,
            rowid: rowid,
          ),
        ));
}

class $$CategoriesTableFilterComposer
    extends FilterComposer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<SyncStatus, SyncStatus, String>
      get syncStatus => $state.composableBuilder(
          column: $state.table.syncStatus,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnFilters<String> get remoteId => $state.composableBuilder(
      column: $state.table.remoteId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isDeleted => $state.composableBuilder(
      column: $state.table.isDeleted,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get nepaliName => $state.composableBuilder(
      column: $state.table.nepaliName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get description => $state.composableBuilder(
      column: $state.table.description,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$CategoriesTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get syncStatus => $state.composableBuilder(
      column: $state.table.syncStatus,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get remoteId => $state.composableBuilder(
      column: $state.table.remoteId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isDeleted => $state.composableBuilder(
      column: $state.table.isDeleted,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get nepaliName => $state.composableBuilder(
      column: $state.table.nepaliName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get description => $state.composableBuilder(
      column: $state.table.description,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$UnitsTableCreateCompanionBuilder = UnitsCompanion Function({
  required String id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<SyncStatus> syncStatus,
  Value<String?> remoteId,
  Value<bool> isDeleted,
  required String name,
  required String symbol,
  Value<String?> nepaliSymbol,
  Value<bool> isFractional,
  Value<int> rowid,
});
typedef $$UnitsTableUpdateCompanionBuilder = UnitsCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<SyncStatus> syncStatus,
  Value<String?> remoteId,
  Value<bool> isDeleted,
  Value<String> name,
  Value<String> symbol,
  Value<String?> nepaliSymbol,
  Value<bool> isFractional,
  Value<int> rowid,
});

class $$UnitsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UnitsTable,
    Unit,
    $$UnitsTableFilterComposer,
    $$UnitsTableOrderingComposer,
    $$UnitsTableCreateCompanionBuilder,
    $$UnitsTableUpdateCompanionBuilder> {
  $$UnitsTableTableManager(_$AppDatabase db, $UnitsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$UnitsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$UnitsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<SyncStatus> syncStatus = const Value.absent(),
            Value<String?> remoteId = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> symbol = const Value.absent(),
            Value<String?> nepaliSymbol = const Value.absent(),
            Value<bool> isFractional = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UnitsCompanion(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            remoteId: remoteId,
            isDeleted: isDeleted,
            name: name,
            symbol: symbol,
            nepaliSymbol: nepaliSymbol,
            isFractional: isFractional,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<SyncStatus> syncStatus = const Value.absent(),
            Value<String?> remoteId = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            required String name,
            required String symbol,
            Value<String?> nepaliSymbol = const Value.absent(),
            Value<bool> isFractional = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UnitsCompanion.insert(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            remoteId: remoteId,
            isDeleted: isDeleted,
            name: name,
            symbol: symbol,
            nepaliSymbol: nepaliSymbol,
            isFractional: isFractional,
            rowid: rowid,
          ),
        ));
}

class $$UnitsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $UnitsTable> {
  $$UnitsTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<SyncStatus, SyncStatus, String>
      get syncStatus => $state.composableBuilder(
          column: $state.table.syncStatus,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnFilters<String> get remoteId => $state.composableBuilder(
      column: $state.table.remoteId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isDeleted => $state.composableBuilder(
      column: $state.table.isDeleted,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get symbol => $state.composableBuilder(
      column: $state.table.symbol,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get nepaliSymbol => $state.composableBuilder(
      column: $state.table.nepaliSymbol,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isFractional => $state.composableBuilder(
      column: $state.table.isFractional,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$UnitsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $UnitsTable> {
  $$UnitsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get syncStatus => $state.composableBuilder(
      column: $state.table.syncStatus,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get remoteId => $state.composableBuilder(
      column: $state.table.remoteId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isDeleted => $state.composableBuilder(
      column: $state.table.isDeleted,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get symbol => $state.composableBuilder(
      column: $state.table.symbol,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get nepaliSymbol => $state.composableBuilder(
      column: $state.table.nepaliSymbol,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isFractional => $state.composableBuilder(
      column: $state.table.isFractional,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$ItemsTableCreateCompanionBuilder = ItemsCompanion Function({
  required String id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<SyncStatus> syncStatus,
  Value<String?> remoteId,
  Value<bool> isDeleted,
  required String name,
  Value<String?> nepaliName,
  required String sku,
  Value<String?> categoryId,
  Value<String> unit,
  Value<int> purchasePricePaisa,
  Value<int> sellingPricePaisa,
  Value<double> stockQty,
  Value<double> lowStockThreshold,
  Value<bool> isActive,
  Value<int> rowid,
});
typedef $$ItemsTableUpdateCompanionBuilder = ItemsCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<SyncStatus> syncStatus,
  Value<String?> remoteId,
  Value<bool> isDeleted,
  Value<String> name,
  Value<String?> nepaliName,
  Value<String> sku,
  Value<String?> categoryId,
  Value<String> unit,
  Value<int> purchasePricePaisa,
  Value<int> sellingPricePaisa,
  Value<double> stockQty,
  Value<double> lowStockThreshold,
  Value<bool> isActive,
  Value<int> rowid,
});

class $$ItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ItemsTable,
    Item,
    $$ItemsTableFilterComposer,
    $$ItemsTableOrderingComposer,
    $$ItemsTableCreateCompanionBuilder,
    $$ItemsTableUpdateCompanionBuilder> {
  $$ItemsTableTableManager(_$AppDatabase db, $ItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$ItemsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$ItemsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<SyncStatus> syncStatus = const Value.absent(),
            Value<String?> remoteId = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> nepaliName = const Value.absent(),
            Value<String> sku = const Value.absent(),
            Value<String?> categoryId = const Value.absent(),
            Value<String> unit = const Value.absent(),
            Value<int> purchasePricePaisa = const Value.absent(),
            Value<int> sellingPricePaisa = const Value.absent(),
            Value<double> stockQty = const Value.absent(),
            Value<double> lowStockThreshold = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ItemsCompanion(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            remoteId: remoteId,
            isDeleted: isDeleted,
            name: name,
            nepaliName: nepaliName,
            sku: sku,
            categoryId: categoryId,
            unit: unit,
            purchasePricePaisa: purchasePricePaisa,
            sellingPricePaisa: sellingPricePaisa,
            stockQty: stockQty,
            lowStockThreshold: lowStockThreshold,
            isActive: isActive,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<SyncStatus> syncStatus = const Value.absent(),
            Value<String?> remoteId = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            required String name,
            Value<String?> nepaliName = const Value.absent(),
            required String sku,
            Value<String?> categoryId = const Value.absent(),
            Value<String> unit = const Value.absent(),
            Value<int> purchasePricePaisa = const Value.absent(),
            Value<int> sellingPricePaisa = const Value.absent(),
            Value<double> stockQty = const Value.absent(),
            Value<double> lowStockThreshold = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ItemsCompanion.insert(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            remoteId: remoteId,
            isDeleted: isDeleted,
            name: name,
            nepaliName: nepaliName,
            sku: sku,
            categoryId: categoryId,
            unit: unit,
            purchasePricePaisa: purchasePricePaisa,
            sellingPricePaisa: sellingPricePaisa,
            stockQty: stockQty,
            lowStockThreshold: lowStockThreshold,
            isActive: isActive,
            rowid: rowid,
          ),
        ));
}

class $$ItemsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $ItemsTable> {
  $$ItemsTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<SyncStatus, SyncStatus, String>
      get syncStatus => $state.composableBuilder(
          column: $state.table.syncStatus,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnFilters<String> get remoteId => $state.composableBuilder(
      column: $state.table.remoteId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isDeleted => $state.composableBuilder(
      column: $state.table.isDeleted,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get nepaliName => $state.composableBuilder(
      column: $state.table.nepaliName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get sku => $state.composableBuilder(
      column: $state.table.sku,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get categoryId => $state.composableBuilder(
      column: $state.table.categoryId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get unit => $state.composableBuilder(
      column: $state.table.unit,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get purchasePricePaisa => $state.composableBuilder(
      column: $state.table.purchasePricePaisa,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get sellingPricePaisa => $state.composableBuilder(
      column: $state.table.sellingPricePaisa,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get stockQty => $state.composableBuilder(
      column: $state.table.stockQty,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get lowStockThreshold => $state.composableBuilder(
      column: $state.table.lowStockThreshold,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isActive => $state.composableBuilder(
      column: $state.table.isActive,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$ItemsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $ItemsTable> {
  $$ItemsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get syncStatus => $state.composableBuilder(
      column: $state.table.syncStatus,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get remoteId => $state.composableBuilder(
      column: $state.table.remoteId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isDeleted => $state.composableBuilder(
      column: $state.table.isDeleted,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get nepaliName => $state.composableBuilder(
      column: $state.table.nepaliName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get sku => $state.composableBuilder(
      column: $state.table.sku,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get categoryId => $state.composableBuilder(
      column: $state.table.categoryId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get unit => $state.composableBuilder(
      column: $state.table.unit,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get purchasePricePaisa => $state.composableBuilder(
      column: $state.table.purchasePricePaisa,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get sellingPricePaisa => $state.composableBuilder(
      column: $state.table.sellingPricePaisa,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get stockQty => $state.composableBuilder(
      column: $state.table.stockQty,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get lowStockThreshold => $state.composableBuilder(
      column: $state.table.lowStockThreshold,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isActive => $state.composableBuilder(
      column: $state.table.isActive,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$InventoriesTableCreateCompanionBuilder = InventoriesCompanion
    Function({
  required String id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<SyncStatus> syncStatus,
  Value<String?> remoteId,
  Value<bool> isDeleted,
  required String name,
  Value<String?> sku,
  Value<String> unit,
  Value<double> unitPrice,
  Value<double> costPrice,
  Value<double> stockQuantity,
  Value<bool> isActive,
  Value<int> rowid,
});
typedef $$InventoriesTableUpdateCompanionBuilder = InventoriesCompanion
    Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<SyncStatus> syncStatus,
  Value<String?> remoteId,
  Value<bool> isDeleted,
  Value<String> name,
  Value<String?> sku,
  Value<String> unit,
  Value<double> unitPrice,
  Value<double> costPrice,
  Value<double> stockQuantity,
  Value<bool> isActive,
  Value<int> rowid,
});

class $$InventoriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $InventoriesTable,
    Inventory,
    $$InventoriesTableFilterComposer,
    $$InventoriesTableOrderingComposer,
    $$InventoriesTableCreateCompanionBuilder,
    $$InventoriesTableUpdateCompanionBuilder> {
  $$InventoriesTableTableManager(_$AppDatabase db, $InventoriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$InventoriesTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$InventoriesTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<SyncStatus> syncStatus = const Value.absent(),
            Value<String?> remoteId = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> sku = const Value.absent(),
            Value<String> unit = const Value.absent(),
            Value<double> unitPrice = const Value.absent(),
            Value<double> costPrice = const Value.absent(),
            Value<double> stockQuantity = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              InventoriesCompanion(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            remoteId: remoteId,
            isDeleted: isDeleted,
            name: name,
            sku: sku,
            unit: unit,
            unitPrice: unitPrice,
            costPrice: costPrice,
            stockQuantity: stockQuantity,
            isActive: isActive,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<SyncStatus> syncStatus = const Value.absent(),
            Value<String?> remoteId = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            required String name,
            Value<String?> sku = const Value.absent(),
            Value<String> unit = const Value.absent(),
            Value<double> unitPrice = const Value.absent(),
            Value<double> costPrice = const Value.absent(),
            Value<double> stockQuantity = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              InventoriesCompanion.insert(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            remoteId: remoteId,
            isDeleted: isDeleted,
            name: name,
            sku: sku,
            unit: unit,
            unitPrice: unitPrice,
            costPrice: costPrice,
            stockQuantity: stockQuantity,
            isActive: isActive,
            rowid: rowid,
          ),
        ));
}

class $$InventoriesTableFilterComposer
    extends FilterComposer<_$AppDatabase, $InventoriesTable> {
  $$InventoriesTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<SyncStatus, SyncStatus, String>
      get syncStatus => $state.composableBuilder(
          column: $state.table.syncStatus,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnFilters<String> get remoteId => $state.composableBuilder(
      column: $state.table.remoteId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isDeleted => $state.composableBuilder(
      column: $state.table.isDeleted,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get sku => $state.composableBuilder(
      column: $state.table.sku,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get unit => $state.composableBuilder(
      column: $state.table.unit,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get unitPrice => $state.composableBuilder(
      column: $state.table.unitPrice,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get costPrice => $state.composableBuilder(
      column: $state.table.costPrice,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get stockQuantity => $state.composableBuilder(
      column: $state.table.stockQuantity,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isActive => $state.composableBuilder(
      column: $state.table.isActive,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$InventoriesTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $InventoriesTable> {
  $$InventoriesTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get syncStatus => $state.composableBuilder(
      column: $state.table.syncStatus,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get remoteId => $state.composableBuilder(
      column: $state.table.remoteId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isDeleted => $state.composableBuilder(
      column: $state.table.isDeleted,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get sku => $state.composableBuilder(
      column: $state.table.sku,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get unit => $state.composableBuilder(
      column: $state.table.unit,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get unitPrice => $state.composableBuilder(
      column: $state.table.unitPrice,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get costPrice => $state.composableBuilder(
      column: $state.table.costPrice,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get stockQuantity => $state.composableBuilder(
      column: $state.table.stockQuantity,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isActive => $state.composableBuilder(
      column: $state.table.isActive,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$SuppliersTableCreateCompanionBuilder = SuppliersCompanion Function({
  required String id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<SyncStatus> syncStatus,
  Value<String?> remoteId,
  Value<bool> isDeleted,
  required String name,
  Value<String?> phone,
  Value<String?> panVat,
  Value<String?> address,
  Value<String?> contactPerson,
  Value<int> rowid,
});
typedef $$SuppliersTableUpdateCompanionBuilder = SuppliersCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<SyncStatus> syncStatus,
  Value<String?> remoteId,
  Value<bool> isDeleted,
  Value<String> name,
  Value<String?> phone,
  Value<String?> panVat,
  Value<String?> address,
  Value<String?> contactPerson,
  Value<int> rowid,
});

class $$SuppliersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SuppliersTable,
    Supplier,
    $$SuppliersTableFilterComposer,
    $$SuppliersTableOrderingComposer,
    $$SuppliersTableCreateCompanionBuilder,
    $$SuppliersTableUpdateCompanionBuilder> {
  $$SuppliersTableTableManager(_$AppDatabase db, $SuppliersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$SuppliersTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$SuppliersTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<SyncStatus> syncStatus = const Value.absent(),
            Value<String?> remoteId = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String?> panVat = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String?> contactPerson = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SuppliersCompanion(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            remoteId: remoteId,
            isDeleted: isDeleted,
            name: name,
            phone: phone,
            panVat: panVat,
            address: address,
            contactPerson: contactPerson,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<SyncStatus> syncStatus = const Value.absent(),
            Value<String?> remoteId = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            required String name,
            Value<String?> phone = const Value.absent(),
            Value<String?> panVat = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String?> contactPerson = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SuppliersCompanion.insert(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            remoteId: remoteId,
            isDeleted: isDeleted,
            name: name,
            phone: phone,
            panVat: panVat,
            address: address,
            contactPerson: contactPerson,
            rowid: rowid,
          ),
        ));
}

class $$SuppliersTableFilterComposer
    extends FilterComposer<_$AppDatabase, $SuppliersTable> {
  $$SuppliersTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<SyncStatus, SyncStatus, String>
      get syncStatus => $state.composableBuilder(
          column: $state.table.syncStatus,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnFilters<String> get remoteId => $state.composableBuilder(
      column: $state.table.remoteId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isDeleted => $state.composableBuilder(
      column: $state.table.isDeleted,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get phone => $state.composableBuilder(
      column: $state.table.phone,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get panVat => $state.composableBuilder(
      column: $state.table.panVat,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get address => $state.composableBuilder(
      column: $state.table.address,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get contactPerson => $state.composableBuilder(
      column: $state.table.contactPerson,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$SuppliersTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $SuppliersTable> {
  $$SuppliersTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get syncStatus => $state.composableBuilder(
      column: $state.table.syncStatus,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get remoteId => $state.composableBuilder(
      column: $state.table.remoteId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isDeleted => $state.composableBuilder(
      column: $state.table.isDeleted,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get phone => $state.composableBuilder(
      column: $state.table.phone,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get panVat => $state.composableBuilder(
      column: $state.table.panVat,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get address => $state.composableBuilder(
      column: $state.table.address,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get contactPerson => $state.composableBuilder(
      column: $state.table.contactPerson,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$CustomersTableCreateCompanionBuilder = CustomersCompanion Function({
  required String id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<SyncStatus> syncStatus,
  Value<String?> remoteId,
  Value<bool> isDeleted,
  required String name,
  Value<String?> phone,
  Value<String?> panVat,
  Value<String?> address,
  Value<int> rowid,
});
typedef $$CustomersTableUpdateCompanionBuilder = CustomersCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<SyncStatus> syncStatus,
  Value<String?> remoteId,
  Value<bool> isDeleted,
  Value<String> name,
  Value<String?> phone,
  Value<String?> panVat,
  Value<String?> address,
  Value<int> rowid,
});

class $$CustomersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CustomersTable,
    Customer,
    $$CustomersTableFilterComposer,
    $$CustomersTableOrderingComposer,
    $$CustomersTableCreateCompanionBuilder,
    $$CustomersTableUpdateCompanionBuilder> {
  $$CustomersTableTableManager(_$AppDatabase db, $CustomersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$CustomersTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$CustomersTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<SyncStatus> syncStatus = const Value.absent(),
            Value<String?> remoteId = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String?> panVat = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CustomersCompanion(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            remoteId: remoteId,
            isDeleted: isDeleted,
            name: name,
            phone: phone,
            panVat: panVat,
            address: address,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<SyncStatus> syncStatus = const Value.absent(),
            Value<String?> remoteId = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            required String name,
            Value<String?> phone = const Value.absent(),
            Value<String?> panVat = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CustomersCompanion.insert(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            remoteId: remoteId,
            isDeleted: isDeleted,
            name: name,
            phone: phone,
            panVat: panVat,
            address: address,
            rowid: rowid,
          ),
        ));
}

class $$CustomersTableFilterComposer
    extends FilterComposer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<SyncStatus, SyncStatus, String>
      get syncStatus => $state.composableBuilder(
          column: $state.table.syncStatus,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnFilters<String> get remoteId => $state.composableBuilder(
      column: $state.table.remoteId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isDeleted => $state.composableBuilder(
      column: $state.table.isDeleted,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get phone => $state.composableBuilder(
      column: $state.table.phone,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get panVat => $state.composableBuilder(
      column: $state.table.panVat,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get address => $state.composableBuilder(
      column: $state.table.address,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$CustomersTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get syncStatus => $state.composableBuilder(
      column: $state.table.syncStatus,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get remoteId => $state.composableBuilder(
      column: $state.table.remoteId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isDeleted => $state.composableBuilder(
      column: $state.table.isDeleted,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get phone => $state.composableBuilder(
      column: $state.table.phone,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get panVat => $state.composableBuilder(
      column: $state.table.panVat,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get address => $state.composableBuilder(
      column: $state.table.address,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$StockLedgerTableCreateCompanionBuilder = StockLedgerCompanion
    Function({
  required String id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<SyncStatus> syncStatus,
  Value<String?> remoteId,
  Value<bool> isDeleted,
  required String itemId,
  required double qtyChange,
  required String reason,
  required String refType,
  required String refId,
  Value<String?> notes,
  Value<int> rowid,
});
typedef $$StockLedgerTableUpdateCompanionBuilder = StockLedgerCompanion
    Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<SyncStatus> syncStatus,
  Value<String?> remoteId,
  Value<bool> isDeleted,
  Value<String> itemId,
  Value<double> qtyChange,
  Value<String> reason,
  Value<String> refType,
  Value<String> refId,
  Value<String?> notes,
  Value<int> rowid,
});

class $$StockLedgerTableTableManager extends RootTableManager<
    _$AppDatabase,
    $StockLedgerTable,
    StockLedgerData,
    $$StockLedgerTableFilterComposer,
    $$StockLedgerTableOrderingComposer,
    $$StockLedgerTableCreateCompanionBuilder,
    $$StockLedgerTableUpdateCompanionBuilder> {
  $$StockLedgerTableTableManager(_$AppDatabase db, $StockLedgerTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$StockLedgerTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$StockLedgerTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<SyncStatus> syncStatus = const Value.absent(),
            Value<String?> remoteId = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<String> itemId = const Value.absent(),
            Value<double> qtyChange = const Value.absent(),
            Value<String> reason = const Value.absent(),
            Value<String> refType = const Value.absent(),
            Value<String> refId = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              StockLedgerCompanion(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            remoteId: remoteId,
            isDeleted: isDeleted,
            itemId: itemId,
            qtyChange: qtyChange,
            reason: reason,
            refType: refType,
            refId: refId,
            notes: notes,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<SyncStatus> syncStatus = const Value.absent(),
            Value<String?> remoteId = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            required String itemId,
            required double qtyChange,
            required String reason,
            required String refType,
            required String refId,
            Value<String?> notes = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              StockLedgerCompanion.insert(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            remoteId: remoteId,
            isDeleted: isDeleted,
            itemId: itemId,
            qtyChange: qtyChange,
            reason: reason,
            refType: refType,
            refId: refId,
            notes: notes,
            rowid: rowid,
          ),
        ));
}

class $$StockLedgerTableFilterComposer
    extends FilterComposer<_$AppDatabase, $StockLedgerTable> {
  $$StockLedgerTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<SyncStatus, SyncStatus, String>
      get syncStatus => $state.composableBuilder(
          column: $state.table.syncStatus,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnFilters<String> get remoteId => $state.composableBuilder(
      column: $state.table.remoteId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isDeleted => $state.composableBuilder(
      column: $state.table.isDeleted,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get itemId => $state.composableBuilder(
      column: $state.table.itemId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get qtyChange => $state.composableBuilder(
      column: $state.table.qtyChange,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get reason => $state.composableBuilder(
      column: $state.table.reason,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get refType => $state.composableBuilder(
      column: $state.table.refType,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get refId => $state.composableBuilder(
      column: $state.table.refId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get notes => $state.composableBuilder(
      column: $state.table.notes,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$StockLedgerTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $StockLedgerTable> {
  $$StockLedgerTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get syncStatus => $state.composableBuilder(
      column: $state.table.syncStatus,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get remoteId => $state.composableBuilder(
      column: $state.table.remoteId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isDeleted => $state.composableBuilder(
      column: $state.table.isDeleted,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get itemId => $state.composableBuilder(
      column: $state.table.itemId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get qtyChange => $state.composableBuilder(
      column: $state.table.qtyChange,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get reason => $state.composableBuilder(
      column: $state.table.reason,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get refType => $state.composableBuilder(
      column: $state.table.refType,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get refId => $state.composableBuilder(
      column: $state.table.refId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get notes => $state.composableBuilder(
      column: $state.table.notes,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$StockAdjustmentsTableCreateCompanionBuilder
    = StockAdjustmentsCompanion Function({
  required String id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<SyncStatus> syncStatus,
  Value<String?> remoteId,
  Value<bool> isDeleted,
  required String itemId,
  required double previousQty,
  required double adjustmentQty,
  required double newQty,
  required String reason,
  Value<String?> notes,
  Value<int> rowid,
});
typedef $$StockAdjustmentsTableUpdateCompanionBuilder
    = StockAdjustmentsCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<SyncStatus> syncStatus,
  Value<String?> remoteId,
  Value<bool> isDeleted,
  Value<String> itemId,
  Value<double> previousQty,
  Value<double> adjustmentQty,
  Value<double> newQty,
  Value<String> reason,
  Value<String?> notes,
  Value<int> rowid,
});

class $$StockAdjustmentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $StockAdjustmentsTable,
    StockAdjustment,
    $$StockAdjustmentsTableFilterComposer,
    $$StockAdjustmentsTableOrderingComposer,
    $$StockAdjustmentsTableCreateCompanionBuilder,
    $$StockAdjustmentsTableUpdateCompanionBuilder> {
  $$StockAdjustmentsTableTableManager(
      _$AppDatabase db, $StockAdjustmentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$StockAdjustmentsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$StockAdjustmentsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<SyncStatus> syncStatus = const Value.absent(),
            Value<String?> remoteId = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<String> itemId = const Value.absent(),
            Value<double> previousQty = const Value.absent(),
            Value<double> adjustmentQty = const Value.absent(),
            Value<double> newQty = const Value.absent(),
            Value<String> reason = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              StockAdjustmentsCompanion(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            remoteId: remoteId,
            isDeleted: isDeleted,
            itemId: itemId,
            previousQty: previousQty,
            adjustmentQty: adjustmentQty,
            newQty: newQty,
            reason: reason,
            notes: notes,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<SyncStatus> syncStatus = const Value.absent(),
            Value<String?> remoteId = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            required String itemId,
            required double previousQty,
            required double adjustmentQty,
            required double newQty,
            required String reason,
            Value<String?> notes = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              StockAdjustmentsCompanion.insert(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            remoteId: remoteId,
            isDeleted: isDeleted,
            itemId: itemId,
            previousQty: previousQty,
            adjustmentQty: adjustmentQty,
            newQty: newQty,
            reason: reason,
            notes: notes,
            rowid: rowid,
          ),
        ));
}

class $$StockAdjustmentsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $StockAdjustmentsTable> {
  $$StockAdjustmentsTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<SyncStatus, SyncStatus, String>
      get syncStatus => $state.composableBuilder(
          column: $state.table.syncStatus,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnFilters<String> get remoteId => $state.composableBuilder(
      column: $state.table.remoteId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isDeleted => $state.composableBuilder(
      column: $state.table.isDeleted,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get itemId => $state.composableBuilder(
      column: $state.table.itemId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get previousQty => $state.composableBuilder(
      column: $state.table.previousQty,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get adjustmentQty => $state.composableBuilder(
      column: $state.table.adjustmentQty,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get newQty => $state.composableBuilder(
      column: $state.table.newQty,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get reason => $state.composableBuilder(
      column: $state.table.reason,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get notes => $state.composableBuilder(
      column: $state.table.notes,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$StockAdjustmentsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $StockAdjustmentsTable> {
  $$StockAdjustmentsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get syncStatus => $state.composableBuilder(
      column: $state.table.syncStatus,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get remoteId => $state.composableBuilder(
      column: $state.table.remoteId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isDeleted => $state.composableBuilder(
      column: $state.table.isDeleted,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get itemId => $state.composableBuilder(
      column: $state.table.itemId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get previousQty => $state.composableBuilder(
      column: $state.table.previousQty,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get adjustmentQty => $state.composableBuilder(
      column: $state.table.adjustmentQty,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get newQty => $state.composableBuilder(
      column: $state.table.newQty,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get reason => $state.composableBuilder(
      column: $state.table.reason,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get notes => $state.composableBuilder(
      column: $state.table.notes,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$PurchasesTableCreateCompanionBuilder = PurchasesCompanion Function({
  required String id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<SyncStatus> syncStatus,
  Value<String?> remoteId,
  Value<bool> isDeleted,
  Value<String?> supplierId,
  required String supplierName,
  Value<String?> supplierPan,
  Value<String?> billNumber,
  Value<DateTime> purchaseDate,
  Value<int> subtotalPaisa,
  Value<int> discountPaisa,
  Value<int> taxablePaisa,
  Value<int> vatPaisa,
  Value<int> totalPaisa,
  Value<String?> remarks,
  Value<bool> isReturned,
  Value<int> rowid,
});
typedef $$PurchasesTableUpdateCompanionBuilder = PurchasesCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<SyncStatus> syncStatus,
  Value<String?> remoteId,
  Value<bool> isDeleted,
  Value<String?> supplierId,
  Value<String> supplierName,
  Value<String?> supplierPan,
  Value<String?> billNumber,
  Value<DateTime> purchaseDate,
  Value<int> subtotalPaisa,
  Value<int> discountPaisa,
  Value<int> taxablePaisa,
  Value<int> vatPaisa,
  Value<int> totalPaisa,
  Value<String?> remarks,
  Value<bool> isReturned,
  Value<int> rowid,
});

class $$PurchasesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PurchasesTable,
    Purchase,
    $$PurchasesTableFilterComposer,
    $$PurchasesTableOrderingComposer,
    $$PurchasesTableCreateCompanionBuilder,
    $$PurchasesTableUpdateCompanionBuilder> {
  $$PurchasesTableTableManager(_$AppDatabase db, $PurchasesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$PurchasesTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$PurchasesTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<SyncStatus> syncStatus = const Value.absent(),
            Value<String?> remoteId = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<String?> supplierId = const Value.absent(),
            Value<String> supplierName = const Value.absent(),
            Value<String?> supplierPan = const Value.absent(),
            Value<String?> billNumber = const Value.absent(),
            Value<DateTime> purchaseDate = const Value.absent(),
            Value<int> subtotalPaisa = const Value.absent(),
            Value<int> discountPaisa = const Value.absent(),
            Value<int> taxablePaisa = const Value.absent(),
            Value<int> vatPaisa = const Value.absent(),
            Value<int> totalPaisa = const Value.absent(),
            Value<String?> remarks = const Value.absent(),
            Value<bool> isReturned = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PurchasesCompanion(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            remoteId: remoteId,
            isDeleted: isDeleted,
            supplierId: supplierId,
            supplierName: supplierName,
            supplierPan: supplierPan,
            billNumber: billNumber,
            purchaseDate: purchaseDate,
            subtotalPaisa: subtotalPaisa,
            discountPaisa: discountPaisa,
            taxablePaisa: taxablePaisa,
            vatPaisa: vatPaisa,
            totalPaisa: totalPaisa,
            remarks: remarks,
            isReturned: isReturned,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<SyncStatus> syncStatus = const Value.absent(),
            Value<String?> remoteId = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<String?> supplierId = const Value.absent(),
            required String supplierName,
            Value<String?> supplierPan = const Value.absent(),
            Value<String?> billNumber = const Value.absent(),
            Value<DateTime> purchaseDate = const Value.absent(),
            Value<int> subtotalPaisa = const Value.absent(),
            Value<int> discountPaisa = const Value.absent(),
            Value<int> taxablePaisa = const Value.absent(),
            Value<int> vatPaisa = const Value.absent(),
            Value<int> totalPaisa = const Value.absent(),
            Value<String?> remarks = const Value.absent(),
            Value<bool> isReturned = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PurchasesCompanion.insert(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            remoteId: remoteId,
            isDeleted: isDeleted,
            supplierId: supplierId,
            supplierName: supplierName,
            supplierPan: supplierPan,
            billNumber: billNumber,
            purchaseDate: purchaseDate,
            subtotalPaisa: subtotalPaisa,
            discountPaisa: discountPaisa,
            taxablePaisa: taxablePaisa,
            vatPaisa: vatPaisa,
            totalPaisa: totalPaisa,
            remarks: remarks,
            isReturned: isReturned,
            rowid: rowid,
          ),
        ));
}

class $$PurchasesTableFilterComposer
    extends FilterComposer<_$AppDatabase, $PurchasesTable> {
  $$PurchasesTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<SyncStatus, SyncStatus, String>
      get syncStatus => $state.composableBuilder(
          column: $state.table.syncStatus,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnFilters<String> get remoteId => $state.composableBuilder(
      column: $state.table.remoteId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isDeleted => $state.composableBuilder(
      column: $state.table.isDeleted,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get supplierId => $state.composableBuilder(
      column: $state.table.supplierId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get supplierName => $state.composableBuilder(
      column: $state.table.supplierName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get supplierPan => $state.composableBuilder(
      column: $state.table.supplierPan,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get billNumber => $state.composableBuilder(
      column: $state.table.billNumber,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get purchaseDate => $state.composableBuilder(
      column: $state.table.purchaseDate,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get subtotalPaisa => $state.composableBuilder(
      column: $state.table.subtotalPaisa,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get discountPaisa => $state.composableBuilder(
      column: $state.table.discountPaisa,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get taxablePaisa => $state.composableBuilder(
      column: $state.table.taxablePaisa,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get vatPaisa => $state.composableBuilder(
      column: $state.table.vatPaisa,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get totalPaisa => $state.composableBuilder(
      column: $state.table.totalPaisa,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get remarks => $state.composableBuilder(
      column: $state.table.remarks,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isReturned => $state.composableBuilder(
      column: $state.table.isReturned,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$PurchasesTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $PurchasesTable> {
  $$PurchasesTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get syncStatus => $state.composableBuilder(
      column: $state.table.syncStatus,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get remoteId => $state.composableBuilder(
      column: $state.table.remoteId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isDeleted => $state.composableBuilder(
      column: $state.table.isDeleted,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get supplierId => $state.composableBuilder(
      column: $state.table.supplierId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get supplierName => $state.composableBuilder(
      column: $state.table.supplierName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get supplierPan => $state.composableBuilder(
      column: $state.table.supplierPan,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get billNumber => $state.composableBuilder(
      column: $state.table.billNumber,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get purchaseDate => $state.composableBuilder(
      column: $state.table.purchaseDate,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get subtotalPaisa => $state.composableBuilder(
      column: $state.table.subtotalPaisa,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get discountPaisa => $state.composableBuilder(
      column: $state.table.discountPaisa,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get taxablePaisa => $state.composableBuilder(
      column: $state.table.taxablePaisa,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get vatPaisa => $state.composableBuilder(
      column: $state.table.vatPaisa,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get totalPaisa => $state.composableBuilder(
      column: $state.table.totalPaisa,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get remarks => $state.composableBuilder(
      column: $state.table.remarks,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isReturned => $state.composableBuilder(
      column: $state.table.isReturned,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$PurchaseItemsTableCreateCompanionBuilder = PurchaseItemsCompanion
    Function({
  required String id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<SyncStatus> syncStatus,
  Value<String?> remoteId,
  Value<bool> isDeleted,
  required String purchaseId,
  required String itemId,
  required String itemName,
  Value<String> unit,
  required double quantity,
  required int ratePaisa,
  Value<int> discountPaisa,
  required int taxablePaisa,
  Value<int> vatPaisa,
  required int lineTotalPaisa,
  Value<int> rowid,
});
typedef $$PurchaseItemsTableUpdateCompanionBuilder = PurchaseItemsCompanion
    Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<SyncStatus> syncStatus,
  Value<String?> remoteId,
  Value<bool> isDeleted,
  Value<String> purchaseId,
  Value<String> itemId,
  Value<String> itemName,
  Value<String> unit,
  Value<double> quantity,
  Value<int> ratePaisa,
  Value<int> discountPaisa,
  Value<int> taxablePaisa,
  Value<int> vatPaisa,
  Value<int> lineTotalPaisa,
  Value<int> rowid,
});

class $$PurchaseItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PurchaseItemsTable,
    PurchaseItem,
    $$PurchaseItemsTableFilterComposer,
    $$PurchaseItemsTableOrderingComposer,
    $$PurchaseItemsTableCreateCompanionBuilder,
    $$PurchaseItemsTableUpdateCompanionBuilder> {
  $$PurchaseItemsTableTableManager(_$AppDatabase db, $PurchaseItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$PurchaseItemsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$PurchaseItemsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<SyncStatus> syncStatus = const Value.absent(),
            Value<String?> remoteId = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<String> purchaseId = const Value.absent(),
            Value<String> itemId = const Value.absent(),
            Value<String> itemName = const Value.absent(),
            Value<String> unit = const Value.absent(),
            Value<double> quantity = const Value.absent(),
            Value<int> ratePaisa = const Value.absent(),
            Value<int> discountPaisa = const Value.absent(),
            Value<int> taxablePaisa = const Value.absent(),
            Value<int> vatPaisa = const Value.absent(),
            Value<int> lineTotalPaisa = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PurchaseItemsCompanion(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            remoteId: remoteId,
            isDeleted: isDeleted,
            purchaseId: purchaseId,
            itemId: itemId,
            itemName: itemName,
            unit: unit,
            quantity: quantity,
            ratePaisa: ratePaisa,
            discountPaisa: discountPaisa,
            taxablePaisa: taxablePaisa,
            vatPaisa: vatPaisa,
            lineTotalPaisa: lineTotalPaisa,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<SyncStatus> syncStatus = const Value.absent(),
            Value<String?> remoteId = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            required String purchaseId,
            required String itemId,
            required String itemName,
            Value<String> unit = const Value.absent(),
            required double quantity,
            required int ratePaisa,
            Value<int> discountPaisa = const Value.absent(),
            required int taxablePaisa,
            Value<int> vatPaisa = const Value.absent(),
            required int lineTotalPaisa,
            Value<int> rowid = const Value.absent(),
          }) =>
              PurchaseItemsCompanion.insert(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            remoteId: remoteId,
            isDeleted: isDeleted,
            purchaseId: purchaseId,
            itemId: itemId,
            itemName: itemName,
            unit: unit,
            quantity: quantity,
            ratePaisa: ratePaisa,
            discountPaisa: discountPaisa,
            taxablePaisa: taxablePaisa,
            vatPaisa: vatPaisa,
            lineTotalPaisa: lineTotalPaisa,
            rowid: rowid,
          ),
        ));
}

class $$PurchaseItemsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $PurchaseItemsTable> {
  $$PurchaseItemsTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<SyncStatus, SyncStatus, String>
      get syncStatus => $state.composableBuilder(
          column: $state.table.syncStatus,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnFilters<String> get remoteId => $state.composableBuilder(
      column: $state.table.remoteId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isDeleted => $state.composableBuilder(
      column: $state.table.isDeleted,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get purchaseId => $state.composableBuilder(
      column: $state.table.purchaseId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get itemId => $state.composableBuilder(
      column: $state.table.itemId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get itemName => $state.composableBuilder(
      column: $state.table.itemName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get unit => $state.composableBuilder(
      column: $state.table.unit,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get quantity => $state.composableBuilder(
      column: $state.table.quantity,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get ratePaisa => $state.composableBuilder(
      column: $state.table.ratePaisa,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get discountPaisa => $state.composableBuilder(
      column: $state.table.discountPaisa,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get taxablePaisa => $state.composableBuilder(
      column: $state.table.taxablePaisa,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get vatPaisa => $state.composableBuilder(
      column: $state.table.vatPaisa,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get lineTotalPaisa => $state.composableBuilder(
      column: $state.table.lineTotalPaisa,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$PurchaseItemsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $PurchaseItemsTable> {
  $$PurchaseItemsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get syncStatus => $state.composableBuilder(
      column: $state.table.syncStatus,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get remoteId => $state.composableBuilder(
      column: $state.table.remoteId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isDeleted => $state.composableBuilder(
      column: $state.table.isDeleted,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get purchaseId => $state.composableBuilder(
      column: $state.table.purchaseId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get itemId => $state.composableBuilder(
      column: $state.table.itemId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get itemName => $state.composableBuilder(
      column: $state.table.itemName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get unit => $state.composableBuilder(
      column: $state.table.unit,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get quantity => $state.composableBuilder(
      column: $state.table.quantity,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get ratePaisa => $state.composableBuilder(
      column: $state.table.ratePaisa,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get discountPaisa => $state.composableBuilder(
      column: $state.table.discountPaisa,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get taxablePaisa => $state.composableBuilder(
      column: $state.table.taxablePaisa,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get vatPaisa => $state.composableBuilder(
      column: $state.table.vatPaisa,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get lineTotalPaisa => $state.composableBuilder(
      column: $state.table.lineTotalPaisa,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$SalesTableCreateCompanionBuilder = SalesCompanion Function({
  required String id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<SyncStatus> syncStatus,
  Value<String?> remoteId,
  Value<bool> isDeleted,
  required String invoiceNumber,
  Value<String?> customerId,
  Value<String> customerName,
  Value<String?> customerPan,
  Value<String?> customerPhone,
  Value<DateTime> invoiceDate,
  required int subtotalPaisa,
  Value<int> discountPaisa,
  required int taxablePaisa,
  Value<int> vatPaisa,
  required int totalPaisa,
  Value<int> tenderedPaisa,
  Value<int> changePaisa,
  Value<String> paymentMode,
  Value<String?> notes,
  Value<String> status,
  Value<bool> isVoided,
  Value<int> rowid,
});
typedef $$SalesTableUpdateCompanionBuilder = SalesCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<SyncStatus> syncStatus,
  Value<String?> remoteId,
  Value<bool> isDeleted,
  Value<String> invoiceNumber,
  Value<String?> customerId,
  Value<String> customerName,
  Value<String?> customerPan,
  Value<String?> customerPhone,
  Value<DateTime> invoiceDate,
  Value<int> subtotalPaisa,
  Value<int> discountPaisa,
  Value<int> taxablePaisa,
  Value<int> vatPaisa,
  Value<int> totalPaisa,
  Value<int> tenderedPaisa,
  Value<int> changePaisa,
  Value<String> paymentMode,
  Value<String?> notes,
  Value<String> status,
  Value<bool> isVoided,
  Value<int> rowid,
});

class $$SalesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SalesTable,
    Sale,
    $$SalesTableFilterComposer,
    $$SalesTableOrderingComposer,
    $$SalesTableCreateCompanionBuilder,
    $$SalesTableUpdateCompanionBuilder> {
  $$SalesTableTableManager(_$AppDatabase db, $SalesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$SalesTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$SalesTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<SyncStatus> syncStatus = const Value.absent(),
            Value<String?> remoteId = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<String> invoiceNumber = const Value.absent(),
            Value<String?> customerId = const Value.absent(),
            Value<String> customerName = const Value.absent(),
            Value<String?> customerPan = const Value.absent(),
            Value<String?> customerPhone = const Value.absent(),
            Value<DateTime> invoiceDate = const Value.absent(),
            Value<int> subtotalPaisa = const Value.absent(),
            Value<int> discountPaisa = const Value.absent(),
            Value<int> taxablePaisa = const Value.absent(),
            Value<int> vatPaisa = const Value.absent(),
            Value<int> totalPaisa = const Value.absent(),
            Value<int> tenderedPaisa = const Value.absent(),
            Value<int> changePaisa = const Value.absent(),
            Value<String> paymentMode = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<bool> isVoided = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SalesCompanion(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            remoteId: remoteId,
            isDeleted: isDeleted,
            invoiceNumber: invoiceNumber,
            customerId: customerId,
            customerName: customerName,
            customerPan: customerPan,
            customerPhone: customerPhone,
            invoiceDate: invoiceDate,
            subtotalPaisa: subtotalPaisa,
            discountPaisa: discountPaisa,
            taxablePaisa: taxablePaisa,
            vatPaisa: vatPaisa,
            totalPaisa: totalPaisa,
            tenderedPaisa: tenderedPaisa,
            changePaisa: changePaisa,
            paymentMode: paymentMode,
            notes: notes,
            status: status,
            isVoided: isVoided,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<SyncStatus> syncStatus = const Value.absent(),
            Value<String?> remoteId = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            required String invoiceNumber,
            Value<String?> customerId = const Value.absent(),
            Value<String> customerName = const Value.absent(),
            Value<String?> customerPan = const Value.absent(),
            Value<String?> customerPhone = const Value.absent(),
            Value<DateTime> invoiceDate = const Value.absent(),
            required int subtotalPaisa,
            Value<int> discountPaisa = const Value.absent(),
            required int taxablePaisa,
            Value<int> vatPaisa = const Value.absent(),
            required int totalPaisa,
            Value<int> tenderedPaisa = const Value.absent(),
            Value<int> changePaisa = const Value.absent(),
            Value<String> paymentMode = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<bool> isVoided = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SalesCompanion.insert(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            remoteId: remoteId,
            isDeleted: isDeleted,
            invoiceNumber: invoiceNumber,
            customerId: customerId,
            customerName: customerName,
            customerPan: customerPan,
            customerPhone: customerPhone,
            invoiceDate: invoiceDate,
            subtotalPaisa: subtotalPaisa,
            discountPaisa: discountPaisa,
            taxablePaisa: taxablePaisa,
            vatPaisa: vatPaisa,
            totalPaisa: totalPaisa,
            tenderedPaisa: tenderedPaisa,
            changePaisa: changePaisa,
            paymentMode: paymentMode,
            notes: notes,
            status: status,
            isVoided: isVoided,
            rowid: rowid,
          ),
        ));
}

class $$SalesTableFilterComposer
    extends FilterComposer<_$AppDatabase, $SalesTable> {
  $$SalesTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<SyncStatus, SyncStatus, String>
      get syncStatus => $state.composableBuilder(
          column: $state.table.syncStatus,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnFilters<String> get remoteId => $state.composableBuilder(
      column: $state.table.remoteId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isDeleted => $state.composableBuilder(
      column: $state.table.isDeleted,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get invoiceNumber => $state.composableBuilder(
      column: $state.table.invoiceNumber,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get customerId => $state.composableBuilder(
      column: $state.table.customerId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get customerName => $state.composableBuilder(
      column: $state.table.customerName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get customerPan => $state.composableBuilder(
      column: $state.table.customerPan,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get customerPhone => $state.composableBuilder(
      column: $state.table.customerPhone,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get invoiceDate => $state.composableBuilder(
      column: $state.table.invoiceDate,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get subtotalPaisa => $state.composableBuilder(
      column: $state.table.subtotalPaisa,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get discountPaisa => $state.composableBuilder(
      column: $state.table.discountPaisa,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get taxablePaisa => $state.composableBuilder(
      column: $state.table.taxablePaisa,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get vatPaisa => $state.composableBuilder(
      column: $state.table.vatPaisa,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get totalPaisa => $state.composableBuilder(
      column: $state.table.totalPaisa,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get tenderedPaisa => $state.composableBuilder(
      column: $state.table.tenderedPaisa,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get changePaisa => $state.composableBuilder(
      column: $state.table.changePaisa,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get paymentMode => $state.composableBuilder(
      column: $state.table.paymentMode,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get notes => $state.composableBuilder(
      column: $state.table.notes,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get status => $state.composableBuilder(
      column: $state.table.status,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isVoided => $state.composableBuilder(
      column: $state.table.isVoided,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$SalesTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $SalesTable> {
  $$SalesTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get syncStatus => $state.composableBuilder(
      column: $state.table.syncStatus,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get remoteId => $state.composableBuilder(
      column: $state.table.remoteId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isDeleted => $state.composableBuilder(
      column: $state.table.isDeleted,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get invoiceNumber => $state.composableBuilder(
      column: $state.table.invoiceNumber,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get customerId => $state.composableBuilder(
      column: $state.table.customerId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get customerName => $state.composableBuilder(
      column: $state.table.customerName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get customerPan => $state.composableBuilder(
      column: $state.table.customerPan,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get customerPhone => $state.composableBuilder(
      column: $state.table.customerPhone,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get invoiceDate => $state.composableBuilder(
      column: $state.table.invoiceDate,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get subtotalPaisa => $state.composableBuilder(
      column: $state.table.subtotalPaisa,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get discountPaisa => $state.composableBuilder(
      column: $state.table.discountPaisa,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get taxablePaisa => $state.composableBuilder(
      column: $state.table.taxablePaisa,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get vatPaisa => $state.composableBuilder(
      column: $state.table.vatPaisa,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get totalPaisa => $state.composableBuilder(
      column: $state.table.totalPaisa,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get tenderedPaisa => $state.composableBuilder(
      column: $state.table.tenderedPaisa,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get changePaisa => $state.composableBuilder(
      column: $state.table.changePaisa,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get paymentMode => $state.composableBuilder(
      column: $state.table.paymentMode,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get notes => $state.composableBuilder(
      column: $state.table.notes,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get status => $state.composableBuilder(
      column: $state.table.status,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isVoided => $state.composableBuilder(
      column: $state.table.isVoided,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$SaleItemsTableCreateCompanionBuilder = SaleItemsCompanion Function({
  required String id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<SyncStatus> syncStatus,
  Value<String?> remoteId,
  Value<bool> isDeleted,
  required String saleId,
  required String itemId,
  required String itemName,
  Value<String> unit,
  required double quantity,
  required int ratePaisa,
  Value<int> discountPaisa,
  required int taxablePaisa,
  Value<int> vatPaisa,
  required int lineTotalPaisa,
  Value<int> rowid,
});
typedef $$SaleItemsTableUpdateCompanionBuilder = SaleItemsCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<SyncStatus> syncStatus,
  Value<String?> remoteId,
  Value<bool> isDeleted,
  Value<String> saleId,
  Value<String> itemId,
  Value<String> itemName,
  Value<String> unit,
  Value<double> quantity,
  Value<int> ratePaisa,
  Value<int> discountPaisa,
  Value<int> taxablePaisa,
  Value<int> vatPaisa,
  Value<int> lineTotalPaisa,
  Value<int> rowid,
});

class $$SaleItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SaleItemsTable,
    SaleItem,
    $$SaleItemsTableFilterComposer,
    $$SaleItemsTableOrderingComposer,
    $$SaleItemsTableCreateCompanionBuilder,
    $$SaleItemsTableUpdateCompanionBuilder> {
  $$SaleItemsTableTableManager(_$AppDatabase db, $SaleItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$SaleItemsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$SaleItemsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<SyncStatus> syncStatus = const Value.absent(),
            Value<String?> remoteId = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<String> saleId = const Value.absent(),
            Value<String> itemId = const Value.absent(),
            Value<String> itemName = const Value.absent(),
            Value<String> unit = const Value.absent(),
            Value<double> quantity = const Value.absent(),
            Value<int> ratePaisa = const Value.absent(),
            Value<int> discountPaisa = const Value.absent(),
            Value<int> taxablePaisa = const Value.absent(),
            Value<int> vatPaisa = const Value.absent(),
            Value<int> lineTotalPaisa = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SaleItemsCompanion(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            remoteId: remoteId,
            isDeleted: isDeleted,
            saleId: saleId,
            itemId: itemId,
            itemName: itemName,
            unit: unit,
            quantity: quantity,
            ratePaisa: ratePaisa,
            discountPaisa: discountPaisa,
            taxablePaisa: taxablePaisa,
            vatPaisa: vatPaisa,
            lineTotalPaisa: lineTotalPaisa,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<SyncStatus> syncStatus = const Value.absent(),
            Value<String?> remoteId = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            required String saleId,
            required String itemId,
            required String itemName,
            Value<String> unit = const Value.absent(),
            required double quantity,
            required int ratePaisa,
            Value<int> discountPaisa = const Value.absent(),
            required int taxablePaisa,
            Value<int> vatPaisa = const Value.absent(),
            required int lineTotalPaisa,
            Value<int> rowid = const Value.absent(),
          }) =>
              SaleItemsCompanion.insert(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            remoteId: remoteId,
            isDeleted: isDeleted,
            saleId: saleId,
            itemId: itemId,
            itemName: itemName,
            unit: unit,
            quantity: quantity,
            ratePaisa: ratePaisa,
            discountPaisa: discountPaisa,
            taxablePaisa: taxablePaisa,
            vatPaisa: vatPaisa,
            lineTotalPaisa: lineTotalPaisa,
            rowid: rowid,
          ),
        ));
}

class $$SaleItemsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $SaleItemsTable> {
  $$SaleItemsTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<SyncStatus, SyncStatus, String>
      get syncStatus => $state.composableBuilder(
          column: $state.table.syncStatus,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnFilters<String> get remoteId => $state.composableBuilder(
      column: $state.table.remoteId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isDeleted => $state.composableBuilder(
      column: $state.table.isDeleted,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get saleId => $state.composableBuilder(
      column: $state.table.saleId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get itemId => $state.composableBuilder(
      column: $state.table.itemId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get itemName => $state.composableBuilder(
      column: $state.table.itemName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get unit => $state.composableBuilder(
      column: $state.table.unit,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get quantity => $state.composableBuilder(
      column: $state.table.quantity,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get ratePaisa => $state.composableBuilder(
      column: $state.table.ratePaisa,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get discountPaisa => $state.composableBuilder(
      column: $state.table.discountPaisa,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get taxablePaisa => $state.composableBuilder(
      column: $state.table.taxablePaisa,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get vatPaisa => $state.composableBuilder(
      column: $state.table.vatPaisa,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get lineTotalPaisa => $state.composableBuilder(
      column: $state.table.lineTotalPaisa,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$SaleItemsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $SaleItemsTable> {
  $$SaleItemsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get syncStatus => $state.composableBuilder(
      column: $state.table.syncStatus,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get remoteId => $state.composableBuilder(
      column: $state.table.remoteId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isDeleted => $state.composableBuilder(
      column: $state.table.isDeleted,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get saleId => $state.composableBuilder(
      column: $state.table.saleId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get itemId => $state.composableBuilder(
      column: $state.table.itemId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get itemName => $state.composableBuilder(
      column: $state.table.itemName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get unit => $state.composableBuilder(
      column: $state.table.unit,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get quantity => $state.composableBuilder(
      column: $state.table.quantity,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get ratePaisa => $state.composableBuilder(
      column: $state.table.ratePaisa,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get discountPaisa => $state.composableBuilder(
      column: $state.table.discountPaisa,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get taxablePaisa => $state.composableBuilder(
      column: $state.table.taxablePaisa,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get vatPaisa => $state.composableBuilder(
      column: $state.table.vatPaisa,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get lineTotalPaisa => $state.composableBuilder(
      column: $state.table.lineTotalPaisa,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$BillMetadataTableCreateCompanionBuilder = BillMetadataCompanion
    Function({
  required String id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<SyncStatus> syncStatus,
  Value<String?> remoteId,
  Value<bool> isDeleted,
  required String saleId,
  required String billNumber,
  required String pdfFilePath,
  required String qrData,
  Value<int> printCount,
  Value<int> rowid,
});
typedef $$BillMetadataTableUpdateCompanionBuilder = BillMetadataCompanion
    Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<SyncStatus> syncStatus,
  Value<String?> remoteId,
  Value<bool> isDeleted,
  Value<String> saleId,
  Value<String> billNumber,
  Value<String> pdfFilePath,
  Value<String> qrData,
  Value<int> printCount,
  Value<int> rowid,
});

class $$BillMetadataTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BillMetadataTable,
    BillMetadataData,
    $$BillMetadataTableFilterComposer,
    $$BillMetadataTableOrderingComposer,
    $$BillMetadataTableCreateCompanionBuilder,
    $$BillMetadataTableUpdateCompanionBuilder> {
  $$BillMetadataTableTableManager(_$AppDatabase db, $BillMetadataTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$BillMetadataTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$BillMetadataTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<SyncStatus> syncStatus = const Value.absent(),
            Value<String?> remoteId = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<String> saleId = const Value.absent(),
            Value<String> billNumber = const Value.absent(),
            Value<String> pdfFilePath = const Value.absent(),
            Value<String> qrData = const Value.absent(),
            Value<int> printCount = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BillMetadataCompanion(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            remoteId: remoteId,
            isDeleted: isDeleted,
            saleId: saleId,
            billNumber: billNumber,
            pdfFilePath: pdfFilePath,
            qrData: qrData,
            printCount: printCount,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<SyncStatus> syncStatus = const Value.absent(),
            Value<String?> remoteId = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            required String saleId,
            required String billNumber,
            required String pdfFilePath,
            required String qrData,
            Value<int> printCount = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BillMetadataCompanion.insert(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            remoteId: remoteId,
            isDeleted: isDeleted,
            saleId: saleId,
            billNumber: billNumber,
            pdfFilePath: pdfFilePath,
            qrData: qrData,
            printCount: printCount,
            rowid: rowid,
          ),
        ));
}

class $$BillMetadataTableFilterComposer
    extends FilterComposer<_$AppDatabase, $BillMetadataTable> {
  $$BillMetadataTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<SyncStatus, SyncStatus, String>
      get syncStatus => $state.composableBuilder(
          column: $state.table.syncStatus,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnFilters<String> get remoteId => $state.composableBuilder(
      column: $state.table.remoteId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isDeleted => $state.composableBuilder(
      column: $state.table.isDeleted,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get saleId => $state.composableBuilder(
      column: $state.table.saleId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get billNumber => $state.composableBuilder(
      column: $state.table.billNumber,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get pdfFilePath => $state.composableBuilder(
      column: $state.table.pdfFilePath,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get qrData => $state.composableBuilder(
      column: $state.table.qrData,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get printCount => $state.composableBuilder(
      column: $state.table.printCount,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$BillMetadataTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $BillMetadataTable> {
  $$BillMetadataTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get syncStatus => $state.composableBuilder(
      column: $state.table.syncStatus,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get remoteId => $state.composableBuilder(
      column: $state.table.remoteId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isDeleted => $state.composableBuilder(
      column: $state.table.isDeleted,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get saleId => $state.composableBuilder(
      column: $state.table.saleId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get billNumber => $state.composableBuilder(
      column: $state.table.billNumber,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get pdfFilePath => $state.composableBuilder(
      column: $state.table.pdfFilePath,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get qrData => $state.composableBuilder(
      column: $state.table.qrData,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get printCount => $state.composableBuilder(
      column: $state.table.printCount,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$BillSequenceTableCreateCompanionBuilder = BillSequenceCompanion
    Function({
  required String sequenceType,
  required String fiscalYear,
  Value<String> prefix,
  Value<int> currentNumber,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$BillSequenceTableUpdateCompanionBuilder = BillSequenceCompanion
    Function({
  Value<String> sequenceType,
  Value<String> fiscalYear,
  Value<String> prefix,
  Value<int> currentNumber,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$BillSequenceTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BillSequenceTable,
    BillSequenceData,
    $$BillSequenceTableFilterComposer,
    $$BillSequenceTableOrderingComposer,
    $$BillSequenceTableCreateCompanionBuilder,
    $$BillSequenceTableUpdateCompanionBuilder> {
  $$BillSequenceTableTableManager(_$AppDatabase db, $BillSequenceTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$BillSequenceTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$BillSequenceTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> sequenceType = const Value.absent(),
            Value<String> fiscalYear = const Value.absent(),
            Value<String> prefix = const Value.absent(),
            Value<int> currentNumber = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BillSequenceCompanion(
            sequenceType: sequenceType,
            fiscalYear: fiscalYear,
            prefix: prefix,
            currentNumber: currentNumber,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String sequenceType,
            required String fiscalYear,
            Value<String> prefix = const Value.absent(),
            Value<int> currentNumber = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BillSequenceCompanion.insert(
            sequenceType: sequenceType,
            fiscalYear: fiscalYear,
            prefix: prefix,
            currentNumber: currentNumber,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
        ));
}

class $$BillSequenceTableFilterComposer
    extends FilterComposer<_$AppDatabase, $BillSequenceTable> {
  $$BillSequenceTableFilterComposer(super.$state);
  ColumnFilters<String> get sequenceType => $state.composableBuilder(
      column: $state.table.sequenceType,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get fiscalYear => $state.composableBuilder(
      column: $state.table.fiscalYear,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get prefix => $state.composableBuilder(
      column: $state.table.prefix,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get currentNumber => $state.composableBuilder(
      column: $state.table.currentNumber,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$BillSequenceTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $BillSequenceTable> {
  $$BillSequenceTableOrderingComposer(super.$state);
  ColumnOrderings<String> get sequenceType => $state.composableBuilder(
      column: $state.table.sequenceType,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get fiscalYear => $state.composableBuilder(
      column: $state.table.fiscalYear,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get prefix => $state.composableBuilder(
      column: $state.table.prefix,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get currentNumber => $state.composableBuilder(
      column: $state.table.currentNumber,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$BackupLogsTableCreateCompanionBuilder = BackupLogsCompanion Function({
  required String id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<SyncStatus> syncStatus,
  Value<String?> remoteId,
  Value<bool> isDeleted,
  required DateTime startedAt,
  Value<DateTime?> finishedAt,
  required String status,
  required String location,
  required String fileName,
  Value<int> sizeBytes,
  Value<String?> errorMessage,
  Value<String?> googleAccountEmail,
  Value<int> rowid,
});
typedef $$BackupLogsTableUpdateCompanionBuilder = BackupLogsCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<SyncStatus> syncStatus,
  Value<String?> remoteId,
  Value<bool> isDeleted,
  Value<DateTime> startedAt,
  Value<DateTime?> finishedAt,
  Value<String> status,
  Value<String> location,
  Value<String> fileName,
  Value<int> sizeBytes,
  Value<String?> errorMessage,
  Value<String?> googleAccountEmail,
  Value<int> rowid,
});

class $$BackupLogsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BackupLogsTable,
    BackupLog,
    $$BackupLogsTableFilterComposer,
    $$BackupLogsTableOrderingComposer,
    $$BackupLogsTableCreateCompanionBuilder,
    $$BackupLogsTableUpdateCompanionBuilder> {
  $$BackupLogsTableTableManager(_$AppDatabase db, $BackupLogsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$BackupLogsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$BackupLogsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<SyncStatus> syncStatus = const Value.absent(),
            Value<String?> remoteId = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<DateTime> startedAt = const Value.absent(),
            Value<DateTime?> finishedAt = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String> location = const Value.absent(),
            Value<String> fileName = const Value.absent(),
            Value<int> sizeBytes = const Value.absent(),
            Value<String?> errorMessage = const Value.absent(),
            Value<String?> googleAccountEmail = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BackupLogsCompanion(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            remoteId: remoteId,
            isDeleted: isDeleted,
            startedAt: startedAt,
            finishedAt: finishedAt,
            status: status,
            location: location,
            fileName: fileName,
            sizeBytes: sizeBytes,
            errorMessage: errorMessage,
            googleAccountEmail: googleAccountEmail,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<SyncStatus> syncStatus = const Value.absent(),
            Value<String?> remoteId = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            required DateTime startedAt,
            Value<DateTime?> finishedAt = const Value.absent(),
            required String status,
            required String location,
            required String fileName,
            Value<int> sizeBytes = const Value.absent(),
            Value<String?> errorMessage = const Value.absent(),
            Value<String?> googleAccountEmail = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BackupLogsCompanion.insert(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            remoteId: remoteId,
            isDeleted: isDeleted,
            startedAt: startedAt,
            finishedAt: finishedAt,
            status: status,
            location: location,
            fileName: fileName,
            sizeBytes: sizeBytes,
            errorMessage: errorMessage,
            googleAccountEmail: googleAccountEmail,
            rowid: rowid,
          ),
        ));
}

class $$BackupLogsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $BackupLogsTable> {
  $$BackupLogsTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<SyncStatus, SyncStatus, String>
      get syncStatus => $state.composableBuilder(
          column: $state.table.syncStatus,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnFilters<String> get remoteId => $state.composableBuilder(
      column: $state.table.remoteId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isDeleted => $state.composableBuilder(
      column: $state.table.isDeleted,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get startedAt => $state.composableBuilder(
      column: $state.table.startedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get finishedAt => $state.composableBuilder(
      column: $state.table.finishedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get status => $state.composableBuilder(
      column: $state.table.status,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get location => $state.composableBuilder(
      column: $state.table.location,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get fileName => $state.composableBuilder(
      column: $state.table.fileName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get sizeBytes => $state.composableBuilder(
      column: $state.table.sizeBytes,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get errorMessage => $state.composableBuilder(
      column: $state.table.errorMessage,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get googleAccountEmail => $state.composableBuilder(
      column: $state.table.googleAccountEmail,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$BackupLogsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $BackupLogsTable> {
  $$BackupLogsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get syncStatus => $state.composableBuilder(
      column: $state.table.syncStatus,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get remoteId => $state.composableBuilder(
      column: $state.table.remoteId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isDeleted => $state.composableBuilder(
      column: $state.table.isDeleted,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get startedAt => $state.composableBuilder(
      column: $state.table.startedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get finishedAt => $state.composableBuilder(
      column: $state.table.finishedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get status => $state.composableBuilder(
      column: $state.table.status,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get location => $state.composableBuilder(
      column: $state.table.location,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get fileName => $state.composableBuilder(
      column: $state.table.fileName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get sizeBytes => $state.composableBuilder(
      column: $state.table.sizeBytes,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get errorMessage => $state.composableBuilder(
      column: $state.table.errorMessage,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get googleAccountEmail => $state.composableBuilder(
      column: $state.table.googleAccountEmail,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$PartyLedgerTableCreateCompanionBuilder = PartyLedgerCompanion
    Function({
  required String id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<SyncStatus> syncStatus,
  Value<String?> remoteId,
  Value<bool> isDeleted,
  required String partyType,
  required String partyId,
  required String entryType,
  required int amountPaisa,
  required int balanceAfterPaisa,
  Value<String?> refId,
  Value<String?> refNumber,
  Value<String?> notes,
  required DateTime entryDate,
  Value<int> rowid,
});
typedef $$PartyLedgerTableUpdateCompanionBuilder = PartyLedgerCompanion
    Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<SyncStatus> syncStatus,
  Value<String?> remoteId,
  Value<bool> isDeleted,
  Value<String> partyType,
  Value<String> partyId,
  Value<String> entryType,
  Value<int> amountPaisa,
  Value<int> balanceAfterPaisa,
  Value<String?> refId,
  Value<String?> refNumber,
  Value<String?> notes,
  Value<DateTime> entryDate,
  Value<int> rowid,
});

class $$PartyLedgerTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PartyLedgerTable,
    PartyLedgerData,
    $$PartyLedgerTableFilterComposer,
    $$PartyLedgerTableOrderingComposer,
    $$PartyLedgerTableCreateCompanionBuilder,
    $$PartyLedgerTableUpdateCompanionBuilder> {
  $$PartyLedgerTableTableManager(_$AppDatabase db, $PartyLedgerTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$PartyLedgerTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$PartyLedgerTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<SyncStatus> syncStatus = const Value.absent(),
            Value<String?> remoteId = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<String> partyType = const Value.absent(),
            Value<String> partyId = const Value.absent(),
            Value<String> entryType = const Value.absent(),
            Value<int> amountPaisa = const Value.absent(),
            Value<int> balanceAfterPaisa = const Value.absent(),
            Value<String?> refId = const Value.absent(),
            Value<String?> refNumber = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> entryDate = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PartyLedgerCompanion(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            remoteId: remoteId,
            isDeleted: isDeleted,
            partyType: partyType,
            partyId: partyId,
            entryType: entryType,
            amountPaisa: amountPaisa,
            balanceAfterPaisa: balanceAfterPaisa,
            refId: refId,
            refNumber: refNumber,
            notes: notes,
            entryDate: entryDate,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<SyncStatus> syncStatus = const Value.absent(),
            Value<String?> remoteId = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            required String partyType,
            required String partyId,
            required String entryType,
            required int amountPaisa,
            required int balanceAfterPaisa,
            Value<String?> refId = const Value.absent(),
            Value<String?> refNumber = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            required DateTime entryDate,
            Value<int> rowid = const Value.absent(),
          }) =>
              PartyLedgerCompanion.insert(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            remoteId: remoteId,
            isDeleted: isDeleted,
            partyType: partyType,
            partyId: partyId,
            entryType: entryType,
            amountPaisa: amountPaisa,
            balanceAfterPaisa: balanceAfterPaisa,
            refId: refId,
            refNumber: refNumber,
            notes: notes,
            entryDate: entryDate,
            rowid: rowid,
          ),
        ));
}

class $$PartyLedgerTableFilterComposer
    extends FilterComposer<_$AppDatabase, $PartyLedgerTable> {
  $$PartyLedgerTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<SyncStatus, SyncStatus, String>
      get syncStatus => $state.composableBuilder(
          column: $state.table.syncStatus,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnFilters<String> get remoteId => $state.composableBuilder(
      column: $state.table.remoteId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isDeleted => $state.composableBuilder(
      column: $state.table.isDeleted,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get partyType => $state.composableBuilder(
      column: $state.table.partyType,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get partyId => $state.composableBuilder(
      column: $state.table.partyId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get entryType => $state.composableBuilder(
      column: $state.table.entryType,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get amountPaisa => $state.composableBuilder(
      column: $state.table.amountPaisa,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get balanceAfterPaisa => $state.composableBuilder(
      column: $state.table.balanceAfterPaisa,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get refId => $state.composableBuilder(
      column: $state.table.refId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get refNumber => $state.composableBuilder(
      column: $state.table.refNumber,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get notes => $state.composableBuilder(
      column: $state.table.notes,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get entryDate => $state.composableBuilder(
      column: $state.table.entryDate,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$PartyLedgerTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $PartyLedgerTable> {
  $$PartyLedgerTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get syncStatus => $state.composableBuilder(
      column: $state.table.syncStatus,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get remoteId => $state.composableBuilder(
      column: $state.table.remoteId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isDeleted => $state.composableBuilder(
      column: $state.table.isDeleted,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get partyType => $state.composableBuilder(
      column: $state.table.partyType,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get partyId => $state.composableBuilder(
      column: $state.table.partyId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get entryType => $state.composableBuilder(
      column: $state.table.entryType,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get amountPaisa => $state.composableBuilder(
      column: $state.table.amountPaisa,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get balanceAfterPaisa => $state.composableBuilder(
      column: $state.table.balanceAfterPaisa,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get refId => $state.composableBuilder(
      column: $state.table.refId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get refNumber => $state.composableBuilder(
      column: $state.table.refNumber,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get notes => $state.composableBuilder(
      column: $state.table.notes,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get entryDate => $state.composableBuilder(
      column: $state.table.entryDate,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$PartyPaymentsTableCreateCompanionBuilder = PartyPaymentsCompanion
    Function({
  required String id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<SyncStatus> syncStatus,
  Value<String?> remoteId,
  Value<bool> isDeleted,
  required String partyType,
  required String partyId,
  required int amountPaisa,
  required String paymentMode,
  required String receiptNumber,
  required DateTime paymentDate,
  Value<String?> notes,
  Value<int> rowid,
});
typedef $$PartyPaymentsTableUpdateCompanionBuilder = PartyPaymentsCompanion
    Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<SyncStatus> syncStatus,
  Value<String?> remoteId,
  Value<bool> isDeleted,
  Value<String> partyType,
  Value<String> partyId,
  Value<int> amountPaisa,
  Value<String> paymentMode,
  Value<String> receiptNumber,
  Value<DateTime> paymentDate,
  Value<String?> notes,
  Value<int> rowid,
});

class $$PartyPaymentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PartyPaymentsTable,
    PartyPayment,
    $$PartyPaymentsTableFilterComposer,
    $$PartyPaymentsTableOrderingComposer,
    $$PartyPaymentsTableCreateCompanionBuilder,
    $$PartyPaymentsTableUpdateCompanionBuilder> {
  $$PartyPaymentsTableTableManager(_$AppDatabase db, $PartyPaymentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$PartyPaymentsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$PartyPaymentsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<SyncStatus> syncStatus = const Value.absent(),
            Value<String?> remoteId = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<String> partyType = const Value.absent(),
            Value<String> partyId = const Value.absent(),
            Value<int> amountPaisa = const Value.absent(),
            Value<String> paymentMode = const Value.absent(),
            Value<String> receiptNumber = const Value.absent(),
            Value<DateTime> paymentDate = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PartyPaymentsCompanion(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            remoteId: remoteId,
            isDeleted: isDeleted,
            partyType: partyType,
            partyId: partyId,
            amountPaisa: amountPaisa,
            paymentMode: paymentMode,
            receiptNumber: receiptNumber,
            paymentDate: paymentDate,
            notes: notes,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<SyncStatus> syncStatus = const Value.absent(),
            Value<String?> remoteId = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            required String partyType,
            required String partyId,
            required int amountPaisa,
            required String paymentMode,
            required String receiptNumber,
            required DateTime paymentDate,
            Value<String?> notes = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PartyPaymentsCompanion.insert(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            remoteId: remoteId,
            isDeleted: isDeleted,
            partyType: partyType,
            partyId: partyId,
            amountPaisa: amountPaisa,
            paymentMode: paymentMode,
            receiptNumber: receiptNumber,
            paymentDate: paymentDate,
            notes: notes,
            rowid: rowid,
          ),
        ));
}

class $$PartyPaymentsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $PartyPaymentsTable> {
  $$PartyPaymentsTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<SyncStatus, SyncStatus, String>
      get syncStatus => $state.composableBuilder(
          column: $state.table.syncStatus,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnFilters<String> get remoteId => $state.composableBuilder(
      column: $state.table.remoteId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isDeleted => $state.composableBuilder(
      column: $state.table.isDeleted,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get partyType => $state.composableBuilder(
      column: $state.table.partyType,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get partyId => $state.composableBuilder(
      column: $state.table.partyId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get amountPaisa => $state.composableBuilder(
      column: $state.table.amountPaisa,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get paymentMode => $state.composableBuilder(
      column: $state.table.paymentMode,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get receiptNumber => $state.composableBuilder(
      column: $state.table.receiptNumber,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get paymentDate => $state.composableBuilder(
      column: $state.table.paymentDate,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get notes => $state.composableBuilder(
      column: $state.table.notes,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$PartyPaymentsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $PartyPaymentsTable> {
  $$PartyPaymentsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get syncStatus => $state.composableBuilder(
      column: $state.table.syncStatus,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get remoteId => $state.composableBuilder(
      column: $state.table.remoteId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isDeleted => $state.composableBuilder(
      column: $state.table.isDeleted,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get partyType => $state.composableBuilder(
      column: $state.table.partyType,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get partyId => $state.composableBuilder(
      column: $state.table.partyId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get amountPaisa => $state.composableBuilder(
      column: $state.table.amountPaisa,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get paymentMode => $state.composableBuilder(
      column: $state.table.paymentMode,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get receiptNumber => $state.composableBuilder(
      column: $state.table.receiptNumber,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get paymentDate => $state.composableBuilder(
      column: $state.table.paymentDate,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get notes => $state.composableBuilder(
      column: $state.table.notes,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$LocalAuthTableCreateCompanionBuilder = LocalAuthCompanion Function({
  required String id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<SyncStatus> syncStatus,
  Value<String?> remoteId,
  Value<bool> isDeleted,
  required String username,
  required String passwordHash,
  required String passwordSalt,
  Value<String> securityQuestion,
  Value<String?> securityAnswerHash,
  Value<int> failedAttempts,
  Value<DateTime?> lockedUntil,
  Value<String?> displayName,
  Value<int> rowid,
});
typedef $$LocalAuthTableUpdateCompanionBuilder = LocalAuthCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<SyncStatus> syncStatus,
  Value<String?> remoteId,
  Value<bool> isDeleted,
  Value<String> username,
  Value<String> passwordHash,
  Value<String> passwordSalt,
  Value<String> securityQuestion,
  Value<String?> securityAnswerHash,
  Value<int> failedAttempts,
  Value<DateTime?> lockedUntil,
  Value<String?> displayName,
  Value<int> rowid,
});

class $$LocalAuthTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LocalAuthTable,
    LocalAuthData,
    $$LocalAuthTableFilterComposer,
    $$LocalAuthTableOrderingComposer,
    $$LocalAuthTableCreateCompanionBuilder,
    $$LocalAuthTableUpdateCompanionBuilder> {
  $$LocalAuthTableTableManager(_$AppDatabase db, $LocalAuthTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$LocalAuthTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$LocalAuthTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<SyncStatus> syncStatus = const Value.absent(),
            Value<String?> remoteId = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<String> username = const Value.absent(),
            Value<String> passwordHash = const Value.absent(),
            Value<String> passwordSalt = const Value.absent(),
            Value<String> securityQuestion = const Value.absent(),
            Value<String?> securityAnswerHash = const Value.absent(),
            Value<int> failedAttempts = const Value.absent(),
            Value<DateTime?> lockedUntil = const Value.absent(),
            Value<String?> displayName = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LocalAuthCompanion(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            remoteId: remoteId,
            isDeleted: isDeleted,
            username: username,
            passwordHash: passwordHash,
            passwordSalt: passwordSalt,
            securityQuestion: securityQuestion,
            securityAnswerHash: securityAnswerHash,
            failedAttempts: failedAttempts,
            lockedUntil: lockedUntil,
            displayName: displayName,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<SyncStatus> syncStatus = const Value.absent(),
            Value<String?> remoteId = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            required String username,
            required String passwordHash,
            required String passwordSalt,
            Value<String> securityQuestion = const Value.absent(),
            Value<String?> securityAnswerHash = const Value.absent(),
            Value<int> failedAttempts = const Value.absent(),
            Value<DateTime?> lockedUntil = const Value.absent(),
            Value<String?> displayName = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LocalAuthCompanion.insert(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            remoteId: remoteId,
            isDeleted: isDeleted,
            username: username,
            passwordHash: passwordHash,
            passwordSalt: passwordSalt,
            securityQuestion: securityQuestion,
            securityAnswerHash: securityAnswerHash,
            failedAttempts: failedAttempts,
            lockedUntil: lockedUntil,
            displayName: displayName,
            rowid: rowid,
          ),
        ));
}

class $$LocalAuthTableFilterComposer
    extends FilterComposer<_$AppDatabase, $LocalAuthTable> {
  $$LocalAuthTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<SyncStatus, SyncStatus, String>
      get syncStatus => $state.composableBuilder(
          column: $state.table.syncStatus,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnFilters<String> get remoteId => $state.composableBuilder(
      column: $state.table.remoteId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isDeleted => $state.composableBuilder(
      column: $state.table.isDeleted,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get username => $state.composableBuilder(
      column: $state.table.username,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get passwordHash => $state.composableBuilder(
      column: $state.table.passwordHash,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get passwordSalt => $state.composableBuilder(
      column: $state.table.passwordSalt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get securityQuestion => $state.composableBuilder(
      column: $state.table.securityQuestion,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get securityAnswerHash => $state.composableBuilder(
      column: $state.table.securityAnswerHash,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get failedAttempts => $state.composableBuilder(
      column: $state.table.failedAttempts,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get lockedUntil => $state.composableBuilder(
      column: $state.table.lockedUntil,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get displayName => $state.composableBuilder(
      column: $state.table.displayName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$LocalAuthTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $LocalAuthTable> {
  $$LocalAuthTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get syncStatus => $state.composableBuilder(
      column: $state.table.syncStatus,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get remoteId => $state.composableBuilder(
      column: $state.table.remoteId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isDeleted => $state.composableBuilder(
      column: $state.table.isDeleted,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get username => $state.composableBuilder(
      column: $state.table.username,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get passwordHash => $state.composableBuilder(
      column: $state.table.passwordHash,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get passwordSalt => $state.composableBuilder(
      column: $state.table.passwordSalt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get securityQuestion => $state.composableBuilder(
      column: $state.table.securityQuestion,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get securityAnswerHash => $state.composableBuilder(
      column: $state.table.securityAnswerHash,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get failedAttempts => $state.composableBuilder(
      column: $state.table.failedAttempts,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get lockedUntil => $state.composableBuilder(
      column: $state.table.lockedUntil,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get displayName => $state.composableBuilder(
      column: $state.table.displayName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$PrinterSettingsTableCreateCompanionBuilder = PrinterSettingsCompanion
    Function({
  required String id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<SyncStatus> syncStatus,
  Value<String?> remoteId,
  Value<bool> isDeleted,
  Value<String> defaultFormat,
  Value<String> connectionType,
  Value<String> ipAddress,
  Value<int> port,
  Value<String?> usbPrinterName,
  Value<int> paperWidth,
  Value<int> printCopies,
  Value<bool> autoPrintAfterSale,
  Value<bool> showNepaliHeader,
  Value<bool> showQrCode,
  Value<bool> showFooterBranding,
  Value<bool> enableRasterNepali,
  Value<bool> cutPaper,
  Value<int> feedLines,
  Value<int> dpi,
  Value<int> rowid,
});
typedef $$PrinterSettingsTableUpdateCompanionBuilder = PrinterSettingsCompanion
    Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<SyncStatus> syncStatus,
  Value<String?> remoteId,
  Value<bool> isDeleted,
  Value<String> defaultFormat,
  Value<String> connectionType,
  Value<String> ipAddress,
  Value<int> port,
  Value<String?> usbPrinterName,
  Value<int> paperWidth,
  Value<int> printCopies,
  Value<bool> autoPrintAfterSale,
  Value<bool> showNepaliHeader,
  Value<bool> showQrCode,
  Value<bool> showFooterBranding,
  Value<bool> enableRasterNepali,
  Value<bool> cutPaper,
  Value<int> feedLines,
  Value<int> dpi,
  Value<int> rowid,
});

class $$PrinterSettingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PrinterSettingsTable,
    PrinterSetting,
    $$PrinterSettingsTableFilterComposer,
    $$PrinterSettingsTableOrderingComposer,
    $$PrinterSettingsTableCreateCompanionBuilder,
    $$PrinterSettingsTableUpdateCompanionBuilder> {
  $$PrinterSettingsTableTableManager(
      _$AppDatabase db, $PrinterSettingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$PrinterSettingsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$PrinterSettingsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<SyncStatus> syncStatus = const Value.absent(),
            Value<String?> remoteId = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<String> defaultFormat = const Value.absent(),
            Value<String> connectionType = const Value.absent(),
            Value<String> ipAddress = const Value.absent(),
            Value<int> port = const Value.absent(),
            Value<String?> usbPrinterName = const Value.absent(),
            Value<int> paperWidth = const Value.absent(),
            Value<int> printCopies = const Value.absent(),
            Value<bool> autoPrintAfterSale = const Value.absent(),
            Value<bool> showNepaliHeader = const Value.absent(),
            Value<bool> showQrCode = const Value.absent(),
            Value<bool> showFooterBranding = const Value.absent(),
            Value<bool> enableRasterNepali = const Value.absent(),
            Value<bool> cutPaper = const Value.absent(),
            Value<int> feedLines = const Value.absent(),
            Value<int> dpi = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PrinterSettingsCompanion(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            remoteId: remoteId,
            isDeleted: isDeleted,
            defaultFormat: defaultFormat,
            connectionType: connectionType,
            ipAddress: ipAddress,
            port: port,
            usbPrinterName: usbPrinterName,
            paperWidth: paperWidth,
            printCopies: printCopies,
            autoPrintAfterSale: autoPrintAfterSale,
            showNepaliHeader: showNepaliHeader,
            showQrCode: showQrCode,
            showFooterBranding: showFooterBranding,
            enableRasterNepali: enableRasterNepali,
            cutPaper: cutPaper,
            feedLines: feedLines,
            dpi: dpi,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<SyncStatus> syncStatus = const Value.absent(),
            Value<String?> remoteId = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<String> defaultFormat = const Value.absent(),
            Value<String> connectionType = const Value.absent(),
            Value<String> ipAddress = const Value.absent(),
            Value<int> port = const Value.absent(),
            Value<String?> usbPrinterName = const Value.absent(),
            Value<int> paperWidth = const Value.absent(),
            Value<int> printCopies = const Value.absent(),
            Value<bool> autoPrintAfterSale = const Value.absent(),
            Value<bool> showNepaliHeader = const Value.absent(),
            Value<bool> showQrCode = const Value.absent(),
            Value<bool> showFooterBranding = const Value.absent(),
            Value<bool> enableRasterNepali = const Value.absent(),
            Value<bool> cutPaper = const Value.absent(),
            Value<int> feedLines = const Value.absent(),
            Value<int> dpi = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PrinterSettingsCompanion.insert(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            remoteId: remoteId,
            isDeleted: isDeleted,
            defaultFormat: defaultFormat,
            connectionType: connectionType,
            ipAddress: ipAddress,
            port: port,
            usbPrinterName: usbPrinterName,
            paperWidth: paperWidth,
            printCopies: printCopies,
            autoPrintAfterSale: autoPrintAfterSale,
            showNepaliHeader: showNepaliHeader,
            showQrCode: showQrCode,
            showFooterBranding: showFooterBranding,
            enableRasterNepali: enableRasterNepali,
            cutPaper: cutPaper,
            feedLines: feedLines,
            dpi: dpi,
            rowid: rowid,
          ),
        ));
}

class $$PrinterSettingsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $PrinterSettingsTable> {
  $$PrinterSettingsTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<SyncStatus, SyncStatus, String>
      get syncStatus => $state.composableBuilder(
          column: $state.table.syncStatus,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnFilters<String> get remoteId => $state.composableBuilder(
      column: $state.table.remoteId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isDeleted => $state.composableBuilder(
      column: $state.table.isDeleted,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get defaultFormat => $state.composableBuilder(
      column: $state.table.defaultFormat,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get connectionType => $state.composableBuilder(
      column: $state.table.connectionType,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get ipAddress => $state.composableBuilder(
      column: $state.table.ipAddress,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get port => $state.composableBuilder(
      column: $state.table.port,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get usbPrinterName => $state.composableBuilder(
      column: $state.table.usbPrinterName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get paperWidth => $state.composableBuilder(
      column: $state.table.paperWidth,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get printCopies => $state.composableBuilder(
      column: $state.table.printCopies,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get autoPrintAfterSale => $state.composableBuilder(
      column: $state.table.autoPrintAfterSale,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get showNepaliHeader => $state.composableBuilder(
      column: $state.table.showNepaliHeader,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get showQrCode => $state.composableBuilder(
      column: $state.table.showQrCode,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get showFooterBranding => $state.composableBuilder(
      column: $state.table.showFooterBranding,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get enableRasterNepali => $state.composableBuilder(
      column: $state.table.enableRasterNepali,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get cutPaper => $state.composableBuilder(
      column: $state.table.cutPaper,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get feedLines => $state.composableBuilder(
      column: $state.table.feedLines,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get dpi => $state.composableBuilder(
      column: $state.table.dpi,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$PrinterSettingsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $PrinterSettingsTable> {
  $$PrinterSettingsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get syncStatus => $state.composableBuilder(
      column: $state.table.syncStatus,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get remoteId => $state.composableBuilder(
      column: $state.table.remoteId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isDeleted => $state.composableBuilder(
      column: $state.table.isDeleted,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get defaultFormat => $state.composableBuilder(
      column: $state.table.defaultFormat,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get connectionType => $state.composableBuilder(
      column: $state.table.connectionType,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get ipAddress => $state.composableBuilder(
      column: $state.table.ipAddress,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get port => $state.composableBuilder(
      column: $state.table.port,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get usbPrinterName => $state.composableBuilder(
      column: $state.table.usbPrinterName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get paperWidth => $state.composableBuilder(
      column: $state.table.paperWidth,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get printCopies => $state.composableBuilder(
      column: $state.table.printCopies,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get autoPrintAfterSale => $state.composableBuilder(
      column: $state.table.autoPrintAfterSale,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get showNepaliHeader => $state.composableBuilder(
      column: $state.table.showNepaliHeader,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get showQrCode => $state.composableBuilder(
      column: $state.table.showQrCode,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get showFooterBranding => $state.composableBuilder(
      column: $state.table.showFooterBranding,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get enableRasterNepali => $state.composableBuilder(
      column: $state.table.enableRasterNepali,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get cutPaper => $state.composableBuilder(
      column: $state.table.cutPaper,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get feedLines => $state.composableBuilder(
      column: $state.table.feedLines,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get dpi => $state.composableBuilder(
      column: $state.table.dpi,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$SyncQueueItemsTableCreateCompanionBuilder = SyncQueueItemsCompanion
    Function({
  Value<int> id,
  required String opType,
  required String payloadJson,
  required String idempotencyKey,
  Value<String> status,
  Value<int> attempts,
  Value<String?> lastError,
  Value<DateTime> createdAt,
  Value<DateTime?> syncedAt,
  Value<String?> serverResponseJson,
});
typedef $$SyncQueueItemsTableUpdateCompanionBuilder = SyncQueueItemsCompanion
    Function({
  Value<int> id,
  Value<String> opType,
  Value<String> payloadJson,
  Value<String> idempotencyKey,
  Value<String> status,
  Value<int> attempts,
  Value<String?> lastError,
  Value<DateTime> createdAt,
  Value<DateTime?> syncedAt,
  Value<String?> serverResponseJson,
});

class $$SyncQueueItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SyncQueueItemsTable,
    SyncQueueItem,
    $$SyncQueueItemsTableFilterComposer,
    $$SyncQueueItemsTableOrderingComposer,
    $$SyncQueueItemsTableCreateCompanionBuilder,
    $$SyncQueueItemsTableUpdateCompanionBuilder> {
  $$SyncQueueItemsTableTableManager(
      _$AppDatabase db, $SyncQueueItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$SyncQueueItemsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$SyncQueueItemsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> opType = const Value.absent(),
            Value<String> payloadJson = const Value.absent(),
            Value<String> idempotencyKey = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> attempts = const Value.absent(),
            Value<String?> lastError = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> syncedAt = const Value.absent(),
            Value<String?> serverResponseJson = const Value.absent(),
          }) =>
              SyncQueueItemsCompanion(
            id: id,
            opType: opType,
            payloadJson: payloadJson,
            idempotencyKey: idempotencyKey,
            status: status,
            attempts: attempts,
            lastError: lastError,
            createdAt: createdAt,
            syncedAt: syncedAt,
            serverResponseJson: serverResponseJson,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String opType,
            required String payloadJson,
            required String idempotencyKey,
            Value<String> status = const Value.absent(),
            Value<int> attempts = const Value.absent(),
            Value<String?> lastError = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> syncedAt = const Value.absent(),
            Value<String?> serverResponseJson = const Value.absent(),
          }) =>
              SyncQueueItemsCompanion.insert(
            id: id,
            opType: opType,
            payloadJson: payloadJson,
            idempotencyKey: idempotencyKey,
            status: status,
            attempts: attempts,
            lastError: lastError,
            createdAt: createdAt,
            syncedAt: syncedAt,
            serverResponseJson: serverResponseJson,
          ),
        ));
}

class $$SyncQueueItemsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $SyncQueueItemsTable> {
  $$SyncQueueItemsTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get opType => $state.composableBuilder(
      column: $state.table.opType,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get payloadJson => $state.composableBuilder(
      column: $state.table.payloadJson,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get idempotencyKey => $state.composableBuilder(
      column: $state.table.idempotencyKey,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get status => $state.composableBuilder(
      column: $state.table.status,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get attempts => $state.composableBuilder(
      column: $state.table.attempts,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get lastError => $state.composableBuilder(
      column: $state.table.lastError,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get syncedAt => $state.composableBuilder(
      column: $state.table.syncedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get serverResponseJson => $state.composableBuilder(
      column: $state.table.serverResponseJson,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$SyncQueueItemsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $SyncQueueItemsTable> {
  $$SyncQueueItemsTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get opType => $state.composableBuilder(
      column: $state.table.opType,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get payloadJson => $state.composableBuilder(
      column: $state.table.payloadJson,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get idempotencyKey => $state.composableBuilder(
      column: $state.table.idempotencyKey,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get status => $state.composableBuilder(
      column: $state.table.status,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get attempts => $state.composableBuilder(
      column: $state.table.attempts,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get lastError => $state.composableBuilder(
      column: $state.table.lastError,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get syncedAt => $state.composableBuilder(
      column: $state.table.syncedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get serverResponseJson => $state.composableBuilder(
      column: $state.table.serverResponseJson,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$BusinessProfilesTableTableManager get businessProfiles =>
      $$BusinessProfilesTableTableManager(_db, _db.businessProfiles);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$UnitsTableTableManager get units =>
      $$UnitsTableTableManager(_db, _db.units);
  $$ItemsTableTableManager get items =>
      $$ItemsTableTableManager(_db, _db.items);
  $$InventoriesTableTableManager get inventories =>
      $$InventoriesTableTableManager(_db, _db.inventories);
  $$SuppliersTableTableManager get suppliers =>
      $$SuppliersTableTableManager(_db, _db.suppliers);
  $$CustomersTableTableManager get customers =>
      $$CustomersTableTableManager(_db, _db.customers);
  $$StockLedgerTableTableManager get stockLedger =>
      $$StockLedgerTableTableManager(_db, _db.stockLedger);
  $$StockAdjustmentsTableTableManager get stockAdjustments =>
      $$StockAdjustmentsTableTableManager(_db, _db.stockAdjustments);
  $$PurchasesTableTableManager get purchases =>
      $$PurchasesTableTableManager(_db, _db.purchases);
  $$PurchaseItemsTableTableManager get purchaseItems =>
      $$PurchaseItemsTableTableManager(_db, _db.purchaseItems);
  $$SalesTableTableManager get sales =>
      $$SalesTableTableManager(_db, _db.sales);
  $$SaleItemsTableTableManager get saleItems =>
      $$SaleItemsTableTableManager(_db, _db.saleItems);
  $$BillMetadataTableTableManager get billMetadata =>
      $$BillMetadataTableTableManager(_db, _db.billMetadata);
  $$BillSequenceTableTableManager get billSequence =>
      $$BillSequenceTableTableManager(_db, _db.billSequence);
  $$BackupLogsTableTableManager get backupLogs =>
      $$BackupLogsTableTableManager(_db, _db.backupLogs);
  $$PartyLedgerTableTableManager get partyLedger =>
      $$PartyLedgerTableTableManager(_db, _db.partyLedger);
  $$PartyPaymentsTableTableManager get partyPayments =>
      $$PartyPaymentsTableTableManager(_db, _db.partyPayments);
  $$LocalAuthTableTableManager get localAuth =>
      $$LocalAuthTableTableManager(_db, _db.localAuth);
  $$PrinterSettingsTableTableManager get printerSettings =>
      $$PrinterSettingsTableTableManager(_db, _db.printerSettings);
  $$SyncQueueItemsTableTableManager get syncQueueItems =>
      $$SyncQueueItemsTableTableManager(_db, _db.syncQueueItems);
}
