import 'models/models.dart';


class ResourceDescriptor {
  const ResourceDescriptor({
    required this.path,
    this.get = false,
    this.post = false,
    this.put = false,
    this.patch = false,
    this.delete = false,
    this.parser,
  });

  final String path;
  final bool get;
  final bool post;
  final bool put;
  final bool patch;
  final bool delete;
  final MgrParser<dynamic>? parser;

  Uri buildUri({
    Map<String, String>? pathParameters,
    Map<String, dynamic>? queryParameters,
  }) {
    String resolvedPath = path;
    pathParameters?.forEach((key, value) {
      resolvedPath =
          resolvedPath.replaceAll('{$key}', Uri.encodeComponent(value));
    });
    if (RegExp(r'{[a-zA-Z]+}').hasMatch(resolvedPath)) {
      throw ArgumentError('Missing path parameters for endpoint $path');
    }
    final normalizedPath =
        resolvedPath.startsWith('/') ? resolvedPath : '/$resolvedPath';
    final uri = Uri.parse('$_baseUrl$normalizedPath');
    if (queryParameters == null || queryParameters.isEmpty) {
      return uri;
    }
    final encodedQueryParameters = queryParameters.map(
      (key, value) => MapEntry(key, value?.toString() ?? ''),
    );
    return uri.replace(queryParameters: encodedQueryParameters);
  }
}

const String _baseUrl = 'https://api.mygadgetrepairs.com/v1';
enum MgrRequestMethod { get, post, put, patch, delete }
enum Resources {
  // --- User & Staff Management ---
  userCollection(ResourceDescriptor(
    path: '/users',
    get: true,
    parser: MgrUser.listFromJson,
  )),
  userMember(ResourceDescriptor(
    path: '/users/{userId}',
    get: true,
    parser: (data) => MgrUser.fromJson(data as Map<String, dynamic>),
  )),
  timeClockCollection(ResourceDescriptor(
    path: '/timeClock',
    get: true,
    post: true,
    parser: MgrTimeClockEntry.listFromJson,
  )),
  timeClockMember(ResourceDescriptor(
    path: '/timeClock/{timeClockId}',
    get: true,
    post: true,
    put: true,
    patch: true,
    delete: true,
    parser: (data) => MgrTimeClockEntry.fromJson(data as Map<String, dynamic>),
  )),

  // --- Shop Metadata ---
  info(ResourceDescriptor(
    path: '/info',
    get: true,
  )),
  paymentMethodCollection(ResourceDescriptor(
    path: '/paymentMethods',
    get: true,
    parser: MgrPaymentMethod.listFromJson,
  )),
  taxRateCollection(ResourceDescriptor(
    path: '/taxRates',
    get: true,
    parser: MgrTaxRate.listFromJson,
  )),

  // --- Customer Management ---
  customerCollection(ResourceDescriptor(
    path: '/customers',
    get: true,
    post: true,
    put: true,
    patch: true,
    delete: true,
    parser: MgrCustomer.listFromJson,
  )),
  customerMember(ResourceDescriptor(
    path: '/customers/{customerId}',
    get: true,
    put: true,
    patch: true,
    delete: true,
    parser: (data) => MgrCustomer.fromJson(data as Map<String, dynamic>),
  )),
  customerUpdated(ResourceDescriptor(
    path: '/customers/updated',
    get: true,
    parser: MgrCustomer.listFromJson,
  )),

  // --- Reminder & Appointment ---
  reminderCollection(ResourceDescriptor(
    path: '/reminder',
    get: true,
    post: true,
    put: true,
    patch: true,
    delete: true,
    parser: MgrReminder.listFromJson,
  )),
  reminderMember(ResourceDescriptor(
    path: '/reminder/{reminderId}',
    get: true,
    put: true,
    patch: true,
    delete: true,
    parser: (data) => MgrReminder.fromJson(data as Map<String, dynamic>),
  )),
  appointmentCollection(ResourceDescriptor(
    path: '/appointment',
    get: true,
    post: true,
    put: true,
    patch: true,
    delete: true,
    parser: MgrAppointment.listFromJson,
  )),
  appointmentMember(ResourceDescriptor(
    path: '/appointment/{appointmentId}',
    get: true,
    put: true,
    patch: true,
    delete: true,
    parser: (data) => MgrAppointment.fromJson(data as Map<String, dynamic>),
  )),
  appointmentUpdated(ResourceDescriptor(
    path: '/appointment/updated',
    get: true,
    parser: MgrAppointment.listFromJson,
  )),

