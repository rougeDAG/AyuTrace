import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../di/injection_container.dart';

// Auth
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';

// Home
import '../../features/home/presentation/cubit/home_cubit.dart';
import '../../features/home/presentation/pages/home_page.dart';

// Product
import '../../features/product/presentation/cubit/product_cubit.dart';
import '../../features/product/presentation/pages/product_tracking_page.dart';
import '../../features/product/presentation/pages/product_info_page.dart';

// Chat
import '../../features/chat/presentation/cubit/chat_cubit.dart';
import '../../features/chat/presentation/pages/chat_page.dart';
import '../../features/chat/domain/usecases/send_message_usecase.dart';
import '../../features/chat/domain/usecases/get_chat_history_usecase.dart';
import '../../features/chat/domain/repositories/chat_repository.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => BlocProvider(
          create: (_) => sl<AuthCubit>()..checkAuthStatus(),
          child: const LoginPage(),
        ),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => BlocProvider(
          create: (_) => sl<AuthCubit>(),
          child: const SignUpPage(),
        ),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => sl<AuthCubit>()),
            BlocProvider(create: (_) => sl<HomeCubit>()),
          ],
          child: const HomePage(),
        ),
      ),
      GoRoute(
        path: '/product/:id',
        builder: (context, state) {
          final productId = state.pathParameters['id']!;
          return BlocProvider(
            create: (_) => sl<ProductCubit>()..loadProduct(productId),
            child: ProductTrackingPage(productId: productId),
          );
        },
        routes: [
          GoRoute(
            path: 'info',
            builder: (context, state) {
              final productId = state.pathParameters['id']!;
              return BlocProvider(
                create: (_) => sl<ProductCubit>()..loadProduct(productId),
                child: ProductInfoPage(productId: productId),
              );
            },
          ),
          GoRoute(
            path: 'chat',
            builder: (context, state) {
              final productId = state.pathParameters['id']!;
              final productName =
                  state.uri.queryParameters['name'] ?? 'Product';
              return BlocProvider(
                create: (_) => ChatCubit(
                  sendMessageUseCase: sl<SendMessageUseCase>(),
                  getChatHistoryUseCase: sl<GetChatHistoryUseCase>(),
                  chatRepository: sl<ChatRepository>(),
                  productId: productId,
                  productContext: _buildProductContext(productId, productName),
                )..loadHistory(),
                child: ChatPage(productId: productId, productName: productName),
              );
            },
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Page not found: ${state.uri}'))),
  );

  static String _buildProductContext(String productId, String productName) {
    return '''
You are an AI assistant for AyuTrace, an Ayurvedic medicine tracking app.
You are helping the user with questions about product: $productName (ID: $productId).
You have access to the product's complete supply chain data including:
- Harvesting & Curing details
- Drying & Grinding process
- Processing & Formulation
- Production & Packaging
- Distribution information
- AYUSH License verification

Answer questions helpfully and accurately about this product's journey,
ingredients, delivery status, health benefits, and AYUSH certification.
''';
  }
}
