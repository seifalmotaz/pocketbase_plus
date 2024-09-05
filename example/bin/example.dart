import 'package:example/models/matches.dart';
import 'package:pocketbase/pocketbase.dart';

Future<void> main(List<String> arguments) async {
  final pb = PocketBase('http://exmaple.com');

  final data = await pb.collection('match_requests').getFullList();

  final matches = data.map((e) => MatchesModel.fromModel(e));
  print(matches.first.id);
  print(matches.first.created);
}
