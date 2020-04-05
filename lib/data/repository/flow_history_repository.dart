import 'package:meta/meta.dart';
import 'package:manufacture/data/apis.dart';
import 'package:manufacture/beans/project.dart';
import 'object_repository.dart';
class FlowHistoryObjectRepository extends ObjectRepository<FlowHistory> {
  FlowHistoryObjectRepository(
      {@required String url,
        @required ObjectFromJsonFunc objectFromJsonFunc, @required ObjectToJsonFunc objectToJsonFunc})
      : super(
      url: url,
      objectToJsonFunc: objectToJsonFunc,
      objectFromJsonFunc: objectFromJsonFunc);

  factory FlowHistoryObjectRepository.init() {
    return FlowHistoryObjectRepository(
      url: ImmpApi.getApiPath(ImmpApi.historyPath),
      objectFromJsonFunc: (value) {
        return FlowHistory.fromJson(value);
      },
      objectToJsonFunc: (value) {
        return value.toJson();
      },
    );
  }
}