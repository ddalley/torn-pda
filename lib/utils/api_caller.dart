// Dart imports:
import 'dart:async';
import 'dart:developer';
import 'dart:io';

// Package imports:
import 'package:dio/dio.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Project imports:
import 'package:torn_pda/models/chaining/attack_full_model.dart';
import 'package:torn_pda/models/chaining/attack_model.dart';
import 'package:torn_pda/models/chaining/bars_model.dart';
import 'package:torn_pda/models/chaining/chain_model.dart';
import 'package:torn_pda/models/chaining/ranked_wars_model.dart';
import 'package:torn_pda/models/chaining/target_model.dart';
import 'package:torn_pda/models/education_model.dart';
import 'package:torn_pda/models/faction/faction_crimes_model.dart';
import 'package:torn_pda/models/faction/faction_model.dart';
import 'package:torn_pda/models/friends/friend_model.dart';
import 'package:torn_pda/models/inventory_model.dart';
import 'package:torn_pda/models/items_model.dart';
import 'package:torn_pda/models/market/market_item_model.dart';
import 'package:torn_pda/models/perks/user_perks_model.dart';
import 'package:torn_pda/models/profile/other_profile_model.dart';
import 'package:torn_pda/models/profile/own_profile_basic.dart';
import 'package:torn_pda/models/profile/own_profile_misc.dart';
import 'package:torn_pda/models/profile/own_profile_model.dart';
import 'package:torn_pda/models/profile/own_stats_model.dart';
import 'package:torn_pda/models/property_model.dart';
import 'package:torn_pda/models/stockmarket/stockmarket_model.dart';
import 'package:torn_pda/models/stockmarket/stockmarket_user_model.dart';
import 'package:torn_pda/models/travel/travel_model.dart';
import 'package:torn_pda/providers/user_controller.dart';

import '../main.dart';

/*
enum ApiType {
  user,
  faction,
  torn,
  property,
  market,
}
*/

enum ApiSelection {
  travel,
  ownBasic,
  ownExtended,
  ownPersonalStats,
  ownMisc,
  bazaar,
  otherProfile,
  target,
  attacks,
  attacksFull,
  chainStatus,
  bars,
  items,
  inventory,
  education,
  faction,
  factionCrimes,
  friends,
  property,
  userStocks,
  tornStocks,
  marketItem,
  perks,
  rankedWars,
}

class ApiError {
  int errorId;
  String errorReason = "";
  String errorDetails = "";
  ApiError({int errorId = 0, String details = ""}) {
    switch (errorId) {
      // Torn PDA codes
      case 100:
        errorReason = 'connection timed out';
        break;
      // Torn PDA codes
      case 101:
        errorReason = 'issue with data model';
        errorDetails = details;
        break;
      // Torn codes
      case 0:
        errorReason = 'no connection';
        errorDetails = details;
        break;
      case 1:
        errorReason = 'key is empty';
        break;
      case 2:
        errorReason = 'incorrect Key';
        break;
      case 3:
        errorReason = 'wrong type';
        break;
      case 4:
        errorReason = 'wrong fields';
        break;
      case 5:
        errorReason = 'too many requests per user (max 100 per minute)';
        break;
      case 6:
        errorReason = 'incorrect ID';
        break;
      case 7:
        errorReason = 'incorrect ID-entity relation';
        break;
      case 8:
        errorReason = 'current IP is banned for a small period of time because of abuse';
        break;
      case 9:
        errorReason = 'API disabled (probably under maintenance by Torn\'s developers)!';
        break;
      case 10:
        errorReason = 'key owner is in federal jail';
        break;
      case 11:
        errorReason = 'key change error: You can only change your API key once every 60 seconds';
        break;
      case 12:
        errorReason = 'key read error: Error reading key from Database';
        break;
      case 13:
        errorReason = 'key is temporary disabled due to inactivity (owner hasn\'t been online for more than 7 days).';
        break;
      case 14:
        errorReason = 'daily read limit reached.';
        break;
      case 15:
        errorReason = 'an error code specifically for testing purposes that has no dedicated meaning.';
        break;
      case 16:
        errorReason = 'access level of this key is not high enough: Torn PDA request at least a Limited key.';
        break;
    }
  }
}

