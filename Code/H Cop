extends Node3D

# ---------------- PLAYER + NPC HELICOPTER ----------------
# Put this script on the helicopter Node3D.
# Works with the player's helicopter handoff code and the updated EnemyManager strategy code.
# - Player can enter with E and fly normally.
# - BattleNPC units can be assigned by EnemyManager and fly it as a strategy.
# - Uses your AudioStreamPlayer child named HelicopterSound, HcopSound, or RotorSound.
# - Sound plays only while someone is inside the helicopter.
# - No generated rotor blades.

const PLAYER_GROUP: String = "Player"
const NPC_GROUP: String = "BattleNPC"
const HELICOPTER_GROUP: String = "Helicopter"

const MIN_BOUND: float = -490.0
const MAX_BOUND: float = 490.0

const INTERACT_DISTANCE: float = 10.0
const EXIT_SIDE_DISTANCE: float = 4.0
const EXIT_FORWARD_DISTANCE: float = 2.5

# Camera / player aim.
const MOUSE_SENSITIVITY: float = 0.055
const CAMERA_FRONT_DISTANCE: float = 7.0
const CAMERA_HEIGHT: float = 3.2
const CAMERA_SMOOTH_SPEED: float = 10.0
const CAMERA_YAW_OFFSET_DEGREES: float = 180.0
# Visual-only fix: player and CPU pilots need different visual yaw offsets.
# This changes only how the helicopter model looks; it does not change camera or controls.
const PLAYER_MODEL_YAW_OFFSET_DEGREES: float = 90.0
const NPC_MODEL_YAW_OFFSET_DEGREES: float = -90.0
const AIM_PITCH_MIN: float = -65.0
const AIM_PITCH_MAX: float = 40.0

# These match your last requested setup.
const INVERT_MOUSE_X: bool = false
const INVERT_MOUSE_Y: bool = false
const INVERT_FORWARD_BACK: bool = true
const INVERT_STRAFE: bool = false

# Player flight movement. Kept slow and playable.
const MAX_FORWARD_SPEED: float = 12.0
const MAX_BACK_SPEED: float = 6.0
const MAX_STRAFE_SPEED: float = 7.0
const ACCELERATION: float = 18.0
const BRAKE_ACCELERATION: float = 30.0
const CLIMB_SPEED: float = 4.5
const DESCEND_SPEED: float = 4.2
const VERTICAL_ACCELERATION: float = 12.0
const VERTICAL_BRAKE: float = 14.0

# NPC helicopter behavior.
const NPC_HELI_FORWARD_SPEED: float = 10.0
const NPC_HELI_ACCELERATION: float = 10.0
const NPC_HELI_BRAKE: float = 18.0
const NPC_HELI_ALTITUDE_ABOVE_GROUND: float = 34.0
const NPC_HELI_MAX_TARGET_DISTANCE: float = 180.0
const NPC_HELI_STANDOFF_DISTANCE: float = 120.0
const NPC_HELI_TARGET_REFRESH_TIME: float = 0.8
const NPC_HELI_FIRE_TIME_MIN: float = 0.35
const NPC_HELI_FIRE_TIME_MAX: float = 0.85
const NPC_HELI_TOO_CLOSE_DISTANCE: float = 65.0
const NPC_HELI_IDEAL_DISTANCE: float = 155.0
const NPC_HELI_CIRCLE_SPEED: float = 7.0
const NPC_HELI_BOUNDARY_BUFFER: float = 75.0
const NPC_HELI_AIM_LEAD_TIME: float = 0.05
const NPC_HELI_SHOOT_CONE_DEGREES: float = 9.0

const MIN_Y_ABOVE_GROUND: float = 3.0
const MAX_Y: float = 180.0

# Auto-land.
const AUTO_LAND_DESCEND_SPEED: float = 5.5
const AUTO_LAND_BRAKE: float = 50.0
const LANDED_EXIT_HEIGHT: float = 4.2
const LANDING_EXIT_SPEED: float = 6.0

# Visual body follow.
const BODY_YAW_FOLLOW_SPEED: float = 2.5
const MAX_VISUAL_PITCH_LEAN: float = 2.0
const MAX_VISUAL_ROLL_LEAN: float = 2.0
const LEAN_SPEED: float = 4.0

# Laser tag shooting.
const BLUE_HELI_LASER_COLOR: Color = Color(0.05, 1.0, 0.20, 1.0)
const RED_HELI_LASER_COLOR: Color = Color(1.0, 0.05, 0.03, 1.0)
const HELI_LASER_LIFETIME: float = 0.10
const HELI_LASER_WIDTH: float = 0.10
const HELI_SHOOT_RANGE: float = 220.0
const HELI_FIRE_COOLDOWN: float = 0.13
const HELI_BODY_DAMAGE: int = 1
const HELI_HEADSHOT_DAMAGE: int = 999
const HELI_PLAYER_DAMAGE: int = 4

# Fairness against the player.
# Red CPU helicopters can miss. Misses still draw laser beams, but they go off target.
const NPC_HELI_CHANCE_TO_HIT_PLAYER: float = 0.40
const NPC_HELI_AIM_MISS_RADIUS: float = 18.0

# Helicopter sound.
const ROTOR_SOUND_VOLUME_DB: float = 8.0
const ROTOR_SOUND_MAX_DISTANCE: float = 220.0

# Player gets first chance before NPCs can take it.
const PLAYER_PRIORITY_SECONDS: float = 7.0

# Fuel: one tank per match. When empty, helicopter auto-lands and becomes useless.
const MAX_FUEL_TIME: float = 180.0

# Helicopter damage. When this hits zero, the helicopter is destroyed and the pilot is knocked out.
const HELI_MAX_HEALTH: int = 30
# New rule: helicopters do not take damage. They can still run out of fuel.
const HELICOPTER_INVINCIBLE: bool = true
const HELI_DAMAGE_FLASH_TIME: float = 0.35

# Enemy helicopter health marker shown above red CPU helicopters.
# Set false so the enemy helicopter Label3D cannot create giant screen-blocking white bars.
const SHOW_ENEMY_HELICOPTER_HEALTH_BAR: bool = false
const ENEMY_HEALTH_BAR_HEIGHT: float = 4.5
const ENEMY_HEALTH_BAR_FONT_SIZE: int = 18
const INVERT_NPC_FORWARD: bool = true

var pilot: CharacterBody3D = null
var is_piloted: bool = false
var pilot_is_player: bool = false
var pilot_team: String = ""
var player_near: bool = false
var auto_landing: bool = false

var horizontal_velocity: Vector3 = Vector3.ZERO
var vertical_speed: float = 0.0

var aim_yaw_degrees: float = 0.0
var aim_pitch_degrees: float = -8.0
var fire_timer: float = 0.0
var npc_fire_timer: float = 0.0
var npc_target_refresh_timer: float = 0.0
var npc_target: Variant = null
var e_was_down: bool = false
var time_since_ready: float = 0.0
var fuel_remaining: float = MAX_FUEL_TIME
var upgraded_max_fuel_time: float = MAX_FUEL_TIME
var hcop_fuel_upgrade_level: int = 0
var fuel_empty_permanent: bool = false
var helicopter_health: int = HELI_MAX_HEALTH
var destroyed_permanent: bool = false
# Becomes true when the player lands/exits with fuel left, so the nearest CPU can claim it.
var player_abandoned_with_fuel: bool = false
var damage_flash_timer: float = 0.0

