# MGR API Client - Comprehensive Implementation Plan

## Overview
This document outlines the plan to implement all MGR API endpoints in the `mygadgetrepairs_client` package, following the existing code structure and patterns.

## Current Implementation Status

### Already Implemented (Partially)
1. **UserMember** - `/users/{ID}` - GET only
2. **UserCollection** - `/users` - GET only
3. **TimeClockMember** - `/timeclock/{ID}` - GET, DELETE (PUT marked as false)
4. **TimeClockCollection** - `/timeClock` - GET only
5. **TaxRateCollection** - `/taxRates` - GET, POST
6. **PaymentMethodCollection** - `/paymentMethods` - GET only
7. **Info** - `/info` - GET only
8. **RmmAlert** - `webhook/rmmAlert` - POST only
9. **InboundCall** - `webhook/inboundCall` - POST only

### Issues with Current Implementation
- HTTP method flags are incomplete (many endpoints support more methods than marked)
- Only `inboundCall` is actually callable via `request()` method
- Missing proper resource model classes for most endpoints
- No support for PUT, PATCH, DELETE methods in the client
- Response handling is hardcoded to `UserResource` only

## Complete List of API Endpoints to Implement

### SHOP Section

#### User Resources
- ✅ UserMember - `/users/{userId}` - **Needs**: PATCH, PUT, POST, DELETE
- ✅ UserCollection - `/users` - **Needs**: POST, PUT, PATCH, DELETE

#### TimeClock Resources
- ✅ TimeClockMember - `/timeClock/{timeClockId}` - **Needs**: POST, PATCH (PUT exists but marked false)
- ✅ TimeClockCollection - `/timeClock` - **Needs**: POST, PUT, PATCH, DELETE

#### Tax & Payment Resources
- ✅ TaxRateCollection - `/taxRate` - **Needs**: PUT, PATCH, DELETE
- ✅ PaymentMethodCollection - `/paymentMethod` - **Needs**: POST, PUT, PATCH, DELETE

#### System Resources
- ✅ Info - `/info` - GET only (correct)

#### Reminder Resources
- ❌ ReminderMember - `/reminder/{reminderId}` - GET, POST, PUT, PATCH, DELETE
- ❌ ReminderCollection - `/reminder` - GET, POST, PUT, PATCH, DELETE

#### Appointment Resources
- ❌ AppointmentUpdated - `/appointment/updated` - GET
- ❌ AppointmentMember - `/appointment/{appointmentId}` - GET, POST, PUT, PATCH, DELETE
- ❌ AppointmentCollection - `/appointment` - GET, POST, PUT, PATCH, DELETE

#### Purchase Resources
- ❌ PurchaseCollection - `/purchase` - GET, POST, PUT, PATCH, DELETE

#### Group Resources
- ❌ GroupMember - `/group/{groupId}` - GET, POST, PUT, PATCH, DELETE
- ❌ GroupCollection - `/group` - GET, POST, PUT, PATCH, DELETE

#### Customer Resources
- ❌ CustomerUpdated - `/customer/updated` - GET
- ❌ CustomerMember - `/customer/{customerId}` - GET, POST, PUT, PATCH, DELETE
- ❌ CustomerCollection - `/customer` - GET, POST, PUT, PATCH, DELETE

#### Asset Resources
- ❌ AssetMember - `/asset/{assetId}` - GET, POST, PUT, PATCH, DELETE
- ❌ AssetCollection - `/asset` - GET, POST, PUT, PATCH, DELETE
- ❌ AssetTypeCollection - `/assetType` - GET, POST, PUT, PATCH, DELETE

