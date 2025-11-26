import 'package:dio/dio.dart';
import 'package:mst_chat/core/config/open_ai.config.dart';

abstract class ChatRemoteDataSource {
  Future<String> generateReply(String prompt);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final Dio dio;

  ChatRemoteDataSourceImpl({required this.dio});

  @override
  Future<String> generateReply(String prompt) async {
    final response = await dio.post(
      '/chat/completions',
      data: {
        'model': OpenAIConfig.model,
        'messages': [
          {'role': 'system', 'content': 'You are a helpful helpdesk support agent.'},
          {'role': 'user', 'content': prompt},
        ],
      },
    );

    final data = response.data as Map<String, dynamic>;
    final choices = data['choices'] as List<dynamic>;
    final message = choices.first['message'] as Map<String, dynamic>;
    final content = message['content'] as String? ?? 'No response';

    return content.trim();
  }
}
