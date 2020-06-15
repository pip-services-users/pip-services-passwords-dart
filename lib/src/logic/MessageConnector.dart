import 'dart:async';

//import 'package:pip_clients_msgdistribution/pip_clients_msgdistribution.dart';
import 'package:pip_services3_commons/pip_services3_commons.dart';
import 'package:pip_services3_components/pip_services3_components.dart';
//import 'package:pip_services_msgdistribution/pip_services_msgdistribution.dart';

class MessageConnector {
  // MessageConnector(ILogger logger, MessageResolverV1 messageResolver, IMessageDistributionClientV1 messageDistributionClient) {
  //   if (messageDistributionClient == null) {
  //     logger.warn(null,
  //         'MessageDistribution client was not found. Password notifications are disabled');
  //   }
  //   _messageDistributionClient = messageDistributionClient;
  //   _messageResolver = messageResolver;
  //   _logger = logger;
  // }

  // IMessageDistributionClientV1 _messageDistributionClient;
  // MessageResolverV1 _messageResolver
  // Logger _logger;

  // Future<void> _sendMessage(
  //     String correlationId, String userId, MessageV1 message, ConfigParams parameters) async {
  //   if (_messageDistributionClient == null) return;
  //   if (message == null) return;

  //   try {
  //     await _messageDistributionClient.sendMessageToRecipient(
  //           correlationId, userId, null, message, parameters, DeliveryMethodV1.All);
  //   } on Exception catch (ex) {
  //     _logger.error(correlationId, ex, 'Failed to send message');
  //   }
  // }

  // void sendAccountLockedEmail(String correlationId, String userId) {
  //   var message = _messageResolver.resolve('account_locked');
  //   _sendMessage(correlationId, userId, message, null);
  // }

  // void sendPasswordChangedEmail(String correlationId, String userId) {
  //   var message = _messageResolver.resolve('password_changed');
  //   _sendMessage(correlationId, userId, message, null);
  // }

  // void sendRecoverPasswordEmail(String correlationId, String userId, String code) {
  //   var message = _messageResolver.resolve('recover_password');
  //   var parameters = ConfigParams.fromTuples(['code', code]);
  //   _sendMessage(correlationId, userId, message, parameters);
  // }
}