#### Ticket Resources
- ❌ TicketUpdated - `/ticket/updated` - GET
- ❌ TicketUploadFile - `/ticket/{ticketId}/upload/{uploadId}` - GET, POST, PUT, PATCH, DELETE
- ❌ TicketUploadFileMeta - `/ticket/{ticketId}/upload` - GET, POST, PUT, PATCH, DELETE
- ❌ TicketItemLine - `/ticket/{ticketId}/itemLine` - GET, POST, PUT, PATCH, DELETE
- ❌ TicketAttachVideo - `/ticket/{ticketId}/attachVideo` - GET, POST, PUT, PATCH, DELETE
- ❌ TicketMember - `/ticket/{ticketId}` - GET, POST, PUT, PATCH, DELETE
- ❌ TicketCollection - `/ticket` - GET, POST, PUT, PATCH, DELETE

#### Ticket Timer Resources
- ❌ TicketTimerMember - `/ticketTimer/{timerId}` - GET, POST, PUT, PATCH, DELETE
- ❌ TicketTimerCollection - `/ticketTimer` - GET, POST, PUT, PATCH, DELETE

#### Ticket Comment Resources
- ❌ TicketComment - `/ticketComment` - GET, POST, PUT, PATCH, DELETE

#### Status Resources
- ❌ StatusCollection - `/statuses` - GET, POST, PUT, PATCH, DELETE

#### Preset Resources
- ❌ PresetMember - `/preset/{presetId}` - GET, POST, PUT, PATCH, DELETE
- ❌ PresetCollection - `/preset` - GET, POST, PUT, PATCH, DELETE
- ❌ PresetCategoryCollection - `/presetCategories` - GET, POST, PUT, PATCH, DELETE

#### Issue Type Resources
- ❌ IssueTypeCollection - `/issueType` - GET, POST, PUT, PATCH, DELETE

#### Invoice Resources
- ❌ TicketInvoiceMember - `/ticketInvoice/{invoiceId}` - GET, POST, PUT, PATCH, DELETE
- ❌ TicketInvoiceCollection - `/ticketInvoice` - GET, POST, PUT, PATCH, DELETE

#### PO Order Resources
- ❌ PoOrderMember - `/poOrder/{orderId}` - GET, POST, PUT, PATCH, DELETE
- ❌ PoOrderCollection - `/poOrder` - GET, POST, PUT, PATCH, DELETE

#### Payment Resources
- ❌ PaymentCollection - `/payment` - GET, POST, PUT, PATCH, DELETE

#### Warranty Resources
- ❌ WarrantyCollection - `/warranties` - GET, POST, PUT, PATCH, DELETE

#### Product Resources
- ❌ ProductUpdated - `/product/updated` - GET
- ❌ ProductUploadFile - `/product/{productId}/upload/{uploadId}` - GET, POST, PUT, PATCH, DELETE
- ❌ ProductUploadFileMeta - `/product/{productId}/upload` - GET, POST, PUT, PATCH, DELETE
- ❌ ProductMember - `/product/{productId}` - GET, POST, PUT, PATCH, DELETE
- ❌ ProductCollection - `/product` - GET, POST, PUT, PATCH, DELETE

#### Model Resources
- ❌ ModelMember - `/model/{modelId}` - GET, POST, PUT, PATCH, DELETE
- ❌ ModelCollection - `/model` - GET, POST, PUT, PATCH, DELETE

#### Model Group Resources
- ❌ ModelGroupMember - `/modelGroup/{groupId}` - GET, POST, PUT, PATCH, DELETE
- ❌ ModelGroupCollection - `/modelGroup` - GET, POST, PUT, PATCH, DELETE

#### Category Resources
- ❌ CategoryMember - `/categories/{categoryId}` - GET, POST, PUT, PATCH, DELETE
- ❌ CategoryCollection - `/categories` - GET, POST, PUT, PATCH, DELETE

#### Brand Resources
- ❌ BrandMember - `/brand/{brandId}` - GET, POST, PUT, PATCH, DELETE
- ❌ BrandCollection - `/brand` - GET, POST, PUT, PATCH, DELETE

