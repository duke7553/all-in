import 'package:service_worker/worker.dart';

void main(List<String> args) {
  onInstall.listen((event) {
    print('ServiceWorker installed.');
  });
}
