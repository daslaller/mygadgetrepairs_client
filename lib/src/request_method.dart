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

  bool supports(MgrRequestMethod method) => switch (method) {
    MgrRequestMethod.get => get,
    MgrRequestMethod.post => post,
    MgrRequestMethod.put => put,
    MgrRequestMethod.patch => patch,
    MgrRequestMethod.delete => delete,
  };

  Uri buildUri({
    Map<String, String>? pathParameters,
    Map<String, dynamic>? queryParameters,
  }) {
    String resolvedPath = path;
    pathParameters?.forEach((key, value) {
      resolvedPath = resolvedPath.replaceAll(
        '{$key}',
        Uri.encodeComponent(value),
      );
    });
    if (RegExp(r'{[a-zA-Z]+}').hasMatch(resolvedPath)) {
      throw ArgumentError('Missing path parameters for endpoint $path');
    }
    final normalizedPath = resolvedPath.startsWith('/')
        ? resolvedPath
        : '/$resolvedPath';
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
  userCollection(
    ResourceDescriptor(path: '/users', get: true, parser: MgrUser.listFromJson),
  ),
  userMember(
   path:'/users/{userId}',
      ResourceDescriptor(
      get: true,
      parser: (data) => MgrUser.fromJson(data as Map<String, dynamic>),
    ),
  ),
  timeClockCollection(
   path:'/timeClock',
      ResourceDescriptor(
      get: true,
      post: true,
      parser: MgrTimeClockEntry.listFromJson,
    ),
  ),
  timeClockMember(
   path:'/timeClock/{timeClockId}',
      ResourceDescriptor(
      get: true,
      post: true,
      put: true,
      patch: true,
      delete: true,
      parser: (data) =>
          MgrTimeClockEntry.fromJson(data as Map<String, dynamic>),
    ),
  ),

  // --- Shop Metadata ---
  info(
   path:'/info',
      ResourceDescriptor(
      get: true,
      parser: (data) => data as Map<String, dynamic>,
    ),
  ),
  paymentMethodCollection(
   path:'/paymentMethods',
      ResourceDescriptor(
      get: true,
      parser: MgrPaymentMethod.listFromJson,
    ),
  ),
  taxRateCollection(
   path:'/taxRates',
      ResourceDescriptor(
      get: true,
      parser: MgrTaxRate.listFromJson,
    ),
  ),

  // --- Customer Management ---
  customerCollection(
   path:'/customers',
      ResourceDescriptor(
      get: true,
      post: true,
      put: true,
      patch: true,
      delete: true,
      parser: MgrCustomer.listFromJson,
    ),
  ),
  customerMember(
   path:'/customers/{customerId}',
      ResourceDescriptor(
      get: true,
      put: true,
      patch: true,
      delete: true,
      parser: (data) => MgrCustomer.fromJson(data as Map<String, dynamic>),
    ),
  ),
  customerUpdated(
   path:'/customers/updated',
      ResourceDescriptor(
      get: true,
      parser: MgrCustomer.listFromJson,
    ),
  ),

  // --- Reminder & Appointment ---
  reminderCollection(
   path:'/reminder',
      ResourceDescriptor(
      get: true,
      post: true,
      put: true,
      patch: true,
      delete: true,
      parser: MgrReminder.listFromJson,
    ),
  ),
  reminderMember(
   path:'/reminder/{reminderId}',
      ResourceDescriptor(
      get: true,
      put: true,
      patch: true,
      delete: true,
      parser: (data) => MgrReminder.fromJson(data as Map<String, dynamic>),
    ),
  ),
  appointmentCollection(
   path:'/appointment',
      ResourceDescriptor(
      get: true,
      post: true,
      put: true,
      patch: true,
      delete: true,
      parser: MgrAppointment.listFromJson,
    ),
  ),
  appointmentMember(
   path:'/appointment/{appointmentId}',
      ResourceDescriptor(
      get: true,
      put: true,
      patch: true,
      delete: true,
      parser: (data) => MgrAppointment.fromJson(data as Map<String, dynamic>),
    ),
  ),
  appointmentUpdated(
   path:'/appointment/updated',
      ResourceDescriptor(
      get: true,
      parser: MgrAppointment.listFromJson,
    ),
  ),

  // --- Purchasing & Inventory ---
  purchaseCollection(
   path:'/purchase',
      ResourceDescriptor(
      get: true,
      post: true,
      put: true,
      patch: true,
      delete: true,
      parser: MgrPurchase.listFromJson,
    ),
  ),
  purchaseOrderCollection(
   path:'/purchaseOrders',
      ResourceDescriptor(
      get: true,
      parser: MgrPurchaseOrder.listFromJson,
    ),
  ),
  purchaseOrderMember(
   path:'/purchaseOrders/{purchaseOrderId}',
      ResourceDescriptor(
      get: true,
      parser: (data) => MgrPurchaseOrder.fromJson(data as Map<String, dynamic>),
    ),
  ),
  supplierCollection(
   path:'/suppliers',
      ResourceDescriptor(
      get: true,
      parser: MgrSupplier.listFromJson,
    ),
  ),
  supplierMember(
   path:'/suppliers/{supplierId}',
      ResourceDescriptor(
      get: true,
      parser: (data) => MgrSupplier.fromJson(data as Map<String, dynamic>),
    ),
  ),
  productCollection(
   path:'/products',
      ResourceDescriptor(
      get: true,
      parser: MgrProduct.listFromJson,
    ),
  ),
  productMember(
   path:'/products/{productId}',
      ResourceDescriptor(
      get: true,
      parser: (data) => MgrProduct.fromJson(data as Map<String, dynamic>),
    ),
  ),
  productUpdated(
   path:'/products/updated',
      ResourceDescriptor(
      get: true,
      parser: MgrProduct.listFromJson,
    ),
  ),
  modelCollection(
   path:'/models',
      ResourceDescriptor(
      get: true,
      parser: MgrModel.listFromJson,
    ),
  ),
  modelMember(
   path:'/models/{modelId}',
      ResourceDescriptor(
      get: true,
      parser: (data) => MgrModel.fromJson(data as Map<String, dynamic>),
    ),
  ),
  modelGroupCollection(
   path:'/modelGroup',
      ResourceDescriptor(
      get: true,
      parser: MgrModelGroup.listFromJson,
    ),
  ),
  modelGroupMember(
   path:'/modelGroup/{groupId}',
      ResourceDescriptor(
      get: true,
      parser: (data) => MgrModelGroup.fromJson(data as Map<String, dynamic>),
    ),
  ),
  brandCollection(
   path:'/brands',
      ResourceDescriptor(
      get: true,
      parser: MgrBrand.listFromJson,
    ),
  ),
  categoryCollection(
   path:'/categories',
      ResourceDescriptor(
      get: true,
      parser: MgrCategory.listFromJson,
    ),
  ),
  categoryMember(
   path:'/categories/{categoryId}',
      ResourceDescriptor(
      get: true,
      parser: (data) => MgrCategory.fromJson(data as Map<String, dynamic>),
    ),
  ),
  stockCollection(
   path:'/stock',
      ResourceDescriptor(
      get: true,
      parser: MgrStockItem.listFromJson,
    ),
  ),
  stockMember(
   path:'/stock/{stockId}',
      ResourceDescriptor(
      get: true,
      parser: (data) => MgrStockItem.fromJson(data as Map<String, dynamic>),
    ),
  ),
  stockCountCollection(
   path:'/stockCount',
      ResourceDescriptor(
      get: true,
      parser: MgrStockCount.listFromJson,
    ),
  ),
  serialCollection(
   path:'/serial',
      ResourceDescriptor(
      get: true,
      parser: MgrSerial.listFromJson,
    ),
  ),
  serialMember(
   path:'/serial/{serialId}',
      ResourceDescriptor(
      get: true,
      parser: (data) => MgrSerial.fromJson(data as Map<String, dynamic>),
    ),
  ),
  adjustmentCollection(
   path:'/adjustment',
      ResourceDescriptor(
      get: true,
      parser: MgrAdjustment.listFromJson,
    ),
  ),
  adjustmentMember(
   path:'/adjustment/{adjustmentId}',
      ResourceDescriptor(
      get: true,
      parser: (data) => MgrAdjustment.fromJson(data as Map<String, dynamic>),
    ),
  ),
  warrantyCollection(
   path:'/warranties',
      ResourceDescriptor(
      get: true,
      parser: MgrWarranty.listFromJson,
    ),
  ),

  // --- Groups & Assets ---
  groupCollection(
   path:'/group',
      ResourceDescriptor(
      get: true,
      post: true,
      put: true,
      patch: true,
      delete: true,
      parser: MgrGroup.listFromJson,
    ),
  ),
  groupMember(
   path:'/group/{groupId}',
      ResourceDescriptor(
      get: true,
      put: true,
      patch: true,
      delete: true,
      parser: (data) => MgrGroup.fromJson(data as Map<String, dynamic>),
    ),
  ),
  assetCollection(
   path:'/asset',
      ResourceDescriptor(
      get: true,
      post: true,
      put: true,
      patch: true,
      delete: true,
      parser: MgrAsset.listFromJson,
    ),
  ),
  assetMember(
   path:'/asset/{assetId}',
      ResourceDescriptor(
      get: true,
      put: true,
      patch: true,
      delete: true,
      parser: (data) => MgrAsset.fromJson(data as Map<String, dynamic>),
    ),
  ),
  assetTypeCollection(
   path:'/assetType',
      ResourceDescriptor(
      get: true,
      parser: MgrAssetType.listFromJson,
    ),
  ),
  assetCustomFieldCollection(
   path:'/assetCustomField',
      ResourceDescriptor(
      get: true,
      parser: MgrAssetCustomField.listFromJson,
    ),
  ),
  assetFormFieldMapping(
    ResourceDescriptor(path: '/assetFormFieldMapping', get: true),
  ),

  // --- Ticketing ---
  ticketCollection(
   path:'/tickets',
      ResourceDescriptor(
      get: true,
      post: true,
      put: true,
      patch: true,
      delete: true,
      parser: MgrTicket.listFromJson,
    ),
  ),
  ticketMember(
   path:'/tickets/{ticketId}',
      ResourceDescriptor(
      get: true,
      put: true,
      patch: true,
      delete: true,
      parser: (data) => MgrTicket.fromJson(data as Map<String, dynamic>),
    ),
  ),
  ticketUpdated(
   path:'/tickets/updated',
      ResourceDescriptor(
      get: true,
      parser: MgrTicket.listFromJson,
    ),
  ),
  ticketItemLine(
   path:'/tickets/{ticketId}/itemLine',
      ResourceDescriptor(
      get: true,
      post: true,
      put: true,
      patch: true,
      delete: true,
      parser: MgrTicketItemLine.listFromJson,
    ),
  ),
  ticketAttachVideo(
    ResourceDescriptor(path: '/tickets/{ticketId}/attachVideo', post: true),
  ),
  ticketUploadMetadata(
    ResourceDescriptor(path: '/tickets/{ticketId}/upload', post: true),
  ),
  ticketUploadFile(
   path:'/tickets/{ticketId}/upload/{uploadId}',
      ResourceDescriptor(
      post: true,
    ),
  ),
  ticketTimerCollection(
   path:'/ticketTimer',
      ResourceDescriptor(
      get: true,
      post: true,
      put: true,
      patch: true,
      delete: true,
      parser: MgrTicketTimer.listFromJson,
    ),
  ),
  ticketTimerMember(
   path:'/ticketTimer/{timerId}',
      ResourceDescriptor(
      get: true,
      put: true,
      patch: true,
      delete: true,
      parser: (data) => MgrTicketTimer.fromJson(data as Map<String, dynamic>),
    ),
  ),
  ticketCommentCollection(
   path:'/ticketComment',
      ResourceDescriptor(
      get: true,
      post: true,
      put: true,
      patch: true,
      delete: true,
      parser: MgrTicketComment.listFromJson,
    ),
  ),
  ticketStatusCollection(
   path:'/statuses',
      ResourceDescriptor(
      get: true,
      parser: MgrStatus.listFromJson,
    ),
  ),
  issueTypeCollection(
   path:'/issueTypes',
      ResourceDescriptor(
      get: true,
      parser: MgrIssueType.listFromJson,
    ),
  ),

  // --- Invoicing & Payments ---
  ticketInvoiceCollection(
   path:'/ticketInvoices',
      ResourceDescriptor(
      get: true,
      parser: MgrTicketInvoice.listFromJson,
    ),
  ),
  ticketInvoiceMember(
   path:'/ticketInvoices/{invoiceId}',
      ResourceDescriptor(
      get: true,
      parser: (data) => MgrTicketInvoice.fromJson(data as Map<String, dynamic>),
    ),
  ),
  posInvoiceCollection(
   path:'/posInvoices',
      ResourceDescriptor(
      get: true,
      parser: MgrPosInvoice.listFromJson,
    ),
  ),
  posInvoiceMember(
   path:'/posInvoices/{invoiceId}',
      ResourceDescriptor(
      get: true,
      parser: (data) => MgrPosInvoice.fromJson(data as Map<String, dynamic>),
    ),
  ),
  paymentCollection(
   path:'/payment',
      ResourceDescriptor(
      get: true,
      post: true,
      put: true,
      patch: true,
      delete: true,
      parser: MgrPayment.listFromJson,
    ),
  ),

  // --- Presets & Templates ---
  presetCollection(
   path:'/preset',
      ResourceDescriptor(
      get: true,
      post: true,
      put: true,
      patch: true,
      delete: true,
      parser: MgrPreset.listFromJson,
    ),
  ),
  presetMember(
   path:'/preset/{presetId}',
      ResourceDescriptor(
      get: true,
      put: true,
      patch: true,
      delete: true,
      parser: (data) => MgrPreset.fromJson(data as Map<String, dynamic>),
    ),
  ),
  presetCategoryCollection(
   path:'/presetCategories',
      ResourceDescriptor(
      get: true,
      parser: MgrCategory.listFromJson,
    ),
  ),

  // --- Leads & Estimates ---
  leadCollection(
   path:'/lead',
      ResourceDescriptor(
      get: true,
      post: true,
      put: true,
      patch: true,
      delete: true,
      parser: MgrLead.listFromJson,
    ),
  ),
  leadMember(
   path:'/lead/{leadId}',
      ResourceDescriptor(
      get: true,
      put: true,
      patch: true,
      delete: true,
      parser: (data) => MgrLead.fromJson(data as Map<String, dynamic>),
    ),
  ),
  estimateCollection(
   path:'/estimate',
      ResourceDescriptor(
      get: true,
      post: true,
      put: true,
      patch: true,
      delete: true,
      parser: MgrEstimate.listFromJson,
    ),
  ),
  estimateMember(
   path:'/estimate/{estimateId}',
      ResourceDescriptor(
      get: true,
      put: true,
      patch: true,
      delete: true,
      parser: (data) => MgrEstimate.fromJson(data as Map<String, dynamic>),
    ),
  ),
  estimateUpdated(
   path:'/estimate/updated',
      ResourceDescriptor(
      get: true,
      parser: MgrEstimate.listFromJson,
    ),
  ),

  // --- Custom Fields ---
  customFieldCategoryCollection(
   path:'/customFieldCategories',
      ResourceDescriptor(
      get: true,
      parser: MgrCategory.listFromJson,
    ),
  ),
  customFieldCollection(
   path:'/customField/{type}',
      ResourceDescriptor(
      get: true,
      parser: MgrCustomField.listFromJson,
    ),
  ),

  // --- Tasks & Projects ---
  taskListCollection(
   path:'/taskList',
      ResourceDescriptor(
      get: true,
      post: true,
      put: true,
      patch: true,
      delete: true,
      parser: MgrTaskList.listFromJson,
    ),
  ),
  projectCollection(
   path:'/project',
      ResourceDescriptor(
      get: true,
      post: true,
      put: true,
      patch: true,
      delete: true,
      parser: MgrProject.listFromJson,
    ),
  ),
  projectMember(
   path:'/project/{projectId}',
      ResourceDescriptor(
      get: true,
      put: true,
      patch: true,
      delete: true,
      parser: (data) => MgrProject.fromJson(data as Map<String, dynamic>),
    ),
  ),
  projectTaskCollection(
   path:'/projectTask',
      ResourceDescriptor(
      get: true,
      post: true,
      put: true,
      patch: true,
      delete: true,
      parser: MgrProjectTask.listFromJson,
    ),
  ),
  projectTaskMember(
   path:'/projectTask/{taskId}',
      ResourceDescriptor(
      get: true,
      put: true,
      patch: true,
      delete: true,
      parser: (data) => MgrProjectTask.fromJson(data as Map<String, dynamic>),
    ),
  ),
  projectTagCollection(
   path:'/projectTag',
      ResourceDescriptor(
      get: true,
      parser: MgrProjectTag.listFromJson,
    ),
  ),
  projectStatusCollection(
   path:'/projectStatuses',
      ResourceDescriptor(
      get: true,
      parser: MgrProjectStatus.listFromJson,
    ),
  ),
  projectMilestoneCollection(
   path:'/projectMilestone',
      ResourceDescriptor(
      get: true,
      parser: MgrProjectMilestone.listFromJson,
    ),
  ),
  projectMessageCollection(
   path:'/projectMessage',
      ResourceDescriptor(
      get: true,
      post: true,
      put: true,
      patch: true,
      delete: true,
      parser: MgrProjectMessage.listFromJson,
    ),
  ),
  projectMessageMember(
   path:'/projectMessage/{messageId}',
      ResourceDescriptor(
      get: true,
      put: true,
      patch: true,
      delete: true,
      parser: (data) =>
          MgrProjectMessage.fromJson(data as Map<String, dynamic>),
    ),
  ),
  projectCategoryCollection(
   path:'/projectCategories',
      ResourceDescriptor(
      get: true,
      parser: MgrProjectCategory.listFromJson,
    ),
  ),

  // --- Shipping & Logistics ---
  shipmentCollection(
   path:'/shipment',
      ResourceDescriptor(
      get: true,
      post: true,
      put: true,
      patch: true,
      delete: true,
      parser: MgrShipment.listFromJson,
    ),
  ),
  shipmentDeleted(
   path:'/shipment/deleted',
      ResourceDescriptor(
      get: true,
      parser: MgrShipment.listFromJson,
    ),
  ),
  poOnHoldCollection(
   path:'/poOnHold',
      ResourceDescriptor(
      get: true,
      post: true,
      put: true,
      patch: true,
      delete: true,
      parser: MgrPoOnHold.listFromJson,
    ),
  ),
  poOnHoldMember(
   path:'/poOnHold/{holdId}',
      ResourceDescriptor(
      get: true,
      put: true,
      patch: true,
      delete: true,
      parser: (data) => MgrPoOnHold.fromJson(data as Map<String, dynamic>),
    ),
  ),

  // --- Expenses & Finance ---
  expenseCollection(
   path:'/expense',
      ResourceDescriptor(
      get: true,
      post: true,
      put: true,
      patch: true,
      delete: true,
      parser: MgrExpense.listFromJson,
    ),
  ),
  expenseCategoryCollection(
   path:'/expenseCategories',
      ResourceDescriptor(
      get: true,
      parser: MgrExpenseCategory.listFromJson,
    ),
  ),

  // --- Reporting & Notifications ---
  systemNotificationCollection(
   path:'/notification',
      ResourceDescriptor(
      get: true,
      parser: MgrNotification.listFromJson,
    ),
  ),
  monthlySaleReport(
   path:'/monthlySale',
      ResourceDescriptor(
      get: true,
      parser: MgrReportEntry.listFromJson,
    ),
  ),
  monthlyPurchaseReport(
   path:'/monthlyPurchase',
      ResourceDescriptor(
      get: true,
      parser: MgrReportEntry.listFromJson,
    ),
  ),
  groupedTicketReport(
       path: '/groupedTicket',
    ResourceDescriptor(
      get: true,
      parser: MgrReportEntry.listFromJson,
    ),
  ),
  dailySaleReport(
       path: '/dailySale',
    ResourceDescriptor(
      descriptor: ResourceDescriptor(get: true, parser: MgrReportEntry.listFromJson),
    ),
  ),
  dailyPurchaseReport(
    path: '/dailyPurchase',
    descriptor: ResourceDescriptor(get: true, parser: MgrReportEntry.listFromJson),
  ),

  // --- Webhooks ---
  rmmAlert(path: '/webhook/rmmAlert', descriptor: ResourceDescriptor(post: true)),
  inboundCall(path: '/webhook/inboundCall', descriptor: ResourceDescriptor(post: true));

  const Resources({this.path, required this.descriptor});

  final ResourceDescriptor descriptor;
  final String path;

  bool supports(MgrRequestMethod method) => descriptor.supports(method);

  Uri fullUrl({
    Map<String, String>? pathParameters,
    Map<String, dynamic>? queryParameters,
  }) => descriptor.buildUri(
    pathParameters: pathParameters,
    queryParameters: queryParameters,
  );

  MgrParser<dynamic>? get parser => descriptor.parser;
}

MgrParser<dynamic>? defaultParserFor(Resources resource) => resource.parser;