var prompt_layer: CanvasLayer = null
var prompt_label: Label = null
var crosshair_label: Label = null
var fuel_label: Label = null
var fuel_bar_back: ColorRect = null
var fuel_bar_fill: ColorRect = null
var heli_health_label: Label = null
var heli_health_bar_back: ColorRect = null
var heli_health_bar_fill: ColorRect = null
var rotor_audio: Node = null
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var enemy_health_marker: Label3D = null
var match_start_transform: Transform3D = Transform3D.IDENTITY
var match_start_rotation_degrees: Vector3 = Vector3.ZERO
var smoothed_camera_position: Vector3 = Vector3.ZERO
var camera_smoothing_ready: bool = false
var helicopter_ui_update_timer: float = 0.0
const HELICOPTER_UI_UPDATE_INTERVAL: float = 0.10


func _ready() -> void:
	rng.randomize()
	match_start_transform = global_transform
	match_start_rotation_degrees = rotation_degrees
	add_to_group(HELICOPTER_GROUP)
	setup_prompt()
	setup_rotor_audio()
	setup_enemy_health_marker()
	aim_yaw_degrees = rotation_degrees.y
	print("PLAYER + NPC HELICOPTER READY")


func _process(delta: float) -> void:
	time_since_ready += delta
	update_player_near()
	update_prompt_throttled(delta)
	update_rotor_audio()
	update_enemy_health_marker()

	if fire_timer > 0.0:
		fire_timer -= delta

	if damage_flash_timer > 0.0:
		damage_flash_timer = max(damage_flash_timer - delta, 0.0)
	if npc_fire_timer > 0.0:
		npc_fire_timer -= delta

	var e_down: bool = Input.is_physical_key_pressed(KEY_E)

	if is_piloted:
		update_fuel(delta)
		if pilot_is_player:
			if e_down and not e_was_down and not auto_landing:
				start_auto_land()
			update_player_flight(delta)
			update_player_camera_pose()
			if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
				shoot_player_helicopter_laser()
		else:
			update_npc_flight(delta)
	else:
		if player_near and e_down and not e_was_down:
			enter_helicopter()

	e_was_down = e_down


func _input(event: InputEvent) -> void:
	if not is_piloted or not pilot_is_player:
		return

	if event is InputEventMouseMotion:
		var mouse_event: InputEventMouseMotion = event as InputEventMouseMotion
		var x_sign: float = -1.0 if INVERT_MOUSE_X else 1.0
		var y_sign: float = -1.0 if INVERT_MOUSE_Y else 1.0
		aim_yaw_degrees -= mouse_event.relative.x * MOUSE_SENSITIVITY * x_sign
		aim_pitch_degrees -= mouse_event.relative.y * MOUSE_SENSITIVITY * y_sign
		aim_pitch_degrees = clamp(aim_pitch_degrees, AIM_PITCH_MIN, AIM_PITCH_MAX)

	if event is InputEventMouseButton:
		var mouse_button: InputEventMouseButton = event as InputEventMouseButton
		if mouse_button.pressed and mouse_button.button_index == MOUSE_BUTTON_LEFT:
			shoot_player_helicopter_laser()


# ---------------- ENEMY HELICOPTER WORLD HEALTH BAR ----------------
func setup_enemy_health_marker() -> void:
	enemy_health_marker = Label3D.new()
	enemy_health_marker.name = "EnemyHelicopterHealthMarker"
	enemy_health_marker.position = Vector3(0.0, ENEMY_HEALTH_BAR_HEIGHT, 0.0)
	enemy_health_marker.billboard = BaseMaterial3D.BILLBOARD_ENABLED

	# Fix: do not force this 3D label to draw through the world.
	# The old settings made the block-text health bar appear as giant white/gray bars
	# across the player's view.
	enemy_health_marker.no_depth_test = false
	enemy_health_marker.fixed_size = false
	enemy_health_marker.font_size = ENEMY_HEALTH_BAR_FONT_SIZE
	enemy_health_marker.outline_size = 3
	enemy_health_marker.modulate = Color(1.0, 0.12, 0.08, 1.0)
	enemy_health_marker.visible = false
	add_child(enemy_health_marker)


func update_enemy_health_marker() -> void:
	if enemy_health_marker == null:
		return

	var should_show: bool = false

	# The player is BlueTeam in your game, so red-piloted helicopters are enemy helicopters.
	if SHOW_ENEMY_HELICOPTER_HEALTH_BAR and is_piloted and pilot_team == "red" and not destroyed_permanent:
		should_show = true

	enemy_health_marker.visible = should_show

	if not should_show:
		return

	var health_ratio: float = clamp(float(helicopter_health) / float(HELI_MAX_HEALTH), 0.0, 1.0)

	# Fix: do not use block characters for a world-space label.
	# The old "█" and "░" text became the screen-blocking bars.
	if HELICOPTER_INVINCIBLE:
		enemy_health_marker.text = "ENEMY HCOP"
	else:
		enemy_health_marker.text = "ENEMY HCOP " + str(max(helicopter_health, 0)) + "/" + str(HELI_MAX_HEALTH)

	if damage_flash_timer > 0.0:
		enemy_health_marker.modulate = Color(1.0, 1.0, 1.0, 1.0)
	elif health_ratio > 0.45:
		enemy_health_marker.modulate = Color(1.0, 0.12, 0.08, 1.0)
	elif health_ratio > 0.20:
		enemy_health_marker.modulate = Color(1.0, 0.65, 0.05, 1.0)
	else:
		enemy_health_marker.modulate = Color(1.0, 0.0, 0.0, 1.0)


# ---------------- UI ----------------
func setup_prompt() -> void:
	prompt_layer = CanvasLayer.new()
	prompt_layer.name = "HelicopterPromptLayer"
	add_child(prompt_layer)

	prompt_label = Label.new()
	prompt_label.name = "HelicopterPrompt"
	prompt_label.set_anchors_preset(Control.PRESET_CENTER)
	prompt_label.position = Vector2(-170.0, 95.0)
	prompt_label.add_theme_font_size_override("font_size", 22)
	prompt_label.visible = false
	prompt_layer.add_child(prompt_label)

	crosshair_label = Label.new()
	crosshair_label.name = "HelicopterCrosshair"
	crosshair_label.text = "+"
	crosshair_label.add_theme_font_size_override("font_size", 50)
	crosshair_label.set_anchors_preset(Control.PRESET_CENTER)
	crosshair_label.position = Vector2(-12.0, -30.0)
	crosshair_label.visible = false
	prompt_layer.add_child(crosshair_label)

	fuel_label = Label.new()
	fuel_label.name = "HelicopterFuelLabel"
	fuel_label.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	fuel_label.position = Vector2(20.0, -116.0)
	fuel_label.text = "HCOP FUEL"
	fuel_label.add_theme_font_size_override("font_size", 15)
	fuel_label.visible = false
	prompt_layer.add_child(fuel_label)

	fuel_bar_back = ColorRect.new()
	fuel_bar_back.name = "HelicopterFuelBack"
	fuel_bar_back.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	fuel_bar_back.position = Vector2(20.0, -94.0)
	fuel_bar_back.size = Vector2(160.0, 13.0)
	fuel_bar_back.color = Color(0.05, 0.05, 0.05, 0.9)
	fuel_bar_back.visible = false
	prompt_layer.add_child(fuel_bar_back)

	fuel_bar_fill = ColorRect.new()
	fuel_bar_fill.name = "HelicopterFuelFill"
	fuel_bar_fill.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	fuel_bar_fill.position = Vector2(22.0, -92.0)
	fuel_bar_fill.size = Vector2(156.0, 9.0)
	fuel_bar_fill.color = Color(0.95, 0.72, 0.08, 0.95)
	fuel_bar_fill.visible = false
	prompt_layer.add_child(fuel_bar_fill)

	heli_health_label = Label.new()
	heli_health_label.name = "HelicopterHealthLabel"
	heli_health_label.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	heli_health_label.position = Vector2(20.0, -154.0)
	heli_health_label.text = "HCOP HP"
	heli_health_label.add_theme_font_size_override("font_size", 15)
	heli_health_label.visible = false
	prompt_layer.add_child(heli_health_label)

	heli_health_bar_back = ColorRect.new()
	heli_health_bar_back.name = "HelicopterHealthBack"
	heli_health_bar_back.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	heli_health_bar_back.position = Vector2(20.0, -132.0)
	heli_health_bar_back.size = Vector2(160.0, 13.0)
	heli_health_bar_back.color = Color(0.05, 0.05, 0.05, 0.9)
	heli_health_bar_back.visible = false
	prompt_layer.add_child(heli_health_bar_back)

	heli_health_bar_fill = ColorRect.new()
	heli_health_bar_fill.name = "HelicopterHealthFill"
	heli_health_bar_fill.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	heli_health_bar_fill.position = Vector2(22.0, -130.0)
	heli_health_bar_fill.size = Vector2(156.0, 9.0)
	heli_health_bar_fill.color = Color(0.05, 0.85, 0.18, 0.95)
	heli_health_bar_fill.visible = false
	prompt_layer.add_child(heli_health_bar_fill)


