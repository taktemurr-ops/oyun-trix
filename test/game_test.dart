import 'package:flutter_test/flutter_test.dart';
import 'package:kart_motoru/kart_motoru.dart';
import 'package:oyun_trix/oyun_trix.dart';
import 'package:studio_core/core/level_plan.dart';

void main() {
  test('33 dilde ad ve anlatım', () {
    expect(trixConfig.title.length, 33);
    expect(trixConfig.tagline.length, 33);
    for (final s in trixConfig.tutorial) {
      expect(s.text.length, 33);
    }
  });

  test('beş sözleşme: dördü el alma, biri dizme; hepsi kazanılabilir', () {
    final planner = LevelPlanner(gameId: trixId, optionalMechanics: const []);
    final seen = <int>{};
    for (var lv = 1; lv <= 80 && seen.length < 5; lv++) {
      final gl = trixRules.build(planner.spec(lv * 97));
      expect(gl.validation.ok, isTrue, reason: 'bölüm ${lv * 97}');
      final p = gl.puzzle;
      if (p is TableLevel) {
        seen.add(4);
        expect(TableGameRules.simulate(p).over, isTrue);
      } else {
        final l = p as TrickLevel;
        seen.add((l.rules as TrixRules).contract);
        expect(TrickGameRules.simulate(l).phase, TrickPhase.over);
      }
    }
    expect(seen.length, 5);
    expect(trixRules.localPlayers, 4);
  });
}
