import 'dart:async';

import 'package:pip_clients_activities/pip_clients_activities.dart';
import 'package:pip_services3_components/pip_services3_components.dart';
import 'package:pip_services_activities/pip_services_activities.dart';
import '../data/version1/PasswordActivityTypeV1.dart';

class ActivitiesConnector {
  ActivitiesConnector(ILogger logger, IActivitiesClientV1 activitiesClient) {
    if (activitiesClient == null) {
      logger.warn(null,
          'Activities client was not found. Logging password activities is disabled');
    }
    _activitiesClient = activitiesClient;
    _logger = logger;
  }

  IActivitiesClientV1 _activitiesClient;
  Logger _logger;

  Future<void> _logActivity(
      String correlationId, String userId, String activityType) async {
    if (_activitiesClient == null) return;

    var party = ReferenceV1(id: userId, type: 'account', name: null);
    var activity = PartyActivityV1(id: null, type: activityType, party: party);

    try {
      await _activitiesClient.logPartyActivity(correlationId, activity);
    } on Exception catch (ex) {
      _logger.error(correlationId, ex, 'Failed to log user activity');
    }
  }

  void logSigninActivity(String correlationId, String userId) {
    _logActivity(correlationId, userId, PasswordActivityTypeV1.Signin);
  }

  void logPasswordRecoveredActivity(String correlationId, String userId) {
    _logActivity(
        correlationId, userId, PasswordActivityTypeV1.PasswordRecovered);
  }

  void logPasswordChangedActivity(String correlationId, String userId) {
    _logActivity(correlationId, userId, PasswordActivityTypeV1.PasswordChanged);
  }
}
