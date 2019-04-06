import 'package:ipl_betting_app/library/dependency_injector.dart';
import 'package:ipl_betting_app/modules/bloc_models/bloc_base_class.dart';
import 'package:ipl_betting_app/modules/bloc_models/bloc_response.dart';
import 'package:ipl_betting_app/modules/models/vm_named_item.dart';
import 'package:ipl_betting_app/repository/team_repository.dart';
import 'package:rxdart/rxdart.dart';

class TeamListBloc extends BlocBaseClass {
  final _pageController = BehaviorSubject<BlocResponse>();
  int selectedBeatId;

  ITeamRepository _teamRepo;
  Subject<BlocResponse> get dataController => _pageController;

  TeamListBloc() {
    _teamRepo = Injector().teamRepository;
  }

  Future loadTeams() async {
    try {
      sendLoaderMessage("Loading Teams!");
      var dbTeams = await _teamRepo.getTeams();
      return _pageController.add(BlocResponse.done(
          data: dbTeams.map((t) => VMNamedItem(t.id, t.name))));
    } on Exception catch (e) {
      sendErrorMessage(e);
    }
  }
}