  // --- Purchasing & Inventory ---
  purchaseCollection(ResourceDescriptor(
    path: '/purchase',
    get: true,
    post: true,
    put: true,
    patch: true,
    delete: true,
    parser: MgrPurchase.listFromJson,
  )),
  purchaseOrderCollection(ResourceDescriptor(
    path: '/purchaseOrders',
    get: true,
    parser: MgrPurchaseOrder.listFromJson,
  )),
  purchaseOrderMember(ResourceDescriptor(
    path: '/purchaseOrders/{purchaseOrderId}',
    get: true,
    parser: (data) => MgrPurchaseOrder.fromJson(data as Map<String, dynamic>),
  )),
  supplierCollection(ResourceDescriptor(
    path: '/suppliers',
    get: true,
    parser: MgrSupplier.listFromJson,
  )),
  supplierMember(ResourceDescriptor(
    path: '/suppliers/{supplierId}',
    get: true,
    parser: (data) => MgrSupplier.fromJson(data as Map<String, dynamic>),
  )),
  productCollection(ResourceDescriptor(
    path: '/products',
    get: true,
    parser: MgrProduct.listFromJson,
  )),
  productMember(ResourceDescriptor(
    path: '/products/{productId}',
    get: true,
    parser: (data) => MgrProduct.fromJson(data as Map<String, dynamic>),
  )),
  productUpdated(ResourceDescriptor(
    path: '/products/updated',
    get: true,
    parser: MgrProduct.listFromJson,
  )),
  modelCollection(ResourceDescriptor(
    path: '/models',
    get: true,
    parser: MgrModel.listFromJson,
  )),
  modelMember(ResourceDescriptor(
    path: '/models/{modelId}',
    get: true,
    parser: (data) => MgrModel.fromJson(data as Map<String, dynamic>),
  )),
  modelGroupCollection(ResourceDescriptor(
    path: '/modelGroup',
    get: true,
    parser: MgrModelGroup.listFromJson,
  )),
  modelGroupMember(ResourceDescriptor(
    path: '/modelGroup/{groupId}',
    get: true,
    parser: (data) => MgrModelGroup.fromJson(data as Map<String, dynamic>),
  )),
  brandCollection(ResourceDescriptor(
    path: '/brands',
    get: true,
    parser: MgrBrand.listFromJson,
  )),
  categoryCollection(ResourceDescriptor(
    path: '/categories',
    get: true,
    parser: MgrCategory.listFromJson,
  )),
  categoryMember(ResourceDescriptor(
    path: '/categories/{categoryId}',
    get: true,
    parser: (data) => MgrCategory.fromJson(data as Map<String, dynamic>),
  )),
  stockCollection(ResourceDescriptor(
    path: '/stock',
    get: true,
    parser: MgrStockItem.listFromJson,
  )),
  stockMember(ResourceDescriptor(
    path: '/stock/{stockId}',
    get: true,
    parser: (data) => MgrStockItem.fromJson(data as Map<String, dynamic>),
  )),
  stockCountCollection(ResourceDescriptor(
    path: '/stockCount',
    get: true,
    parser: MgrStockCount.listFromJson,
  )),
  serialCollection(ResourceDescriptor(
    path: '/serial',
    get: true,
    parser: MgrSerial.listFromJson,
  )),
  serialMember(ResourceDescriptor(
    path: '/serial/{serialId}',
    get: true,
    parser: (data) => MgrSerial.fromJson(data as Map<String, dynamic>),
  )),
  adjustmentCollection(ResourceDescriptor(
    path: '/adjustment',
    get: true,
    parser: MgrAdjustment.listFromJson,
  )),
  adjustmentMember(ResourceDescriptor(
    path: '/adjustment/{adjustmentId}',
    get: true,
    parser: (data) => MgrAdjustment.fromJson(data as Map<String, dynamic>),
  )),
  warrantyCollection(ResourceDescriptor(
    path: '/warranties',
    get: true,
    parser: MgrWarranty.listFromJson,
  )),