func update_prompt_throttled(delta: float) -> void:
	helicopter_ui_update_timer -= delta
	if helicopter_ui_update_timer > 0.0:
		return
	helicopter_ui_update_timer = HELICOPTER_UI_UPDATE_INTERVAL
	update_prompt()


func update_prompt() -> void:
	# No center-screen helicopter words. Keep only crosshair and bars.
	if prompt_label:
		prompt_label.visible = false

	if crosshair_label:
		crosshair_label.visible = is_piloted and pilot_is_player

	update_vehicle_ui()


func apply_economy_upgrades(fuel_level: int, fuel_bonus_per_level: float) -> void:
	hcop_fuel_upgrade_level = fuel_level

	var old_max_fuel: float = upgraded_max_fuel_time
	upgraded_max_fuel_time = MAX_FUEL_TIME + float(fuel_level) * fuel_bonus_per_level

	if not fuel_empty_permanent and not destroyed_permanent:
		var gained_capacity: float = max(upgraded_max_fuel_time - old_max_fuel, 0.0)
		fuel_remaining = min(fuel_remaining + gained_capacity, upgraded_max_fuel_time)

	update_vehicle_ui()


func refuel_from_crate(amount: float) -> void:
	if destroyed_permanent:
		return

	fuel_empty_permanent = false
	fuel_remaining = min(fuel_remaining + amount, upgraded_max_fuel_time)
	update_vehicle_ui()


func update_vehicle_ui() -> void:
	var show_vehicle_bars: bool = is_piloted and pilot_is_player

	if fuel_label:
		fuel_label.visible = false
	if fuel_bar_back:
		fuel_bar_back.visible = show_vehicle_bars
	if fuel_bar_fill:
		fuel_bar_fill.visible = show_vehicle_bars
		var fuel_ratio: float = clamp(fuel_remaining / upgraded_max_fuel_time, 0.0, 1.0)
		fuel_bar_fill.size.x = 156.0 * fuel_ratio
		if fuel_ratio > 0.45:
			fuel_bar_fill.color = Color(0.95, 0.72, 0.08, 0.95)
		elif fuel_ratio > 0.20:
			fuel_bar_fill.color = Color(0.95, 0.36, 0.04, 0.95)
		else:
			fuel_bar_fill.color = Color(0.95, 0.05, 0.03, 0.95)

	if heli_health_label:
		heli_health_label.visible = false
	if heli_health_bar_back:
		heli_health_bar_back.visible = show_vehicle_bars
	if heli_health_bar_fill:
		heli_health_bar_fill.visible = show_vehicle_bars
		var health_ratio: float = 1.0 if HELICOPTER_INVINCIBLE else clamp(float(helicopter_health) / float(HELI_MAX_HEALTH), 0.0, 1.0)
		heli_health_bar_fill.size.x = 156.0 * health_ratio
		if damage_flash_timer > 0.0:
			heli_health_bar_fill.color = Color(1.0, 1.0, 1.0, 0.95)
		elif health_ratio > 0.45:
			heli_health_bar_fill.color = Color(0.05, 0.85, 0.18, 0.95)
		elif health_ratio > 0.20:
			heli_health_bar_fill.color = Color(0.95, 0.70, 0.04, 0.95)
		else:
			heli_health_bar_fill.color = Color(0.95, 0.05, 0.03, 0.95)


# ---------------- ENTER / EXIT ----------------
func update_player_near() -> void:
	if is_piloted:
		player_near = false
		return

	var found_player: CharacterBody3D = get_player()
	if found_player == null:
		player_near = false
		return

	player_near = global_position.distance_to(found_player.global_position) <= INTERACT_DISTANCE


func get_player() -> CharacterBody3D:
	var players: Array[Node] = get_tree().get_nodes_in_group(PLAYER_GROUP)
	for node in players:
		if node is CharacterBody3D:
			return node as CharacterBody3D
	return null


func has_pilot() -> bool:
	return is_piloted


func is_available_for_npc() -> bool:
	if destroyed_permanent:
		return false
	if fuel_empty_permanent:
		return false
	if time_since_ready < PLAYER_PRIORITY_SECONDS:
		return false
	return not is_piloted


func is_out_of_fuel() -> bool:
	return fuel_empty_permanent


func is_destroyed() -> bool:
	return destroyed_permanent


func is_invincible() -> bool:
	return HELICOPTER_INVINCIBLE


func should_npc_claim_now() -> bool:
	if not player_abandoned_with_fuel:
		return false
	if is_piloted:
		return false
	if fuel_empty_permanent:
		return false
	if fuel_remaining <= 0.0:
		return false
	if destroyed_permanent:
		return false
	return true


func clear_npc_claim_request() -> void:
	player_abandoned_with_fuel = false


func get_helicopter_health() -> int:
	return max(helicopter_health, 0)


func get_fuel_remaining() -> float:
	return max(fuel_remaining, 0.0)


func get_pilot_team() -> String:
	return pilot_team


func should_show_on_minimap() -> bool:
	return not fuel_empty_permanent and not destroyed_permanent


func is_player_already_in_any_helicopter(found_player: CharacterBody3D) -> bool:
	if found_player == null or not is_instance_valid(found_player):
		return true

	# This stops two helicopter nodes from accepting the same player on the same E press.
	var in_vehicle_value: Variant = found_player.get("in_helicopter")
	if in_vehicle_value != null and bool(in_vehicle_value):
		return true

	if found_player.has_meta("active_helicopter_id"):
		var active_id: int = int(found_player.get_meta("active_helicopter_id"))
		if active_id != 0 and active_id != get_instance_id():
			return true

	return false