#### Stock Resources
- ❌ StockCountCollection - `/stockCount` - GET, POST, PUT, PATCH, DELETE
- ❌ StockMember - `/stock/{stockId}` - GET, POST, PUT, PATCH, DELETE
- ❌ StockCollection - `/stock` - GET, POST, PUT, PATCH, DELETE

#### Serial Resources
- ❌ SerialMember - `/serial/{serialId}` - GET, POST, PUT, PATCH, DELETE
- ❌ SerialCollection - `/serial` - GET, POST, PUT, PATCH, DELETE

#### Adjustment Resources
- ❌ AdjustmentMember - `/adjustment/{adjustmentId}` - GET, POST, PUT, PATCH, DELETE
- ❌ AdjustmentCollection - `/adjustment` - GET, POST, PUT, PATCH, DELETE

#### Supplier Resources
- ❌ SupplierMember - `/supplier/{supplierId}` - GET, POST, PUT, PATCH, DELETE
- ❌ SupplierCollection - `/supplier` - GET, POST, PUT, PATCH, DELETE

#### Purchase Order Resources
- ❌ PurchaseOrderMember - `/purchaseOrder/{purchaseOrderId}` - GET, POST, PUT, PATCH, DELETE
- ❌ PurchaseOrderCollection - `/purchaseOrder` - GET, POST, PUT, PATCH, DELETE

#### Expense Resources
- ❌ ExpenseCollection - `/expense` - GET, POST, PUT, PATCH, DELETE
- ❌ ExpenseCategoryCollection - `/expenseCategories` - GET, POST, PUT, PATCH, DELETE

#### Lead Resources
- ❌ LeadMember - `/lead/{leadId}` - GET, POST, PUT, PATCH, DELETE
- ❌ LeadCollection - `/lead` - GET, POST, PUT, PATCH, DELETE

#### Estimate Resources
- ❌ EstimateUpdated - `/estimate/updated` - GET
- ❌ EstimateMember - `/estimate/{estimateId}` - GET, POST, PUT, PATCH, DELETE
- ❌ EstimateCollection - `/estimate` - GET, POST, PUT, PATCH, DELETE

#### Custom Field Resources
- ❌ CustomFieldCategories - `/customFieldCategories` - GET, POST, PUT, PATCH, DELETE
- ❌ CustomFieldCollection - `/customField/{type:ticket|lead|customer|product}` - GET, POST, PUT, PATCH, DELETE
- ❌ AssetFormFieldMapping - `/assetFormFieldMapping` - GET, POST, PUT, PATCH, DELETE
- ❌ AssetCustomFieldCollection - `/assetCustomField` - GET, POST, PUT, PATCH, DELETE

#### Task List Resources
- ❌ TaskListCollection - `/taskList` - GET, POST, PUT, PATCH, DELETE

#### Project Resources
- ❌ ProjectMember - `/project/{projectId}` - GET, POST, PUT, PATCH, DELETE
- ❌ ProjectCollection - `/project` - GET, POST, PUT, PATCH, DELETE

#### Project Task Resources
- ❌ ProjectTaskMember - `/projectTask/{taskId}` - GET, POST, PUT, PATCH, DELETE
- ❌ ProjectTaskCollection - `/projectTask` - GET, POST, PUT, PATCH, DELETE

#### Project Tag Resources
- ❌ ProjectTagCollection - `/projectTag` - GET, POST, PUT, PATCH, DELETE

#### Project Status Resources
- ❌ ProjectStatusCollection - `/projectStatuses` - GET, POST, PUT, PATCH, DELETE

#### Project Milestone Resources
- ❌ ProjectMilestoneCollection - `/projectMilestone` - GET, POST, PUT, PATCH, DELETE

#### Project Message Resources
- ❌ ProjectMessageMember - `/projectMessage/{messageId}` - GET, POST, PUT, PATCH, DELETE
- ❌ ProjectMessageCollection - `/projectMessage` - GET, POST, PUT, PATCH, DELETE

