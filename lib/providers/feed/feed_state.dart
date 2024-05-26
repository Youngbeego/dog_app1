import 'package:dog_app/providers/feed/feed_state.dart';

enum FeedStatus {
  init,
  submitting,
  success,
  error,
}

class FeedState{
final FeedStatus feedStatus;

const FeedState({
  required this.feedStatus,
});

factory FeedState.init(){
  return FeedState(
      feedStatus: FeedStatus.init,
  );
}

FeedState copyWith({
    FeedStatus? feedStatus,
  }) {
    return FeedState(
      feedStatus: feedStatus ?? this.feedStatus,
    );
  }
}