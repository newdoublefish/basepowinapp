class ReqResponse<T>{
  bool isSuccess = false;
  String message;
  T t;
  
  ReqResponse({this.isSuccess=false,this.t,this.message});

  @override
  String toString() {
    return "ReqResponse {isSuccess:$isSuccess,t:$t, message:$message}";
  }
}