typedef Json = Map<String, dynamic>;

typedef MgrParser<T> = T Function(dynamic data);

String? _asString(Json json, String key) {
  final value = json[key];
  if (value == null) return null;
  if (value is String) return value;
  return value.toString();
}

num? _asNum(Json json, String key) {
  final value = json[key];
  if (value == null) return null;
  if (value is num) return value;
  if (value is String) return num.tryParse(value);
  return null;
}

bool? _asBool(Json json, String key) {
  final value = json[key];
  if (value == null) return null;
  if (value is bool) return value;
  if (value is num) return value != 0;
  if (value is String) {
    switch (value.toLowerCase()) {
      case 'true':
      case '1':
      case 'yes':
        return true;
      case 'false':
      case '0':
      case 'no':
        return false;
    }
  }
  return null;
}

DateTime? _asDateTime(Json json, String key) {
  final value = json[key];
  if (value == null) return null;
  if (value is DateTime) return value;
  if (value is int) {
    if (value.toString().length == 10) {
      return DateTime.fromMillisecondsSinceEpoch(value * 1000, isUtc: true);
    }
    return DateTime.fromMillisecondsSinceEpoch(value, isUtc: true);
  }
  if (value is String) return DateTime.tryParse(value);
  return null;
}

List<T> _mapList<T>(
  dynamic data,
  T Function(Json json) builder,
) {
  if (data == null) return <T>[];
  if (data is List) {
    return data
        .whereType<Json>()
        .map(builder)
        .toList(growable: false);
  }
  if (data is Json && data['data'] is List) {
    return _mapList<T>(data['data'], builder);
  }
  if (data is Json) {
    return <T>[builder(data)];
  }
  throw ArgumentError(
    'Unsupported payload type ${data.runtimeType}; cannot parse into model list.',
  );
}

abstract class MgrEntity {
  final String? id;
  final Json rawData;

  const MgrEntity({
    required this.rawData,
    this.id,
  });

  @override
  String toString() => '$runtimeType(id: $id)';
}

class MgrUser extends MgrEntity {
  final String? name;
  final String? email;
  final String? role;

  MgrUser({
    super.id,
    required super.rawData,
    this.name,
    this.email,
    this.role,
  });

  factory MgrUser.fromJson(Json json) => MgrUser(
        id: _asString(json, 'id'),
        rawData: json,
        name: _asString(json, 'name'),
        email: _asString(json, 'email'),
        role: _asString(json, 'role'),
      );

  static List<MgrUser> listFromJson(dynamic data) =>
      _mapList(data, MgrUser.fromJson);
}

class MgrTimeClockEntry extends MgrEntity {
  final String? userId;
  final DateTime? clockIn;
  final DateTime? clockOut;
  final num? durationMinutes;

  MgrTimeClockEntry({
    super.id,
    required super.rawData,
    this.userId,
    this.clockIn,
    this.clockOut,
    this.durationMinutes,
  });

  factory MgrTimeClockEntry.fromJson(Json json) => MgrTimeClockEntry(
        id: _asString(json, 'id'),
        rawData: json,
        userId: _asString(json, 'userId'),
        clockIn: _asDateTime(json, 'clockIn'),
        clockOut: _asDateTime(json, 'clockOut'),
        durationMinutes: _asNum(json, 'durationMinutes'),
      );

  static List<MgrTimeClockEntry> listFromJson(dynamic data) =>
      _mapList(data, MgrTimeClockEntry.fromJson);
}

class MgrPaymentMethod extends MgrEntity {
  final String? name;
  final bool? isDefault;

  MgrPaymentMethod({
    super.id,
    required super.rawData,
    this.name,
    this.isDefault,
  });

  factory MgrPaymentMethod.fromJson(Json json) => MgrPaymentMethod(
        id: _asString(json, 'id'),
        rawData: json,
        name: _asString(json, 'name'),
        isDefault: _asBool(json, 'isDefault'),
      );

  static List<MgrPaymentMethod> listFromJson(dynamic data) =>
      _mapList(data, MgrPaymentMethod.fromJson);
}

class MgrTaxRate extends MgrEntity {
  final String? name;
  final num? rate;

  MgrTaxRate({
    super.id,
    required super.rawData,
    this.name,
    this.rate,
  });

  factory MgrTaxRate.fromJson(Json json) => MgrTaxRate(
        id: _asString(json, 'id'),
        rawData: json,
        name: _asString(json, 'name'),
        rate: _asNum(json, 'rate'),
      );