func enter_helicopter() -> void:
	if is_piloted:
		return
	if destroyed_permanent:
		return
	if fuel_empty_permanent:
		return

	var found_player: CharacterBody3D = get_player()
	if found_player == null:
		return

	# Some game modes mark the hunted/commander target as unable to use helicopters.
	if bool(found_player.get_meta("no_helicopter", false)):
		return

	if is_player_already_in_any_helicopter(found_player):
		return

	found_player.set_meta("active_helicopter_id", get_instance_id())
	player_abandoned_with_fuel = false
	pilot = found_player
	pilot_is_player = true
	pilot_team = "blue"
	is_piloted = true
	auto_landing = false
	camera_smoothing_ready = false
	horizontal_velocity = Vector3.ZERO
	vertical_speed = 0.0
	aim_yaw_degrees = rotation_degrees.y
	aim_pitch_degrees = -8.0

	if pilot.has_method("enter_helicopter"):
		pilot.call("enter_helicopter", self)
	else:
		pilot.visible = false

	update_player_camera_pose()
	play_rotor_audio()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func npc_enter_helicopter(npc: CharacterBody3D) -> bool:
	if is_piloted:
		return false
	if destroyed_permanent:
		return false
	if fuel_empty_permanent:
		return false
	if time_since_ready < PLAYER_PRIORITY_SECONDS:
		return false
	if npc == null or not is_instance_valid(npc):
		return false
	if npc.has_meta("dead") and bool(npc.get_meta("dead")):
		return false
	if bool(npc.get_meta("no_helicopter", false)):
		return false

	player_abandoned_with_fuel = false
	pilot = npc
	pilot_is_player = false
	pilot_team = get_team_from_node(npc)
	is_piloted = true
	auto_landing = false
	camera_smoothing_ready = false
	horizontal_velocity = Vector3.ZERO
	vertical_speed = 0.0
	aim_yaw_degrees = rotation_degrees.y
	aim_pitch_degrees = -8.0
	npc_fire_timer = rng.randf_range(NPC_HELI_FIRE_TIME_MIN, NPC_HELI_FIRE_TIME_MAX)
	npc_target_refresh_timer = 0.0
	npc_target = null

	npc.visible = false
	npc.set_meta("in_helicopter", true)
	npc.set_meta("piloting_helicopter", true)
	npc.set_meta("wants_helicopter", false)
	npc.velocity = Vector3.ZERO

	for child in npc.get_children():
		if child is CollisionShape3D:
			(child as CollisionShape3D).disabled = true
		elif child is Area3D:
			(child as Area3D).collision_layer = 0
			(child as Area3D).collision_mask = 0

	play_rotor_audio()
	return true


func update_fuel(delta: float) -> void:
	if destroyed_permanent:
		return
	if fuel_empty_permanent:
		if not auto_landing:
			start_auto_land()
		return

	# Fuel burns only while someone is actually flying. Auto-land still finishes after empty.
	if not auto_landing:
		fuel_remaining = max(fuel_remaining - delta, 0.0)
		if fuel_remaining <= 0.0:
			fuel_empty_permanent = true
			start_auto_land()


func start_auto_land() -> void:
	auto_landing = true
	vertical_speed = min(vertical_speed, 0.0)


func finish_landing_and_exit() -> void:
	var ground_y: float = get_ground_y(global_position)
	global_position.y = ground_y + MIN_Y_ABOVE_GROUND
	exit_helicopter()


func exit_helicopter() -> void:
	if not is_piloted:
		return

	var was_player_pilot: bool = pilot_is_player
	var had_fuel_left_when_landed: bool = fuel_remaining > 0.0 and not fuel_empty_permanent and not destroyed_permanent
	var exit_position: Vector3 = get_safe_exit_position()
	var exit_yaw: float = rotation.y

	if pilot != null and is_instance_valid(pilot):
		if pilot_is_player:
			if pilot.has_meta("active_helicopter_id"):
				pilot.remove_meta("active_helicopter_id")
			if pilot.has_method("exit_helicopter"):
				pilot.call("exit_helicopter", exit_position, exit_yaw)
			else:
				pilot.visible = true
				pilot.global_position = exit_position
				pilot.rotation.y = exit_yaw
		else:
			pilot.visible = true
			pilot.global_position = exit_position
			pilot.rotation.y = exit_yaw
			pilot.set_meta("in_helicopter", false)
			pilot.set_meta("piloting_helicopter", false)
			for child in pilot.get_children():
				if child is CollisionShape3D:
					(child as CollisionShape3D).disabled = false

	stop_rotor_audio()
	pilot = null
	is_piloted = false
	pilot_is_player = false
	pilot_team = ""
	auto_landing = false
	camera_smoothing_ready = false
	horizontal_velocity = Vector3.ZERO
	vertical_speed = 0.0
	if was_player_pilot and had_fuel_left_when_landed:
		player_abandoned_with_fuel = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func get_safe_exit_position() -> Vector3:
	var right: Vector3 = get_flat_right()
	var forward: Vector3 = get_flat_forward()
	var raw_exit: Vector3 = global_position + right * EXIT_SIDE_DISTANCE + forward * EXIT_FORWARD_DISTANCE
	raw_exit.x = clamp(raw_exit.x, MIN_BOUND + 2.0, MAX_BOUND - 2.0)
	raw_exit.z = clamp(raw_exit.z, MIN_BOUND + 2.0, MAX_BOUND - 2.0)
	return snap_to_ground(raw_exit) + Vector3(0.0, 1.1, 0.0)


# ---------------- CAMERA HANDOFF ----------------
func get_camera_world_position() -> Vector3:
	var camera_forward: Vector3 = get_flat_forward_for_yaw(aim_yaw_degrees + CAMERA_YAW_OFFSET_DEGREES)
	return global_position + camera_forward * CAMERA_FRONT_DISTANCE + Vector3(0.0, CAMERA_HEIGHT, 0.0)


func update_player_camera_pose() -> void:
	if pilot == null or not is_instance_valid(pilot):
		return

	var target_camera_pos: Vector3 = get_camera_world_position()
	if not camera_smoothing_ready:
		smoothed_camera_position = target_camera_pos
		camera_smoothing_ready = true
	else:
		var smooth_weight: float = clamp(get_process_delta_time() * CAMERA_SMOOTH_SPEED, 0.0, 1.0)
		smoothed_camera_position = smoothed_camera_position.lerp(target_camera_pos, smooth_weight)

	if pilot.has_method("set_vehicle_camera_pose"):
		pilot.call("set_vehicle_camera_pose", smoothed_camera_position, aim_yaw_degrees + CAMERA_YAW_OFFSET_DEGREES, aim_pitch_degrees)
	else:
		pilot.global_position = smoothed_camera_position
		pilot.rotation_degrees.y = aim_yaw_degrees + CAMERA_YAW_OFFSET_DEGREES


# ---------------- FLIGHT ----------------
func update_player_flight(delta: float) -> void:
	var desired_velocity: Vector3 = Vector3.ZERO

	if not auto_landing:
		var forward: Vector3 = get_flat_forward()
		var right: Vector3 = get_flat_right()
		var forward_sign: float = -1.0 if INVERT_FORWARD_BACK else 1.0
		var strafe_sign: float = -1.0 if INVERT_STRAFE else 1.0

		if Input.is_key_pressed(KEY_W):
			desired_velocity += forward * MAX_FORWARD_SPEED * forward_sign
		if Input.is_key_pressed(KEY_S):
			desired_velocity -= forward * MAX_BACK_SPEED * forward_sign
		if Input.is_key_pressed(KEY_A):
			desired_velocity -= right * MAX_STRAFE_SPEED * strafe_sign
		if Input.is_key_pressed(KEY_D):
			desired_velocity += right * MAX_STRAFE_SPEED * strafe_sign

		if desired_velocity.length() > MAX_FORWARD_SPEED:
			desired_velocity = desired_velocity.normalized() * MAX_FORWARD_SPEED
	else:
		desired_velocity = Vector3.ZERO

	move_helicopter(delta, desired_velocity, get_player_desired_vertical_speed(), ACCELERATION, BRAKE_ACCELERATION)


