import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:petrolchik/firebase/firebase_storages.dart';

class FireAuth {
  final _fireauth = FirebaseAuth.instance;

  Stream<User?> get authStateChanges => _fireauth.authStateChanges();

  Future RegisterWithEmailAndPassword(String _email, String _password, BuildContext cont) async {
    try {
      await _fireauth.createUserWithEmailAndPassword(email: _email, password: _password);
      await _fireauth.currentUser?.sendEmailVerification();
      await FireStorages().userReggister(_email);
      return showDialog(
          context: cont,
          builder: (cont) => AlertDialog(
                backgroundColor: Colors.green,
                title: Text("проверьте почту"),
                content: Text(
                  "Мы отправили на вашу почту письмо для подтверждения почты.После подтверждения зайдите в свой аккаунт",
                  maxLines: 4,
                ),
              ));
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "email-already-in-use":
          {
            return showDialog(
                context: cont,
                builder: (cont) => AlertDialog(
                      backgroundColor: Colors.red,
                      title: Text("Ваш аккаунт уже создан"),
                      content: Text("Ваш аккаунт уже создан"),
                    ));
          }
        case "invalid-email":
          {
            return showDialog(
                context: cont,
                builder: (cont) => AlertDialog(
                      backgroundColor: Colors.red,
                      title: Text("Неверная почта"),
                      content: Text("Вы указали невозможную почту"),
                    ));
          }
        case "too-many-requests":
          {
            return showDialog(
                context: cont,
                builder: (cont) => AlertDialog(
                      backgroundColor: Colors.red,
                      title: Text("Слишком много запросов"),
                      content: Text("Слишком много запросов.Отдохните и вернитесь позже"),
                    ));
          }
        case "network-request-failed":
          {
            return showDialog(
                context: cont,
                builder: (cont) => AlertDialog(
                      backgroundColor: Colors.red,
                      title: Text("Не получилось отправить запрос"),
                      content: Text("Пожалуйста проверьте свое подключение и вернитесь позже"),
                    ));
          }
        default:
          {
            return showDialog(
                context: cont,
                builder: (cont) => AlertDialog(
                      backgroundColor: Colors.red,
                      title: Text("Что то пошло не так."),
                      content: Text("Мы не знаем что случилось, перезапустите приложение и попробуйте опять."),
                    ));
          }
      }
    } catch (e) {}
  }

  //signing out function
  Future SignOutAcc() async {
    try {
      await _fireauth.signOut();
    } catch (e) {
      debugPrint('signing out func gone wrong');
    }
  }

  //Login function
  Future LogInWithEmailANdPassword(String _email, String _password, BuildContext cont) async {
    try {
      await _fireauth.signInWithEmailAndPassword(email: _email, password: _password);
      await _fireauth.currentUser?.reload();
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "invalid-email":
          {
            return showDialog(
                context: cont,
                builder: (cont) => AlertDialog(
                      backgroundColor: Colors.red,
                      title: Text("Неверная почта"),
                      content: Text("Вы указали невозможную почту"),
                    ));
          }
        case "wrong-password":
          {
            return showDialog(
                context: cont,
                builder: (cont) => AlertDialog(
                      backgroundColor: Colors.red,
                      title: Text("Неверный пароль"),
                      content: Text("Вы указали неверный пароль"),
                    ));
          }
        case "user-disabled":
          {
            return showDialog(
                context: cont,
                builder: (cont) => AlertDialog(
                      backgroundColor: Colors.red,
                      title: Text("Ваш аккаунт оключен."),
                      content: Text("Ваш аккаунт был отключен за ваши нарушения."),
                    ));
          }
        case "user-not-found":
          {
            return showDialog(
                context: cont,
                builder: (cont) => AlertDialog(
                      backgroundColor: Colors.red,
                      title: Text("Пользователь не найден"),
                      content: Text("Вы еще не зарегестрировались в нашем приложении"),
                    ));
          }
        case "too-many-requests":
          {
            return showDialog(
                context: cont,
                builder: (cont) => AlertDialog(
                      backgroundColor: Colors.red,
                      title: Text("Слишком много запросов"),
                      content: Text("Слишком много запросов.Отдохните и вернитесь позже"),
                    ));
          }
        case "network-request-failed":
          {
            return showDialog(
                context: cont,
                builder: (cont) => AlertDialog(
                      backgroundColor: Colors.red,
                      title: Text("Не получилось отправить запрос"),
                      content: Text("Пожалуйста проверьте свое подключение и вернитесь позже"),
                    ));
          }
        default:
          {
            return showDialog(
                context: cont,
                builder: (cont) => AlertDialog(
                      backgroundColor: Colors.red,
                      title: Text("Что то пошло не так."),
                      content: Text("Мы не знаем что случилось, перезапустите приложение и попробуйте опять."),
                    ));
          }
      }
    }
  }
}