  static List<MgrTaxRate> listFromJson(dynamic data) =>
      _mapList(data, MgrTaxRate.fromJson);
}

class MgrCustomer extends MgrEntity {
  final String? name;
  final String? email;
  final String? mobile;
  final String? phone;
  final String? company;
  final DateTime? createdAt;

  MgrCustomer({
    super.id,
    required super.rawData,
    this.name,
    this.email,
    this.mobile,
    this.phone,
    this.company,
    this.createdAt,
  });

  factory MgrCustomer.fromJson(Json json) => MgrCustomer(
        id: _asString(json, 'id'),
        rawData: json,
        name: _asString(json, 'name'),
        email: _asString(json, 'email'),
        mobile: _asString(json, 'mobile') ?? _asString(json, 'telephone'),
        phone: _asString(json, 'telephone'),
        company: _asString(json, 'company'),
        createdAt: _asDateTime(json, 'createdAt'),
      );

  static List<MgrCustomer> listFromJson(dynamic data) =>
      _mapList(data, MgrCustomer.fromJson);
}

class MgrReminder extends MgrEntity {
  final String? subject;
  final String? assignedTo;
  final DateTime? dueAt;
  final bool? completed;

  MgrReminder({
    super.id,
    required super.rawData,
    this.subject,
    this.assignedTo,
    this.dueAt,
    this.completed,
  });

  factory MgrReminder.fromJson(Json json) => MgrReminder(
        id: _asString(json, 'id'),
        rawData: json,
        subject: _asString(json, 'subject'),
        assignedTo: _asString(json, 'assignedTo'),
        dueAt: _asDateTime(json, 'dueAt'),
        completed: _asBool(json, 'completed'),
      );

  static List<MgrReminder> listFromJson(dynamic data) =>
      _mapList(data, MgrReminder.fromJson);
}

class MgrAppointment extends MgrEntity {
  final String? title;
  final DateTime? startAt;
  final DateTime? endAt;
  final String? customerId;
  final String? location;

  MgrAppointment({
    super.id,
    required super.rawData,
    this.title,
    this.startAt,
    this.endAt,
    this.customerId,
    this.location,
  });

  factory MgrAppointment.fromJson(Json json) => MgrAppointment(
        id: _asString(json, 'id'),
        rawData: json,
        title: _asString(json, 'title') ?? _asString(json, 'subject'),
        startAt: _asDateTime(json, 'startAt') ?? _asDateTime(json, 'start'),
        endAt: _asDateTime(json, 'endAt') ?? _asDateTime(json, 'end'),
        customerId: _asString(json, 'customerId'),
        location: _asString(json, 'location'),
      );

  static List<MgrAppointment> listFromJson(dynamic data) =>
      _mapList(data, MgrAppointment.fromJson);
}

class MgrPurchase extends MgrEntity {
  final String? reference;
  final num? total;
  final String? supplierId;
  final DateTime? createdAt;

  MgrPurchase({
    super.id,
    required super.rawData,
    this.reference,
    this.total,
    this.supplierId,
    this.createdAt,
  });

  factory MgrPurchase.fromJson(Json json) => MgrPurchase(
        id: _asString(json, 'id'),
        rawData: json,
        reference: _asString(json, 'reference'),
        total: _asNum(json, 'total'),
        supplierId: _asString(json, 'supplierId'),
        createdAt: _asDateTime(json, 'createdAt'),
      );

  static List<MgrPurchase> listFromJson(dynamic data) =>
      _mapList(data, MgrPurchase.fromJson);
}

class MgrSupplier extends MgrEntity {
  final String? name;
  final String? email;
  final String? phone;
  final String? accountNumber;

  MgrSupplier({
    super.id,
    required super.rawData,
    this.name,
    this.email,
    this.phone,
    this.accountNumber,
  });

  factory MgrSupplier.fromJson(Json json) => MgrSupplier(
        id: _asString(json, 'id'),
        rawData: json,
        name: _asString(json, 'name'),
        email: _asString(json, 'email'),
        phone: _asString(json, 'telephone'),
        accountNumber: _asString(json, 'accountNumber'),
      );

  static List<MgrSupplier> listFromJson(dynamic data) =>
      _mapList(data, MgrSupplier.fromJson);
}

class MgrPurchaseOrder extends MgrEntity {
  final String? number;
  final num? total;
  final String? supplierId;
  final DateTime? createdAt;

  MgrPurchaseOrder({
    super.id,
    required super.rawData,
    this.number,
    this.total,
    this.supplierId,
    this.createdAt,
  });

