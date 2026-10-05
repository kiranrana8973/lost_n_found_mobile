// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $AuthTableTable extends AuthTable
    with TableInfo<$AuthTableTable, AuthModel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AuthTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _authIdMeta = const VerificationMeta('authId');
  @override
  late final GeneratedColumn<String> authId = GeneratedColumn<String>(
    'auth_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fullNameMeta = const VerificationMeta(
    'fullName',
  );
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
    'full_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _phoneNumberMeta = const VerificationMeta(
    'phoneNumber',
  );
  @override
  late final GeneratedColumn<String> phoneNumber = GeneratedColumn<String>(
    'phone_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _usernameMeta = const VerificationMeta(
    'username',
  );
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _passwordMeta = const VerificationMeta(
    'password',
  );
  @override
  late final GeneratedColumn<String> password = GeneratedColumn<String>(
    'password',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _batchIdMeta = const VerificationMeta(
    'batchId',
  );
  @override
  late final GeneratedColumn<String> batchId = GeneratedColumn<String>(
    'batch_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _profilePictureMeta = const VerificationMeta(
    'profilePicture',
  );
  @override
  late final GeneratedColumn<String> profilePicture = GeneratedColumn<String>(
    'profile_picture',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    authId,
    fullName,
    email,
    phoneNumber,
    username,
    password,
    batchId,
    profilePicture,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'auth_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<AuthModel> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('auth_id')) {
      context.handle(
        _authIdMeta,
        authId.isAcceptableOrUnknown(data['auth_id']!, _authIdMeta),
      );
    } else if (isInserting) {
      context.missing(_authIdMeta);
    }
    if (data.containsKey('full_name')) {
      context.handle(
        _fullNameMeta,
        fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fullNameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('phone_number')) {
      context.handle(
        _phoneNumberMeta,
        phoneNumber.isAcceptableOrUnknown(
          data['phone_number']!,
          _phoneNumberMeta,
        ),
      );
    }
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('password')) {
      context.handle(
        _passwordMeta,
        password.isAcceptableOrUnknown(data['password']!, _passwordMeta),
      );
    }
    if (data.containsKey('batch_id')) {
      context.handle(
        _batchIdMeta,
        batchId.isAcceptableOrUnknown(data['batch_id']!, _batchIdMeta),
      );
    }
    if (data.containsKey('profile_picture')) {
      context.handle(
        _profilePictureMeta,
        profilePicture.isAcceptableOrUnknown(
          data['profile_picture']!,
          _profilePictureMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {authId};
  @override
  AuthModel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AuthModel(
      authId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}auth_id'],
      )!,
      fullName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}full_name'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      phoneNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone_number'],
      ),
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
      )!,
      password: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}password'],
      ),
      batchId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}batch_id'],
      ),
      profilePicture: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_picture'],
      ),
    );
  }

  @override
  $AuthTableTable createAlias(String alias) {
    return $AuthTableTable(attachedDatabase, alias);
  }
}