#### Project Category Resources
- ❌ ProjectCategoryCollection - `/projectCategories` - GET, POST, PUT, PATCH, DELETE

#### Shipment Resources
- ❌ ShipmentDeleted - `/shipment/deleted` - GET
- ❌ Shipment - `/shipment` - GET, POST, PUT, PATCH, DELETE

#### PO OnHold Resources
- ❌ PoOnHoldMember - `/poOnHold/{holdId}` - GET, POST, PUT, PATCH, DELETE
- ❌ PoOnHoldCollection - `/poOnHold` - GET, POST, PUT, PATCH, DELETE

#### Notification Resources
- ❌ SystemNotification - `/notification` - GET, POST, PUT, PATCH, DELETE

#### Report Resources
- ❌ MonthlySale - `/monthlySale` - GET
- ❌ MonthlyPurchase - `/monthlyPurchase` - GET
- ❌ GroupedTicket - `/groupedTicket` - GET
- ❌ DailySale - `/dailySale` - GET
- ❌ DailyPurchase - `/dailyPurchase` - GET

#### Webhook Resources
- ✅ RmmAlert - `webhook/rmmAlert` - **Needs**: GET (currently POST only)
- ✅ InboundCall - `webhook/inboundCall` - **Needs**: GET (currently POST only)

## Implementation Strategy

### Phase 1: Foundation Improvements
1. **Fix HTTP Method Support**
   - Update all Resources enum entries with correct HTTP method flags
   - Implement PUT, PATCH, DELETE methods in MgrClient
   - Add request body support for POST, PUT, PATCH

2. **Improve Request Handling**
   - Refactor `request()` method to handle all resources and HTTP methods
   - Add method parameter to `request()` to specify GET, POST, PUT, PATCH, DELETE
   - Add support for request bodies and query parameters

3. **Response Handling**
   - Create generic response handler that doesn't hardcode UserResource
   - Add support for different response types (single object, list, etc.)
   - Improve error handling with better error messages

### Phase 2: Add Missing Endpoints
1. **Add All Missing Resources to Enum**
   - Add all endpoints from the list above to Resources enum
   - Ensure correct HTTP method flags for each

2. **Create Resource Model Classes**
   - Create model classes for each resource type (following UserResource pattern)
   - Each model should have:
     - Required fields as properties
     - `rawData` Map for complete response data
     - `fromJson` factory constructor
     - `toString` override

### Phase 3: Enhanced Features
1. **Query Parameters Support**
   - Add query parameter support to request methods
   - Support filtering, pagination, etc.

2. **Request Body Support**
   - Add support for sending JSON bodies in POST, PUT, PATCH requests
   - Validate request bodies before sending

3. **Better Error Handling**
   - Parse API error responses properly
   - Provide meaningful error messages
   - Handle different HTTP status codes appropriately

### Phase 4: Documentation & Examples
1. **Update README**
   - Document all available endpoints
   - Provide usage examples
   - Document authentication

2. **Update Example File**
   - Add examples for different resource types
   - Show GET, POST, PUT, PATCH, DELETE usage
   - Demonstrate error handling

## Code Structure to Follow

### Resources Enum Pattern
```dart
enum Resources {
  resourceMember('/resource/{ID}', GET: true, POST: true, PUT: true, PATCH: true, DELETE: true),
  resourceCollection('/resource', GET: true, POST: true, PUT: true, PATCH: true, DELETE: true);
  
  // ... existing pattern
}
```

### Resource Model Pattern
```dart
class ResourceModel {
  final String id;
  final Map<String, dynamic> rawData;
  // ... other fields
  
  ResourceModel({required this.id, required this.rawData, ...});
  
  factory ResourceModel.fromJson(Map<String, dynamic> json) {
    return ResourceModel(
      id: json['id'] as String,
      rawData: json,
      // ... other fields
    );
  }
  
  @override
  String toString() => 'ResourceModel(id: $id, ...)';
}
```

