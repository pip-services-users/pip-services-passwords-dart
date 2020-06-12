import 'dart:async';
import '../data/version1/UserPasswordV1.dart';

abstract class IPasswordsPersistence {
  Future<UserPasswordV1> getOneById(String correlationId, String userId);

  Future<UserPasswordV1> create(String correlationId, UserPasswordV1 item);

  Future<UserPasswordV1> update(String correlationId, UserPasswordV1 item);

  Future<UserPasswordV1> deleteById(String correlationId, String id);
}