func get_player_desired_vertical_speed() -> float:
	if auto_landing:
		return -AUTO_LAND_DESCEND_SPEED
	if Input.is_key_pressed(KEY_SPACE):
		return CLIMB_SPEED
	if Input.is_key_pressed(KEY_SHIFT):
		return -DESCEND_SPEED
	return 0.0


func update_npc_flight(delta: float) -> void:
	if pilot == null or not is_instance_valid(pilot):
		exit_helicopter()
		return

	# CPU pilot rule set:
	# 1. Pick a target.
	# 2. Turn nose toward the target.
	# 3. Move to a useful standoff range instead of ramming or flying backward.
	# 4. Circle when close enough.
	# 5. Avoid map edges.
	# 6. Fire only when mostly aimed at the target.
	npc_target_refresh_timer -= delta
	if npc_target_refresh_timer <= 0.0 or not is_valid_air_target(npc_target):
		npc_target = find_best_air_target()
		npc_target_refresh_timer = NPC_HELI_TARGET_REFRESH_TIME

	var desired_velocity: Vector3 = Vector3.ZERO
	var desired_vertical: float = 0.0
	var target_y: float = get_ground_y(global_position) + NPC_HELI_ALTITUDE_ABOVE_GROUND

	if is_valid_air_target(npc_target):
		var air_target: Node3D = npc_target as Node3D
		var target_velocity: Vector3 = Vector3.ZERO
		if air_target is CharacterBody3D:
			target_velocity = (air_target as CharacterBody3D).velocity

		var predicted_target_position: Vector3 = air_target.global_position + target_velocity * NPC_HELI_AIM_LEAD_TIME
		var to_target: Vector3 = predicted_target_position - global_position
		var flat_to_target: Vector3 = Vector3(to_target.x, 0.0, to_target.z)
		var distance: float = flat_to_target.length()

		if distance > 0.1:
			var desired_yaw_degrees: float = rad_to_deg(atan2(-flat_to_target.x, -flat_to_target.z))
			var current_yaw_radians: float = deg_to_rad(aim_yaw_degrees)
			var desired_yaw_radians: float = deg_to_rad(desired_yaw_degrees)
			aim_yaw_degrees = rad_to_deg(lerp_angle(current_yaw_radians, desired_yaw_radians, delta * 2.2))

			var target_forward: Vector3 = get_flat_forward_for_yaw(aim_yaw_degrees)
			var target_right: Vector3 = Vector3(target_forward.z, 0.0, -target_forward.x).normalized()
			var to_target_dir: Vector3 = flat_to_target.normalized()
			var circle_side: float = -1.0
			if pilot != null and is_instance_valid(pilot):
				circle_side = -1.0 if int(pilot.get_instance_id()) % 2 == 0 else 1.0

			if distance > NPC_HELI_IDEAL_DISTANCE:
				# Approach the target directly.
				desired_velocity = to_target_dir * NPC_HELI_FORWARD_SPEED
			elif distance < NPC_HELI_TOO_CLOSE_DISTANCE:
				# Back away if too close.
				desired_velocity = -to_target_dir * (NPC_HELI_FORWARD_SPEED * 0.7)
			else:
				# Orbit/standoff instead of flying straight over the target.
				desired_velocity = target_right * circle_side * NPC_HELI_CIRCLE_SPEED
				desired_velocity += to_target_dir * clamp((distance - NPC_HELI_STANDOFF_DISTANCE) / 80.0, -0.35, 0.35) * NPC_HELI_FORWARD_SPEED

			# Fire only when the helicopter is generally pointed at the target.
			var aim_dot: float = clamp(target_forward.dot(to_target_dir), -1.0, 1.0)
			var aim_error_degrees: float = rad_to_deg(acos(aim_dot))
			if npc_fire_timer <= 0.0 and aim_error_degrees <= NPC_HELI_SHOOT_CONE_DEGREES and has_air_line_of_sight(air_target):
				shoot_npc_helicopter_laser(air_target)
				npc_fire_timer = rng.randf_range(NPC_HELI_FIRE_TIME_MIN, NPC_HELI_FIRE_TIME_MAX)

		# Smarter altitude: stay above ground and slightly above ground targets.
		target_y = max(get_ground_y(global_position) + NPC_HELI_ALTITUDE_ABOVE_GROUND, air_target.global_position.y + 16.0)
	else:
		# Patrol toward the center if no target is visible.
		var to_center: Vector3 = Vector3.ZERO - global_position
		to_center.y = 0.0
		if to_center.length() > 35.0:
			var center_dir: Vector3 = to_center.normalized()
			aim_yaw_degrees = rad_to_deg(atan2(-center_dir.x, -center_dir.z))
			desired_velocity = center_dir * (NPC_HELI_FORWARD_SPEED * 0.45)

	# Avoid getting stuck on the edge of the playable box.
	var boundary_push: Vector3 = Vector3.ZERO
	if global_position.x < MIN_BOUND + NPC_HELI_BOUNDARY_BUFFER:
		boundary_push.x += 1.0
	elif global_position.x > MAX_BOUND - NPC_HELI_BOUNDARY_BUFFER:
		boundary_push.x -= 1.0
	if global_position.z < MIN_BOUND + NPC_HELI_BOUNDARY_BUFFER:
		boundary_push.z += 1.0
	elif global_position.z > MAX_BOUND - NPC_HELI_BOUNDARY_BUFFER:
		boundary_push.z -= 1.0
	if boundary_push.length() > 0.01:
		boundary_push = boundary_push.normalized() * NPC_HELI_FORWARD_SPEED
		desired_velocity = desired_velocity.lerp(boundary_push, 0.75)
		aim_yaw_degrees = rad_to_deg(atan2(-boundary_push.x, -boundary_push.z))

	if global_position.y < target_y - 1.5:
		desired_vertical = CLIMB_SPEED
	elif global_position.y > target_y + 3.0:
		desired_vertical = -DESCEND_SPEED

	if desired_velocity.length() > NPC_HELI_FORWARD_SPEED:
		desired_velocity = desired_velocity.normalized() * NPC_HELI_FORWARD_SPEED

	move_helicopter(delta, desired_velocity, desired_vertical, NPC_HELI_ACCELERATION, NPC_HELI_BRAKE)

	# move_helicopter() can finish an auto-land and call exit_helicopter(),
	# which clears pilot. Do not touch pilot after that happens.
	if pilot == null or not is_instance_valid(pilot):
		return

	# Keep the hidden pilot carried with the helicopter.
	pilot.global_position = global_position + Vector3(0.0, 0.5, 0.0)

