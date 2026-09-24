import 'package:get/get_utils/src/extensions/dynamic_extensions.dart';

import '../../../../main.dart';
import 'model/social_model.dart';

class SocialService {
  static Future<List<SocialPostModel>> getSocialPosts() async {
    try {
      // Dummy API delay
      await Future.delayed(
        const Duration(milliseconds: 500),
      );

      final List<Map<String, dynamic>> responseData = [
        {
          "id": 1,
          "user_name": "Aisha Rahman",
          "user_image":
          "https://i.pravatar.cc/150?img=47",
          "posted_time": "2h ago",
          "description":
          "Great teamwork today!\nAnother successful project milestone completed.",
          "post_image":
          "https://images.unsplash.com/photo-1521737711867-e3b97375f902?auto=format&fit=crop&w=900&q=80",

          "reactions": [
            "👍",
            "❤️",
            "👏"
          ],

          "reaction_count": 12,

          "reaction_users": [
            {
              "id": 1,
              "user_name": "Arjun Nair",
              "user_image":
              "https://i.pravatar.cc/150?img=11",
              "reaction": "👍"
            },
            {
              "id": 2,
              "user_name": "Meera S",
              "user_image":
              "https://i.pravatar.cc/150?img=32",
              "reaction": "❤️"
            },
            {
              "id": 3,
              "user_name": "Rahul K",
              "user_image":
              "https://i.pravatar.cc/150?img=13",
              "reaction": "👏"
            },
            {
              "id": 4,
              "user_name": "Anjali P",
              "user_image":
              "https://i.pravatar.cc/150?img=44",
              "reaction": "👍"
            }
          ]
        }
      ];

      return getSocialPostsFromJson(
        responseData,
      );
    } catch (e) {
      appValidations.printError();
      rethrow;
    }
  }
}