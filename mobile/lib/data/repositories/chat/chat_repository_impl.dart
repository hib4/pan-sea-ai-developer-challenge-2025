import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:kanca/core/core.dart';
import 'package:kanca/data/data.dart';
import 'package:kanca/utils/utils.dart';

class ChatRepositoryImpl implements ChatRepository {
  ChatRepositoryImpl({required this.dioClient});

  final DioClient dioClient;

  @override
  Stream<ChatChunkModel?> chatStream({required String prompt}) async* {
    try {
      logger.d('Starting chat stream with prompt: $prompt');

      final response = await dioClient.post<ResponseBody>(
        '/chat/stream',
        data: {
          'message': prompt,
          'child_age': 12,
          'language': 'english',
        },
        options: Options(
          responseType: ResponseType.stream,
          headers: {
            'Accept': 'text/event-stream',
            'Cache-Control': 'no-cache',
            'Authorization': 'Bearer ${Env.bearerToken}',
          },
        ),
      );

      logger.d('Response status: ${response.statusCode}');
      logger.d('Response headers: ${response.headers}');

      if (response.data != null) {
        logger.d('Response data is not null, starting stream parsing');
        await for (final chunk in _parseSSEStream(response.data!.stream)) {
          if (chunk != null) {
            logger.d('Yielding chunk: ${chunk.type} - ${chunk.content}');
            yield chunk;
          }
        }
      } else {
        logger.e('Response data is null');
        yield const ChatChunkModel(
          type: 'error',
          content: 'No response data received',
        );
      }
    } catch (e) {
      logger.e('Error in chat stream: $e');
      // Handle errors by yielding an error chunk
      yield const ChatChunkModel(
        type: 'error',
        content: 'An error occurred while streaming',
      );
    }
  }

  Stream<ChatChunkModel?> _parseSSEStream(Stream<Uint8List> stream) async* {
    final streamTransformer = StreamTransformer<Uint8List, String>.fromHandlers(
      handleData: (data, sink) {
        sink.add(utf8.decode(data));
      },
    );

    await for (final chunk in stream.transform(streamTransformer)) {
      logger.d('Raw chunk received: $chunk');

      // Split by newlines to process each line
      final lines = chunk.split('\n');

      for (final line in lines) {
        final trimmedLine = line.trim();
        logger.d('Processing line: $trimmedLine');

        // Skip empty lines and comments
        if (trimmedLine.isEmpty || trimmedLine.startsWith(':')) {
          continue;
        }

        // Parse SSE data lines
        if (trimmedLine.startsWith('data: ')) {
          final jsonData = trimmedLine.substring(6); // Remove "data: " prefix
          logger.d('JSON data: $jsonData');

          // Skip if data is "[DONE]" or empty
          if (jsonData == '[DONE]' || jsonData.isEmpty) {
            logger.d('Skipping [DONE] or empty data');
            continue;
          }

          try {
            final dynamic decodedJson = json.decode(jsonData);
            logger.d('Decoded JSON: $decodedJson');

            if (decodedJson is Map<String, dynamic>) {
              final chatChunk = ChatChunkModel.fromJson(decodedJson);
              logger.d(
                'Created ChatChunk: ${chatChunk.type} - ${chatChunk.content}',
              );
              yield chatChunk;

              // Stop streaming when we receive a complete type
              if (chatChunk.type == 'complete') {
                logger.d('Streaming complete');
                return;
              }
            }
          } catch (e) {
            logger.e('Error parsing JSON: $e');
            // Skip malformed JSON chunks
            continue;
          }
        }
      }
    }
  }
}
