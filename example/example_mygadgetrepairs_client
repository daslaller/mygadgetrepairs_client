import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:mygadgetrepairs_client/mygadgetrepairs_client.dart';

Future<void> main(List<String> args) async {
  final configFile = File('example/config.json');
  if (!await configFile.exists()) {
    log('Config file not found at ${configFile.path}.');
    log('Create it with your API key: {"apiKey": "YOUR_MGR_API_KEY"}');
    return;
  }

  final config = jsonDecode(await configFile.readAsString()) as Map<String, dynamic>;
  final apiKey = config['apiKey'] as String?;
  if (apiKey == null || apiKey.isEmpty || apiKey == 'YOUR_MGR_API_KEY') {
    log('Please set a valid apiKey in example/config.json before running the demo.');
    return;
  }

  final client = MgrClient(apiKey: apiKey);

  try {
    final customers = await client.request<List<MgrCustomer>>(
      resource: Resources.customerCollection,
      method: MgrRequestMethod.get,
    );
    log('Fetched ${customers?.length ?? 0} customers');
    customers?.take(5).forEach((customer) {
      log('• ${customer.name} <${customer.email}>');
    });

    final inboundCallPayload = {
      'callerId': '+15551234567',
      'calleeId': 'api-demo',
      'timestamp': DateTime.now().toUtc().toIso8601String(),
      'notes': 'Demo payload sent from example app',
    };

    final inboundCallResponse = await client.request<Map<String, dynamic>>(
      resource: Resources.inboundCall,
      method: MgrRequestMethod.post,
      body: inboundCallPayload,
      parser: (data) => data as Map<String, dynamic>,
    );
    log('Inbound call response: ${inboundCallResponse ?? 'no content'}');
  } on MgrApiException catch (e, st) {
    log(
      'API error (${e.statusCode}) for ${e.uri}: ${e.message ?? e.body}',
      error: e,
      stackTrace: st,
    );
  } catch (e, st) {
    log('Unexpected error: $e', stackTrace: st);
  }
}