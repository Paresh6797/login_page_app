import 'dart:async';

import '../models/banner_content.dart';
import '../repositories/login_repository.dart';

class BannerBloc extends Object {
  // Fetch banner content
  Stream<BannerContent> fetchBannerContent() async* {
    yield* Stream.fromFuture(LoginRepository().fetchContentAPI());
  }
}
