class Result<T> {
  final T? data;
  final String? error;
  final bool initial;
  final bool loading;

  Result.success(this.data) : error = null, loading = false, initial = false;

  Result.error(this.error) : data = null, loading = false, initial = false;

  Result.loading()
      : data = null,
        error = null,
        loading = true,
        initial = false;

  Result.initial()
      : data = null,
        error = null,
        loading = false,
        initial = true;
}