class TornApiCaller {
  Future<dynamic> getTravel() async {
    dynamic apiResult;
    await _apiCall(apiSelection: ApiSelection.travel).then((value) {
      apiResult = value;
    });
    if (apiResult is! ApiError) {
      try {
        return TravelModel.fromJson(apiResult);
      } catch (e, trace) {
        FirebaseCrashlytics.instance.recordError(e, trace);
        return ApiError(errorId: 101, details: "$e\n$trace");
      }
    } else {
      return apiResult;
    }
  }

  Future<dynamic> getProfileBasic({String forcedApiKey = ""}) async {
    dynamic apiResult;
    await _apiCall(apiSelection: ApiSelection.ownBasic, forcedApiKey: forcedApiKey).then((value) {
      apiResult = value;
    });
    if (apiResult is! ApiError) {
      try {
        return OwnProfileBasic.fromJson(apiResult);
      } catch (e, trace) {
        FirebaseCrashlytics.instance.recordError(e, trace);
        return ApiError(errorId: 101, details: "$e\n$trace");
      }
    } else {
      return apiResult;
    }
  }

  Future<dynamic> getProfileExtended({@required int limit}) async {
    dynamic apiResult;
    await _apiCall(apiSelection: ApiSelection.ownExtended, limit: limit).then((value) {
      apiResult = value;
    });
    if (apiResult is! ApiError) {
      try {
        return OwnProfileExtended.fromJson(apiResult);
      } catch (e, trace) {
        FirebaseCrashlytics.instance.recordError(e, trace);
        return ApiError(errorId: 101, details: "$e\n$trace");
      }
    } else {
      return apiResult;
    }
  }

  Future<dynamic> getOwnPersonalStats() async {
    dynamic apiResult;
    await _apiCall(apiSelection: ApiSelection.ownPersonalStats).then((value) {
      apiResult = value;
    });
    if (apiResult is! ApiError) {
      try {
        return OwnPersonalStatsModel.fromJson(apiResult);
      } catch (e, trace) {
        FirebaseCrashlytics.instance.recordError(e, trace);
        return ApiError(errorId: 101, details: "$e\n$trace");
      }
    } else {
      return apiResult;
    }
  }

  Future<dynamic> getProfileMisc() async {
    dynamic apiResult;
    await _apiCall(apiSelection: ApiSelection.ownMisc).then((value) {
      apiResult = value;
    });
    if (apiResult is! ApiError) {
      try {
        return OwnProfileMisc.fromJson(apiResult);
      } catch (e, trace) {
        FirebaseCrashlytics.instance.recordError(e, trace);
        return ApiError(errorId: 101, details: "$e\n$trace");
      }
    } else {
      return apiResult;
    }
  }

  Future<dynamic> getOtherProfile({@required String playerId}) async {
    dynamic apiResult;
    await _apiCall(prefix: playerId, apiSelection: ApiSelection.otherProfile).then((value) {
      apiResult = value;
    });
    if (apiResult is! ApiError) {
      try {
        return OtherProfileModel.fromJson(apiResult);
      } catch (e, trace) {
        FirebaseCrashlytics.instance.recordError(e, trace);
        return ApiError(errorId: 101, details: "$e\n$trace");
      }
    } else {
      return apiResult;
    }
  }

  Future<dynamic> getTarget({@required String playerId}) async {
    dynamic apiResult;
    await _apiCall(prefix: playerId, apiSelection: ApiSelection.target).then((value) {
      apiResult = value;
    });
    if (apiResult is! ApiError) {
      try {
        return TargetModel.fromJson(apiResult);
      } catch (e, trace) {
        FirebaseCrashlytics.instance.recordError(e, trace);
        return ApiError(errorId: 101, details: "$e\n$trace");
      }
    } else {
      return apiResult;
    }
  }