func move_helicopter(delta: float, desired_velocity: Vector3, desired_vertical_speed: float, accel_value: float, brake_value: float) -> void:
	var accel: float = accel_value
	if desired_velocity.length() <= 0.01:
		accel = brake_value

	if auto_landing:
		horizontal_velocity = horizontal_velocity.move_toward(Vector3.ZERO, AUTO_LAND_BRAKE * delta)
		desired_vertical_speed = -AUTO_LAND_DESCEND_SPEED
	else:
		horizontal_velocity = horizontal_velocity.move_toward(desired_velocity, accel * delta)

	var vertical_accel: float = VERTICAL_BRAKE
	if abs(desired_vertical_speed) > 0.01:
		vertical_accel = VERTICAL_ACCELERATION
	vertical_speed = move_toward(vertical_speed, desired_vertical_speed, vertical_accel * delta)

	global_position += (horizontal_velocity + Vector3(0.0, vertical_speed, 0.0)) * delta
	global_position.x = clamp(global_position.x, MIN_BOUND, MAX_BOUND)
	global_position.z = clamp(global_position.z, MIN_BOUND, MAX_BOUND)

	var ground_y: float = get_ground_y(global_position)
	var min_y: float = ground_y + MIN_Y_ABOVE_GROUND
	global_position.y = clamp(global_position.y, min_y, MAX_Y)

	if auto_landing and global_position.y <= ground_y + LANDED_EXIT_HEIGHT and horizontal_velocity.length() <= LANDING_EXIT_SPEED:
		finish_landing_and_exit()
		return

	var visual_yaw_offset: float = PLAYER_MODEL_YAW_OFFSET_DEGREES if pilot_is_player else NPC_MODEL_YAW_OFFSET_DEGREES
	var target_yaw: float = deg_to_rad(aim_yaw_degrees + visual_yaw_offset)
	rotation.y = lerp_angle(rotation.y, target_yaw, BODY_YAW_FOLLOW_SPEED * delta)
	update_visual_lean(delta)


func get_flat_forward() -> Vector3:
	return get_flat_forward_for_yaw(aim_yaw_degrees)


func get_flat_forward_for_yaw(yaw_degrees: float) -> Vector3:
	var yaw_rad: float = deg_to_rad(yaw_degrees)
	var forward: Vector3 = Vector3(-sin(yaw_rad), 0.0, -cos(yaw_rad))
	return forward.normalized()


func get_flat_right() -> Vector3:
	var forward: Vector3 = get_flat_forward()
	var right: Vector3 = Vector3(forward.z, 0.0, -forward.x)
	return right.normalized()


func update_visual_lean(delta: float) -> void:
	var forward: Vector3 = get_flat_forward()
	var right: Vector3 = get_flat_right()
	var forward_amount: float = clamp(horizontal_velocity.dot(forward) / max(MAX_FORWARD_SPEED, 0.1), -1.0, 1.0)
	var side_amount: float = clamp(horizontal_velocity.dot(right) / max(MAX_STRAFE_SPEED, 0.1), -1.0, 1.0)
	var target_pitch: float = deg_to_rad(-MAX_VISUAL_PITCH_LEAN * forward_amount)
	var target_roll: float = deg_to_rad(-MAX_VISUAL_ROLL_LEAN * side_amount)
	rotation.x = lerp_angle(rotation.x, target_pitch, delta * LEAN_SPEED)
	rotation.z = lerp_angle(rotation.z, target_roll, delta * LEAN_SPEED)


# ---------------- NPC TARGETING ----------------
func find_best_air_target() -> Node3D:
	var best: Node3D = null
	var best_score: float = 999999.0
	var enemy_group: String = "RedTeam" if pilot_team == "blue" else "BlueTeam"
	var candidates: Array[Node] = get_tree().get_nodes_in_group(enemy_group)

	for node in candidates:
		if node == pilot:
			continue
		if not is_valid_air_target(node):
			continue
		var target_node: Node3D = node as Node3D
		var distance: float = global_position.distance_to(target_node.global_position)
		if distance > NPC_HELI_MAX_TARGET_DISTANCE:
			continue
		var score: float = distance
		if has_air_line_of_sight(target_node):
			score -= 85.0
		if score < best_score:
			best_score = score
			best = target_node

	return best


func is_valid_air_target(target: Variant) -> bool:
	# Must accept Variant because a stored target can be freed between frames.
	# A typed Node3D argument can crash before the function body runs.
	if target == null:
		return false
	if not is_instance_valid(target):
		return false
	if not (target is Node3D):
		return false

	var target_node: Node3D = target as Node3D
	if target_node.has_meta("dead") and bool(target_node.get_meta("dead")):
		return false
	if target_node.has_meta("in_helicopter") and bool(target_node.get_meta("in_helicopter")):
		return false
	return true


func has_air_line_of_sight(target: Variant) -> bool:
	if not is_valid_air_target(target):
		return false
	var target_node: Node3D = target as Node3D
	if target_node == null:
		return false
	var start_position: Vector3 = global_position + Vector3(0.0, 1.5, 0.0)
	var end_position: Vector3 = target_node.global_position + Vector3(0.0, 1.0, 0.0)
	var query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(start_position, end_position)
	query.collide_with_bodies = true
	query.collide_with_areas = true
	for rid in get_helicopter_exclude_rids():
		query.exclude.append(rid)
	if pilot != null and is_instance_valid(pilot):
		query.exclude.append(pilot.get_rid())
	var hit: Dictionary = get_world_3d().direct_space_state.intersect_ray(query)
	if hit.size() <= 0:
		return true
	var collider: Object = hit.get("collider", null)
	if collider == null:
		return false
	if collider == target_node:
		return true
	if collider is Node:
		var collider_node: Node = collider as Node
		return target_node.is_ancestor_of(collider_node)
	return false


# ---------------- SHOOTING ----------------
func shoot_player_helicopter_laser() -> void:
	if fire_timer > 0.0:
		return
	var camera: Camera3D = get_viewport().get_camera_3d()
	if camera == null:
		print("Helicopter could not find active camera.")
		return
	fire_timer = HELI_FIRE_COOLDOWN
	var start_position: Vector3 = camera.global_position + (-camera.global_transform.basis.z * 1.6)
	var end_position: Vector3 = start_position + (-camera.global_transform.basis.z * HELI_SHOOT_RANGE)
	fire_laser_between(start_position, end_position)


func shoot_npc_helicopter_laser(target: Variant) -> void:
	if not is_valid_air_target(target):
		return

	var target_node: Node3D = target as Node3D
	var start_position: Vector3 = global_position + Vector3(0.0, 1.5, 0.0) + get_flat_forward() * 3.0
	var target_position: Vector3 = target_node.global_position + Vector3(0.0, 1.1, 0.0)

	var distance: float = start_position.distance_to(target_position)

	# Helicopters cannot shoot from outside laser range.
	if distance > HELI_SHOOT_RANGE:
		return

	# Red CPU helicopters only get a real chance to hit the player.
	# Misses still draw a laser, but the laser goes off-target.
	if pilot_team == "red" and target_node.is_in_group(PLAYER_GROUP):
		if rng.randf() > NPC_HELI_CHANCE_TO_HIT_PLAYER:
			target_position += Vector3(
				rng.randf_range(-NPC_HELI_AIM_MISS_RADIUS, NPC_HELI_AIM_MISS_RADIUS),
				rng.randf_range(-4.0, 5.0),
				rng.randf_range(-NPC_HELI_AIM_MISS_RADIUS, NPC_HELI_AIM_MISS_RADIUS)
			)
		else:
			target_position += Vector3(
				rng.randf_range(-2.5, 2.5),
				rng.randf_range(-0.8, 0.8),
				rng.randf_range(-2.5, 2.5)
			)
	else:
		target_position += Vector3(
			rng.randf_range(-3.0, 3.0),
			rng.randf_range(-1.0, 1.0),
			rng.randf_range(-3.0, 3.0)
		)

	fire_laser_between(start_position, target_position)


