import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/utils/api_services/api_sevices.dart';
import 'core/utils/cache/cache_helper.dart';
import 'core/utils/observer/bloc_observer.dart';
import 'features/auth/presentaion/auth/login/login_cubit/cubit.dart';
import 'features/auth/presentaion/auth/login/login_screen/login_screen.dart';
import 'features/auth/presentaion/auth/register/register_bloc/cubit.dart';
import 'features/home/presentaion/home_cubit/home_cubit.dart';
import 'features/home/presentaion/screens/main_home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: ApiServices.baseUrl,
    anonKey: ApiServices.anon,
    authOptions: FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
      autoRefreshToken: true,
    ),
  );

  await CacheHelper.init();

  Widget startWidget;
  try {
    final currentUser = Supabase.instance.client.auth.currentUser;
    final onBoarding = CacheHelper.getData(key: 'onBoarding') ?? false;

    startWidget = (currentUser != null && onBoarding)
        ? const MainHomeScreen()
        : const LoginScreen();
  } catch (e) {
    startWidget = const LoginScreen();
  }

  Bloc.observer = MyBlocObserver();
  runApp(MyApp(startWidget: startWidget));
}

class MyApp extends StatelessWidget {
  final Widget startWidget;
  const MyApp({super.key, required this.startWidget});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => HomeShopCubit()),
        BlocProvider(create: (context) => LoginCubit()),
        BlocProvider(create: (context) => RegisterCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: startWidget,
      ),
    );
  }


}