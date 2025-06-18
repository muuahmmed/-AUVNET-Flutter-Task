import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../../../core/utils/cache/cache_helper.dart';
import 'states.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of<RegisterCubit>(context);

  final SupabaseClient client = Supabase.instance.client;

  Future<void> signup({
    required String email,
    required String password,
    required String name,
    required String confirmPassword,
  }) async {
    emit(RegisterLoadingState());
    try {
      // First check if user exists
      final authResponse = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      // If signIn succeeds, user already exists
      emit(RegisterErrorState('Email already registered'));
    } on AuthException catch (e) {
      // If signIn fails with "Email not confirmed" or "Invalid credentials", proceed with signup
      if (e.message.contains('Invalid login credentials') ||
          e.message.contains('Email not confirmed')) {

        final response = await client.auth.signUp(
          email: email,
          password: password,
          data: {'name': name},
        );

        if (response.user != null) {
          await CacheHelper.saveData(key: 'onBoarding', value: true);
          emit(RegisterSuccessState());
        } else {
          emit(RegisterErrorState('Registration failed'));
        }
      } else {
        emit(RegisterErrorState(e.message));
      }
    } catch (e) {
      emit(RegisterErrorState('An unexpected error occurred'));
    }
  }
}