  // --- Groups & Assets ---
  groupCollection(ResourceDescriptor(
    path: '/group',
    get: true,
    post: true,
    put: true,
    patch: true,
    delete: true,
    parser: MgrGroup.listFromJson,
  )),
  groupMember(ResourceDescriptor(
    path: '/group/{groupId}',
    get: true,
    put: true,
    patch: true,
    delete: true,
    parser: (data) => MgrGroup.fromJson(data as Map<String, dynamic>),
  )),
  assetCollection(ResourceDescriptor(
    path: '/asset',
    get: true,
    post: true,
    put: true,
    patch: true,
    delete: true,
    parser: MgrAsset.listFromJson,
  )),
  assetMember(ResourceDescriptor(
    path: '/asset/{assetId}',
    get: true,
    put: true,
    patch: true,
    delete: true,
    parser: (data) => MgrAsset.fromJson(data as Map<String, dynamic>),
  )),
  assetTypeCollection(ResourceDescriptor(
    path: '/assetType',
    get: true,
    parser: MgrAssetType.listFromJson,
  )),
  assetCustomFieldCollection(ResourceDescriptor(
    path: '/assetCustomField',
    get: true,
    parser: MgrAssetCustomField.listFromJson,
  )),
  assetFormFieldMapping(ResourceDescriptor(
    path: '/assetFormFieldMapping',
    get: true,
  )),

  // --- Ticketing ---
  ticketCollection(ResourceDescriptor(
    path: '/tickets',
    get: true,
    post: true,
    put: true,
    patch: true,
    delete: true,
    parser: MgrTicket.listFromJson,
  )),
  ticketMember(ResourceDescriptor(
    path: '/tickets/{ticketId}',
    get: true,
    put: true,
    patch: true,
    delete: true,
    parser: (data) => MgrTicket.fromJson(data as Map<String, dynamic>),
  )),
  ticketUpdated(ResourceDescriptor(
    path: '/tickets/updated',
    get: true,
    parser: MgrTicket.listFromJson,
  )),
  ticketItemLine(ResourceDescriptor(
    path: '/tickets/{ticketId}/itemLine',
    get: true,
    post: true,
    put: true,
    patch: true,
    delete: true,
    parser: MgrTicketItemLine.listFromJson,
  )),
  ticketAttachVideo(ResourceDescriptor(
    path: '/tickets/{ticketId}/attachVideo',
    post: true,
  )),
  ticketUploadMetadata(ResourceDescriptor(
    path: '/tickets/{ticketId}/upload',
    post: true,
  )),
  ticketUploadFile(ResourceDescriptor(
    path: '/tickets/{ticketId}/upload/{uploadId}',
    post: true,
  )),
  ticketTimerCollection(ResourceDescriptor(
    path: '/ticketTimer',
    get: true,
    post: true,
    put: true,
    patch: true,
    delete: true,
    parser: MgrTicketTimer.listFromJson,
  )),
  ticketTimerMember(ResourceDescriptor(
    path: '/ticketTimer/{timerId}',
    get: true,
    put: true,
    patch: true,
    delete: true,
    parser: (data) => MgrTicketTimer.fromJson(data as Map<String, dynamic>),
  )),
  ticketCommentCollection(ResourceDescriptor(
    path: '/ticketComment',
    get: true,
    post: true,
    put: true,
    patch: true,
    delete: true,
    parser: MgrTicketComment.listFromJson,
  )),
  ticketStatusCollection(ResourceDescriptor(
    path: '/statuses',
    get: true,
    parser: MgrStatus.listFromJson,
  )),
  issueTypeCollection(ResourceDescriptor(
    path: '/issueTypes',
    get: true,
    parser: MgrIssueType.listFromJson,
  )),

