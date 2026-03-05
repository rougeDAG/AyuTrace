import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Auth
import '../../features/auth/data/datasources/firebase_auth_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/signup_usecase.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';

// Home
import '../../features/home/data/datasources/firestore_home_datasource.dart';
import '../../features/home/data/repositories/home_repository_impl.dart';
import '../../features/home/domain/repositories/home_repository.dart';
import '../../features/home/domain/usecases/get_products_usecase.dart';
import '../../features/home/domain/usecases/search_products_usecase.dart';
import '../../features/home/presentation/cubit/home_cubit.dart';

// Product
import '../../features/product/data/datasources/firestore_product_datasource.dart';
import '../../features/product/data/repositories/product_repository_impl.dart';
import '../../features/product/domain/repositories/product_repository.dart';
import '../../features/product/domain/usecases/get_product_usecase.dart';
import '../../features/product/presentation/cubit/product_cubit.dart';

// Chat
import '../../features/chat/data/datasources/ai_model_datasource.dart';
import '../../features/chat/data/datasources/firestore_chat_datasource.dart';
import '../../features/chat/data/repositories/chat_repository_impl.dart';
import '../../features/chat/domain/repositories/chat_repository.dart';
import '../../features/chat/domain/usecases/send_message_usecase.dart';
import '../../features/chat/domain/usecases/get_chat_history_usecase.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // ──── External ────
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  // ──── Auth ────
  sl.registerLazySingleton<FirebaseAuthDatasource>(
    () => FirebaseAuthDatasource(firebaseAuth: sl()),
  );
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerFactory(
    () => AuthCubit(
      loginUseCase: sl(),
      signUpUseCase: sl(),
      authRepository: sl(),
    ),
  );

  // ──── Home ────
  sl.registerLazySingleton<FirestoreHomeDatasource>(
    () => FirestoreHomeDatasource(firestore: sl()),
  );
  sl.registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetProductsUseCase(sl()));
  sl.registerLazySingleton(() => SearchProductsUseCase(sl()));
  sl.registerFactory(
    () => HomeCubit(getProductsUseCase: sl(), searchProductsUseCase: sl()),
  );

  // ──── Product ────
  sl.registerLazySingleton<FirestoreProductDatasource>(
    () => FirestoreProductDatasource(firestore: sl()),
  );
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetProductUseCase(sl()));
  sl.registerFactory(() => ProductCubit(getProductUseCase: sl()));

  // ──── Chat ────
  // Replace MockAiModelDatasource with your local model implementation
  sl.registerLazySingleton<AiModelDatasource>(() => MockAiModelDatasource());
  sl.registerLazySingleton<FirestoreChatDatasource>(
    () => FirestoreChatDatasource(firestore: sl()),
  );
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(
      aiDatasource: sl(),
      chatDatasource: sl(),
      auth: sl(),
    ),
  );
  sl.registerLazySingleton(() => SendMessageUseCase(sl()));
  sl.registerLazySingleton(() => GetChatHistoryUseCase(sl()));
}