class AuthModel extends DataClass implements Insertable<AuthModel> {
  final String authId;
  final String fullName;
  final String email;
  final String? phoneNumber;
  final String username;
  final String? password;
  final String? batchId;
  final String? profilePicture;
  const AuthModel({
    required this.authId,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    required this.username,
    this.password,
    this.batchId,
    this.profilePicture,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['auth_id'] = Variable<String>(authId);
    map['full_name'] = Variable<String>(fullName);
    map['email'] = Variable<String>(email);
    if (!nullToAbsent || phoneNumber != null) {
      map['phone_number'] = Variable<String>(phoneNumber);
    }
    map['username'] = Variable<String>(username);
    if (!nullToAbsent || password != null) {
      map['password'] = Variable<String>(password);
    }
    if (!nullToAbsent || batchId != null) {
      map['batch_id'] = Variable<String>(batchId);
    }
    if (!nullToAbsent || profilePicture != null) {
      map['profile_picture'] = Variable<String>(profilePicture);
    }
    return map;
  }

  AuthTableCompanion toCompanion(bool nullToAbsent) {
    return AuthTableCompanion(
      authId: Value(authId),
      fullName: Value(fullName),
      email: Value(email),
      phoneNumber: phoneNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(phoneNumber),
      username: Value(username),
      password: password == null && nullToAbsent
          ? const Value.absent()
          : Value(password),
      batchId: batchId == null && nullToAbsent
          ? const Value.absent()
          : Value(batchId),
      profilePicture: profilePicture == null && nullToAbsent
          ? const Value.absent()
          : Value(profilePicture),
    );
  }

  factory AuthModel.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AuthModel(
      authId: serializer.fromJson<String>(json['authId']),
      fullName: serializer.fromJson<String>(json['fullName']),
      email: serializer.fromJson<String>(json['email']),
      phoneNumber: serializer.fromJson<String?>(json['phoneNumber']),
      username: serializer.fromJson<String>(json['username']),
      password: serializer.fromJson<String?>(json['password']),
      batchId: serializer.fromJson<String?>(json['batchId']),
      profilePicture: serializer.fromJson<String?>(json['profilePicture']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'authId': serializer.toJson<String>(authId),
      'fullName': serializer.toJson<String>(fullName),
      'email': serializer.toJson<String>(email),
      'phoneNumber': serializer.toJson<String?>(phoneNumber),
      'username': serializer.toJson<String>(username),
      'password': serializer.toJson<String?>(password),
      'batchId': serializer.toJson<String?>(batchId),
      'profilePicture': serializer.toJson<String?>(profilePicture),
    };
  }

  AuthModel copyWith({
    String? authId,
    String? fullName,
    String? email,
    Value<String?> phoneNumber = const Value.absent(),
    String? username,
    Value<String?> password = const Value.absent(),
    Value<String?> batchId = const Value.absent(),
    Value<String?> profilePicture = const Value.absent(),
  }) => AuthModel(
    authId: authId ?? this.authId,
    fullName: fullName ?? this.fullName,
    email: email ?? this.email,
    phoneNumber: phoneNumber.present ? phoneNumber.value : this.phoneNumber,
    username: username ?? this.username,
    password: password.present ? password.value : this.password,
    batchId: batchId.present ? batchId.value : this.batchId,
    profilePicture: profilePicture.present
        ? profilePicture.value
        : this.profilePicture,
  );
  AuthModel copyWithCompanion(AuthTableCompanion data) {
    return AuthModel(
      authId: data.authId.present ? data.authId.value : this.authId,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      email: data.email.present ? data.email.value : this.email,
      phoneNumber: data.phoneNumber.present
          ? data.phoneNumber.value
          : this.phoneNumber,
      username: data.username.present ? data.username.value : this.username,
      password: data.password.present ? data.password.value : this.password,
      batchId: data.batchId.present ? data.batchId.value : this.batchId,
      profilePicture: data.profilePicture.present
          ? data.profilePicture.value
          : this.profilePicture,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AuthModel(')
          ..write('authId: $authId, ')
          ..write('fullName: $fullName, ')
          ..write('email: $email, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('username: $username, ')
          ..write('password: $password, ')
          ..write('batchId: $batchId, ')
          ..write('profilePicture: $profilePicture')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    authId,
    fullName,
    email,
    phoneNumber,
    username,
    password,
    batchId,
    profilePicture,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuthModel &&
          other.authId == this.authId &&
          other.fullName == this.fullName &&
          other.email == this.email &&
          other.phoneNumber == this.phoneNumber &&
          other.username == this.username &&
          other.password == this.password &&
          other.batchId == this.batchId &&
          other.profilePicture == this.profilePicture);
}

class AuthTableCompanion extends UpdateCompanion<AuthModel> {
  final Value<String> authId;
  final Value<String> fullName;
  final Value<String> email;
  final Value<String?> phoneNumber;
  final Value<String> username;
  final Value<String?> password;
  final Value<String?> batchId;
  final Value<String?> profilePicture;
  final Value<int> rowid;
  const AuthTableCompanion({
    this.authId = const Value.absent(),
    this.fullName = const Value.absent(),
    this.email = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.username = const Value.absent(),
    this.password = const Value.absent(),
    this.batchId = const Value.absent(),
    this.profilePicture = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AuthTableCompanion.insert({
    required String authId,
    required String fullName,
    required String email,
    this.phoneNumber = const Value.absent(),
    required String username,
    this.password = const Value.absent(),
    this.batchId = const Value.absent(),
    this.profilePicture = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : authId = Value(authId),
       fullName = Value(fullName),
       email = Value(email),
       username = Value(username);
  static Insertable<AuthModel> custom({
    Expression<String>? authId,
    Expression<String>? fullName,
    Expression<String>? email,
    Expression<String>? phoneNumber,
    Expression<String>? username,
    Expression<String>? password,
    Expression<String>? batchId,
    Expression<String>? profilePicture,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (authId != null) 'auth_id': authId,
      if (fullName != null) 'full_name': fullName,
      if (email != null) 'email': email,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (username != null) 'username': username,
      if (password != null) 'password': password,
      if (batchId != null) 'batch_id': batchId,
      if (profilePicture != null) 'profile_picture': profilePicture,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AuthTableCompanion copyWith({
    Value<String>? authId,
    Value<String>? fullName,
    Value<String>? email,
    Value<String?>? phoneNumber,
    Value<String>? username,
    Value<String?>? password,
    Value<String?>? batchId,
    Value<String?>? profilePicture,
    Value<int>? rowid,
  }) {
    return AuthTableCompanion(
      authId: authId ?? this.authId,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      username: username ?? this.username,
      password: password ?? this.password,
      batchId: batchId ?? this.batchId,
      profilePicture: profilePicture ?? this.profilePicture,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (authId.present) {
      map['auth_id'] = Variable<String>(authId.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (phoneNumber.present) {
      map['phone_number'] = Variable<String>(phoneNumber.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (password.present) {
      map['password'] = Variable<String>(password.value);
    }
    if (batchId.present) {
      map['batch_id'] = Variable<String>(batchId.value);
    }
    if (profilePicture.present) {
      map['profile_picture'] = Variable<String>(profilePicture.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AuthTableCompanion(')
          ..write('authId: $authId, ')
          ..write('fullName: $fullName, ')
          ..write('email: $email, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('username: $username, ')
          ..write('password: $password, ')
          ..write('batchId: $batchId, ')
          ..write('profilePicture: $profilePicture, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BatchTableTable extends BatchTable
    with TableInfo<$BatchTableTable, BatchModel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BatchTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _batchIdMeta = const VerificationMeta(
    'batchId',
  );
  @override
  late final GeneratedColumn<String> batchId = GeneratedColumn<String>(
    'batch_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _batchNameMeta = const VerificationMeta(
    'batchName',
  );
  @override
  late final GeneratedColumn<String> batchName = GeneratedColumn<String>(
    'batch_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [batchId, batchName, status];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'batch_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<BatchModel> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('batch_id')) {
      context.handle(
        _batchIdMeta,
        batchId.isAcceptableOrUnknown(data['batch_id']!, _batchIdMeta),
      );
    } else if (isInserting) {
      context.missing(_batchIdMeta);
    }
    if (data.containsKey('batch_name')) {
      context.handle(
        _batchNameMeta,
        batchName.isAcceptableOrUnknown(data['batch_name']!, _batchNameMeta),
      );
    } else if (isInserting) {
      context.missing(_batchNameMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {batchId};
  @override
  BatchModel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BatchModel(
      batchId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}batch_id'],
      )!,
      batchName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}batch_name'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      ),
    );
  }

  @override
  $BatchTableTable createAlias(String alias) {
    return $BatchTableTable(attachedDatabase, alias);
  }
}

class BatchModel extends DataClass implements Insertable<BatchModel> {
  final String batchId;
  final String batchName;
  final String? status;
  const BatchModel({
    required this.batchId,
    required this.batchName,
    this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['batch_id'] = Variable<String>(batchId);
    map['batch_name'] = Variable<String>(batchName);
    if (!nullToAbsent || status != null) {
      map['status'] = Variable<String>(status);
    }
    return map;
  }

  BatchTableCompanion toCompanion(bool nullToAbsent) {
    return BatchTableCompanion(
      batchId: Value(batchId),
      batchName: Value(batchName),
      status: status == null && nullToAbsent
          ? const Value.absent()
          : Value(status),
    );
  }

  factory BatchModel.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BatchModel(
      batchId: serializer.fromJson<String>(json['batchId']),
      batchName: serializer.fromJson<String>(json['batchName']),
      status: serializer.fromJson<String?>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'batchId': serializer.toJson<String>(batchId),
      'batchName': serializer.toJson<String>(batchName),
      'status': serializer.toJson<String?>(status),
    };
  }

  BatchModel copyWith({
    String? batchId,
    String? batchName,
    Value<String?> status = const Value.absent(),
  }) => BatchModel(
    batchId: batchId ?? this.batchId,
    batchName: batchName ?? this.batchName,
    status: status.present ? status.value : this.status,
  );
  BatchModel copyWithCompanion(BatchTableCompanion data) {
    return BatchModel(
      batchId: data.batchId.present ? data.batchId.value : this.batchId,
      batchName: data.batchName.present ? data.batchName.value : this.batchName,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BatchModel(')
          ..write('batchId: $batchId, ')
          ..write('batchName: $batchName, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(batchId, batchName, status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BatchModel &&
          other.batchId == this.batchId &&
          other.batchName == this.batchName &&
          other.status == this.status);
}

class BatchTableCompanion extends UpdateCompanion<BatchModel> {
  final Value<String> batchId;
  final Value<String> batchName;
  final Value<String?> status;
  final Value<int> rowid;
  const BatchTableCompanion({
    this.batchId = const Value.absent(),
    this.batchName = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BatchTableCompanion.insert({
    required String batchId,
    required String batchName,
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : batchId = Value(batchId),
       batchName = Value(batchName);
  static Insertable<BatchModel> custom({
    Expression<String>? batchId,
    Expression<String>? batchName,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (batchId != null) 'batch_id': batchId,
      if (batchName != null) 'batch_name': batchName,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BatchTableCompanion copyWith({
    Value<String>? batchId,
    Value<String>? batchName,
    Value<String?>? status,
    Value<int>? rowid,
  }) {
    return BatchTableCompanion(
      batchId: batchId ?? this.batchId,
      batchName: batchName ?? this.batchName,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (batchId.present) {
      map['batch_id'] = Variable<String>(batchId.value);
    }
    if (batchName.present) {
      map['batch_name'] = Variable<String>(batchName.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BatchTableCompanion(')
          ..write('batchId: $batchId, ')
          ..write('batchName: $batchName, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CategoryTableTable extends CategoryTable
    with TableInfo<$CategoryTableTable, CategoryModel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoryTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [categoryId, name, description, status];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'category_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<CategoryModel> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {categoryId};
  @override
  CategoryModel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoryModel(
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      ),
    );
  }

  @override
  $CategoryTableTable createAlias(String alias) {
    return $CategoryTableTable(attachedDatabase, alias);
  }
}

class CategoryModel extends DataClass implements Insertable<CategoryModel> {
  final String categoryId;
  final String name;
  final String? description;
  final String? status;
  const CategoryModel({
    required this.categoryId,
    required this.name,
    this.description,
    this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['category_id'] = Variable<String>(categoryId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || status != null) {
      map['status'] = Variable<String>(status);
    }
    return map;
  }

  CategoryTableCompanion toCompanion(bool nullToAbsent) {
    return CategoryTableCompanion(
      categoryId: Value(categoryId),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      status: status == null && nullToAbsent
          ? const Value.absent()
          : Value(status),
    );
  }

  factory CategoryModel.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoryModel(
      categoryId: serializer.fromJson<String>(json['categoryId']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      status: serializer.fromJson<String?>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'categoryId': serializer.toJson<String>(categoryId),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'status': serializer.toJson<String?>(status),
    };
  }

  CategoryModel copyWith({
    String? categoryId,
    String? name,
    Value<String?> description = const Value.absent(),
    Value<String?> status = const Value.absent(),
  }) => CategoryModel(
    categoryId: categoryId ?? this.categoryId,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    status: status.present ? status.value : this.status,
  );
  CategoryModel copyWithCompanion(CategoryTableCompanion data) {
    return CategoryModel(
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoryModel(')
          ..write('categoryId: $categoryId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(categoryId, name, description, status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryModel &&
          other.categoryId == this.categoryId &&
          other.name == this.name &&
          other.description == this.description &&
          other.status == this.status);
}

class CategoryTableCompanion extends UpdateCompanion<CategoryModel> {
  final Value<String> categoryId;
  final Value<String> name;
  final Value<String?> description;
  final Value<String?> status;
  final Value<int> rowid;
  const CategoryTableCompanion({
    this.categoryId = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoryTableCompanion.insert({
    required String categoryId,
    required String name,
    this.description = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : categoryId = Value(categoryId),
       name = Value(name);
  static Insertable<CategoryModel> custom({
    Expression<String>? categoryId,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (categoryId != null) 'category_id': categoryId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoryTableCompanion copyWith({
    Value<String>? categoryId,
    Value<String>? name,
    Value<String?>? description,
    Value<String?>? status,
    Value<int>? rowid,
  }) {
    return CategoryTableCompanion(
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      description: description ?? this.description,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoryTableCompanion(')
          ..write('categoryId: $categoryId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ItemTableTable extends ItemTable
    with TableInfo<$ItemTableTable, ItemModel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ItemTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
    'item_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reportedByMeta = const VerificationMeta(
    'reportedBy',
  );
  @override
  late final GeneratedColumn<String> reportedBy = GeneratedColumn<String>(
    'reported_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _claimedByMeta = const VerificationMeta(
    'claimedBy',
  );
  @override
  late final GeneratedColumn<String> claimedBy = GeneratedColumn<String>(
    'claimed_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _itemNameMeta = const VerificationMeta(
    'itemName',
  );
  @override
  late final GeneratedColumn<String> itemName = GeneratedColumn<String>(
    'item_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _locationMeta = const VerificationMeta(
    'location',
  );
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
    'location',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mediaMeta = const VerificationMeta('media');
  @override
  late final GeneratedColumn<String> media = GeneratedColumn<String>(
    'media',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mediaTypeMeta = const VerificationMeta(
    'mediaType',
  );
  @override
  late final GeneratedColumn<String> mediaType = GeneratedColumn<String>(
    'media_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isClaimedMeta = const VerificationMeta(
    'isClaimed',
  );
  @override
  late final GeneratedColumn<bool> isClaimed = GeneratedColumn<bool>(
    'is_claimed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_claimed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    itemId,
    reportedBy,
    claimedBy,
    categoryId,
    itemName,
    description,
    type,
    location,
    media,
    mediaType,
    isClaimed,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'item_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ItemModel> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('reported_by')) {
      context.handle(
        _reportedByMeta,
        reportedBy.isAcceptableOrUnknown(data['reported_by']!, _reportedByMeta),
      );
    }
    if (data.containsKey('claimed_by')) {
      context.handle(
        _claimedByMeta,
        claimedBy.isAcceptableOrUnknown(data['claimed_by']!, _claimedByMeta),
      );
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('item_name')) {
      context.handle(
        _itemNameMeta,
        itemName.isAcceptableOrUnknown(data['item_name']!, _itemNameMeta),
      );
    } else if (isInserting) {
      context.missing(_itemNameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('location')) {
      context.handle(
        _locationMeta,
        location.isAcceptableOrUnknown(data['location']!, _locationMeta),
      );
    } else if (isInserting) {
      context.missing(_locationMeta);
    }
    if (data.containsKey('media')) {
      context.handle(
        _mediaMeta,
        media.isAcceptableOrUnknown(data['media']!, _mediaMeta),
      );
    }
    if (data.containsKey('media_type')) {
      context.handle(
        _mediaTypeMeta,
        mediaType.isAcceptableOrUnknown(data['media_type']!, _mediaTypeMeta),
      );
    }
    if (data.containsKey('is_claimed')) {
      context.handle(
        _isClaimedMeta,
        isClaimed.isAcceptableOrUnknown(data['is_claimed']!, _isClaimedMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {itemId};
  @override
  ItemModel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ItemModel(
      itemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_id'],
      )!,
      reportedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reported_by'],
      ),
      claimedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}claimed_by'],
      ),
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      ),
      itemName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      location: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location'],
      )!,
      media: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}media'],
      ),
      mediaType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}media_type'],
      ),
      isClaimed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_claimed'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      ),
    );
  }

  @override
  $ItemTableTable createAlias(String alias) {
    return $ItemTableTable(attachedDatabase, alias);
  }
}

class ItemModel extends DataClass implements Insertable<ItemModel> {
  final String itemId;
  final String? reportedBy;
  final String? claimedBy;
  final String? categoryId;
  final String itemName;
  final String? description;

  /// 'lost' or 'found'
  final String type;
  final String location;
  final String? media;
  final String? mediaType;
  final bool isClaimed;
  final String? status;
  const ItemModel({
    required this.itemId,
    this.reportedBy,
    this.claimedBy,
    this.categoryId,
    required this.itemName,
    this.description,
    required this.type,
    required this.location,
    this.media,
    this.mediaType,
    required this.isClaimed,
    this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['item_id'] = Variable<String>(itemId);
    if (!nullToAbsent || reportedBy != null) {
      map['reported_by'] = Variable<String>(reportedBy);
    }
    if (!nullToAbsent || claimedBy != null) {
      map['claimed_by'] = Variable<String>(claimedBy);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    map['item_name'] = Variable<String>(itemName);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['type'] = Variable<String>(type);
    map['location'] = Variable<String>(location);
    if (!nullToAbsent || media != null) {
      map['media'] = Variable<String>(media);
    }
    if (!nullToAbsent || mediaType != null) {
      map['media_type'] = Variable<String>(mediaType);
    }
    map['is_claimed'] = Variable<bool>(isClaimed);
    if (!nullToAbsent || status != null) {
      map['status'] = Variable<String>(status);
    }
    return map;
  }

  ItemTableCompanion toCompanion(bool nullToAbsent) {
    return ItemTableCompanion(
      itemId: Value(itemId),
      reportedBy: reportedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(reportedBy),
      claimedBy: claimedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(claimedBy),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      itemName: Value(itemName),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      type: Value(type),
      location: Value(location),
      media: media == null && nullToAbsent
          ? const Value.absent()
          : Value(media),
      mediaType: mediaType == null && nullToAbsent
          ? const Value.absent()
          : Value(mediaType),
      isClaimed: Value(isClaimed),
      status: status == null && nullToAbsent
          ? const Value.absent()
          : Value(status),
    );
  }

  factory ItemModel.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ItemModel(
      itemId: serializer.fromJson<String>(json['itemId']),
      reportedBy: serializer.fromJson<String?>(json['reportedBy']),
      claimedBy: serializer.fromJson<String?>(json['claimedBy']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      itemName: serializer.fromJson<String>(json['itemName']),
      description: serializer.fromJson<String?>(json['description']),
      type: serializer.fromJson<String>(json['type']),
      location: serializer.fromJson<String>(json['location']),
      media: serializer.fromJson<String?>(json['media']),
      mediaType: serializer.fromJson<String?>(json['mediaType']),
      isClaimed: serializer.fromJson<bool>(json['isClaimed']),
      status: serializer.fromJson<String?>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'itemId': serializer.toJson<String>(itemId),
      'reportedBy': serializer.toJson<String?>(reportedBy),
      'claimedBy': serializer.toJson<String?>(claimedBy),
      'categoryId': serializer.toJson<String?>(categoryId),
      'itemName': serializer.toJson<String>(itemName),
      'description': serializer.toJson<String?>(description),
      'type': serializer.toJson<String>(type),
      'location': serializer.toJson<String>(location),
      'media': serializer.toJson<String?>(media),
      'mediaType': serializer.toJson<String?>(mediaType),
      'isClaimed': serializer.toJson<bool>(isClaimed),
      'status': serializer.toJson<String?>(status),
    };
  }

  ItemModel copyWith({
    String? itemId,
    Value<String?> reportedBy = const Value.absent(),
    Value<String?> claimedBy = const Value.absent(),
    Value<String?> categoryId = const Value.absent(),
    String? itemName,
    Value<String?> description = const Value.absent(),
    String? type,
    String? location,
    Value<String?> media = const Value.absent(),
    Value<String?> mediaType = const Value.absent(),
    bool? isClaimed,
    Value<String?> status = const Value.absent(),
  }) => ItemModel(
    itemId: itemId ?? this.itemId,
    reportedBy: reportedBy.present ? reportedBy.value : this.reportedBy,
    claimedBy: claimedBy.present ? claimedBy.value : this.claimedBy,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    itemName: itemName ?? this.itemName,
    description: description.present ? description.value : this.description,
    type: type ?? this.type,
    location: location ?? this.location,
    media: media.present ? media.value : this.media,
    mediaType: mediaType.present ? mediaType.value : this.mediaType,
    isClaimed: isClaimed ?? this.isClaimed,
    status: status.present ? status.value : this.status,
  );
  ItemModel copyWithCompanion(ItemTableCompanion data) {
    return ItemModel(
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      reportedBy: data.reportedBy.present
          ? data.reportedBy.value
          : this.reportedBy,
      claimedBy: data.claimedBy.present ? data.claimedBy.value : this.claimedBy,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      itemName: data.itemName.present ? data.itemName.value : this.itemName,
      description: data.description.present
          ? data.description.value
          : this.description,
      type: data.type.present ? data.type.value : this.type,
      location: data.location.present ? data.location.value : this.location,
      media: data.media.present ? data.media.value : this.media,
      mediaType: data.mediaType.present ? data.mediaType.value : this.mediaType,
      isClaimed: data.isClaimed.present ? data.isClaimed.value : this.isClaimed,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ItemModel(')
          ..write('itemId: $itemId, ')
          ..write('reportedBy: $reportedBy, ')
          ..write('claimedBy: $claimedBy, ')
          ..write('categoryId: $categoryId, ')
          ..write('itemName: $itemName, ')
          ..write('description: $description, ')
          ..write('type: $type, ')
          ..write('location: $location, ')
          ..write('media: $media, ')
          ..write('mediaType: $mediaType, ')
          ..write('isClaimed: $isClaimed, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    itemId,
    reportedBy,
    claimedBy,
    categoryId,
    itemName,
    description,
    type,
    location,
    media,
    mediaType,
    isClaimed,
    status,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ItemModel &&
          other.itemId == this.itemId &&
          other.reportedBy == this.reportedBy &&
          other.claimedBy == this.claimedBy &&
          other.categoryId == this.categoryId &&
          other.itemName == this.itemName &&
          other.description == this.description &&
          other.type == this.type &&
          other.location == this.location &&
          other.media == this.media &&
          other.mediaType == this.mediaType &&
          other.isClaimed == this.isClaimed &&
          other.status == this.status);
}

class ItemTableCompanion extends UpdateCompanion<ItemModel> {
  final Value<String> itemId;
  final Value<String?> reportedBy;
  final Value<String?> claimedBy;
  final Value<String?> categoryId;
  final Value<String> itemName;
  final Value<String?> description;
  final Value<String> type;
  final Value<String> location;
  final Value<String?> media;
  final Value<String?> mediaType;
  final Value<bool> isClaimed;
  final Value<String?> status;
  final Value<int> rowid;
  const ItemTableCompanion({
    this.itemId = const Value.absent(),
    this.reportedBy = const Value.absent(),
    this.claimedBy = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.itemName = const Value.absent(),
    this.description = const Value.absent(),
    this.type = const Value.absent(),
    this.location = const Value.absent(),
    this.media = const Value.absent(),
    this.mediaType = const Value.absent(),
    this.isClaimed = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ItemTableCompanion.insert({
    required String itemId,
    this.reportedBy = const Value.absent(),
    this.claimedBy = const Value.absent(),
    this.categoryId = const Value.absent(),
    required String itemName,
    this.description = const Value.absent(),
    required String type,
    required String location,
    this.media = const Value.absent(),
    this.mediaType = const Value.absent(),
    this.isClaimed = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : itemId = Value(itemId),
       itemName = Value(itemName),
       type = Value(type),
       location = Value(location);
  static Insertable<ItemModel> custom({
    Expression<String>? itemId,
    Expression<String>? reportedBy,
    Expression<String>? claimedBy,
    Expression<String>? categoryId,
    Expression<String>? itemName,
    Expression<String>? description,
    Expression<String>? type,
    Expression<String>? location,
    Expression<String>? media,
    Expression<String>? mediaType,
    Expression<bool>? isClaimed,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (itemId != null) 'item_id': itemId,
      if (reportedBy != null) 'reported_by': reportedBy,
      if (claimedBy != null) 'claimed_by': claimedBy,
      if (categoryId != null) 'category_id': categoryId,
      if (itemName != null) 'item_name': itemName,
      if (description != null) 'description': description,
      if (type != null) 'type': type,
      if (location != null) 'location': location,
      if (media != null) 'media': media,
      if (mediaType != null) 'media_type': mediaType,
      if (isClaimed != null) 'is_claimed': isClaimed,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ItemTableCompanion copyWith({
    Value<String>? itemId,
    Value<String?>? reportedBy,
    Value<String?>? claimedBy,
    Value<String?>? categoryId,
    Value<String>? itemName,
    Value<String?>? description,
    Value<String>? type,
    Value<String>? location,
    Value<String?>? media,
    Value<String?>? mediaType,
    Value<bool>? isClaimed,
    Value<String?>? status,
    Value<int>? rowid,
  }) {
    return ItemTableCompanion(
      itemId: itemId ?? this.itemId,
      reportedBy: reportedBy ?? this.reportedBy,
      claimedBy: claimedBy ?? this.claimedBy,
      categoryId: categoryId ?? this.categoryId,
      itemName: itemName ?? this.itemName,
      description: description ?? this.description,
      type: type ?? this.type,
      location: location ?? this.location,
      media: media ?? this.media,
      mediaType: mediaType ?? this.mediaType,
      isClaimed: isClaimed ?? this.isClaimed,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (reportedBy.present) {
      map['reported_by'] = Variable<String>(reportedBy.value);
    }
    if (claimedBy.present) {
      map['claimed_by'] = Variable<String>(claimedBy.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (itemName.present) {
      map['item_name'] = Variable<String>(itemName.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (media.present) {
      map['media'] = Variable<String>(media.value);
    }
    if (mediaType.present) {
      map['media_type'] = Variable<String>(mediaType.value);
    }
    if (isClaimed.present) {
      map['is_claimed'] = Variable<bool>(isClaimed.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ItemTableCompanion(')
          ..write('itemId: $itemId, ')
          ..write('reportedBy: $reportedBy, ')
          ..write('claimedBy: $claimedBy, ')
          ..write('categoryId: $categoryId, ')
          ..write('itemName: $itemName, ')
          ..write('description: $description, ')
          ..write('type: $type, ')
          ..write('location: $location, ')
          ..write('media: $media, ')
          ..write('mediaType: $mediaType, ')
          ..write('isClaimed: $isClaimed, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AuthTableTable authTable = $AuthTableTable(this);
  late final $BatchTableTable batchTable = $BatchTableTable(this);
  late final $CategoryTableTable categoryTable = $CategoryTableTable(this);
  late final $ItemTableTable itemTable = $ItemTableTable(this);
  late final Index idxItemType = Index(
    'idx_item_type',
    'CREATE INDEX idx_item_type ON item_table (type)',
  );
  late final Index idxItemReportedBy = Index(
    'idx_item_reported_by',
    'CREATE INDEX idx_item_reported_by ON item_table (reported_by)',
  );
  late final Index idxItemCategoryId = Index(
    'idx_item_category_id',
    'CREATE INDEX idx_item_category_id ON item_table (category_id)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    authTable,
    batchTable,
    categoryTable,
    itemTable,
    idxItemType,
    idxItemReportedBy,
    idxItemCategoryId,
  ];
}

typedef $$AuthTableTableCreateCompanionBuilder =
    AuthTableCompanion Function({
      required String authId,
      required String fullName,
      required String email,
      Value<String?> phoneNumber,
      required String username,
      Value<String?> password,
      Value<String?> batchId,
      Value<String?> profilePicture,
      Value<int> rowid,
    });
typedef $$AuthTableTableUpdateCompanionBuilder =
    AuthTableCompanion Function({
      Value<String> authId,
      Value<String> fullName,
      Value<String> email,
      Value<String?> phoneNumber,
      Value<String> username,
      Value<String?> password,
      Value<String?> batchId,
      Value<String?> profilePicture,
      Value<int> rowid,
    });

class $$AuthTableTableFilterComposer
    extends Composer<_$AppDatabase, $AuthTableTable> {
  $$AuthTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get authId => $composableBuilder(
    column: $table.authId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get password => $composableBuilder(
    column: $table.password,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get batchId => $composableBuilder(
    column: $table.batchId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get profilePicture => $composableBuilder(
    column: $table.profilePicture,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AuthTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AuthTableTable> {
  $$AuthTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get authId => $composableBuilder(
    column: $table.authId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get password => $composableBuilder(
    column: $table.password,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get batchId => $composableBuilder(
    column: $table.batchId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get profilePicture => $composableBuilder(
    column: $table.profilePicture,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AuthTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AuthTableTable> {
  $$AuthTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get authId =>
      $composableBuilder(column: $table.authId, builder: (column) => column);

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get password =>
      $composableBuilder(column: $table.password, builder: (column) => column);

  GeneratedColumn<String> get batchId =>
      $composableBuilder(column: $table.batchId, builder: (column) => column);

  GeneratedColumn<String> get profilePicture => $composableBuilder(
    column: $table.profilePicture,
    builder: (column) => column,
  );
}

class $$AuthTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AuthTableTable,
          AuthModel,
          $$AuthTableTableFilterComposer,
          $$AuthTableTableOrderingComposer,
          $$AuthTableTableAnnotationComposer,
          $$AuthTableTableCreateCompanionBuilder,
          $$AuthTableTableUpdateCompanionBuilder,
          (
            AuthModel,
            BaseReferences<_$AppDatabase, $AuthTableTable, AuthModel>,
          ),
          AuthModel,
          PrefetchHooks Function()
        > {
  $$AuthTableTableTableManager(_$AppDatabase db, $AuthTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AuthTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AuthTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AuthTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> authId = const Value.absent(),
                Value<String> fullName = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String?> phoneNumber = const Value.absent(),
                Value<String> username = const Value.absent(),
                Value<String?> password = const Value.absent(),
                Value<String?> batchId = const Value.absent(),
                Value<String?> profilePicture = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AuthTableCompanion(
                authId: authId,
                fullName: fullName,
                email: email,
                phoneNumber: phoneNumber,
                username: username,
                password: password,
                batchId: batchId,
                profilePicture: profilePicture,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String authId,
                required String fullName,
                required String email,
                Value<String?> phoneNumber = const Value.absent(),
                required String username,
                Value<String?> password = const Value.absent(),
                Value<String?> batchId = const Value.absent(),
                Value<String?> profilePicture = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AuthTableCompanion.insert(
                authId: authId,
                fullName: fullName,
                email: email,
                phoneNumber: phoneNumber,
                username: username,
                password: password,
                batchId: batchId,
                profilePicture: profilePicture,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AuthTableTable, AuthModel>(table),
                  BaseReferences<_$AppDatabase, $AuthTableTable, AuthModel>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AuthTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AuthTableTable,
      AuthModel,
      $$AuthTableTableFilterComposer,
      $$AuthTableTableOrderingComposer,
      $$AuthTableTableAnnotationComposer,
      $$AuthTableTableCreateCompanionBuilder,
      $$AuthTableTableUpdateCompanionBuilder,
      (AuthModel, BaseReferences<_$AppDatabase, $AuthTableTable, AuthModel>),
      AuthModel,
      PrefetchHooks Function()
    >;
typedef $$BatchTableTableCreateCompanionBuilder =
    BatchTableCompanion Function({
      required String batchId,
      required String batchName,
      Value<String?> status,
      Value<int> rowid,
    });
typedef $$BatchTableTableUpdateCompanionBuilder =
    BatchTableCompanion Function({
      Value<String> batchId,
      Value<String> batchName,
      Value<String?> status,
      Value<int> rowid,
    });

class $$BatchTableTableFilterComposer
    extends Composer<_$AppDatabase, $BatchTableTable> {
  $$BatchTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get batchId => $composableBuilder(
    column: $table.batchId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get batchName => $composableBuilder(
    column: $table.batchName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BatchTableTableOrderingComposer
    extends Composer<_$AppDatabase, $BatchTableTable> {
  $$BatchTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get batchId => $composableBuilder(
    column: $table.batchId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get batchName => $composableBuilder(
    column: $table.batchName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BatchTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $BatchTableTable> {
  $$BatchTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get batchId =>
      $composableBuilder(column: $table.batchId, builder: (column) => column);

  GeneratedColumn<String> get batchName =>
      $composableBuilder(column: $table.batchName, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$BatchTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BatchTableTable,
          BatchModel,
          $$BatchTableTableFilterComposer,
          $$BatchTableTableOrderingComposer,
          $$BatchTableTableAnnotationComposer,
          $$BatchTableTableCreateCompanionBuilder,
          $$BatchTableTableUpdateCompanionBuilder,
          (
            BatchModel,
            BaseReferences<_$AppDatabase, $BatchTableTable, BatchModel>,
          ),
          BatchModel,
          PrefetchHooks Function()
        > {
  $$BatchTableTableTableManager(_$AppDatabase db, $BatchTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BatchTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BatchTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BatchTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> batchId = const Value.absent(),
                Value<String> batchName = const Value.absent(),
                Value<String?> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BatchTableCompanion(
                batchId: batchId,
                batchName: batchName,
                status: status,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String batchId,
                required String batchName,
                Value<String?> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BatchTableCompanion.insert(
                batchId: batchId,
                batchName: batchName,
                status: status,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BatchTableTable, BatchModel>(table),
                  BaseReferences<_$AppDatabase, $BatchTableTable, BatchModel>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BatchTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BatchTableTable,
      BatchModel,
      $$BatchTableTableFilterComposer,
      $$BatchTableTableOrderingComposer,
      $$BatchTableTableAnnotationComposer,
      $$BatchTableTableCreateCompanionBuilder,
      $$BatchTableTableUpdateCompanionBuilder,
      (BatchModel, BaseReferences<_$AppDatabase, $BatchTableTable, BatchModel>),
      BatchModel,
      PrefetchHooks Function()
    >;
typedef $$CategoryTableTableCreateCompanionBuilder =
    CategoryTableCompanion Function({
      required String categoryId,
      required String name,
      Value<String?> description,
      Value<String?> status,
      Value<int> rowid,
    });
typedef $$CategoryTableTableUpdateCompanionBuilder =
    CategoryTableCompanion Function({
      Value<String> categoryId,
      Value<String> name,
      Value<String?> description,
      Value<String?> status,
      Value<int> rowid,
    });

class $$CategoryTableTableFilterComposer
    extends Composer<_$AppDatabase, $CategoryTableTable> {
  $$CategoryTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CategoryTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoryTableTable> {
  $$CategoryTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoryTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoryTableTable> {
  $$CategoryTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$CategoryTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoryTableTable,
          CategoryModel,
          $$CategoryTableTableFilterComposer,
          $$CategoryTableTableOrderingComposer,
          $$CategoryTableTableAnnotationComposer,
          $$CategoryTableTableCreateCompanionBuilder,
          $$CategoryTableTableUpdateCompanionBuilder,
          (
            CategoryModel,
            BaseReferences<_$AppDatabase, $CategoryTableTable, CategoryModel>,
          ),
          CategoryModel,
          PrefetchHooks Function()
        > {
  $$CategoryTableTableTableManager(_$AppDatabase db, $CategoryTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoryTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoryTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoryTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> categoryId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoryTableCompanion(
                categoryId: categoryId,
                name: name,
                description: description,
                status: status,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String categoryId,
                required String name,
                Value<String?> description = const Value.absent(),
                Value<String?> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoryTableCompanion.insert(
                categoryId: categoryId,
                name: name,
                description: description,
                status: status,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CategoryTableTable, CategoryModel>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $CategoryTableTable,
                    CategoryModel
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CategoryTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoryTableTable,
      CategoryModel,
      $$CategoryTableTableFilterComposer,
      $$CategoryTableTableOrderingComposer,
      $$CategoryTableTableAnnotationComposer,
      $$CategoryTableTableCreateCompanionBuilder,
      $$CategoryTableTableUpdateCompanionBuilder,
      (
        CategoryModel,
        BaseReferences<_$AppDatabase, $CategoryTableTable, CategoryModel>,
      ),
      CategoryModel,
      PrefetchHooks Function()
    >;
typedef $$ItemTableTableCreateCompanionBuilder =
    ItemTableCompanion Function({
      required String itemId,
      Value<String?> reportedBy,
      Value<String?> claimedBy,
      Value<String?> categoryId,
      required String itemName,
      Value<String?> description,
      required String type,
      required String location,
      Value<String?> media,
      Value<String?> mediaType,
      Value<bool> isClaimed,
      Value<String?> status,
      Value<int> rowid,
    });
typedef $$ItemTableTableUpdateCompanionBuilder =
    ItemTableCompanion Function({
      Value<String> itemId,
      Value<String?> reportedBy,
      Value<String?> claimedBy,
      Value<String?> categoryId,
      Value<String> itemName,
      Value<String?> description,
      Value<String> type,
      Value<String> location,
      Value<String?> media,
      Value<String?> mediaType,
      Value<bool> isClaimed,
      Value<String?> status,
      Value<int> rowid,
    });

class $$ItemTableTableFilterComposer
    extends Composer<_$AppDatabase, $ItemTableTable> {
  $$ItemTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get itemId => $composableBuilder(
    column: $table.itemId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reportedBy => $composableBuilder(
    column: $table.reportedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get claimedBy => $composableBuilder(
    column: $table.claimedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get itemName => $composableBuilder(
    column: $table.itemName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get media => $composableBuilder(
    column: $table.media,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mediaType => $composableBuilder(
    column: $table.mediaType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isClaimed => $composableBuilder(
    column: $table.isClaimed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ItemTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ItemTableTable> {
  $$ItemTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get itemId => $composableBuilder(
    column: $table.itemId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reportedBy => $composableBuilder(
    column: $table.reportedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get claimedBy => $composableBuilder(
    column: $table.claimedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get itemName => $composableBuilder(
    column: $table.itemName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get media => $composableBuilder(
    column: $table.media,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mediaType => $composableBuilder(
    column: $table.mediaType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isClaimed => $composableBuilder(
    column: $table.isClaimed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ItemTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ItemTableTable> {
  $$ItemTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => column);

  GeneratedColumn<String> get reportedBy => $composableBuilder(
    column: $table.reportedBy,
    builder: (column) => column,
  );

  GeneratedColumn<String> get claimedBy =>
      $composableBuilder(column: $table.claimedBy, builder: (column) => column);

  GeneratedColumn<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get itemName =>
      $composableBuilder(column: $table.itemName, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get location =>
      $composableBuilder(column: $table.location, builder: (column) => column);

  GeneratedColumn<String> get media =>
      $composableBuilder(column: $table.media, builder: (column) => column);

  GeneratedColumn<String> get mediaType =>
      $composableBuilder(column: $table.mediaType, builder: (column) => column);

  GeneratedColumn<bool> get isClaimed =>
      $composableBuilder(column: $table.isClaimed, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$ItemTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ItemTableTable,
          ItemModel,
          $$ItemTableTableFilterComposer,
          $$ItemTableTableOrderingComposer,
          $$ItemTableTableAnnotationComposer,
          $$ItemTableTableCreateCompanionBuilder,
          $$ItemTableTableUpdateCompanionBuilder,
          (
            ItemModel,
            BaseReferences<_$AppDatabase, $ItemTableTable, ItemModel>,
          ),
          ItemModel,
          PrefetchHooks Function()
        > {
  $$ItemTableTableTableManager(_$AppDatabase db, $ItemTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ItemTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ItemTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ItemTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> itemId = const Value.absent(),
                Value<String?> reportedBy = const Value.absent(),
                Value<String?> claimedBy = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<String> itemName = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> location = const Value.absent(),
                Value<String?> media = const Value.absent(),
                Value<String?> mediaType = const Value.absent(),
                Value<bool> isClaimed = const Value.absent(),
                Value<String?> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ItemTableCompanion(
                itemId: itemId,
                reportedBy: reportedBy,
                claimedBy: claimedBy,
                categoryId: categoryId,
                itemName: itemName,
                description: description,
                type: type,
                location: location,
                media: media,
                mediaType: mediaType,
                isClaimed: isClaimed,
                status: status,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String itemId,
                Value<String?> reportedBy = const Value.absent(),
                Value<String?> claimedBy = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                required String itemName,
                Value<String?> description = const Value.absent(),
                required String type,
                required String location,
                Value<String?> media = const Value.absent(),
                Value<String?> mediaType = const Value.absent(),
                Value<bool> isClaimed = const Value.absent(),
                Value<String?> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ItemTableCompanion.insert(
                itemId: itemId,
                reportedBy: reportedBy,
                claimedBy: claimedBy,
                categoryId: categoryId,
                itemName: itemName,
                description: description,
                type: type,
                location: location,
                media: media,
                mediaType: mediaType,
                isClaimed: isClaimed,
                status: status,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ItemTableTable, ItemModel>(table),
                  BaseReferences<_$AppDatabase, $ItemTableTable, ItemModel>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ItemTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ItemTableTable,
      ItemModel,
      $$ItemTableTableFilterComposer,
      $$ItemTableTableOrderingComposer,
      $$ItemTableTableAnnotationComposer,
      $$ItemTableTableCreateCompanionBuilder,
      $$ItemTableTableUpdateCompanionBuilder,
      (ItemModel, BaseReferences<_$AppDatabase, $ItemTableTable, ItemModel>),
      ItemModel,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AuthTableTableTableManager get authTable =>
      $$AuthTableTableTableManager(_db, _db.authTable);
  $$BatchTableTableTableManager get batchTable =>
      $$BatchTableTableTableManager(_db, _db.batchTable);
  $$CategoryTableTableTableManager get categoryTable =>
      $$CategoryTableTableTableManager(_db, _db.categoryTable);
  $$ItemTableTableTableManager get itemTable =>
      $$ItemTableTableTableManager(_db, _db.itemTable);
}
