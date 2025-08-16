sealed class Result<T> {
  const Result();

  /// Creates a successful [Result], completed with the specified [value].
  const factory Result.success(T value, bool more) = Success<T>._;

  /// Creates an error [Result], completed with the specified [error].
  const factory Result.failure(Exception error) = Failure<T>._;

  /// Converts the result to another type.
  R map<R>({
    required R Function(T value, bool more) onSuccess,
    required R Function(Exception error) onFailure,
  }) => switch (this) {
    Success(:final value, :final more) => onSuccess(value, more),
    Failure(:final error) => onFailure(error),
  };

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;

  /// Returns the value if the result is successful, otherwise returns null.
  T? get valueOrNull => switch (this) {
    Success(:final value) => value,
    Failure() => null,
  };

  /// Returns the error if the result is unsuccessful, otherwise returns null.
  Exception? get errorOrNull => switch (this) {
    Success() => null,
    Failure(:final error) => error,
  };
}

/// Subclass of Result for values
final class Success<T> extends Result<T> {
  const Success._(this.value, this.more);

  /// Returned value in result
  final T value;
  final bool more;

  @override
  String toString() => '$value';
}

/// Subclass of Result for errors
final class Failure<T> extends Result<T> {
  const Failure._(this.error);

  /// Returned error in result
  final Exception error;

  @override
  String toString() => 'Error: $error';
}