  factory MgrPurchaseOrder.fromJson(Json json) => MgrPurchaseOrder(
        id: _asString(json, 'id'),
        rawData: json,
        number: _asString(json, 'number'),
        total: _asNum(json, 'total'),
        supplierId: _asString(json, 'supplierId'),
        createdAt: _asDateTime(json, 'createdAt'),
      );

  static List<MgrPurchaseOrder> listFromJson(dynamic data) =>
      _mapList(data, MgrPurchaseOrder.fromJson);
}

class MgrProduct extends MgrEntity {
  final String? name;
  final String? sku;
  final String? brandId;
  final String? categoryId;
  final num? price;

  MgrProduct({
    super.id,
    required super.rawData,
    this.name,
    this.sku,
    this.brandId,
    this.categoryId,
    this.price,
  });

  factory MgrProduct.fromJson(Json json) => MgrProduct(
        id: _asString(json, 'id'),
        rawData: json,
        name: _asString(json, 'name'),
        sku: _asString(json, 'sku') ?? _asString(json, 'barcode'),
        brandId: _asString(json, 'brandId'),
        categoryId: _asString(json, 'categoryId'),
        price: _asNum(json, 'price') ?? _asNum(json, 'sellPrice'),
      );

  static List<MgrProduct> listFromJson(dynamic data) =>
      _mapList(data, MgrProduct.fromJson);
}

class MgrModel extends MgrEntity {
  final String? name;
  final String? brandId;
  final String? categoryId;

  MgrModel({
    super.id,
    required super.rawData,
    this.name,
    this.brandId,
    this.categoryId,
  });

  factory MgrModel.fromJson(Json json) => MgrModel(
        id: _asString(json, 'id'),
        rawData: json,
        name: _asString(json, 'name'),
        brandId: _asString(json, 'brandId'),
        categoryId: _asString(json, 'categoryId'),
      );

  static List<MgrModel> listFromJson(dynamic data) =>
      _mapList(data, MgrModel.fromJson);
}

class MgrModelGroup extends MgrEntity {
  final String? name;

  MgrModelGroup({
    super.id,
    required super.rawData,
    this.name,
  });

  factory MgrModelGroup.fromJson(Json json) => MgrModelGroup(
        id: _asString(json, 'id'),
        rawData: json,
        name: _asString(json, 'name'),
      );

  static List<MgrModelGroup> listFromJson(dynamic data) =>
      _mapList(data, MgrModelGroup.fromJson);
}

class MgrBrand extends MgrEntity {
  final String? name;

  MgrBrand({
    super.id,
    required super.rawData,
    this.name,
  });

  factory MgrBrand.fromJson(Json json) => MgrBrand(
        id: _asString(json, 'id'),
        rawData: json,
        name: _asString(json, 'name'),
      );

  static List<MgrBrand> listFromJson(dynamic data) =>
      _mapList(data, MgrBrand.fromJson);
}

class MgrCategory extends MgrEntity {
  final String? name;
  final String? parentId;

  MgrCategory({
    super.id,
    required super.rawData,
    this.name,
    this.parentId,
  });

  factory MgrCategory.fromJson(Json json) => MgrCategory(
        id: _asString(json, 'id'),
        rawData: json,
        name: _asString(json, 'name'),
        parentId: _asString(json, 'parentId'),
      );

  static List<MgrCategory> listFromJson(dynamic data) =>
      _mapList(data, MgrCategory.fromJson);
}

class MgrStockItem extends MgrEntity {
  final String? productId;
  final num? quantity;
  final String? location;

  MgrStockItem({
    super.id,
    required super.rawData,
    this.productId,
    this.quantity,
    this.location,
  });

  factory MgrStockItem.fromJson(Json json) => MgrStockItem(
        id: _asString(json, 'id'),
        rawData: json,
        productId: _asString(json, 'productId'),
        quantity: _asNum(json, 'quantity'),
        location: _asString(json, 'location'),
      );

  static List<MgrStockItem> listFromJson(dynamic data) =>
      _mapList(data, MgrStockItem.fromJson);
}

class MgrStockCount extends MgrEntity {
  final String? productId;
  final num? counted;
  final DateTime? countedAt;

  MgrStockCount({
    super.id,
    required super.rawData,
    this.productId,
    this.counted,
    this.countedAt,
  });

  factory MgrStockCount.fromJson(Json json) => MgrStockCount(
        id: _asString(json, 'id'),
        rawData: json,
        productId: _asString(json, 'productId'),
        counted: _asNum(json, 'count'),
        countedAt: _asDateTime(json, 'countedAt'),
      );