func fire_laser_between(start_position: Vector3, end_position: Vector3) -> void:
	var query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(start_position, end_position)
	query.collide_with_bodies = true
	query.collide_with_areas = true
	for rid in get_helicopter_exclude_rids():
		query.exclude.append(rid)
	if pilot != null and is_instance_valid(pilot):
		query.exclude.append(pilot.get_rid())

	var hit: Dictionary = get_world_3d().direct_space_state.intersect_ray(query)
	if hit.size() <= 0:
		spawn_helicopter_laser_ray(start_position, end_position)
		return

	var hit_position: Vector3 = hit["position"] as Vector3
	spawn_helicopter_laser_ray(start_position, hit_position)

	var collider_object: Object = hit.get("collider", null)
	if collider_object == null:
		return
	if not collider_object is Node:
		return

	var hit_object: Node = collider_object as Node
	handle_laser_hit(hit_object)


func handle_laser_hit(hit_object: Node) -> void:
	if hit_object == null:
		return

	var hit_helicopter: Node = find_helicopter_from_hit_object(hit_object)
	if hit_helicopter != null and hit_helicopter != self:
		if hit_helicopter.has_method("take_damage"):
			hit_helicopter.call("take_damage", HELI_BODY_DAMAGE, pilot_team)
		return

	var hit_player: Node = find_player_from_hit_object(hit_object)
	if hit_player != null and pilot_team == "red":
		if hit_player.has_method("take_damage"):
			hit_player.call("take_damage", HELI_PLAYER_DAMAGE)
		return

	var npc: Node3D = find_npc_from_hit_object(hit_object)
	if npc == null:
		return
	if get_npc_team(npc) == pilot_team:
		return

	var hit_zone: String = get_hit_zone(hit_object)
	if hit_zone == "head":
		damage_npc(npc, HELI_HEADSHOT_DAMAGE, true)
	else:
		damage_npc(npc, HELI_BODY_DAMAGE, false)


func spawn_helicopter_laser_ray(start_position: Vector3, end_position: Vector3) -> void:
	var direction: Vector3 = end_position - start_position
	if direction.length() < 0.01:
		return
	var laser: MeshInstance3D = MeshInstance3D.new()
	laser.name = "HelicopterLaserRay"
	var cylinder: CylinderMesh = CylinderMesh.new()
	cylinder.top_radius = HELI_LASER_WIDTH
	cylinder.bottom_radius = HELI_LASER_WIDTH
	cylinder.height = direction.length()
	cylinder.radial_segments = 8
	laser.mesh = cylinder
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.albedo_color = get_laser_color()
	material.emission_enabled = true
	material.emission = get_laser_color()
	material.emission_energy_multiplier = 3.5
	laser.material_override = material
	get_tree().current_scene.add_child(laser)
	laser.global_position = start_position + direction * 0.5
	laser.look_at(end_position, Vector3.UP)
	laser.rotate_object_local(Vector3.RIGHT, deg_to_rad(90.0))
	await get_tree().create_timer(HELI_LASER_LIFETIME).timeout
	if is_instance_valid(laser):
		laser.queue_free()


func get_laser_color() -> Color:
	return BLUE_HELI_LASER_COLOR if pilot_team != "red" else RED_HELI_LASER_COLOR


func get_helicopter_exclude_rids() -> Array[RID]:
	var rids: Array[RID] = []
	var children: Array[Node] = find_children("*", "CollisionObject3D", true, false)
	for node in children:
		if node is CollisionObject3D:
			rids.append((node as CollisionObject3D).get_rid())
	return rids


func get_hit_zone(hit_object: Node) -> String:
	if hit_object == null:
		return "body"
	var node: Node = hit_object
	while node != null:
		if node.has_meta("hit_zone"):
			return str(node.get_meta("hit_zone"))
		node = node.get_parent()
	return "body"


func find_npc_from_hit_object(hit_object: Node) -> Node3D:
	if hit_object == null:
		return null
	var node: Node = hit_object
	while node != null:
		if node.is_in_group(NPC_GROUP) and node is Node3D:
			return node as Node3D
		if node.has_meta("npc_root"):
			var npc_root: Node = node.get_meta("npc_root") as Node
			if npc_root != null and npc_root is Node3D:
				return npc_root as Node3D
		node = node.get_parent()
	return null


func find_helicopter_from_hit_object(hit_object: Node) -> Node:
	if hit_object == null:
		return null
	var node: Node = hit_object
	while node != null:
		if node.is_in_group(HELICOPTER_GROUP):
			return node
		node = node.get_parent()
	return null


func find_player_from_hit_object(hit_object: Node) -> Node:
	var node: Node = hit_object
	while node != null:
		if node.is_in_group(PLAYER_GROUP):
			return node
		node = node.get_parent()
	return null


func get_npc_team(npc: Node) -> String:
	return get_team_from_node(npc)


func get_team_from_node(node: Node) -> String:
	if node == null:
		return ""
	if node.has_meta("team"):
		return str(node.get_meta("team"))
	if node.is_in_group("BlueTeam"):
		return "blue"
	if node.is_in_group("RedTeam"):
		return "red"
	return ""


func damage_npc(npc: Node3D, amount: int, headshot: bool) -> void:
	if npc == null or not is_instance_valid(npc):
		return
	if get_npc_team(npc) == pilot_team:
		return
	if npc.has_method("take_damage"):
		npc.call("take_damage", amount, headshot)
		return
	if not npc.has_meta("health"):
		return
	var health: int = int(npc.get_meta("health"))
	health -= amount
	npc.set_meta("health", health)
	if health <= 0:
		npc.set_meta("dead", true)
		if pilot_team == "blue":
			notify_battle_manager_player_kill(headshot)


func take_damage(amount: int, attacker_team: String = "") -> void:
	if HELICOPTER_INVINCIBLE:
		# Helicopters ignore all damage. Fuel is the only way they stop working.
		damage_flash_timer = 0.0
		helicopter_health = HELI_MAX_HEALTH
		update_vehicle_ui()
		return
	if destroyed_permanent:
		return
	if amount <= 0:
		return
	if attacker_team != "" and attacker_team == pilot_team:
		return

	helicopter_health -= amount
	helicopter_health = max(helicopter_health, 0)
	damage_flash_timer = HELI_DAMAGE_FLASH_TIME
	update_vehicle_ui()

	if helicopter_health <= 0:
		destroy_helicopter()


func destroy_helicopter() -> void:
	if destroyed_permanent:
		return

	destroyed_permanent = true
	fuel_empty_permanent = true
	fuel_remaining = 0.0
	horizontal_velocity = Vector3.ZERO
	vertical_speed = 0.0
	stop_rotor_audio()

	if is_piloted and pilot != null and is_instance_valid(pilot):
		var crash_exit_position: Vector3 = snap_to_ground(global_position + get_flat_right() * EXIT_SIDE_DISTANCE) + Vector3(0.0, 1.1, 0.0)
		if pilot_is_player:
			if pilot.has_meta("active_helicopter_id"):
				pilot.remove_meta("active_helicopter_id")
			if pilot.has_method("exit_helicopter"):
				pilot.call("exit_helicopter", crash_exit_position, rotation.y)
			else:
				pilot.visible = true
				pilot.global_position = crash_exit_position
			if pilot.has_method("take_damage"):
				pilot.call("take_damage", 9999)
		else:
			pilot.visible = true
			pilot.global_position = crash_exit_position
			pilot.set_meta("dead", true)
			pilot.set_meta("in_helicopter", false)
			pilot.set_meta("piloting_helicopter", false)

	pilot = null
	is_piloted = false
	pilot_is_player = false
	pilot_team = ""
	auto_landing = false
	update_vehicle_ui()


