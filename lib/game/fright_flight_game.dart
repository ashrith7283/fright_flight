import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';

import '../core/game_config.dart';
import 'components/background_component.dart';
import 'components/cloud_component.dart';
import 'components/plane_component.dart';
import 'logic/cloud_field.dart';
import 'logic/collision_rules.dart';
import 'logic/lane_picker.dart';
import 'logic/plane_body.dart';
import 'logic/run_controller.dart';

class FrightFlightGame extends FlameGame with TapCallbacks {
  FrightFlightGame({Random? random})
    : super(
        camera: CameraComponent.withFixedResolution(
          width: GameConfig.worldWidth,
          height: GameConfig.worldHeight,
        ),
      ) {
    _field = CloudField(LanePicker(random));
    _run = RunController(onStart: () {}, onFlap: _body.flap, onReset: _reset);
  }

  final PlaneBody _body = PlaneBody();
  late final CloudField _field;
  late final RunController _run;
  final Map<Object, CloudComponent> _cloudComponents = {};

  RunState get runState => _run.state;

  @override
  Future<void> onLoad() async {
    camera.viewfinder.anchor = Anchor.topLeft;
    world.add(BackgroundComponent());
    world.add(PlaneComponent(_body));
  }

  @override
  void onTapDown(TapDownEvent event) => _run.onTap();

  @override
  void update(double dt) {
    final step = min(dt, GameConfig.maxFrameDelta);
    _run.update(step);
    if (_run.state == RunState.playing) {
      _body.step(step);
      for (final spec in _field.step(step)) {
        final c = CloudComponent(spec);
        _cloudComponents[spec] = c;
        world.add(c);
      }
      _cloudComponents.removeWhere((spec, c) {
        final gone = !_field.clouds.contains(spec);
        if (gone) c.removeFromParent();
        return gone;
      });
      if (CollisionRules.hits(_body.y, _field.clouds)) _run.crash();
    }
    super.update(step);
  }

  void _reset() {
    _body.reset();
    _field.reset();
    for (final c in _cloudComponents.values) {
      c.removeFromParent();
    }
    _cloudComponents.clear();
  }
}
