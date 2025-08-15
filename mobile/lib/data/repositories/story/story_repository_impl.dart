import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:kanca/core/core.dart';
import 'package:kanca/data/data.dart';
import 'package:kanca/utils/utils.dart';

class StoryRepositoryImpl implements StoryRepository {
  StoryRepositoryImpl({
    required DioClient client,
  }) : _client = client;

  final DioClient _client;

  @override
  Future<StoryModel> createStory(String query) async {
    try {
      final response = await _client.post(
        '/book',
        data: {
          'query': query,
          'age': 12,
          'voice_name_code': 'en-US-JennyMultilingualNeural',
          'language': 'english',
        },
        options: Options(
          headers: {
            'Authorization':
                'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY4OWYxYjY2YzU5OTlmYzQwMWY5MzA3NiIsIm5hbWUiOiJqdWFuIiwiZW1haWwiOiJqQGdtYWlsLmNvbSIsImF1dGgiOiJsb2NhbCIsImdvb2dsZV9pZCI6bnVsbCwiZXhwIjoxNzU1MzA2ODM4fQ.S1sxQkbHXKqjVOjOOuSmEd96EpYMugGDCPe6g15Yj_g',
          },
        ),
      );

      final raw = response.data;

      final data = raw is String
          ? jsonDecode(raw) as Map<String, dynamic>
          : raw as Map<String, dynamic>;

      final id = data['data']['id'] as String;

      final story = await getStoryById(id);

      return story;
    } on DioException catch (e) {
      // Handle Dio exceptions, e.g., log the error or rethrow
      logger.e('Failed to create story: ${e.message}');
      throw Exception('Failed to create story: ${e.message}');
    } catch (e) {
      // Handle exceptions, e.g., log the error or rethrow
      logger.e('Failed to create story: $e');
      throw Exception('Failed to create story: $e');
    }
  }

  @override
  Future<StoryModel> getStoryById(String id) async {
    try {
      final response = await _client.get(
        '/book/$id',
        options: Options(
          headers: {
            'Authorization':
                'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY4OWYxYjY2YzU5OTlmYzQwMWY5MzA3NiIsIm5hbWUiOiJqdWFuIiwiZW1haWwiOiJqQGdtYWlsLmNvbSIsImF1dGgiOiJsb2NhbCIsImdvb2dsZV9pZCI6bnVsbCwiZXhwIjoxNzU1MzA2ODM4fQ.S1sxQkbHXKqjVOjOOuSmEd96EpYMugGDCPe6g15Yj_g',
          },
        ),
      );

      final raw = response.data;
      final data = raw is String
          ? jsonDecode(raw) as Map<String, dynamic>
          : raw as Map<String, dynamic>;

      // Extract the nested data from the response
      final storyData = data['data'] as Map<String, dynamic>;

      return StoryModel.fromJson(storyData);
    } on DioException catch (e) {
      // Handle Dio exceptions, e.g., log the error or rethrow
      logger.e('Failed to get story: ${e.message}');
      throw Exception('Failed to get story: ${e.message}');
    } catch (e) {
      // Handle exceptions, e.g., log the error or rethrow
      logger.e('Failed to get story: $e');
      throw Exception('Failed to get story: $e');
    }
  }
}
