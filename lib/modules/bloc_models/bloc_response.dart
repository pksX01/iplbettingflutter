class BlocResponse<T> {
  BlocResponseStatus status;
  T data;
  String loaderMessage;
  String pageFlag;

  BlocResponse.loading([this.data]) : status = BlocResponseStatus.loading;
  BlocResponse.done({this.data, this.pageFlag}) : status = BlocResponseStatus.completed;
  BlocResponse.error({this.data, this.pageFlag}) : status = BlocResponseStatus.error;
  @override
  String toString() => data.toString();
}

enum BlocResponseStatus { loading, completed, error }