  // --- Invoicing & Payments ---
  ticketInvoiceCollection(ResourceDescriptor(
    path: '/ticketInvoices',
    get: true,
    parser: MgrTicketInvoice.listFromJson,
  )),
  ticketInvoiceMember(ResourceDescriptor(
    path: '/ticketInvoices/{invoiceId}',
    get: true,
    parser: (data) => MgrTicketInvoice.fromJson(data as Map<String, dynamic>),
  )),
  posInvoiceCollection(ResourceDescriptor(
    path: '/posInvoices',
    get: true,
    parser: MgrPosInvoice.listFromJson,
  )),
  posInvoiceMember(ResourceDescriptor(
    path: '/posInvoices/{invoiceId}',
    get: true,
    parser: (data) => MgrPosInvoice.fromJson(data as Map<String, dynamic>),
  )),
  paymentCollection(ResourceDescriptor(
    path: '/payment',
    get: true,
    post: true,
    put: true,
    patch: true,
    delete: true,
    parser: MgrPayment.listFromJson,
  )),

  // --- Presets & Templates ---
  presetCollection(ResourceDescriptor(
    path: '/preset',
    get: true,
    post: true,
    put: true,
    patch: true,
    delete: true,
    parser: MgrPreset.listFromJson,
  )),
  presetMember(ResourceDescriptor(
    path: '/preset/{presetId}',
    get: true,
    put: true,
    patch: true,
    delete: true,
    parser: (data) => MgrPreset.fromJson(data as Map<String, dynamic>),
  )),
  presetCategoryCollection(ResourceDescriptor(
    path: '/presetCategories',
    get: true,
    parser: MgrCategory.listFromJson,
  )),

  // --- Leads & Estimates ---
  leadCollection(ResourceDescriptor(
    path: '/lead',
    get: true,
    post: true,
    put: true,
    patch: true,
    delete: true,
    parser: MgrLead.listFromJson,
  )),
  leadMember(ResourceDescriptor(
    path: '/lead/{leadId}',
    get: true,
    put: true,
    patch: true,
    delete: true,
    parser: (data) => MgrLead.fromJson(data as Map<String, dynamic>),
  )),
  estimateCollection(ResourceDescriptor(
    path: '/estimate',
    get: true,
    post: true,
    put: true,
    patch: true,
    delete: true,
    parser: MgrEstimate.listFromJson,
  )),
  estimateMember(ResourceDescriptor(
    path: '/estimate/{estimateId}',
    get: true,
    put: true,
    patch: true,
    delete: true,
    parser: (data) => MgrEstimate.fromJson(data as Map<String, dynamic>),
  )),
  estimateUpdated(ResourceDescriptor(
    path: '/estimate/updated',
    get: true,
    parser: MgrEstimate.listFromJson,
  )),

  // --- Custom Fields ---
  customFieldCategoryCollection(ResourceDescriptor(
    path: '/customFieldCategories',
    get: true,
    parser: MgrCategory.listFromJson,
  )),
  customFieldCollection(ResourceDescriptor(
    path: '/customField/{type}',
    get: true,
    parser: MgrCustomField.listFromJson,
  )),

  // --- Tasks & Projects ---
  taskListCollection(ResourceDescriptor(
    path: '/taskList',
    get: true,
    post: true,
    put: true,
    patch: true,
    delete: true,
    parser: MgrTaskList.listFromJson,
  )),
  projectCollection(ResourceDescriptor(
    path: '/project',
    get: true,
    post: true,
    put: true,
    patch: true,
    delete: true,
    parser: MgrProject.listFromJson,
  )),
  projectMember(ResourceDescriptor(
    path: '/project/{projectId}',
    get: true,
    put: true,
    patch: true,
    delete: true,
    parser: (data) => MgrProject.fromJson(data as Map<String, dynamic>),
  )),
  projectTaskCollection(ResourceDescriptor(
    path: '/projectTask',
    get: true,
    post: true,
    put: true,
    patch: true,
    delete: true,
    parser: MgrProjectTask.listFromJson,
  )),
  projectTaskMember(ResourceDescriptor(
    path: '/projectTask/{taskId}',
    get: true,
    put: true,
    patch: true,
    delete: true,
    parser: (data) => MgrProjectTask.fromJson(data as Map<String, dynamic>),
  )),
  projectTagCollection(ResourceDescriptor(
    path: '/projectTag',
    get: true,
    parser: MgrProjectTag.listFromJson,
  )),
  projectStatusCollection(ResourceDescriptor(
    path: '/projectStatuses',
    get: true,
    parser: MgrProjectStatus.listFromJson,
  )),
  projectMilestoneCollection(ResourceDescriptor(
    path: '/projectMilestone',
    get: true,
    parser: MgrProjectMilestone.listFromJson,
  )),
  projectMessageCollection(ResourceDescriptor(
    path: '/projectMessage',
    get: true,
    post: true,
    put: true,
    patch: true,
    delete: true,
    parser: MgrProjectMessage.listFromJson,
  )),
  projectMessageMember(ResourceDescriptor(
    path: '/projectMessage/{messageId}',
    get: true,
    put: true,
    patch: true,
    delete: true,
    parser: (data) => MgrProjectMessage.fromJson(data as Map<String, dynamic>),
  )),
  projectCategoryCollection(ResourceDescriptor(
    path: '/projectCategories',
    get: true,
    parser: MgrProjectCategory.listFromJson,
  )),