  Future<dynamic> getAttacks() async {
    dynamic apiResult;
    await _apiCall(apiSelection: ApiSelection.attacks).then((value) {
      apiResult = value;
    });
    if (apiResult is! ApiError) {
      try {
        return AttackModel.fromJson(apiResult);
      } catch (e, trace) {
        FirebaseCrashlytics.instance.recordError(e, trace);
        return ApiError(errorId: 101, details: "$e\n$trace");
      }
    } else {
      return apiResult;
    }
  }

  Future<dynamic> getAttacksFull() async {
    dynamic apiResult;
    await _apiCall(apiSelection: ApiSelection.attacksFull).then((value) {
      apiResult = value;
    });
    if (apiResult is! ApiError) {
      try {
        return AttackFullModel.fromJson(apiResult);
      } catch (e, trace) {
        FirebaseCrashlytics.instance.recordError(e, trace);
        return ApiError(errorId: 101, details: "$e\n$trace");
      }
    } else {
      return apiResult;
    }
  }

  Future<dynamic> getChainStatus() async {
    dynamic apiResult;
    await _apiCall(apiSelection: ApiSelection.chainStatus).then((value) {
      apiResult = value;
    });
    if (apiResult is! ApiError) {
      try {
        return ChainModel.fromJson(apiResult);
      } catch (e, trace) {
        FirebaseCrashlytics.instance.recordError(e, trace);
        return ApiError(errorId: 101, details: "$e\n$trace");
      }
    } else {
      return apiResult;
    }
  }

  Future<dynamic> getBars() async {
    dynamic apiResult;
    await _apiCall(apiSelection: ApiSelection.bars).then((value) {
      apiResult = value;
    });
    if (apiResult is! ApiError) {
      try {
        return BarsModel.fromJson(apiResult);
      } catch (e, trace) {
        FirebaseCrashlytics.instance.recordError(e, trace);
        return ApiError(errorId: 101, details: "$e\n$trace");
      }
    } else {
      return apiResult;
    }
  }

  Future<dynamic> getItems() async {
    dynamic apiResult;
    await _apiCall(apiSelection: ApiSelection.items).then((value) {
      apiResult = value;
    });
    if (apiResult is! ApiError) {
      try {
        return ItemsModel.fromJson(apiResult);
      } catch (e, trace) {
        FirebaseCrashlytics.instance.recordError(e, trace);
        return ApiError(errorId: 101, details: "$e\n$trace");
      }
    } else {
      return apiResult;
    }
  }

  Future<dynamic> getInventory() async {
    dynamic apiResult;
    await _apiCall(apiSelection: ApiSelection.inventory).then((value) {
      apiResult = value;
    });
    if (apiResult is! ApiError) {
      try {
        return InventoryModel.fromJson(apiResult);
      } catch (e, trace) {
        FirebaseCrashlytics.instance.recordError(e, trace);
        return ApiError(errorId: 101, details: "$e\n$trace");
      }
    } else {
      return apiResult;
    }
  }

  Future<dynamic> getEducation() async {
    dynamic apiResult;
    await _apiCall(apiSelection: ApiSelection.education).then((value) {
      apiResult = value;
    });
    if (apiResult is! ApiError) {
      try {
        return TornEducationModel.fromJson(apiResult);
      } catch (e, trace) {
        FirebaseCrashlytics.instance.recordError(e, trace);
        return ApiError(errorId: 101, details: "$e\n$trace");
      }
    } else {
      return apiResult;
    }
  }

  Future<dynamic> getFaction({@required String factionId}) async {
    dynamic apiResult;
    await _apiCall(prefix: factionId, apiSelection: ApiSelection.faction).then((value) {
      apiResult = value;
    });
    if (apiResult is! ApiError) {
      try {
        return FactionModel.fromJson(apiResult);
      } catch (e, trace) {
        FirebaseCrashlytics.instance.recordError(e, trace);
        return ApiError(errorId: 101, details: "$e\n$trace");
      }
    } else {
      return apiResult;
    }
  }

  Future<dynamic> getFactionCrimes() async {
    dynamic apiResult;
    await _apiCall(apiSelection: ApiSelection.factionCrimes).then((value) {
      apiResult = value;
    });
    if (apiResult is! ApiError) {
      try {
        return FactionCrimesModel.fromJson(apiResult);
      } catch (e, trace) {
        FirebaseCrashlytics.instance.recordError(e, trace);
        return ApiError(errorId: 101, details: "$e\n$trace");
      }
    } else {
      return apiResult;
    }
  }