  static List<MgrStockCount> listFromJson(dynamic data) =>
      _mapList(data, MgrStockCount.fromJson);
}

class MgrSerial extends MgrEntity {
  final String? productId;
  final String? serialNumber;
  final String? status;

  MgrSerial({
    super.id,
    required super.rawData,
    this.productId,
    this.serialNumber,
    this.status,
  });

  factory MgrSerial.fromJson(Json json) => MgrSerial(
        id: _asString(json, 'id'),
        rawData: json,
        productId: _asString(json, 'productId'),
        serialNumber: _asString(json, 'serialNumber') ??
            _asString(json, 'serial') ??
            _asString(json, 'imei'),
        status: _asString(json, 'status'),
      );

  static List<MgrSerial> listFromJson(dynamic data) =>
      _mapList(data, MgrSerial.fromJson);
}

class MgrAdjustment extends MgrEntity {
  final String? productId;
  final num? quantity;
  final String? reason;

  MgrAdjustment({
    super.id,
    required super.rawData,
    this.productId,
    this.quantity,
    this.reason,
  });

  factory MgrAdjustment.fromJson(Json json) => MgrAdjustment(
        id: _asString(json, 'id'),
        rawData: json,
        productId: _asString(json, 'productId'),
        quantity: _asNum(json, 'quantity'),
        reason: _asString(json, 'reason'),
      );

  static List<MgrAdjustment> listFromJson(dynamic data) =>
      _mapList(data, MgrAdjustment.fromJson);
}

class MgrWarranty extends MgrEntity {
  final String? name;
  final num? months;

  MgrWarranty({
    super.id,
    required super.rawData,
    this.name,
    this.months,
  });

  factory MgrWarranty.fromJson(Json json) => MgrWarranty(
        id: _asString(json, 'id'),
        rawData: json,
        name: _asString(json, 'name'),
        months: _asNum(json, 'months'),
      );

  static List<MgrWarranty> listFromJson(dynamic data) =>
      _mapList(data, MgrWarranty.fromJson);
}

class MgrGroup extends MgrEntity {
  final String? name;
  final String? description;

  MgrGroup({
    super.id,
    required super.rawData,
    this.name,
    this.description,
  });

  factory MgrGroup.fromJson(Json json) => MgrGroup(
        id: _asString(json, 'id'),
        rawData: json,
        name: _asString(json, 'name'),
        description: _asString(json, 'description'),
      );

  static List<MgrGroup> listFromJson(dynamic data) =>
      _mapList(data, MgrGroup.fromJson);
}

class MgrAsset extends MgrEntity {
  final String? name;
  final String? typeId;
  final String? customerId;
  final String? serial;

  MgrAsset({
    super.id,
    required super.rawData,
    this.name,
    this.typeId,
    this.customerId,
    this.serial,
  });

  factory MgrAsset.fromJson(Json json) => MgrAsset(
        id: _asString(json, 'id'),
        rawData: json,
        name: _asString(json, 'name'),
        typeId: _asString(json, 'typeId'),
        customerId: _asString(json, 'customerId'),
        serial: _asString(json, 'serialNumber') ?? _asString(json, 'serial'),
      );

  static List<MgrAsset> listFromJson(dynamic data) =>
      _mapList(data, MgrAsset.fromJson);
}

class MgrAssetType extends MgrEntity {
  final String? name;

  MgrAssetType({
    super.id,
    required super.rawData,
    this.name,
  });

  factory MgrAssetType.fromJson(Json json) => MgrAssetType(
        id: _asString(json, 'id'),
        rawData: json,
        name: _asString(json, 'name'),
      );

  static List<MgrAssetType> listFromJson(dynamic data) =>
      _mapList(data, MgrAssetType.fromJson);
}

class MgrAssetCustomField extends MgrEntity {
  final String? label;
  final String? valueType;

  MgrAssetCustomField({
    super.id,
    required super.rawData,
    this.label,
    this.valueType,
  });

  factory MgrAssetCustomField.fromJson(Json json) => MgrAssetCustomField(
        id: _asString(json, 'id'),
        rawData: json,
        label: _asString(json, 'label'),
        valueType: _asString(json, 'valueType'),
      );

  static List<MgrAssetCustomField> listFromJson(dynamic data) =>
      _mapList(data, MgrAssetCustomField.fromJson);
}

