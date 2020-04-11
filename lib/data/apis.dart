class ImmpApi{
  //static const String baseUrl = "http://192.168.10.107:8000";
  static const String baseUrl = "http://47.107.182.100:9000";
  //static const String baseUrl = "http://172.29.136.2:8000";
  //static const String baseUrl = "http://disk.tcce.pro:9000";
  static const String loginPath = "/api/user/login/";
  static const String projectPath = "/api/flow/project/";
  static const String productPath = "/api/product/";
  static const String errorPath = "/api/fault/query";
  static const String userInfoPath = "/api/user/";
  static const String flowHistoryPath = "/api/flow/instance/";
  static const String flowInstancePath = "/api/flow/instance/";
  static const String flowModalPath = "/api/flow/modal/";
  static const String flowNodePath = "/api/flow/node/";
  static const String techPath = "/api/tech/instance/";
  static const String techCreateInflow = "/api/tech/instance/create_inflow/";
  static const String techModalPath = "/api/tech/modal/";
  static const String flowCommit = "/api/flow/instance/commit/";
  static const String flowConfirm = "/api/flow/instance/confirm/";
  static const String flowBind = "/api/flow/instance/bind/";
  static const String flowSkip = "/api/flow/instance/skip/";
  static const String flowUnBind = "/api/flow/instance/unbind/";
  static const String flowJoin = "/api/flow/instance/join/";
  static const String shipOrder = "/api/ship/instance/";
  static const String shipDetail = "/api/ship/detail/";
  static const String shipOrderGetByProduct = "/api/ship/instance/get_by_product/";
  static const String shipModal = "/api/ship/modal/";
  static const String shipInfo = "/api/ship/info/";
  static const String detailPath = "/api/flow/detail/";
  static const String testPath = "/api/test/";
  static const String versionPath = "/api/version/";
  static const String authorityPath = "/api/authority/";
  static const String recordTypePath = "/api/record/type/";
  static const String organizationPath = "/api/organization/";
  static const String unitPath = "/api/unit/";
  static const String tradePath = "/api/trade/";
  static const String attributePath = "/api/attribute/";
  static const String brandPath = "/api/brand/";
  static const String managerPath = "/api/manager/";
  static const String categoryPath = "/api/category/";
  static const String positionPath = "/api/position/";
  static const String historyPath = "/api/flow/history/";

  static String getApiPath(String path) {
    StringBuffer sb = new StringBuffer(baseUrl);
    sb.write(path);
    return sb.toString();
  }
}