  Future<dynamic> getFriends({@required String playerId}) async {
    dynamic apiResult;
    await _apiCall(prefix: playerId, apiSelection: ApiSelection.friends).then((value) {
      apiResult = value;
    });
    if (apiResult is! ApiError) {
      try {
        return FriendModel.fromJson(apiResult);
      } catch (e, trace) {
        FirebaseCrashlytics.instance.recordError(e, trace);
        return ApiError(errorId: 101, details: "$e\n$trace");
      }
    } else {
      return apiResult;
    }
  }

  Future<dynamic> getProperty({@required String propertyId}) async {
    dynamic apiResult;
    await _apiCall(prefix: propertyId, apiSelection: ApiSelection.property).then((value) {
      apiResult = value;
    });
    if (apiResult is! ApiError) {
      try {
        return PropertyModel.fromJson(apiResult);
      } catch (e, trace) {
        FirebaseCrashlytics.instance.recordError(e, trace);
        return ApiError(errorId: 101, details: "$e\n$trace");
      }
    } else {
      return apiResult;
    }
  }

  Future<dynamic> getAllStocks() async {
    dynamic apiResult;
    await _apiCall(apiSelection: ApiSelection.tornStocks).then((value) {
      apiResult = value;
    });
    if (apiResult is! ApiError) {
      try {
        return StockMarketModel.fromJson(apiResult);
      } catch (e, trace) {
        FirebaseCrashlytics.instance.recordError(e, trace);
        return ApiError(errorId: 101, details: "$e\n$trace");
      }
    } else {
      return apiResult;
    }
  }

  Future<dynamic> getUserStocks() async {
    dynamic apiResult;
    await _apiCall(apiSelection: ApiSelection.userStocks).then((value) {
      apiResult = value;
    });
    if (apiResult is! ApiError) {
      try {
        return StockMarketUserModel.fromJson(apiResult);
      } catch (e, trace) {
        FirebaseCrashlytics.instance.recordError(e, trace);
        return ApiError(errorId: 101, details: "$e\n$trace");
      }
    } else {
      return apiResult;
    }
  }

  Future<dynamic> getMarketItem({@required String itemId}) async {
    dynamic apiResult;
    await _apiCall(prefix: itemId, apiSelection: ApiSelection.marketItem).then((value) {
      apiResult = value;
    });
    if (apiResult is! ApiError) {
      try {
        return MarketItemModel.fromJson(apiResult);
      } catch (e, trace) {
        FirebaseCrashlytics.instance.recordError(e, trace);
        return ApiError(errorId: 101, details: "$e\n$trace");
      }
    } else {
      return apiResult;
    }
  }

  Future<dynamic> getUserPerks() async {
    dynamic apiResult;
    await _apiCall(apiSelection: ApiSelection.perks).then((value) {
      apiResult = value;
    });
    if (apiResult is! ApiError) {
      try {
        return UserPerksModel.fromJson(apiResult);
      } catch (e, trace) {
        FirebaseCrashlytics.instance.recordError(e, trace);
        return ApiError(errorId: 101, details: "$e\n$trace");
      }
    } else {
      return apiResult;
    }
  }

  Future<dynamic> getRankedWars() async {
    dynamic apiResult;
    await _apiCall(apiSelection: ApiSelection.rankedWars).then((value) {
      apiResult = value;
    });
    if (apiResult is! ApiError) {
      try {
        return RankedWarsModel.fromJson(apiResult);
      } catch (e, trace) {
        FirebaseCrashlytics.instance.recordError(e, trace);
        return ApiError(errorId: 101, details: "$e\n$trace");
      }
    } else {
      return apiResult;
    }
  }