func notify_battle_manager_player_kill(headshot: bool) -> void:
	var battle_manager: Node = get_tree().current_scene.find_child("BattleManager", true, false)
	if battle_manager == null:
		battle_manager = get_tree().current_scene.find_child("EnemyManager", true, false)
	if battle_manager == null:
		return
	if battle_manager.has_method("record_player_kill"):
		battle_manager.call("record_player_kill", headshot, true)


# ---------------- GROUND / AUDIO ----------------
func snap_to_ground(position: Vector3) -> Vector3:
	var start: Vector3 = position + Vector3(0.0, 150.0, 0.0)
	var end: Vector3 = position + Vector3(0.0, -350.0, 0.0)
	var query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(start, end)
	query.collide_with_bodies = true
	query.collide_with_areas = false
	for rid in get_helicopter_exclude_rids():
		query.exclude.append(rid)
	var hit: Dictionary = get_world_3d().direct_space_state.intersect_ray(query)
	if hit.size() > 0:
		return hit["position"] as Vector3
	return position


func get_ground_y(position: Vector3) -> float:
	return snap_to_ground(position).y


func setup_rotor_audio() -> void:
	rotor_audio = get_node_or_null("HelicopterSound")
	if rotor_audio == null:
		rotor_audio = get_node_or_null("HcopSound")
	if rotor_audio == null:
		rotor_audio = get_node_or_null("RotorSound")
	if rotor_audio == null:
		rotor_audio = find_first_audio_player(self)
	if rotor_audio == null:
		print("No helicopter audio node found. Add an AudioStreamPlayer named HelicopterSound as a child of the helicopter.")
		return
	setup_audio_node(rotor_audio)
	stop_audio_node(rotor_audio)


func find_first_audio_player(root: Node) -> Node:
	if root == null:
		return null
	var audio_3d_nodes: Array[Node] = root.find_children("*", "AudioStreamPlayer3D", true, false)
	if audio_3d_nodes.size() > 0:
		return audio_3d_nodes[0]
	var audio_nodes: Array[Node] = root.find_children("*", "AudioStreamPlayer", true, false)
	if audio_nodes.size() > 0:
		return audio_nodes[0]
	var audio_2d_nodes: Array[Node] = root.find_children("*", "AudioStreamPlayer2D", true, false)
	if audio_2d_nodes.size() > 0:
		return audio_2d_nodes[0]
	return null


func setup_audio_node(audio_node: Node) -> void:
	if audio_node == null:
		return
	if audio_node is AudioStreamPlayer3D:
		var audio_3d: AudioStreamPlayer3D = audio_node as AudioStreamPlayer3D
		audio_3d.volume_db = ROTOR_SOUND_VOLUME_DB
		audio_3d.max_distance = ROTOR_SOUND_MAX_DISTANCE
		audio_3d.unit_size = 10.0
		audio_3d.attenuation_model = AudioStreamPlayer3D.ATTENUATION_INVERSE_DISTANCE
		audio_3d.autoplay = false
	elif audio_node is AudioStreamPlayer:
		var audio: AudioStreamPlayer = audio_node as AudioStreamPlayer
		audio.volume_db = ROTOR_SOUND_VOLUME_DB
		audio.autoplay = false
	elif audio_node is AudioStreamPlayer2D:
		var audio_2d: AudioStreamPlayer2D = audio_node as AudioStreamPlayer2D
		audio_2d.volume_db = ROTOR_SOUND_VOLUME_DB
		audio_2d.autoplay = false


func play_rotor_audio() -> void:
	if rotor_audio == null:
		return
	setup_audio_node(rotor_audio)
	if not is_audio_node_playing(rotor_audio):
		play_audio_node(rotor_audio)


func stop_rotor_audio() -> void:
	if rotor_audio == null:
		return
	stop_audio_node(rotor_audio)


func update_rotor_audio() -> void:
	if rotor_audio == null:
		return
	if is_piloted:
		if not is_audio_node_playing(rotor_audio):
			play_audio_node(rotor_audio)
	else:
		if is_audio_node_playing(rotor_audio):
			stop_audio_node(rotor_audio)


func is_audio_node_playing(audio_node: Node) -> bool:
	if audio_node is AudioStreamPlayer3D:
		return (audio_node as AudioStreamPlayer3D).playing
	if audio_node is AudioStreamPlayer:
		return (audio_node as AudioStreamPlayer).playing
	if audio_node is AudioStreamPlayer2D:
		return (audio_node as AudioStreamPlayer2D).playing
	return false


func play_audio_node(audio_node: Node) -> void:
	if audio_node is AudioStreamPlayer3D:
		var audio_3d: AudioStreamPlayer3D = audio_node as AudioStreamPlayer3D
		if audio_3d.stream != null:
			audio_3d.play(0.0)
	elif audio_node is AudioStreamPlayer:
		var audio: AudioStreamPlayer = audio_node as AudioStreamPlayer
		if audio.stream != null:
			audio.play(0.0)
	elif audio_node is AudioStreamPlayer2D:
		var audio_2d: AudioStreamPlayer2D = audio_node as AudioStreamPlayer2D
		if audio_2d.stream != null:
			audio_2d.play(0.0)


func stop_audio_node(audio_node: Node) -> void:
	if audio_node is AudioStreamPlayer3D:
		(audio_node as AudioStreamPlayer3D).stop()
	elif audio_node is AudioStreamPlayer:
		(audio_node as AudioStreamPlayer).stop()
	elif audio_node is AudioStreamPlayer2D:
		(audio_node as AudioStreamPlayer2D).stop()


# ---------------- MATCH RESET ----------------
func reset_for_new_match() -> void:
	# Restore helicopter to its original map position and make it usable again.
	global_transform = match_start_transform
	rotation_degrees = match_start_rotation_degrees

	pilot = null
	is_piloted = false
	pilot_is_player = false
	pilot_team = ""
	player_near = false
	auto_landing = false

	horizontal_velocity = Vector3.ZERO
	vertical_speed = 0.0
	fire_timer = 0.0
	npc_fire_timer = 0.0
	npc_target_refresh_timer = 0.0
	npc_target = null
	e_was_down = false

	fuel_empty_permanent = false
	destroyed_permanent = false
	player_abandoned_with_fuel = false
	damage_flash_timer = 0.0
	helicopter_health = HELI_MAX_HEALTH

	if upgraded_max_fuel_time > 0.0:
		fuel_remaining = upgraded_max_fuel_time
	else:
		fuel_remaining = MAX_FUEL_TIME

	if crosshair_label:
		crosshair_label.visible = false

	if fuel_bar_back:
		fuel_bar_back.visible = false

	if fuel_bar_fill:
		fuel_bar_fill.visible = false

	if heli_health_bar_back:
		heli_health_bar_back.visible = false

	if heli_health_bar_fill:
		heli_health_bar_fill.visible = false

	update_vehicle_ui()
	update_rotor_audio()
	update_enemy_health_marker()
