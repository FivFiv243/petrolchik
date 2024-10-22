import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petrolchik/firebase/firebase_auth.dart';

part 'app_state.dart';
part 'app_event.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(AppInitial()) {
    //auth events

    on<ToAuthEvent>((event, emit) {
      emit(RegistrationState());
    });
    on<RegistrationEvent>((event, emit) {
      FireAuth().RegisterWithEmailAndPassword(event.email, event.password, event.cont);
      emit(RegistrationState());
    });
    on<LoginEvent>((event, emit) {
      FireAuth().SignOutAcc();
      FireAuth().LogInWithEmailANdPassword(event.email, event.password, event.cont);
      emit(LoginState());
    });
    on<ToForgotPasswordEvent>((event, emit) {
      emit(ForgotPasswordState());
    });
    // on<CheckEvent>((event, emit) {
    //   emit(CheckState());
    // });
    on<ToSettingsEvent>((event, emit) {
      emit(SettingState());
    });
  }
}