class MgrTicket extends MgrEntity {
  final String? shortInfo;
  final String? status;
  final String? customerId;
  final String? technicianId;
  final DateTime? createdAt;

  MgrTicket({
    super.id,
    required super.rawData,
    this.shortInfo,
    this.status,
    this.customerId,
    this.technicianId,
    this.createdAt,
  });

  factory MgrTicket.fromJson(Json json) => MgrTicket(
        id: _asString(json, 'id') ?? _asString(json, 'ticketId'),
        rawData: json,
        shortInfo: _asString(json, 'shortInfo') ?? _asString(json, 'subject'),
        status: _asString(json, 'status'),
        customerId: _asString(json, 'customerId'),
        technicianId: _asString(json, 'technicianId'),
        createdAt: _asDateTime(json, 'createdAt'),
      );

  static List<MgrTicket> listFromJson(dynamic data) =>
      _mapList(data, MgrTicket.fromJson);
}

class MgrTicketItemLine extends MgrEntity {
  final String? ticketId;
  final String? productId;
  final num? quantity;
  final num? price;

  MgrTicketItemLine({
    super.id,
    required super.rawData,
    this.ticketId,
    this.productId,
    this.quantity,
    this.price,
  });

  factory MgrTicketItemLine.fromJson(Json json) => MgrTicketItemLine(
        id: _asString(json, 'id'),
        rawData: json,
        ticketId: _asString(json, 'ticketId'),
        productId: _asString(json, 'productId'),
        quantity: _asNum(json, 'quantity'),
        price: _asNum(json, 'price'),
      );

  static List<MgrTicketItemLine> listFromJson(dynamic data) =>
      _mapList(data, MgrTicketItemLine.fromJson);
}

class MgrTicketTimer extends MgrEntity {
  final String? ticketId;
  final String? userId;
  final DateTime? startedAt;
  final DateTime? stoppedAt;
  final num? durationMinutes;

  MgrTicketTimer({
    super.id,
    required super.rawData,
    this.ticketId,
    this.userId,
    this.startedAt,
    this.stoppedAt,
    this.durationMinutes,
  });

  factory MgrTicketTimer.fromJson(Json json) => MgrTicketTimer(
        id: _asString(json, 'id'),
        rawData: json,
        ticketId: _asString(json, 'ticketId'),
        userId: _asString(json, 'userId'),
        startedAt: _asDateTime(json, 'startTime') ??
            _asDateTime(json, 'startedAt'),
        stoppedAt: _asDateTime(json, 'stopTime') ?? _asDateTime(json, 'endedAt'),
        durationMinutes: _asNum(json, 'durationMinutes'),
      );

  static List<MgrTicketTimer> listFromJson(dynamic data) =>
      _mapList(data, MgrTicketTimer.fromJson);
}

class MgrTicketComment extends MgrEntity {
  final String? ticketId;
  final String? authorId;
  final String? note;
  final DateTime? createdAt;

  MgrTicketComment({
    super.id,
    required super.rawData,
    this.ticketId,
    this.authorId,
    this.note,
    this.createdAt,
  });

  factory MgrTicketComment.fromJson(Json json) => MgrTicketComment(
        id: _asString(json, 'id'),
        rawData: json,
        ticketId: _asString(json, 'ticketId'),
        authorId: _asString(json, 'authorId'),
        note: _asString(json, 'comment') ?? _asString(json, 'note'),
        createdAt: _asDateTime(json, 'createdAt'),
      );

  static List<MgrTicketComment> listFromJson(dynamic data) =>
      _mapList(data, MgrTicketComment.fromJson);
}

class MgrTicketInvoice extends MgrEntity {
  final String? ticketId;
  final String? number;
  final num? total;
  final DateTime? createdAt;

  MgrTicketInvoice({
    super.id,
    required super.rawData,
    this.ticketId,
    this.number,
    this.total,
    this.createdAt,
  });

  factory MgrTicketInvoice.fromJson(Json json) => MgrTicketInvoice(
        id: _asString(json, 'id'),
        rawData: json,
        ticketId: _asString(json, 'ticketId'),
        number: _asString(json, 'invoiceNumber'),
        total: _asNum(json, 'total'),
        createdAt: _asDateTime(json, 'createdAt'),
      );

  static List<MgrTicketInvoice> listFromJson(dynamic data) =>
      _mapList(data, MgrTicketInvoice.fromJson);
}

class MgrPosInvoice extends MgrEntity {
  final String? orderId;
  final String? number;
  final num? total;

