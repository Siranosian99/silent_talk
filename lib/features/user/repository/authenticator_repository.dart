import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:silent_talk/features/user/service/authenticator.dart';

class AuthenticatorRepository {
  final AuthenticatorService _authenticatorService;
  AuthenticatorRepository(this._authenticatorService);

  String getUserId(){
    return _authenticatorService.getUserId();
  }
  Future<void> createUser(
    String name,
    String userName,
    String email,
    String password,
    String image,
  ) async {
    await _authenticatorService.createUser(
      name,
      userName,
      email,
      password,
      image,
    );
  }

  Future<bool?> checkVerify() async {
    return await _authenticatorService.checkVerify();
  }

  Future<void> login(String email, String password, BuildContext ctx) async {
    return await _authenticatorService.login(email, password, ctx);
  }

  Future<void> resetPassword(String email) async {
    await _authenticatorService.resetPassword(email);
  }

  Future<void> signOut(BuildContext context) async {
    await _authenticatorService.signOut(context);
  }

  Future<void> deleteAccount(BuildContext context) async {
    await _authenticatorService.deleteAccount(context);
  }

  void listenForAnotherDeviceLogin(BuildContext context, String deviceId) {
    _authenticatorService.listenForAnotherDeviceLogin(context, deviceId);
  }

  void disposeListener() {
    _authenticatorService.disposeListener();
  }
}
