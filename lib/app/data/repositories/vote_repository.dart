// lib/app/data/repositories/vote_repository.dart
import 'package:get/get.dart';
import '../providers/api_provider.dart';
import '../models/vote.dart';
import '../../utils/constants.dart';

class VoteRepository {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  Future<bool> createVote(List<String> courseIds) async {
    try {
      final response = await _apiProvider.post(
        ApiConstants.createVote,
        data: {
          'courseIds': courseIds,
        },
      );
      print(response.data);
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Create vote error: $e');
      return false;
    }
  }

  Future<List<Vote>> getMyVotes() async {
    try {
      final response = await _apiProvider.get(ApiConstants.myVotes);

      if (response.statusCode == 200) {
        final List<dynamic> votesData = response.data;
        return votesData.map((data) => Vote.fromJson(data)).toList();
      }
      return [];
    } catch (e) {
      print('Get my votes error: $e');
      return [];
    }
  }

  Future<Vote?> getVoteById(String id) async {
    try {
      final response = await _apiProvider.get('${ApiConstants.vote}/find-by-id/$id');

      if (response.statusCode == 200) {
        return Vote.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print('Get vote by ID error: $e');
      return null;
    }
  }

  Future<bool> updateVote(String id, List<String> courseIds) async {
    try {
      final response = await _apiProvider.patch(
        '${ApiConstants.updateVote}/$id',
        data: {
          'courseIds': courseIds,
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Update vote error: $e');
      return false;
    }
  }

  Future<bool> deleteVote(String id) async {
    try {
      final response = await _apiProvider.delete('${ApiConstants.vote}/delete/$id');
      return response.statusCode == 200;
    } catch (e) {
      print('Delete vote error: $e');
      return false;
    }
  }
}