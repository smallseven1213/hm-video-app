// ActorController is a getx controller for the Actor class.

import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/apis/publisher_api.dart';

import '../models/publisher.dart';

final PublisherApi publisherApi = PublisherApi();
final logger = Logger();

class PublisherController extends GetxController {
  var publisher = Publisher.fromJson({}).obs;
  int publisherId;

  PublisherController({required this.publisherId}) {
    _fetchData();
  }

  _fetchData() async {
    var res = await publisherApi.getOne(publisherId);
    publisher.value = res;
  }
}
