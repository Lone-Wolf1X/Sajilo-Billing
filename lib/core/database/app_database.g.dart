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
  static const VerificationMeta _businessNameMeta =
      const VerificationMeta('businessName');
  @override
  late final GeneratedColumn<String> businessName = GeneratedColumn<String>(
      'business_name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 200),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
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
        businessName,
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
    if (data.containsKey('business_name')) {
      context.handle(
          _businessNameMeta,
          businessName.isAcceptableOrUnknown(
              data['business_name']!, _businessNameMeta));
    } else if (isInserting) {
      context.missing(_businessNameMeta);
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
      businessName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}business_name'])!,
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
  final String businessName;
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
      required this.businessName,
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
    map['business_name'] = Variable<String>(businessName);
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
      businessName: Value(businessName),
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
      businessName: serializer.fromJson<String>(json['businessName']),
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
      'businessName': serializer.toJson<String>(businessName),
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
          String? businessName,
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
        businessName: businessName ?? this.businessName,
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
      businessName: data.businessName.present
          ? data.businessName.value
          : this.businessName,
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
          ..write('businessName: $businessName, ')
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
      businessName,
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
          other.businessName == this.businessName &&
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
  final Value<String> businessName;
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
    this.businessName = const Value.absent(),
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
    required String businessName,
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
    Expression<String>? businessName,
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
      if (businessName != null) 'business_name': businessName,
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
      Value<String>? businessName,
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
      businessName: businessName ?? this.businessName,
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
    if (businessName.present) {
      map['business_name'] = Variable<String>(businessName.value);
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
          ..write('businessName: $businessName, ')
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
  int get hashCode => Object.hash(id, createdAt, updatedAt, syncStatus,
      remoteId, name, sku, unit, unitPrice, costPrice, stockQuantity, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Inventory &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus &&
          other.remoteId == this.remoteId &&
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
  static const VerificationMeta _invoiceNumberMeta =
      const VerificationMeta('invoiceNumber');
  @override
  late final GeneratedColumn<String> invoiceNumber = GeneratedColumn<String>(
      'invoice_number', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _customerNameMeta =
      const VerificationMeta('customerName');
  @override
  late final GeneratedColumn<String> customerName = GeneratedColumn<String>(
      'customer_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
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
  static const VerificationMeta _subtotalMeta =
      const VerificationMeta('subtotal');
  @override
  late final GeneratedColumn<double> subtotal = GeneratedColumn<double>(
      'subtotal', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _discountAmountMeta =
      const VerificationMeta('discountAmount');
  @override
  late final GeneratedColumn<double> discountAmount = GeneratedColumn<double>(
      'discount_amount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _taxableAmountMeta =
      const VerificationMeta('taxableAmount');
  @override
  late final GeneratedColumn<double> taxableAmount = GeneratedColumn<double>(
      'taxable_amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _vatAmountMeta =
      const VerificationMeta('vatAmount');
  @override
  late final GeneratedColumn<double> vatAmount = GeneratedColumn<double>(
      'vat_amount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _totalAmountMeta =
      const VerificationMeta('totalAmount');
  @override
  late final GeneratedColumn<double> totalAmount = GeneratedColumn<double>(
      'total_amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
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
  @override
  List<GeneratedColumn> get $columns => [
        id,
        createdAt,
        updatedAt,
        syncStatus,
        remoteId,
        invoiceNumber,
        customerName,
        customerPan,
        customerPhone,
        invoiceDate,
        subtotal,
        discountAmount,
        taxableAmount,
        vatAmount,
        totalAmount,
        paymentMode,
        notes
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
    if (data.containsKey('invoice_number')) {
      context.handle(
          _invoiceNumberMeta,
          invoiceNumber.isAcceptableOrUnknown(
              data['invoice_number']!, _invoiceNumberMeta));
    } else if (isInserting) {
      context.missing(_invoiceNumberMeta);
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
    if (data.containsKey('subtotal')) {
      context.handle(_subtotalMeta,
          subtotal.isAcceptableOrUnknown(data['subtotal']!, _subtotalMeta));
    } else if (isInserting) {
      context.missing(_subtotalMeta);
    }
    if (data.containsKey('discount_amount')) {
      context.handle(
          _discountAmountMeta,
          discountAmount.isAcceptableOrUnknown(
              data['discount_amount']!, _discountAmountMeta));
    }
    if (data.containsKey('taxable_amount')) {
      context.handle(
          _taxableAmountMeta,
          taxableAmount.isAcceptableOrUnknown(
              data['taxable_amount']!, _taxableAmountMeta));
    } else if (isInserting) {
      context.missing(_taxableAmountMeta);
    }
    if (data.containsKey('vat_amount')) {
      context.handle(_vatAmountMeta,
          vatAmount.isAcceptableOrUnknown(data['vat_amount']!, _vatAmountMeta));
    }
    if (data.containsKey('total_amount')) {
      context.handle(
          _totalAmountMeta,
          totalAmount.isAcceptableOrUnknown(
              data['total_amount']!, _totalAmountMeta));
    } else if (isInserting) {
      context.missing(_totalAmountMeta);
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
      invoiceNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}invoice_number'])!,
      customerName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}customer_name']),
      customerPan: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}customer_pan']),
      customerPhone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}customer_phone']),
      invoiceDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}invoice_date'])!,
      subtotal: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}subtotal'])!,
      discountAmount: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}discount_amount'])!,
      taxableAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}taxable_amount'])!,
      vatAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}vat_amount'])!,
      totalAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_amount'])!,
      paymentMode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payment_mode'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
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
  final String invoiceNumber;
  final String? customerName;
  final String? customerPan;
  final String? customerPhone;
  final DateTime invoiceDate;
  final double subtotal;
  final double discountAmount;
  final double taxableAmount;
  final double vatAmount;
  final double totalAmount;
  final String paymentMode;
  final String? notes;
  const Sale(
      {required this.id,
      required this.createdAt,
      required this.updatedAt,
      required this.syncStatus,
      this.remoteId,
      required this.invoiceNumber,
      this.customerName,
      this.customerPan,
      this.customerPhone,
      required this.invoiceDate,
      required this.subtotal,
      required this.discountAmount,
      required this.taxableAmount,
      required this.vatAmount,
      required this.totalAmount,
      required this.paymentMode,
      this.notes});
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
    map['invoice_number'] = Variable<String>(invoiceNumber);
    if (!nullToAbsent || customerName != null) {
      map['customer_name'] = Variable<String>(customerName);
    }
    if (!nullToAbsent || customerPan != null) {
      map['customer_pan'] = Variable<String>(customerPan);
    }
    if (!nullToAbsent || customerPhone != null) {
      map['customer_phone'] = Variable<String>(customerPhone);
    }
    map['invoice_date'] = Variable<DateTime>(invoiceDate);
    map['subtotal'] = Variable<double>(subtotal);
    map['discount_amount'] = Variable<double>(discountAmount);
    map['taxable_amount'] = Variable<double>(taxableAmount);
    map['vat_amount'] = Variable<double>(vatAmount);
    map['total_amount'] = Variable<double>(totalAmount);
    map['payment_mode'] = Variable<String>(paymentMode);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
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
      invoiceNumber: Value(invoiceNumber),
      customerName: customerName == null && nullToAbsent
          ? const Value.absent()
          : Value(customerName),
      customerPan: customerPan == null && nullToAbsent
          ? const Value.absent()
          : Value(customerPan),
      customerPhone: customerPhone == null && nullToAbsent
          ? const Value.absent()
          : Value(customerPhone),
      invoiceDate: Value(invoiceDate),
      subtotal: Value(subtotal),
      discountAmount: Value(discountAmount),
      taxableAmount: Value(taxableAmount),
      vatAmount: Value(vatAmount),
      totalAmount: Value(totalAmount),
      paymentMode: Value(paymentMode),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
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
      invoiceNumber: serializer.fromJson<String>(json['invoiceNumber']),
      customerName: serializer.fromJson<String?>(json['customerName']),
      customerPan: serializer.fromJson<String?>(json['customerPan']),
      customerPhone: serializer.fromJson<String?>(json['customerPhone']),
      invoiceDate: serializer.fromJson<DateTime>(json['invoiceDate']),
      subtotal: serializer.fromJson<double>(json['subtotal']),
      discountAmount: serializer.fromJson<double>(json['discountAmount']),
      taxableAmount: serializer.fromJson<double>(json['taxableAmount']),
      vatAmount: serializer.fromJson<double>(json['vatAmount']),
      totalAmount: serializer.fromJson<double>(json['totalAmount']),
      paymentMode: serializer.fromJson<String>(json['paymentMode']),
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
      'syncStatus': serializer
          .toJson<String>($SalesTable.$convertersyncStatus.toJson(syncStatus)),
      'remoteId': serializer.toJson<String?>(remoteId),
      'invoiceNumber': serializer.toJson<String>(invoiceNumber),
      'customerName': serializer.toJson<String?>(customerName),
      'customerPan': serializer.toJson<String?>(customerPan),
      'customerPhone': serializer.toJson<String?>(customerPhone),
      'invoiceDate': serializer.toJson<DateTime>(invoiceDate),
      'subtotal': serializer.toJson<double>(subtotal),
      'discountAmount': serializer.toJson<double>(discountAmount),
      'taxableAmount': serializer.toJson<double>(taxableAmount),
      'vatAmount': serializer.toJson<double>(vatAmount),
      'totalAmount': serializer.toJson<double>(totalAmount),
      'paymentMode': serializer.toJson<String>(paymentMode),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  Sale copyWith(
          {String? id,
          DateTime? createdAt,
          DateTime? updatedAt,
          SyncStatus? syncStatus,
          Value<String?> remoteId = const Value.absent(),
          String? invoiceNumber,
          Value<String?> customerName = const Value.absent(),
          Value<String?> customerPan = const Value.absent(),
          Value<String?> customerPhone = const Value.absent(),
          DateTime? invoiceDate,
          double? subtotal,
          double? discountAmount,
          double? taxableAmount,
          double? vatAmount,
          double? totalAmount,
          String? paymentMode,
          Value<String?> notes = const Value.absent()}) =>
      Sale(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        syncStatus: syncStatus ?? this.syncStatus,
        remoteId: remoteId.present ? remoteId.value : this.remoteId,
        invoiceNumber: invoiceNumber ?? this.invoiceNumber,
        customerName:
            customerName.present ? customerName.value : this.customerName,
        customerPan: customerPan.present ? customerPan.value : this.customerPan,
        customerPhone:
            customerPhone.present ? customerPhone.value : this.customerPhone,
        invoiceDate: invoiceDate ?? this.invoiceDate,
        subtotal: subtotal ?? this.subtotal,
        discountAmount: discountAmount ?? this.discountAmount,
        taxableAmount: taxableAmount ?? this.taxableAmount,
        vatAmount: vatAmount ?? this.vatAmount,
        totalAmount: totalAmount ?? this.totalAmount,
        paymentMode: paymentMode ?? this.paymentMode,
        notes: notes.present ? notes.value : this.notes,
      );
  Sale copyWithCompanion(SalesCompanion data) {
    return Sale(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      invoiceNumber: data.invoiceNumber.present
          ? data.invoiceNumber.value
          : this.invoiceNumber,
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
      subtotal: data.subtotal.present ? data.subtotal.value : this.subtotal,
      discountAmount: data.discountAmount.present
          ? data.discountAmount.value
          : this.discountAmount,
      taxableAmount: data.taxableAmount.present
          ? data.taxableAmount.value
          : this.taxableAmount,
      vatAmount: data.vatAmount.present ? data.vatAmount.value : this.vatAmount,
      totalAmount:
          data.totalAmount.present ? data.totalAmount.value : this.totalAmount,
      paymentMode:
          data.paymentMode.present ? data.paymentMode.value : this.paymentMode,
      notes: data.notes.present ? data.notes.value : this.notes,
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
          ..write('invoiceNumber: $invoiceNumber, ')
          ..write('customerName: $customerName, ')
          ..write('customerPan: $customerPan, ')
          ..write('customerPhone: $customerPhone, ')
          ..write('invoiceDate: $invoiceDate, ')
          ..write('subtotal: $subtotal, ')
          ..write('discountAmount: $discountAmount, ')
          ..write('taxableAmount: $taxableAmount, ')
          ..write('vatAmount: $vatAmount, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('paymentMode: $paymentMode, ')
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
      invoiceNumber,
      customerName,
      customerPan,
      customerPhone,
      invoiceDate,
      subtotal,
      discountAmount,
      taxableAmount,
      vatAmount,
      totalAmount,
      paymentMode,
      notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Sale &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus &&
          other.remoteId == this.remoteId &&
          other.invoiceNumber == this.invoiceNumber &&
          other.customerName == this.customerName &&
          other.customerPan == this.customerPan &&
          other.customerPhone == this.customerPhone &&
          other.invoiceDate == this.invoiceDate &&
          other.subtotal == this.subtotal &&
          other.discountAmount == this.discountAmount &&
          other.taxableAmount == this.taxableAmount &&
          other.vatAmount == this.vatAmount &&
          other.totalAmount == this.totalAmount &&
          other.paymentMode == this.paymentMode &&
          other.notes == this.notes);
}

class SalesCompanion extends UpdateCompanion<Sale> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<SyncStatus> syncStatus;
  final Value<String?> remoteId;
  final Value<String> invoiceNumber;
  final Value<String?> customerName;
  final Value<String?> customerPan;
  final Value<String?> customerPhone;
  final Value<DateTime> invoiceDate;
  final Value<double> subtotal;
  final Value<double> discountAmount;
  final Value<double> taxableAmount;
  final Value<double> vatAmount;
  final Value<double> totalAmount;
  final Value<String> paymentMode;
  final Value<String?> notes;
  final Value<int> rowid;
  const SalesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.invoiceNumber = const Value.absent(),
    this.customerName = const Value.absent(),
    this.customerPan = const Value.absent(),
    this.customerPhone = const Value.absent(),
    this.invoiceDate = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.discountAmount = const Value.absent(),
    this.taxableAmount = const Value.absent(),
    this.vatAmount = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.paymentMode = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SalesCompanion.insert({
    required String id,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.remoteId = const Value.absent(),
    required String invoiceNumber,
    this.customerName = const Value.absent(),
    this.customerPan = const Value.absent(),
    this.customerPhone = const Value.absent(),
    this.invoiceDate = const Value.absent(),
    required double subtotal,
    this.discountAmount = const Value.absent(),
    required double taxableAmount,
    this.vatAmount = const Value.absent(),
    required double totalAmount,
    this.paymentMode = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        invoiceNumber = Value(invoiceNumber),
        subtotal = Value(subtotal),
        taxableAmount = Value(taxableAmount),
        totalAmount = Value(totalAmount);
  static Insertable<Sale> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncStatus,
    Expression<String>? remoteId,
    Expression<String>? invoiceNumber,
    Expression<String>? customerName,
    Expression<String>? customerPan,
    Expression<String>? customerPhone,
    Expression<DateTime>? invoiceDate,
    Expression<double>? subtotal,
    Expression<double>? discountAmount,
    Expression<double>? taxableAmount,
    Expression<double>? vatAmount,
    Expression<double>? totalAmount,
    Expression<String>? paymentMode,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (remoteId != null) 'remote_id': remoteId,
      if (invoiceNumber != null) 'invoice_number': invoiceNumber,
      if (customerName != null) 'customer_name': customerName,
      if (customerPan != null) 'customer_pan': customerPan,
      if (customerPhone != null) 'customer_phone': customerPhone,
      if (invoiceDate != null) 'invoice_date': invoiceDate,
      if (subtotal != null) 'subtotal': subtotal,
      if (discountAmount != null) 'discount_amount': discountAmount,
      if (taxableAmount != null) 'taxable_amount': taxableAmount,
      if (vatAmount != null) 'vat_amount': vatAmount,
      if (totalAmount != null) 'total_amount': totalAmount,
      if (paymentMode != null) 'payment_mode': paymentMode,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SalesCompanion copyWith(
      {Value<String>? id,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<SyncStatus>? syncStatus,
      Value<String?>? remoteId,
      Value<String>? invoiceNumber,
      Value<String?>? customerName,
      Value<String?>? customerPan,
      Value<String?>? customerPhone,
      Value<DateTime>? invoiceDate,
      Value<double>? subtotal,
      Value<double>? discountAmount,
      Value<double>? taxableAmount,
      Value<double>? vatAmount,
      Value<double>? totalAmount,
      Value<String>? paymentMode,
      Value<String?>? notes,
      Value<int>? rowid}) {
    return SalesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      remoteId: remoteId ?? this.remoteId,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      customerName: customerName ?? this.customerName,
      customerPan: customerPan ?? this.customerPan,
      customerPhone: customerPhone ?? this.customerPhone,
      invoiceDate: invoiceDate ?? this.invoiceDate,
      subtotal: subtotal ?? this.subtotal,
      discountAmount: discountAmount ?? this.discountAmount,
      taxableAmount: taxableAmount ?? this.taxableAmount,
      vatAmount: vatAmount ?? this.vatAmount,
      totalAmount: totalAmount ?? this.totalAmount,
      paymentMode: paymentMode ?? this.paymentMode,
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
          $SalesTable.$convertersyncStatus.toSql(syncStatus.value));
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    if (invoiceNumber.present) {
      map['invoice_number'] = Variable<String>(invoiceNumber.value);
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
    if (subtotal.present) {
      map['subtotal'] = Variable<double>(subtotal.value);
    }
    if (discountAmount.present) {
      map['discount_amount'] = Variable<double>(discountAmount.value);
    }
    if (taxableAmount.present) {
      map['taxable_amount'] = Variable<double>(taxableAmount.value);
    }
    if (vatAmount.present) {
      map['vat_amount'] = Variable<double>(vatAmount.value);
    }
    if (totalAmount.present) {
      map['total_amount'] = Variable<double>(totalAmount.value);
    }
    if (paymentMode.present) {
      map['payment_mode'] = Variable<String>(paymentMode.value);
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
    return (StringBuffer('SalesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('remoteId: $remoteId, ')
          ..write('invoiceNumber: $invoiceNumber, ')
          ..write('customerName: $customerName, ')
          ..write('customerPan: $customerPan, ')
          ..write('customerPhone: $customerPhone, ')
          ..write('invoiceDate: $invoiceDate, ')
          ..write('subtotal: $subtotal, ')
          ..write('discountAmount: $discountAmount, ')
          ..write('taxableAmount: $taxableAmount, ')
          ..write('vatAmount: $vatAmount, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('paymentMode: $paymentMode, ')
          ..write('notes: $notes, ')
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
  static const VerificationMeta _saleIdMeta = const VerificationMeta('saleId');
  @override
  late final GeneratedColumn<String> saleId = GeneratedColumn<String>(
      'sale_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _itemNameMeta =
      const VerificationMeta('itemName');
  @override
  late final GeneratedColumn<String> itemName = GeneratedColumn<String>(
      'item_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _unitPriceMeta =
      const VerificationMeta('unitPrice');
  @override
  late final GeneratedColumn<double> unitPrice = GeneratedColumn<double>(
      'unit_price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
      'quantity', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pcs'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        createdAt,
        updatedAt,
        syncStatus,
        remoteId,
        saleId,
        itemName,
        unitPrice,
        quantity,
        amount,
        unit
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
    if (data.containsKey('sale_id')) {
      context.handle(_saleIdMeta,
          saleId.isAcceptableOrUnknown(data['sale_id']!, _saleIdMeta));
    } else if (isInserting) {
      context.missing(_saleIdMeta);
    }
    if (data.containsKey('item_name')) {
      context.handle(_itemNameMeta,
          itemName.isAcceptableOrUnknown(data['item_name']!, _itemNameMeta));
    } else if (isInserting) {
      context.missing(_itemNameMeta);
    }
    if (data.containsKey('unit_price')) {
      context.handle(_unitPriceMeta,
          unitPrice.isAcceptableOrUnknown(data['unit_price']!, _unitPriceMeta));
    } else if (isInserting) {
      context.missing(_unitPriceMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
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
      saleId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sale_id'])!,
      itemName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}item_name'])!,
      unitPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}unit_price'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}quantity'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit'])!,
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
  final String saleId;
  final String itemName;
  final double unitPrice;
  final double quantity;
  final double amount;
  final String unit;
  const SaleItem(
      {required this.id,
      required this.createdAt,
      required this.updatedAt,
      required this.syncStatus,
      this.remoteId,
      required this.saleId,
      required this.itemName,
      required this.unitPrice,
      required this.quantity,
      required this.amount,
      required this.unit});
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
    map['sale_id'] = Variable<String>(saleId);
    map['item_name'] = Variable<String>(itemName);
    map['unit_price'] = Variable<double>(unitPrice);
    map['quantity'] = Variable<double>(quantity);
    map['amount'] = Variable<double>(amount);
    map['unit'] = Variable<String>(unit);
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
      saleId: Value(saleId),
      itemName: Value(itemName),
      unitPrice: Value(unitPrice),
      quantity: Value(quantity),
      amount: Value(amount),
      unit: Value(unit),
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
      saleId: serializer.fromJson<String>(json['saleId']),
      itemName: serializer.fromJson<String>(json['itemName']),
      unitPrice: serializer.fromJson<double>(json['unitPrice']),
      quantity: serializer.fromJson<double>(json['quantity']),
      amount: serializer.fromJson<double>(json['amount']),
      unit: serializer.fromJson<String>(json['unit']),
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
      'saleId': serializer.toJson<String>(saleId),
      'itemName': serializer.toJson<String>(itemName),
      'unitPrice': serializer.toJson<double>(unitPrice),
      'quantity': serializer.toJson<double>(quantity),
      'amount': serializer.toJson<double>(amount),
      'unit': serializer.toJson<String>(unit),
    };
  }

  SaleItem copyWith(
          {String? id,
          DateTime? createdAt,
          DateTime? updatedAt,
          SyncStatus? syncStatus,
          Value<String?> remoteId = const Value.absent(),
          String? saleId,
          String? itemName,
          double? unitPrice,
          double? quantity,
          double? amount,
          String? unit}) =>
      SaleItem(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        syncStatus: syncStatus ?? this.syncStatus,
        remoteId: remoteId.present ? remoteId.value : this.remoteId,
        saleId: saleId ?? this.saleId,
        itemName: itemName ?? this.itemName,
        unitPrice: unitPrice ?? this.unitPrice,
        quantity: quantity ?? this.quantity,
        amount: amount ?? this.amount,
        unit: unit ?? this.unit,
      );
  SaleItem copyWithCompanion(SaleItemsCompanion data) {
    return SaleItem(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      saleId: data.saleId.present ? data.saleId.value : this.saleId,
      itemName: data.itemName.present ? data.itemName.value : this.itemName,
      unitPrice: data.unitPrice.present ? data.unitPrice.value : this.unitPrice,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      amount: data.amount.present ? data.amount.value : this.amount,
      unit: data.unit.present ? data.unit.value : this.unit,
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
          ..write('saleId: $saleId, ')
          ..write('itemName: $itemName, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('quantity: $quantity, ')
          ..write('amount: $amount, ')
          ..write('unit: $unit')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, createdAt, updatedAt, syncStatus,
      remoteId, saleId, itemName, unitPrice, quantity, amount, unit);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SaleItem &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus &&
          other.remoteId == this.remoteId &&
          other.saleId == this.saleId &&
          other.itemName == this.itemName &&
          other.unitPrice == this.unitPrice &&
          other.quantity == this.quantity &&
          other.amount == this.amount &&
          other.unit == this.unit);
}

class SaleItemsCompanion extends UpdateCompanion<SaleItem> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<SyncStatus> syncStatus;
  final Value<String?> remoteId;
  final Value<String> saleId;
  final Value<String> itemName;
  final Value<double> unitPrice;
  final Value<double> quantity;
  final Value<double> amount;
  final Value<String> unit;
  final Value<int> rowid;
  const SaleItemsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.saleId = const Value.absent(),
    this.itemName = const Value.absent(),
    this.unitPrice = const Value.absent(),
    this.quantity = const Value.absent(),
    this.amount = const Value.absent(),
    this.unit = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SaleItemsCompanion.insert({
    required String id,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.remoteId = const Value.absent(),
    required String saleId,
    required String itemName,
    required double unitPrice,
    required double quantity,
    required double amount,
    this.unit = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        saleId = Value(saleId),
        itemName = Value(itemName),
        unitPrice = Value(unitPrice),
        quantity = Value(quantity),
        amount = Value(amount);
  static Insertable<SaleItem> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncStatus,
    Expression<String>? remoteId,
    Expression<String>? saleId,
    Expression<String>? itemName,
    Expression<double>? unitPrice,
    Expression<double>? quantity,
    Expression<double>? amount,
    Expression<String>? unit,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (remoteId != null) 'remote_id': remoteId,
      if (saleId != null) 'sale_id': saleId,
      if (itemName != null) 'item_name': itemName,
      if (unitPrice != null) 'unit_price': unitPrice,
      if (quantity != null) 'quantity': quantity,
      if (amount != null) 'amount': amount,
      if (unit != null) 'unit': unit,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SaleItemsCompanion copyWith(
      {Value<String>? id,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<SyncStatus>? syncStatus,
      Value<String?>? remoteId,
      Value<String>? saleId,
      Value<String>? itemName,
      Value<double>? unitPrice,
      Value<double>? quantity,
      Value<double>? amount,
      Value<String>? unit,
      Value<int>? rowid}) {
    return SaleItemsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      remoteId: remoteId ?? this.remoteId,
      saleId: saleId ?? this.saleId,
      itemName: itemName ?? this.itemName,
      unitPrice: unitPrice ?? this.unitPrice,
      quantity: quantity ?? this.quantity,
      amount: amount ?? this.amount,
      unit: unit ?? this.unit,
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
    if (saleId.present) {
      map['sale_id'] = Variable<String>(saleId.value);
    }
    if (itemName.present) {
      map['item_name'] = Variable<String>(itemName.value);
    }
    if (unitPrice.present) {
      map['unit_price'] = Variable<double>(unitPrice.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
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
          ..write('saleId: $saleId, ')
          ..write('itemName: $itemName, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('quantity: $quantity, ')
          ..write('amount: $amount, ')
          ..write('unit: $unit, ')
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
  static const VerificationMeta _invoiceNumberMeta =
      const VerificationMeta('invoiceNumber');
  @override
  late final GeneratedColumn<String> invoiceNumber = GeneratedColumn<String>(
      'invoice_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _purchaseDateMeta =
      const VerificationMeta('purchaseDate');
  @override
  late final GeneratedColumn<DateTime> purchaseDate = GeneratedColumn<DateTime>(
      'purchase_date', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _totalAmountMeta =
      const VerificationMeta('totalAmount');
  @override
  late final GeneratedColumn<double> totalAmount = GeneratedColumn<double>(
      'total_amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _remarksMeta =
      const VerificationMeta('remarks');
  @override
  late final GeneratedColumn<String> remarks = GeneratedColumn<String>(
      'remarks', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        createdAt,
        updatedAt,
        syncStatus,
        remoteId,
        supplierName,
        supplierPan,
        invoiceNumber,
        purchaseDate,
        totalAmount,
        remarks
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
    if (data.containsKey('invoice_number')) {
      context.handle(
          _invoiceNumberMeta,
          invoiceNumber.isAcceptableOrUnknown(
              data['invoice_number']!, _invoiceNumberMeta));
    }
    if (data.containsKey('purchase_date')) {
      context.handle(
          _purchaseDateMeta,
          purchaseDate.isAcceptableOrUnknown(
              data['purchase_date']!, _purchaseDateMeta));
    }
    if (data.containsKey('total_amount')) {
      context.handle(
          _totalAmountMeta,
          totalAmount.isAcceptableOrUnknown(
              data['total_amount']!, _totalAmountMeta));
    } else if (isInserting) {
      context.missing(_totalAmountMeta);
    }
    if (data.containsKey('remarks')) {
      context.handle(_remarksMeta,
          remarks.isAcceptableOrUnknown(data['remarks']!, _remarksMeta));
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
      supplierName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}supplier_name'])!,
      supplierPan: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}supplier_pan']),
      invoiceNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}invoice_number']),
      purchaseDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}purchase_date'])!,
      totalAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_amount'])!,
      remarks: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}remarks']),
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
  final String supplierName;
  final String? supplierPan;
  final String? invoiceNumber;
  final DateTime purchaseDate;
  final double totalAmount;
  final String? remarks;
  const Purchase(
      {required this.id,
      required this.createdAt,
      required this.updatedAt,
      required this.syncStatus,
      this.remoteId,
      required this.supplierName,
      this.supplierPan,
      this.invoiceNumber,
      required this.purchaseDate,
      required this.totalAmount,
      this.remarks});
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
    map['supplier_name'] = Variable<String>(supplierName);
    if (!nullToAbsent || supplierPan != null) {
      map['supplier_pan'] = Variable<String>(supplierPan);
    }
    if (!nullToAbsent || invoiceNumber != null) {
      map['invoice_number'] = Variable<String>(invoiceNumber);
    }
    map['purchase_date'] = Variable<DateTime>(purchaseDate);
    map['total_amount'] = Variable<double>(totalAmount);
    if (!nullToAbsent || remarks != null) {
      map['remarks'] = Variable<String>(remarks);
    }
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
      supplierName: Value(supplierName),
      supplierPan: supplierPan == null && nullToAbsent
          ? const Value.absent()
          : Value(supplierPan),
      invoiceNumber: invoiceNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(invoiceNumber),
      purchaseDate: Value(purchaseDate),
      totalAmount: Value(totalAmount),
      remarks: remarks == null && nullToAbsent
          ? const Value.absent()
          : Value(remarks),
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
      supplierName: serializer.fromJson<String>(json['supplierName']),
      supplierPan: serializer.fromJson<String?>(json['supplierPan']),
      invoiceNumber: serializer.fromJson<String?>(json['invoiceNumber']),
      purchaseDate: serializer.fromJson<DateTime>(json['purchaseDate']),
      totalAmount: serializer.fromJson<double>(json['totalAmount']),
      remarks: serializer.fromJson<String?>(json['remarks']),
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
      'supplierName': serializer.toJson<String>(supplierName),
      'supplierPan': serializer.toJson<String?>(supplierPan),
      'invoiceNumber': serializer.toJson<String?>(invoiceNumber),
      'purchaseDate': serializer.toJson<DateTime>(purchaseDate),
      'totalAmount': serializer.toJson<double>(totalAmount),
      'remarks': serializer.toJson<String?>(remarks),
    };
  }

  Purchase copyWith(
          {String? id,
          DateTime? createdAt,
          DateTime? updatedAt,
          SyncStatus? syncStatus,
          Value<String?> remoteId = const Value.absent(),
          String? supplierName,
          Value<String?> supplierPan = const Value.absent(),
          Value<String?> invoiceNumber = const Value.absent(),
          DateTime? purchaseDate,
          double? totalAmount,
          Value<String?> remarks = const Value.absent()}) =>
      Purchase(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        syncStatus: syncStatus ?? this.syncStatus,
        remoteId: remoteId.present ? remoteId.value : this.remoteId,
        supplierName: supplierName ?? this.supplierName,
        supplierPan: supplierPan.present ? supplierPan.value : this.supplierPan,
        invoiceNumber:
            invoiceNumber.present ? invoiceNumber.value : this.invoiceNumber,
        purchaseDate: purchaseDate ?? this.purchaseDate,
        totalAmount: totalAmount ?? this.totalAmount,
        remarks: remarks.present ? remarks.value : this.remarks,
      );
  Purchase copyWithCompanion(PurchasesCompanion data) {
    return Purchase(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      supplierName: data.supplierName.present
          ? data.supplierName.value
          : this.supplierName,
      supplierPan:
          data.supplierPan.present ? data.supplierPan.value : this.supplierPan,
      invoiceNumber: data.invoiceNumber.present
          ? data.invoiceNumber.value
          : this.invoiceNumber,
      purchaseDate: data.purchaseDate.present
          ? data.purchaseDate.value
          : this.purchaseDate,
      totalAmount:
          data.totalAmount.present ? data.totalAmount.value : this.totalAmount,
      remarks: data.remarks.present ? data.remarks.value : this.remarks,
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
          ..write('supplierName: $supplierName, ')
          ..write('supplierPan: $supplierPan, ')
          ..write('invoiceNumber: $invoiceNumber, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('remarks: $remarks')
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
      supplierName,
      supplierPan,
      invoiceNumber,
      purchaseDate,
      totalAmount,
      remarks);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Purchase &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus &&
          other.remoteId == this.remoteId &&
          other.supplierName == this.supplierName &&
          other.supplierPan == this.supplierPan &&
          other.invoiceNumber == this.invoiceNumber &&
          other.purchaseDate == this.purchaseDate &&
          other.totalAmount == this.totalAmount &&
          other.remarks == this.remarks);
}

class PurchasesCompanion extends UpdateCompanion<Purchase> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<SyncStatus> syncStatus;
  final Value<String?> remoteId;
  final Value<String> supplierName;
  final Value<String?> supplierPan;
  final Value<String?> invoiceNumber;
  final Value<DateTime> purchaseDate;
  final Value<double> totalAmount;
  final Value<String?> remarks;
  final Value<int> rowid;
  const PurchasesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.supplierName = const Value.absent(),
    this.supplierPan = const Value.absent(),
    this.invoiceNumber = const Value.absent(),
    this.purchaseDate = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.remarks = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PurchasesCompanion.insert({
    required String id,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.remoteId = const Value.absent(),
    required String supplierName,
    this.supplierPan = const Value.absent(),
    this.invoiceNumber = const Value.absent(),
    this.purchaseDate = const Value.absent(),
    required double totalAmount,
    this.remarks = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        supplierName = Value(supplierName),
        totalAmount = Value(totalAmount);
  static Insertable<Purchase> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncStatus,
    Expression<String>? remoteId,
    Expression<String>? supplierName,
    Expression<String>? supplierPan,
    Expression<String>? invoiceNumber,
    Expression<DateTime>? purchaseDate,
    Expression<double>? totalAmount,
    Expression<String>? remarks,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (remoteId != null) 'remote_id': remoteId,
      if (supplierName != null) 'supplier_name': supplierName,
      if (supplierPan != null) 'supplier_pan': supplierPan,
      if (invoiceNumber != null) 'invoice_number': invoiceNumber,
      if (purchaseDate != null) 'purchase_date': purchaseDate,
      if (totalAmount != null) 'total_amount': totalAmount,
      if (remarks != null) 'remarks': remarks,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PurchasesCompanion copyWith(
      {Value<String>? id,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<SyncStatus>? syncStatus,
      Value<String?>? remoteId,
      Value<String>? supplierName,
      Value<String?>? supplierPan,
      Value<String?>? invoiceNumber,
      Value<DateTime>? purchaseDate,
      Value<double>? totalAmount,
      Value<String?>? remarks,
      Value<int>? rowid}) {
    return PurchasesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      remoteId: remoteId ?? this.remoteId,
      supplierName: supplierName ?? this.supplierName,
      supplierPan: supplierPan ?? this.supplierPan,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      totalAmount: totalAmount ?? this.totalAmount,
      remarks: remarks ?? this.remarks,
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
    if (supplierName.present) {
      map['supplier_name'] = Variable<String>(supplierName.value);
    }
    if (supplierPan.present) {
      map['supplier_pan'] = Variable<String>(supplierPan.value);
    }
    if (invoiceNumber.present) {
      map['invoice_number'] = Variable<String>(invoiceNumber.value);
    }
    if (purchaseDate.present) {
      map['purchase_date'] = Variable<DateTime>(purchaseDate.value);
    }
    if (totalAmount.present) {
      map['total_amount'] = Variable<double>(totalAmount.value);
    }
    if (remarks.present) {
      map['remarks'] = Variable<String>(remarks.value);
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
          ..write('supplierName: $supplierName, ')
          ..write('supplierPan: $supplierPan, ')
          ..write('invoiceNumber: $invoiceNumber, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('remarks: $remarks, ')
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
      remoteId, saleId, billNumber, pdfFilePath, qrData, printCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BillMetadataData &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus &&
          other.remoteId == this.remoteId &&
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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $BusinessProfilesTable businessProfiles =
      $BusinessProfilesTable(this);
  late final $InventoriesTable inventories = $InventoriesTable(this);
  late final $SalesTable sales = $SalesTable(this);
  late final $SaleItemsTable saleItems = $SaleItemsTable(this);
  late final $PurchasesTable purchases = $PurchasesTable(this);
  late final $BillMetadataTable billMetadata = $BillMetadataTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        businessProfiles,
        inventories,
        sales,
        saleItems,
        purchases,
        billMetadata
      ];
}

typedef $$BusinessProfilesTableCreateCompanionBuilder
    = BusinessProfilesCompanion Function({
  required String id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<SyncStatus> syncStatus,
  Value<String?> remoteId,
  required String businessName,
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
  Value<String> businessName,
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
            Value<String> businessName = const Value.absent(),
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
            businessName: businessName,
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
            required String businessName,
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
            businessName: businessName,
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

  ColumnFilters<String> get businessName => $state.composableBuilder(
      column: $state.table.businessName,
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

  ColumnOrderings<String> get businessName => $state.composableBuilder(
      column: $state.table.businessName,
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

typedef $$InventoriesTableCreateCompanionBuilder = InventoriesCompanion
    Function({
  required String id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<SyncStatus> syncStatus,
  Value<String?> remoteId,
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

typedef $$SalesTableCreateCompanionBuilder = SalesCompanion Function({
  required String id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<SyncStatus> syncStatus,
  Value<String?> remoteId,
  required String invoiceNumber,
  Value<String?> customerName,
  Value<String?> customerPan,
  Value<String?> customerPhone,
  Value<DateTime> invoiceDate,
  required double subtotal,
  Value<double> discountAmount,
  required double taxableAmount,
  Value<double> vatAmount,
  required double totalAmount,
  Value<String> paymentMode,
  Value<String?> notes,
  Value<int> rowid,
});
typedef $$SalesTableUpdateCompanionBuilder = SalesCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<SyncStatus> syncStatus,
  Value<String?> remoteId,
  Value<String> invoiceNumber,
  Value<String?> customerName,
  Value<String?> customerPan,
  Value<String?> customerPhone,
  Value<DateTime> invoiceDate,
  Value<double> subtotal,
  Value<double> discountAmount,
  Value<double> taxableAmount,
  Value<double> vatAmount,
  Value<double> totalAmount,
  Value<String> paymentMode,
  Value<String?> notes,
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
            Value<String> invoiceNumber = const Value.absent(),
            Value<String?> customerName = const Value.absent(),
            Value<String?> customerPan = const Value.absent(),
            Value<String?> customerPhone = const Value.absent(),
            Value<DateTime> invoiceDate = const Value.absent(),
            Value<double> subtotal = const Value.absent(),
            Value<double> discountAmount = const Value.absent(),
            Value<double> taxableAmount = const Value.absent(),
            Value<double> vatAmount = const Value.absent(),
            Value<double> totalAmount = const Value.absent(),
            Value<String> paymentMode = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SalesCompanion(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            remoteId: remoteId,
            invoiceNumber: invoiceNumber,
            customerName: customerName,
            customerPan: customerPan,
            customerPhone: customerPhone,
            invoiceDate: invoiceDate,
            subtotal: subtotal,
            discountAmount: discountAmount,
            taxableAmount: taxableAmount,
            vatAmount: vatAmount,
            totalAmount: totalAmount,
            paymentMode: paymentMode,
            notes: notes,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<SyncStatus> syncStatus = const Value.absent(),
            Value<String?> remoteId = const Value.absent(),
            required String invoiceNumber,
            Value<String?> customerName = const Value.absent(),
            Value<String?> customerPan = const Value.absent(),
            Value<String?> customerPhone = const Value.absent(),
            Value<DateTime> invoiceDate = const Value.absent(),
            required double subtotal,
            Value<double> discountAmount = const Value.absent(),
            required double taxableAmount,
            Value<double> vatAmount = const Value.absent(),
            required double totalAmount,
            Value<String> paymentMode = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SalesCompanion.insert(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            remoteId: remoteId,
            invoiceNumber: invoiceNumber,
            customerName: customerName,
            customerPan: customerPan,
            customerPhone: customerPhone,
            invoiceDate: invoiceDate,
            subtotal: subtotal,
            discountAmount: discountAmount,
            taxableAmount: taxableAmount,
            vatAmount: vatAmount,
            totalAmount: totalAmount,
            paymentMode: paymentMode,
            notes: notes,
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

  ColumnFilters<String> get invoiceNumber => $state.composableBuilder(
      column: $state.table.invoiceNumber,
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

  ColumnFilters<double> get subtotal => $state.composableBuilder(
      column: $state.table.subtotal,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get discountAmount => $state.composableBuilder(
      column: $state.table.discountAmount,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get taxableAmount => $state.composableBuilder(
      column: $state.table.taxableAmount,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get vatAmount => $state.composableBuilder(
      column: $state.table.vatAmount,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get totalAmount => $state.composableBuilder(
      column: $state.table.totalAmount,
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

  ColumnOrderings<String> get invoiceNumber => $state.composableBuilder(
      column: $state.table.invoiceNumber,
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

  ColumnOrderings<double> get subtotal => $state.composableBuilder(
      column: $state.table.subtotal,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get discountAmount => $state.composableBuilder(
      column: $state.table.discountAmount,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get taxableAmount => $state.composableBuilder(
      column: $state.table.taxableAmount,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get vatAmount => $state.composableBuilder(
      column: $state.table.vatAmount,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get totalAmount => $state.composableBuilder(
      column: $state.table.totalAmount,
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
}

typedef $$SaleItemsTableCreateCompanionBuilder = SaleItemsCompanion Function({
  required String id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<SyncStatus> syncStatus,
  Value<String?> remoteId,
  required String saleId,
  required String itemName,
  required double unitPrice,
  required double quantity,
  required double amount,
  Value<String> unit,
  Value<int> rowid,
});
typedef $$SaleItemsTableUpdateCompanionBuilder = SaleItemsCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<SyncStatus> syncStatus,
  Value<String?> remoteId,
  Value<String> saleId,
  Value<String> itemName,
  Value<double> unitPrice,
  Value<double> quantity,
  Value<double> amount,
  Value<String> unit,
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
            Value<String> saleId = const Value.absent(),
            Value<String> itemName = const Value.absent(),
            Value<double> unitPrice = const Value.absent(),
            Value<double> quantity = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<String> unit = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SaleItemsCompanion(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            remoteId: remoteId,
            saleId: saleId,
            itemName: itemName,
            unitPrice: unitPrice,
            quantity: quantity,
            amount: amount,
            unit: unit,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<SyncStatus> syncStatus = const Value.absent(),
            Value<String?> remoteId = const Value.absent(),
            required String saleId,
            required String itemName,
            required double unitPrice,
            required double quantity,
            required double amount,
            Value<String> unit = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SaleItemsCompanion.insert(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            remoteId: remoteId,
            saleId: saleId,
            itemName: itemName,
            unitPrice: unitPrice,
            quantity: quantity,
            amount: amount,
            unit: unit,
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

  ColumnFilters<String> get saleId => $state.composableBuilder(
      column: $state.table.saleId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get itemName => $state.composableBuilder(
      column: $state.table.itemName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get unitPrice => $state.composableBuilder(
      column: $state.table.unitPrice,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get quantity => $state.composableBuilder(
      column: $state.table.quantity,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get amount => $state.composableBuilder(
      column: $state.table.amount,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get unit => $state.composableBuilder(
      column: $state.table.unit,
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

  ColumnOrderings<String> get saleId => $state.composableBuilder(
      column: $state.table.saleId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get itemName => $state.composableBuilder(
      column: $state.table.itemName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get unitPrice => $state.composableBuilder(
      column: $state.table.unitPrice,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get quantity => $state.composableBuilder(
      column: $state.table.quantity,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get amount => $state.composableBuilder(
      column: $state.table.amount,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get unit => $state.composableBuilder(
      column: $state.table.unit,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$PurchasesTableCreateCompanionBuilder = PurchasesCompanion Function({
  required String id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<SyncStatus> syncStatus,
  Value<String?> remoteId,
  required String supplierName,
  Value<String?> supplierPan,
  Value<String?> invoiceNumber,
  Value<DateTime> purchaseDate,
  required double totalAmount,
  Value<String?> remarks,
  Value<int> rowid,
});
typedef $$PurchasesTableUpdateCompanionBuilder = PurchasesCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<SyncStatus> syncStatus,
  Value<String?> remoteId,
  Value<String> supplierName,
  Value<String?> supplierPan,
  Value<String?> invoiceNumber,
  Value<DateTime> purchaseDate,
  Value<double> totalAmount,
  Value<String?> remarks,
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
            Value<String> supplierName = const Value.absent(),
            Value<String?> supplierPan = const Value.absent(),
            Value<String?> invoiceNumber = const Value.absent(),
            Value<DateTime> purchaseDate = const Value.absent(),
            Value<double> totalAmount = const Value.absent(),
            Value<String?> remarks = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PurchasesCompanion(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            remoteId: remoteId,
            supplierName: supplierName,
            supplierPan: supplierPan,
            invoiceNumber: invoiceNumber,
            purchaseDate: purchaseDate,
            totalAmount: totalAmount,
            remarks: remarks,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<SyncStatus> syncStatus = const Value.absent(),
            Value<String?> remoteId = const Value.absent(),
            required String supplierName,
            Value<String?> supplierPan = const Value.absent(),
            Value<String?> invoiceNumber = const Value.absent(),
            Value<DateTime> purchaseDate = const Value.absent(),
            required double totalAmount,
            Value<String?> remarks = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PurchasesCompanion.insert(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            remoteId: remoteId,
            supplierName: supplierName,
            supplierPan: supplierPan,
            invoiceNumber: invoiceNumber,
            purchaseDate: purchaseDate,
            totalAmount: totalAmount,
            remarks: remarks,
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

  ColumnFilters<String> get supplierName => $state.composableBuilder(
      column: $state.table.supplierName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get supplierPan => $state.composableBuilder(
      column: $state.table.supplierPan,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get invoiceNumber => $state.composableBuilder(
      column: $state.table.invoiceNumber,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get purchaseDate => $state.composableBuilder(
      column: $state.table.purchaseDate,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get totalAmount => $state.composableBuilder(
      column: $state.table.totalAmount,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get remarks => $state.composableBuilder(
      column: $state.table.remarks,
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

  ColumnOrderings<String> get supplierName => $state.composableBuilder(
      column: $state.table.supplierName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get supplierPan => $state.composableBuilder(
      column: $state.table.supplierPan,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get invoiceNumber => $state.composableBuilder(
      column: $state.table.invoiceNumber,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get purchaseDate => $state.composableBuilder(
      column: $state.table.purchaseDate,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get totalAmount => $state.composableBuilder(
      column: $state.table.totalAmount,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get remarks => $state.composableBuilder(
      column: $state.table.remarks,
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

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$BusinessProfilesTableTableManager get businessProfiles =>
      $$BusinessProfilesTableTableManager(_db, _db.businessProfiles);
  $$InventoriesTableTableManager get inventories =>
      $$InventoriesTableTableManager(_db, _db.inventories);
  $$SalesTableTableManager get sales =>
      $$SalesTableTableManager(_db, _db.sales);
  $$SaleItemsTableTableManager get saleItems =>
      $$SaleItemsTableTableManager(_db, _db.saleItems);
  $$PurchasesTableTableManager get purchases =>
      $$PurchasesTableTableManager(_db, _db.purchases);
  $$BillMetadataTableTableManager get billMetadata =>
      $$BillMetadataTableTableManager(_db, _db.billMetadata);
}