  MgrPosInvoice({
    super.id,
    required super.rawData,
    this.orderId,
    this.number,
    this.total,
  });

  factory MgrPosInvoice.fromJson(Json json) => MgrPosInvoice(
        id: _asString(json, 'id'),
        rawData: json,
        orderId: _asString(json, 'orderId'),
        number: _asString(json, 'invoiceNumber'),
        total: _asNum(json, 'total'),
      );

  static List<MgrPosInvoice> listFromJson(dynamic data) =>
      _mapList(data, MgrPosInvoice.fromJson);
}

class MgrIssueType extends MgrEntity {
  final String? name;

  MgrIssueType({
    super.id,
    required super.rawData,
    this.name,
  });

  factory MgrIssueType.fromJson(Json json) => MgrIssueType(
        id: _asString(json, 'id'),
        rawData: json,
        name: _asString(json, 'name'),
      );

  static List<MgrIssueType> listFromJson(dynamic data) =>
      _mapList(data, MgrIssueType.fromJson);
}

class MgrStatus extends MgrEntity {
  final String? name;
  final String? category;

  MgrStatus({
    super.id,
    required super.rawData,
    this.name,
    this.category,
  });

  factory MgrStatus.fromJson(Json json) => MgrStatus(
        id: _asString(json, 'id'),
        rawData: json,
        name: _asString(json, 'name'),
        category: _asString(json, 'category') ?? _asString(json, 'type'),
      );

  static List<MgrStatus> listFromJson(dynamic data) =>
      _mapList(data, MgrStatus.fromJson);
}

class MgrPayment extends MgrEntity {
  final String? reference;
  final String? customerId;
  final num? amount;
  final DateTime? paidAt;
  final String? methodId;

  MgrPayment({
    super.id,
    required super.rawData,
    this.reference,
    this.customerId,
    this.amount,
    this.paidAt,
    this.methodId,
  });

  factory MgrPayment.fromJson(Json json) => MgrPayment(
        id: _asString(json, 'id'),
        rawData: json,
        reference: _asString(json, 'reference'),
        customerId: _asString(json, 'customerId'),
        amount: _asNum(json, 'amount'),
        paidAt: _asDateTime(json, 'paidAt'),
        methodId: _asString(json, 'paymentMethodId'),
      );

  static List<MgrPayment> listFromJson(dynamic data) =>
      _mapList(data, MgrPayment.fromJson);
}

class MgrPreset extends MgrEntity {
  final String? name;
  final String? categoryId;
  final String? description;

  MgrPreset({
    super.id,
    required super.rawData,
    this.name,
    this.categoryId,
    this.description,
  });

  factory MgrPreset.fromJson(Json json) => MgrPreset(
        id: _asString(json, 'id'),
        rawData: json,
        name: _asString(json, 'name'),
        categoryId: _asString(json, 'categoryId'),
        description: _asString(json, 'description'),
      );

  static List<MgrPreset> listFromJson(dynamic data) =>
      _mapList(data, MgrPreset.fromJson);
}

class MgrLead extends MgrEntity {
  final String? name;
  final String? email;
  final String? status;
  final DateTime? createdAt;

  MgrLead({
    super.id,
    required super.rawData,
    this.name,
    this.email,
    this.status,
    this.createdAt,
  });

  factory MgrLead.fromJson(Json json) => MgrLead(
        id: _asString(json, 'id'),
        rawData: json,
        name: _asString(json, 'name'),
        email: _asString(json, 'email'),
        status: _asString(json, 'status'),
        createdAt: _asDateTime(json, 'createdAt'),
      );

  static List<MgrLead> listFromJson(dynamic data) =>
      _mapList(data, MgrLead.fromJson);
}

class MgrEstimate extends MgrEntity {
  final String? number;
  final String? customerId;
  final num? total;
  final DateTime? createdAt;

  MgrEstimate({
    super.id,
    required super.rawData,
    this.number,
    this.customerId,
    this.total,
    this.createdAt,
  });

  factory MgrEstimate.fromJson(Json json) => MgrEstimate(
        id: _asString(json, 'id'),
        rawData: json,
        number: _asString(json, 'number'),
        customerId: _asString(json, 'customerId'),
        total: _asNum(json, 'total'),
        createdAt: _asDateTime(json, 'createdAt'),
      );

  static List<MgrEstimate> listFromJson(dynamic data) =>
      _mapList(data, MgrEstimate.fromJson);
}

class MgrCustomField extends MgrEntity {
  final String? name;
  final String? type;
  final String? appliesTo;

