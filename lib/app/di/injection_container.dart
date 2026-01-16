import 'package:flutter_tts/flutter_tts.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/services/settings_local_data_source.dart';
import '../../core/services/tts_service.dart';
import '../../features/auth/data/datasources/auth_local_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/get_current_user.dart';
import '../../features/auth/domain/usecases/login.dart';
import '../../features/auth/domain/usecases/logout.dart';
import '../../features/auth/domain/usecases/register.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/settings/presentation/bloc/settings_cubit.dart';
import '../../features/words/data/datasources/words_local_data_source.dart';
import '../../features/words/data/repositories/words_repository_impl.dart';
import '../../features/words/domain/repositories/words_repository.dart';
import '../../features/words/domain/usecases/add_word.dart';
import '../../features/words/domain/usecases/get_saved_word_ids.dart';
import '../../features/words/domain/usecases/get_words.dart';
import '../../features/words/domain/usecases/set_word_saved.dart';
import '../../features/words/presentation/bloc/words_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => prefs);

  // Core
  sl.registerLazySingleton<FlutterTts>(() => FlutterTts());
  sl.registerLazySingleton<TtsService>(() => TtsService(sl()));
  sl.registerLazySingleton<SettingsLocalDataSource>(
    () => SettingsLocalDataSourceImpl(sl()),
  );

  // Data sources
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<WordsLocalDataSource>(
    () => WordsLocalDataSourceImpl(sl()),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton<WordsRepository>(() => WordsRepositoryImpl(sl()));

  // Auth use cases
  sl.registerLazySingleton(() => GetCurrentUser(sl()));
  sl.registerLazySingleton(() => Login(sl()));
  sl.registerLazySingleton(() => Register(sl()));
  sl.registerLazySingleton(() => Logout(sl()));

  // Words use cases
  sl.registerLazySingleton(() => GetWords(sl()));
  sl.registerLazySingleton(() => GetSavedWordIds(sl()));
  sl.registerLazySingleton(() => SetWordSaved(sl()));
  sl.registerLazySingleton(() => AddWord(sl()));

  // Blocs (factories)
  sl.registerFactory(
    () => AuthBloc(
      getCurrentUser: sl(),
      login: sl(),
      register: sl(),
      logout: sl(),
    ),
  );
  sl.registerFactory(
    () => WordsBloc(
      getWords: sl(),
      getSavedWordIds: sl(),
      setWordSaved: sl(),
      addWord: sl(),
      tts: sl(),
      settingsLocal: sl(),
    ),
  );
  sl.registerFactory(() => SettingsCubit(local: sl()));
}