  // --- Shipping & Logistics ---
  shipmentCollection(ResourceDescriptor(
    path: '/shipment',
    get: true,
    post: true,
    put: true,
    patch: true,
    delete: true,
    parser: MgrShipment.listFromJson,
  )),
  shipmentDeleted(ResourceDescriptor(
    path: '/shipment/deleted',
    get: true,
    parser: MgrShipment.listFromJson,
  )),
  poOnHoldCollection(ResourceDescriptor(
    path: '/poOnHold',
    get: true,
    post: true,
    put: true,
    patch: true,
    delete: true,
    parser: MgrPoOnHold.listFromJson,
  )),
  poOnHoldMember(ResourceDescriptor(
    path: '/poOnHold/{holdId}',
    get: true,
    put: true,
    patch: true,
    delete: true,
    parser: (data) => MgrPoOnHold.fromJson(data as Map<String, dynamic>),
  )),

  // --- Expenses & Finance ---
  expenseCollection(ResourceDescriptor(
    path: '/expense',
    get: true,
    post: true,
    put: true,
    patch: true,
    delete: true,
    parser: MgrExpense.listFromJson,
  )),
  expenseCategoryCollection(ResourceDescriptor(
    path: '/expenseCategories',
    get: true,
    parser: MgrExpenseCategory.listFromJson,
  )),

  // --- Reporting & Notifications ---
  systemNotificationCollection(ResourceDescriptor(
    path: '/notification',
    get: true,
    parser: MgrNotification.listFromJson,
  )),
  monthlySaleReport(ResourceDescriptor(
    path: '/monthlySale',
    get: true,
    parser: MgrReportEntry.listFromJson,
  )),
  monthlyPurchaseReport(ResourceDescriptor(
    path: '/monthlyPurchase',
    get: true,
    parser: MgrReportEntry.listFromJson,
  )),
  groupedTicketReport(ResourceDescriptor(
    path: '/groupedTicket',
    get: true,
    parser: MgrReportEntry.listFromJson,
  )),
  dailySaleReport(ResourceDescriptor(
    path: '/dailySale',
    get: true,
    parser: MgrReportEntry.listFromJson,
  )),
  dailyPurchaseReport(ResourceDescriptor(
    path: '/dailyPurchase',
    get: true,
    parser: MgrReportEntry.listFromJson,
  )),

  // --- Webhooks ---
  rmmAlert(ResourceDescriptor(
    path: '/webhook/rmmAlert',
    post: true,
  )),
  inboundCall(ResourceDescriptor(
    path: '/webhook/inboundCall',
    post: true,
  ));

  const Resources(this.descriptor);

  final ResourceDescriptor descriptor;

  bool supports(MgrRequestMethod method) => descriptor.supports(method);

  Uri fullUrl({
    Map<String, String>? pathParameters,
    Map<String, dynamic>? queryParameters,
  }) =>
      descriptor.buildUri(
        pathParameters: pathParameters,
        queryParameters: queryParameters,
      );

  MgrParser<dynamic>? get parser => descriptor.parser;
}

MgrParser<dynamic>? defaultParserFor(Resources resource) => resource.parser;