  Future<dynamic> _apiCall({
    @required ApiSelection apiSelection,
    String prefix = "",
    int limit = 100,
    String forcedApiKey = "",
  }) async {
    String apiKey = "";
    if (forcedApiKey != "") {
      apiKey = forcedApiKey;
    } else {
      UserController user = Get.put(UserController());
      apiKey = user.apiKey;
    }

    String url = 'https://api.torn.com:443/';

    switch (apiSelection) {
      case ApiSelection.travel:
        url += 'user/?selections=money,travel';
        break;
      case ApiSelection.ownBasic:
        url += 'user/?selections=profile,battlestats';
        break;
      case ApiSelection.ownExtended:
        url += 'user/?selections=profile,bars,networth,cooldowns,events,travel,icons,money,education,messages';
        break;
      case ApiSelection.ownPersonalStats:
        url += 'user/?selections=personalstats';
        break;
      case ApiSelection.ownMisc:
        url += 'user/?selections=money,education,workstats,battlestats,jobpoints,properties,skills,bazaar';
        break;
      case ApiSelection.bazaar:
        url += 'user/?selections=bazaar';
        break;
      case ApiSelection.otherProfile:
        url += 'user/$prefix?selections=profile,crimes,personalstats';
        break;
      case ApiSelection.target:
        url += 'user/$prefix?selections=profile,discord';
        break;
      case ApiSelection.attacks:
        url += 'user/$prefix?selections=attacks';
        break;
      case ApiSelection.attacksFull:
        url += 'user/$prefix?selections=attacksfull';
        break;
      case ApiSelection.chainStatus:
        url += 'faction/?selections=chain';
        break;
      case ApiSelection.bars:
        url += 'user/?selections=bars';
        break;
      case ApiSelection.items:
        url += 'torn/?selections=items';
        break;
      case ApiSelection.inventory:
        url += 'user/?selections=inventory,display';
        break;
      case ApiSelection.education:
        url += 'torn/?selections=education';
        break;
      case ApiSelection.faction:
        url += 'faction/$prefix?selections=';
        break;
      case ApiSelection.factionCrimes:
        url += 'faction/?selections=crimes';
        break;
      case ApiSelection.friends:
        url += 'user/$prefix?selections=profile,discord';
        break;
      case ApiSelection.property:
        url += 'property/$prefix?selections=property';
        break;
      case ApiSelection.userStocks:
        url += 'user/?selections=stocks';
        break;
      case ApiSelection.tornStocks:
        url += 'torn/?selections=stocks';
        break;
      case ApiSelection.marketItem:
        url += 'market/$prefix?selections=bazaar,itemmarket';
        break;
      case ApiSelection.perks:
        url += 'user/$prefix?selections=perks';
        break;
      case ApiSelection.rankedWars:
        url += 'torn/?selections=rankedwars';
        break;
    }
    url += '&key=$apiKey&comment=PDA-App&limit=$limit';

    try {
      final response = await Dio(
        BaseOptions(
          receiveTimeout: 30000,
        ),
      ).get(url);

      if (response.statusCode == 200) {
        // Check if json is responding with errors
        if (response.data['error'] != null) {
          return ApiError(errorId: response.data['error']['code']);
        }
        // Otherwise, return a good json response
        return response.data;
      } else {
        log("Api code ${response.statusCode}: ${response.data}");
        analytics.logEvent(
          name: 'api_error',
          parameters: {
            'type': 'status',
            'status_code': response.statusCode,
            'response_body': response.data.length > 99 ? response.data.substring(0, 99) : response.data,
          },
        );
        return ApiError(errorId: 0, details: "API STATUS CODE\n[${response.statusCode}: ${response.data}]");
      }
    } on TimeoutException catch (_) {
      return ApiError(errorId: 100);
    } catch (e) {
      log("API CATCH [$e]");
      // Analytics limits at 100 chars
      String platform = Platform.isAndroid ? "a" : "i";
      String versionError = "$appVersion$platform $e";
      analytics.logEvent(
        name: 'api_error',
        parameters: {
          'type': 'exception',
          'error': versionError.length > 99 ? versionError.substring(0, 99) : versionError,
        },
      );
      // We limit to a bit more here (it will be shown to the user)
      String error = e.toString();
      return ApiError(errorId: 0, details: "API CATCH\n[${error.length > 300 ? error.substring(0, 300) : e}]");
    }
  }
}