### Client Method Pattern
```dart
Future<T> request<T>({
  required Resources resource,
  required String method, // 'GET', 'POST', 'PUT', 'PATCH', 'DELETE'
  String? id,
  Map<String, dynamic>? body,
  Map<String, String>? queryParams,
}) async {
  // Handle all HTTP methods
  // Support request bodies
  // Support query parameters
  // Return typed responses
}
```

## Estimated Endpoints Count
- **Currently Implemented**: 9 endpoints (partially)
- **Total Endpoints to Implement**: ~100+ endpoints
- **Missing Endpoints**: ~90+ endpoints

## Priority Order
1. **High Priority**: Complete existing endpoints (add missing HTTP methods)
2. **High Priority**: Core resources (Customer, Ticket, Product, Appointment)
3. **Medium Priority**: Supporting resources (Asset, Lead, Estimate, Project)
4. **Low Priority**: Report and webhook endpoints

## Notes
- Some endpoints have special path patterns (e.g., `/customField/{type:...}`)
- Some endpoints are GET-only (reports, updated endpoints)
- Webhook endpoints support both GET and POST
- File upload endpoints need special handling

## API Documentation Insights (from https://docs.mygadgetrepairs.com/api/public-api/)

### Authentication
- **Method**: API key in `Authorization` header (not Bearer token, just the apiKey directly)
- **Base URL**: `https://api.mygadgetrepairs.com/v1`
- **Rate Limit**: 30 requests per minute (blocked for 6-8 hours if exceeded 10 times)
- **Pagination**: Default 50 records per page

### Response Format
- **Success Codes**: 200 (GET, PUT, DELETE) or 201 (POST)
- **Formats**: JSON (default) or XML (via Accept header)
- **POST/PUT Response**: Returns `{"id":"xxxx-xxxx-xxxx-xxxx"}` on success
- **DELETE Response**: No content on success (200 status)
- **Error Response**: `{"error":"Error message. Advice message"}`

### Endpoint Method Support (from official docs)

#### GET-Only Endpoints (Read-only)
- **Users**: `/users`, `/users/{userId}` - GET only
- **Products**: `/products`, `/products/{productId}` - GET only
- **Models**: `/models` - GET only
- **Brands**: `/brands` - GET only
- **Suppliers**: `/suppliers`, `/suppliers/{supplierId}` - GET only
- **Payment Methods**: `/paymentMethods` - GET only
- **Tax Rates**: `/taxRates` - GET only
- **Custom Fields**: `/customFields/{type}` - GET only
- **Invoices**: `/ticketInvoices`, `/ticketInvoices/{invoiceId}`, `/posInvoices`, `/posInvoices/{invoiceId}` - GET only
- **Purchase Orders**: `/purchaseOrders`, `/purchaseOrders/{purchaseOrderId}` - GET only
- **Issue Types**: `/issueTypes` - GET only
- **Statuses**: `/statuses` - GET only

#### Full CRUD Endpoints (from docs)
- **Customers**: `/customers`, `/customers/{customerId}` - GET, POST, PUT, DELETE
- **Tickets**: `/tickets`, `/tickets/{ticketId}` - GET, POST, PUT, DELETE

#### Special Endpoints
- **Ticket File Upload**: Two-step process
  1. POST `/tickets/{ticketId}/upload` - Send metadata, get uploadId in Location header
  2. POST `/tickets/{ticketId}/upload/{uploadId}` - Send actual file as form-data

### Important Implementation Notes
1. **Authorization Header**: Should be `Authorization: {apiKey}` (not `Bearer {apiKey}`)
2. **Content-Type**: Use `application/json` for JSON request bodies
3. **Accept Header**: Use `application/json` or `application/xml` for response format
4. **PUT Requests**: Only send fields that need to be updated (partial updates)
5. **Error Handling**: Check for status codes other than 200/201 and parse error message from response
6. **Rate Limiting**: Implement request throttling to respect 30 req/min limit

