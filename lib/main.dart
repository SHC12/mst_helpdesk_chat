import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mst_chat/core/config/open_ai.config.dart';
import 'package:mst_chat/features/chat/data/datasources/chat_local_data_source.dart';
import 'package:mst_chat/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:mst_chat/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:mst_chat/features/chat/domain/repositories/chat_repository.dart';
import 'package:mst_chat/features/chat/domain/usecases/get_contacts.dart';
import 'package:mst_chat/features/chat/domain/usecases/get_messages.dart';
import 'package:mst_chat/features/chat/domain/usecases/send_message.dart';
import 'package:mst_chat/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:mst_chat/features/chat/presentation/pages/chat.page.dart';
import 'package:device_preview/device_preview.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  final contactsBox = await Hive.openBox<Map>('contacts_box');
  final messagesBox = await Hive.openBox<Map>('messages_box');

  final dio = Dio(
    BaseOptions(
      baseUrl: OpenAIConfig.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer ${OpenAIConfig.apiKey}'},
    ),
  );

  final localDS = ChatLocalDataSourceImpl(contactsBox: contactsBox, messagesBox: messagesBox);
  final remoteDS = ChatRemoteDataSourceImpl(dio: dio);

  ChatRepository chatRepository = ChatRepositoryImpl(localDataSource: localDS, remoteDataSource: remoteDS);

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) {
        return MyApp(chatRepository: chatRepository);
      },
    ),
  );
}

class MyApp extends StatelessWidget {
  final ChatRepository chatRepository;
  const MyApp({super.key, required this.chatRepository});
  @override
  Widget build(BuildContext context) {
    final getContacts = GetContacts(chatRepository);
    final getMessages = GetMessages(chatRepository);
    final sendMessage = SendMessage(chatRepository);

    return BlocProvider(
      create: (_) {
        final cubit = ChatCubit(
          getContactsUseCase: getContacts,
          getMessagesUseCase: getMessages,
          sendMessageUseCase: sendMessage,
        );
        cubit.loadInitial();
        return cubit;
      },
      child: MaterialApp(
        title: 'Helpdesk Chat',
        debugShowCheckedModeBanner: false,
        useInheritedMediaQuery: true,
        builder: DevicePreview.appBuilder,
        locale: DevicePreview.locale(context),
        theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue), useMaterial3: true),
        home: const ChatPage(),
      ),
    );
  }
}
