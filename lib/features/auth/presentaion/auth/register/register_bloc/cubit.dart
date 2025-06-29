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
      // Check if email already exists in the 'users' table
      final existingUser =
          await client.from('users').select().eq('email', email).maybeSingle();

      if (existingUser != null) {
        emit(RegisterErrorState('Email already registered'));
        return;
      }

      final response = await client.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      );

      if (response.user != null) {
        await CacheHelper.saveData(key: 'onBoarding', value: true);
        await addUserData(id: response.user!.id, name: name, email: email);
        emit(RegisterSuccessState());
      } else {
        emit(RegisterErrorState('Registration failed'));
      }
    } on AuthException catch (e) {
      emit(RegisterErrorState(e.message));
    } catch (e) {
      emit(RegisterErrorState('An unexpected error occurred'));
    }
  }

  Future<void> addUserData({
    required String id,
    required String name,
    required String email,
  }) async {
    emit(UserDataLoadingLoginState('Adding user data...'));

    try {
      // Check if user data already exists
      final alreadyExists =
          await client.from('users').select().eq('id', id).maybeSingle();

      if (alreadyExists != null) {
        emit(UserDataErrorLoginState('User data already exists'));
        return;
      }

      // Insert user data into Supabase
      await client.from('users').insert({
        'id': id,
        'name': name,
        'email': email,
      });

      emit(UserDataAddedLoginState('User data added successfully'));
    } catch (e) {
      emit(UserDataErrorLoginState('Failed to add user data: ${e.toString()}'));
    }
  }
}