  MgrCustomField({
    super.id,
    required super.rawData,
    this.name,
    this.type,
    this.appliesTo,
  });

  factory MgrCustomField.fromJson(Json json) => MgrCustomField(
        id: _asString(json, 'id'),
        rawData: json,
        name: _asString(json, 'name'),
        type: _asString(json, 'type'),
        appliesTo: _asString(json, 'appliesTo') ??
            _asString(json, 'context') ??
            _asString(json, 'for'),
      );

  static List<MgrCustomField> listFromJson(dynamic data) =>
      _mapList(data, MgrCustomField.fromJson);
}

class MgrTaskList extends MgrEntity {
  final String? name;
  final String? description;

  MgrTaskList({
    super.id,
    required super.rawData,
    this.name,
    this.description,
  });

  factory MgrTaskList.fromJson(Json json) => MgrTaskList(
        id: _asString(json, 'id'),
        rawData: json,
        name: _asString(json, 'name'),
        description: _asString(json, 'description'),
      );

  static List<MgrTaskList> listFromJson(dynamic data) =>
      _mapList(data, MgrTaskList.fromJson);
}

class MgrProject extends MgrEntity {
  final String? name;
  final String? customerId;
  final String? statusId;
  final DateTime? createdAt;

  MgrProject({
    super.id,
    required super.rawData,
    this.name,
    this.customerId,
    this.statusId,
    this.createdAt,
  });

  factory MgrProject.fromJson(Json json) => MgrProject(
        id: _asString(json, 'id'),
        rawData: json,
        name: _asString(json, 'name'),
        customerId: _asString(json, 'customerId'),
        statusId: _asString(json, 'statusId'),
        createdAt: _asDateTime(json, 'createdAt'),
      );

  static List<MgrProject> listFromJson(dynamic data) =>
      _mapList(data, MgrProject.fromJson);
}

class MgrProjectTask extends MgrEntity {
  final String? projectId;
  final String? name;
  final String? assignedTo;
  final DateTime? dueAt;
  final bool? completed;

  MgrProjectTask({
    super.id,
    required super.rawData,
    this.projectId,
    this.name,
    this.assignedTo,
    this.dueAt,
    this.completed,
  });

  factory MgrProjectTask.fromJson(Json json) => MgrProjectTask(
        id: _asString(json, 'id'),
        rawData: json,
        projectId: _asString(json, 'projectId'),
        name: _asString(json, 'name'),
        assignedTo: _asString(json, 'assignedTo'),
        dueAt: _asDateTime(json, 'dueAt'),
        completed: _asBool(json, 'completed'),
      );

  static List<MgrProjectTask> listFromJson(dynamic data) =>
      _mapList(data, MgrProjectTask.fromJson);
}

class MgrProjectTag extends MgrEntity {
  final String? name;

  MgrProjectTag({
    super.id,
    required super.rawData,
    this.name,
  });

  factory MgrProjectTag.fromJson(Json json) => MgrProjectTag(
        id: _asString(json, 'id'),
        rawData: json,
        name: _asString(json, 'name'),
      );

  static List<MgrProjectTag> listFromJson(dynamic data) =>
      _mapList(data, MgrProjectTag.fromJson);
}

class MgrProjectStatus extends MgrEntity {
  final String? name;

  MgrProjectStatus({
    super.id,
    required super.rawData,
    this.name,
  });

  factory MgrProjectStatus.fromJson(Json json) => MgrProjectStatus(
        id: _asString(json, 'id'),
        rawData: json,
        name: _asString(json, 'name'),
      );

  static List<MgrProjectStatus> listFromJson(dynamic data) =>
      _mapList(data, MgrProjectStatus.fromJson);
}

class MgrProjectMilestone extends MgrEntity {
  final String? projectId;
  final String? name;
  final DateTime? dueAt;

  MgrProjectMilestone({
    super.id,
    required super.rawData,
    this.projectId,
    this.name,
    this.dueAt,
  });

  factory MgrProjectMilestone.fromJson(Json json) => MgrProjectMilestone(
        id: _asString(json, 'id'),
        rawData: json,
        projectId: _asString(json, 'projectId'),
        name: _asString(json, 'name'),
        dueAt: _asDateTime(json, 'dueAt'),
      );

  static List<MgrProjectMilestone> listFromJson(dynamic data) =>
      _mapList(data, MgrProjectMilestone.fromJson);
}

class MgrProjectMessage extends MgrEntity {
  final String? projectId;
  final String? authorId;
  final String? message;
  final DateTime? createdAt;

  MgrProjectMessage({
    super.id,
    required super.rawData,
    this.projectId,
    this.authorId,
    this.message,
    this.createdAt,
  });

  factory MgrProjectMessage.fromJson(Json json) => MgrProjectMessage(
        id: _asString(json, 'id'),
        rawData: json,
        projectId: _asString(json, 'projectId'),
        authorId: _asString(json, 'authorId'),
        message: _asString(json, 'message'),
        createdAt: _asDateTime(json, 'createdAt'),
      );

  static List<MgrProjectMessage> listFromJson(dynamic data) =>
      _mapList(data, MgrProjectMessage.fromJson);
}

class MgrProjectCategory extends MgrEntity {
  final String? name;

  MgrProjectCategory({
    super.id,
    required super.rawData,
    this.name,
  });

  factory MgrProjectCategory.fromJson(Json json) => MgrProjectCategory(
        id: _asString(json, 'id'),
        rawData: json,
        name: _asString(json, 'name'),
      );

  static List<MgrProjectCategory> listFromJson(dynamic data) =>
      _mapList(data, MgrProjectCategory.fromJson);
}

class MgrShipment extends MgrEntity {
  final String? number;
  final String? carrier;
  final DateTime? shippedAt;

  MgrShipment({
    super.id,
    required super.rawData,
    this.number,
    this.carrier,
    this.shippedAt,
  });

  factory MgrShipment.fromJson(Json json) => MgrShipment(
        id: _asString(json, 'id'),
        rawData: json,
        number: _asString(json, 'number'),
        carrier: _asString(json, 'carrier'),
        shippedAt: _asDateTime(json, 'shippedAt'),
      );

  static List<MgrShipment> listFromJson(dynamic data) =>
      _mapList(data, MgrShipment.fromJson);
}

class MgrPoOnHold extends MgrEntity {
  final String? orderId;
  final String? reason;
  final DateTime? createdAt;

  MgrPoOnHold({
    super.id,
    required super.rawData,
    this.orderId,
    this.reason,
    this.createdAt,
  });

  factory MgrPoOnHold.fromJson(Json json) => MgrPoOnHold(
        id: _asString(json, 'id'),
        rawData: json,
        orderId: _asString(json, 'orderId'),
        reason: _asString(json, 'reason'),
        createdAt: _asDateTime(json, 'createdAt'),
      );

  static List<MgrPoOnHold> listFromJson(dynamic data) =>
      _mapList(data, MgrPoOnHold.fromJson);
}

class MgrExpense extends MgrEntity {
  final String? categoryId;
  final num? amount;
  final String? vendor;
  final DateTime? incurredOn;

  MgrExpense({
    super.id,
    required super.rawData,
    this.categoryId,
    this.amount,
    this.vendor,
    this.incurredOn,
  });

  factory MgrExpense.fromJson(Json json) => MgrExpense(
        id: _asString(json, 'id'),
        rawData: json,
        categoryId: _asString(json, 'categoryId'),
        amount: _asNum(json, 'amount'),
        vendor: _asString(json, 'vendor'),
        incurredOn: _asDateTime(json, 'incurredOn') ??
            _asDateTime(json, 'expenseDate'),
      );

  static List<MgrExpense> listFromJson(dynamic data) =>
      _mapList(data, MgrExpense.fromJson);
}

class MgrExpenseCategory extends MgrEntity {
  final String? name;

  MgrExpenseCategory({
    super.id,
    required super.rawData,
    this.name,
  });

  factory MgrExpenseCategory.fromJson(Json json) => MgrExpenseCategory(
        id: _asString(json, 'id'),
        rawData: json,
        name: _asString(json, 'name'),
      );

  static List<MgrExpenseCategory> listFromJson(dynamic data) =>
      _mapList(data, MgrExpenseCategory.fromJson);
}

class MgrNotification extends MgrEntity {
  final String? title;
  final String? message;
  final DateTime? createdAt;

  MgrNotification({
    super.id,
    required super.rawData,
    this.title,
    this.message,
    this.createdAt,
  });

  factory MgrNotification.fromJson(Json json) => MgrNotification(
        id: _asString(json, 'id'),
        rawData: json,
        title: _asString(json, 'title'),
        message: _asString(json, 'message'),
        createdAt: _asDateTime(json, 'createdAt'),
      );

  static List<MgrNotification> listFromJson(dynamic data) =>
      _mapList(data, MgrNotification.fromJson);
}
