extends CharacterBody3D


# ---------------- LASER TAG MODE ----------------
const PLAYER_LASER_TAG_MODE: bool = true
const PLAYER_LASER_COLOR: Color = Color(0.05, 1.0, 0.20, 1.0)
const PLAYER_LASER_LIFETIME: float = 0.10
const PLAYER_LASER_WIDTH: float = 0.08

# ---------------- PLAYER FOG / HAZE ----------------
# Tune these values to make the map more or less foggy.
const PLAYER_FOG_ENABLED: bool = true
const PLAYER_FOG_COLOR: Color = Color(0.62, 0.70, 0.76, 1.0)
const PLAYER_FOG_LIGHT_ENERGY: float = 0.75
const PLAYER_FOG_DENSITY: float = 0.035
const PLAYER_FOG_HEIGHT_DENSITY: float = 0.025
const PLAYER_FOG_HEIGHT_FALLOFF: float = 0.35
const PLAYER_FOG_SKY_AFFECT: float = 0.70
const PLAYER_FOG_AERIAL_PERSPECTIVE: float = 0.25

# This is a light screen haze on top of the 3D world.
# Lower this if the screen looks washed out. Raise it if you want a thicker fog feel.
const PLAYER_SCREEN_HAZE_ALPHA: float = 0.08

# PLAYER SCRIPT - FUN TEAM BATTLE VERSION
# Put this on CameraRig.
#
# Important fixes:
# - Player is BlueTeam.
# - Player cannot damage BlueTeam NPCs.
# - Player can damage RedTeam NPCs.
# - Headshot kills red in one hit.
# - Body shot takes two hits.
# - You died screen and respawn still work.
# - Terrain hit = dust. Enemy hit = red particles. Friendly hit = no damage.

@onready var head: Node3D = get_node_or_null("Head")
@onready var collision: CollisionShape3D = get_node_or_null("CollisionShape3D") as CollisionShape3D
@onready var gun: Node3D = get_node_or_null("Gun")

@onready var gun_shot: Node = find_child("Gun Shot", true, false)
@onready var walk_sound: Node = find_child("Walk", true, false)
@onready var jump_sound: Node = find_child("Jump", true, false)
@onready var land_sound: Node = find_child("Land", true, false)

const SPEED: float = 6.0
const SPRINT: float = 10.0
const CROUCH_SPEED: float = 3.0
const JUMP: float = 9.0
const GRAVITY: float = 20.0

const MIN_BOUND: float = -490.0
const MAX_BOUND: float = 490.0

const PLAYER_MAX_HEALTH: int = 20
const RESPAWN_HEALTH: int = 20

var player_health: int = PLAYER_MAX_HEALTH
var player_dead: bool = false
var spawn_position: Vector3 = Vector3.ZERO
var spawn_rotation: Vector3 = Vector3.ZERO

const SOUND_VOLUME_DB: float = 24.0
const WALK_PITCH: float = 1.0
const SPRINT_WALK_PITCH: float = 1.55
const CROUCH_WALK_PITCH: float = 0.75

const FIRE_COOLDOWN: float = 0.32
const SHOOT_WHILE_MOUSE_HELD: bool = true
const SHOOT_RANGE: float = 380.0
const BODY_DAMAGE: int = 1
const HEADSHOT_DAMAGE: int = 999

const MAX_AMMO: int = 25
const RELOAD_TIME: float = 5.0
const RELOAD_MOVE_SPEED: float = 1.6

const MAX_STAMINA: float = 500.0
const STAMINA_DRAIN_RATE: float = 28.0
const STAMINA_RECHARGE_RATE: float = 22.0
const MIN_STAMINA_TO_SPRINT: float = 12.0

const CAMERA_RECOIL_AMOUNT: float = 1.15
const CAMERA_RECOIL_RECOVER_SPEED: float = 18.0
const GUN_RECOIL_AMOUNT: float = 0.16
const GUN_RECOIL_RECOVER_SPEED: float = 22.0

const DOUBLE_TAP_TIME: float = 0.25

const STAND_HEAD_HEIGHT: float = 1.6
const CROUCH_HEAD_HEIGHT: float = 0.9
const STAND_CAPSULE_HEIGHT: float = 1.6
const CROUCH_CAPSULE_HEIGHT: float = 0.9
const CAPSULE_RADIUS: float = 0.4

var gun_idle_pos: Vector3 = Vector3(3.585, 0.08, -0.54)
var gun_move_pos: Vector3 = Vector3(-0.47, -0.08, -3.68)
var gun_crouch_offset: Vector3 = Vector3(0.0, -0.45, 0.0)

var gun_idle_rot: Vector3 = Vector3(0.0, -90.0, 0.0)
var gun_move_rot: Vector3 = Vector3(0.0, 0.0, 0.0)

var mouse_sensitivity: float = 0.055
var camera_angle: float = 0.0
var fire_timer: float = 0.0
var camera_recoil: float = 0.0
var gun_recoil: float = 0.0
var last_w_tap_time: float = -10.0
var sprinting: bool = false
var ammo: int = MAX_AMMO
var current_max_ammo: int = MAX_AMMO
var is_reloading: bool = false
var reload_timer: float = 0.0
var current_reload_time: float = RELOAD_TIME
var stamina: float = MAX_STAMINA
var current_sprint_speed: float = SPRINT
var current_max_stamina: float = MAX_STAMINA
var current_stamina_recharge_rate: float = STAMINA_RECHARGE_RATE
var current_max_health: int = PLAYER_MAX_HEALTH
var current_fire_cooldown: float = FIRE_COOLDOWN
var final_boss_reward_power_mode: bool = false
var walk_bob_time: float = 0.0
var camera_roll: float = 0.0
var last_mouse_x: float = 0.0

var gun_base_pos: Vector3 = Vector3.ZERO
var gun_base_rot: Vector3 = Vector3.ZERO

var ui_layer: CanvasLayer = null
var health_label: Label = null
var health_bar_back: ColorRect = null
var health_bar_fill: ColorRect = null
var stamina_label: Label = null
var stamina_bar_back: ColorRect = null
var stamina_bar_fill: ColorRect = null
var ammo_label: Label = null
var crosshair_label: Label = null
var damage_flash: ColorRect = null
var death_panel: ColorRect = null
var death_label: Label = null
var fog_overlay: ColorRect = null
var player_world_environment: WorldEnvironment = null


const PLAYER_UI_UPDATE_INTERVAL: float = 0.10
var player_ui_update_timer: float = 0.0

# ---------------- HELICOPTER VEHICLE HANDOFF ----------------
var in_helicopter: bool = false
var active_helicopter: Node3D = null
var stored_player_visible: bool = true
var vehicle_camera: Camera3D = null
var saved_camera_top_level: bool = false
var saved_camera_transform: Transform3D = Transform3D.IDENTITY



var online_local_damage_lock: bool = false


func online_is_active() -> bool:
	return false


func online_is_local_player() -> bool:
	return true


func online_is_server() -> bool:
	return true


func online_refresh_local_only_nodes() -> void:
	var local_player: bool = online_is_local_player()
	set_process_input(local_player)

	var camera: Camera3D = get_player_camera()
	if camera != null:
		camera.current = local_player

	if ui_layer != null:
		ui_layer.visible = local_player


@rpc("any_peer", "reliable")

func set_player_ui_visible(visible_now: bool) -> void:
	if ui_layer != null:
		ui_layer.visible = visible_now

func server_damage_npc(npc_path: NodePath, amount: int, headshot: bool) -> void:
	# Client shots ask the server to apply the actual damage.
	# This keeps enemy health and kills controlled by the server.
	if online_is_active() and not multiplayer.is_server():
		return

	var npc: Node = get_node_or_null(npc_path)
	if npc == null or not npc is Node3D:
		return

	_apply_npc_damage_local(npc as Node3D, amount, headshot)


@rpc("any_peer", "call_local", "reliable")
func client_take_damage(amount: int) -> void:
	# In online mode, only accept health damage sent by the server.
	if online_is_active() and multiplayer.get_remote_sender_id() != 1 and not multiplayer.is_server():
		return

	_apply_player_damage_local(amount)


func _ready() -> void:
	name = "CameraRig"
	add_to_group("Player")
	add_to_group("BlueTeam")
	set_meta("team", "blue")
	set_meta("is_player", true)

	if collision == null:
		collision = get_node_or_null("CollisionShape") as CollisionShape3D

	spawn_position = global_position
	spawn_rotation = rotation_degrees

	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	floor_snap_length = 0.8
	setup_player_fog()

	setup_audio()
	if online_is_local_player():
		create_ui()
	call_deferred("online_refresh_local_only_nodes")

	if head:
		head.position.y = STAND_HEAD_HEIGHT

	if collision and collision.shape and collision.shape is CapsuleShape3D:
		var capsule: CapsuleShape3D = collision.shape as CapsuleShape3D
		capsule.height = STAND_CAPSULE_HEIGHT
		capsule.radius = CAPSULE_RADIUS

	if gun:
		gun_base_pos = gun_idle_pos
		gun_base_rot = gun_idle_rot
		gun.position = gun_base_pos
		gun.rotation_degrees = gun_base_rot

	print("PLAYER READY")

func setup_player_fog() -> void:
	if not PLAYER_FOG_ENABLED:
		return

	var existing_world_environment: Node = get_tree().root.find_child("WorldEnvironment", true, false)

	if existing_world_environment != null and existing_world_environment is WorldEnvironment:
		player_world_environment = existing_world_environment as WorldEnvironment
	else:
		player_world_environment = WorldEnvironment.new()
		player_world_environment.name = "PlayerFogWorldEnvironment"
		var scene_root: Node = get_tree().current_scene
		if scene_root != null:
			scene_root.add_child(player_world_environment)
		else:
			add_child(player_world_environment)

	if player_world_environment.environment == null:
		player_world_environment.environment = Environment.new()

	var env: Environment = player_world_environment.environment

	# Godot Environment fog properties vary by version.
	# Set each fog property only if this Godot build supports it.
	set_environment_property_if_available(env, "fog_enabled", true)
	set_environment_property_if_available(env, "fog_light_color", PLAYER_FOG_COLOR)
	set_environment_property_if_available(env, "fog_light_energy", PLAYER_FOG_LIGHT_ENERGY)
	set_environment_property_if_available(env, "fog_density", PLAYER_FOG_DENSITY)
	set_environment_property_if_available(env, "fog_height_density", PLAYER_FOG_HEIGHT_DENSITY)
	set_environment_property_if_available(env, "fog_height_falloff", PLAYER_FOG_HEIGHT_FALLOFF)
	set_environment_property_if_available(env, "fog_sky_affect", PLAYER_FOG_SKY_AFFECT)
	set_environment_property_if_available(env, "fog_aerial_perspective", PLAYER_FOG_AERIAL_PERSPECTIVE)


func environment_has_property(env: Environment, property_name: String) -> bool:
	if env == null:
		return false

	for property_info in env.get_property_list():
		if property_info.has("name") and String(property_info["name"]) == property_name:
			return true

	return false


func set_environment_property_if_available(env: Environment, property_name: String, value: Variant) -> void:
	if env == null:
		return

	if environment_has_property(env, property_name):
		env.set(property_name, value)


func setup_screen_haze() -> void:
	if not PLAYER_FOG_ENABLED or ui_layer == null:
		return

	fog_overlay = ColorRect.new()
	fog_overlay.name = "PlayerScreenHaze"
	fog_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	fog_overlay.color = Color(PLAYER_FOG_COLOR.r, PLAYER_FOG_COLOR.g, PLAYER_FOG_COLOR.b, PLAYER_SCREEN_HAZE_ALPHA)
	fog_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	fog_overlay.z_index = -100
	ui_layer.add_child(fog_overlay)



func create_ui() -> void:
	ui_layer = CanvasLayer.new()
	ui_layer.name = "PlayerUI"
	add_child(ui_layer)

	setup_screen_haze()

	health_label = Label.new()
	health_label.name = "HealthLabel"
	health_label.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	health_label.position = Vector2(20.0, -102.0)
	health_label.text = "HP: 20/20"
	health_label.add_theme_font_size_override("font_size", 18)
	ui_layer.add_child(health_label)

	health_bar_back = ColorRect.new()
	health_bar_back.name = "HealthBarBack"
	health_bar_back.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	health_bar_back.position = Vector2(20.0, -76.0)
	health_bar_back.size = Vector2(150.0, 14.0)
	health_bar_back.color = Color(0.05, 0.05, 0.05, 0.90)
	ui_layer.add_child(health_bar_back)

	health_bar_fill = ColorRect.new()
	health_bar_fill.name = "HealthBarFill"
	health_bar_fill.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	health_bar_fill.position = Vector2(22.0, -74.0)
	health_bar_fill.size = Vector2(146.0, 10.0)
	health_bar_fill.color = Color(0.0, 0.75, 0.15, 0.95)
	ui_layer.add_child(health_bar_fill)

	stamina_label = Label.new()
	stamina_label.name = "StaminaLabel"
	stamina_label.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	stamina_label.position = Vector2(20.0, -58.0)
	stamina_label.text = "STAMINA"
	stamina_label.add_theme_font_size_override("font_size", 14)
	ui_layer.add_child(stamina_label)

	stamina_bar_back = ColorRect.new()
	stamina_bar_back.name = "StaminaBarBack"
	stamina_bar_back.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	stamina_bar_back.position = Vector2(20.0, -36.0)
	stamina_bar_back.size = Vector2(150.0, 12.0)
	stamina_bar_back.color = Color(0.05, 0.05, 0.05, 0.90)
	ui_layer.add_child(stamina_bar_back)

	stamina_bar_fill = ColorRect.new()
	stamina_bar_fill.name = "StaminaBarFill"
	stamina_bar_fill.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	stamina_bar_fill.position = Vector2(22.0, -34.0)
	stamina_bar_fill.size = Vector2(146.0, 8.0)
	stamina_bar_fill.color = Color(0.1, 0.45, 1.0, 0.95)
	ui_layer.add_child(stamina_bar_fill)

	ammo_label = Label.new()
	ammo_label.name = "AmmoLabel"
	ammo_label.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	ammo_label.position = Vector2(20.0, -22.0)
	ammo_label.text = "AMMO: 25/25"
	ammo_label.add_theme_font_size_override("font_size", 16)
	ui_layer.add_child(ammo_label)

	crosshair_label = Label.new()
	crosshair_label.name = "Crosshair"
	crosshair_label.text = "+"
	crosshair_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	crosshair_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	crosshair_label.add_theme_font_size_override("font_size", 46)
	crosshair_label.anchor_left = 0.5
	crosshair_label.anchor_right = 0.5
	crosshair_label.anchor_top = 0.5
	crosshair_label.anchor_bottom = 0.5
	crosshair_label.offset_left = -24.0
	crosshair_label.offset_right = 24.0
	crosshair_label.offset_top = -24.0
	crosshair_label.offset_bottom = 24.0
	ui_layer.add_child(crosshair_label)

	damage_flash = ColorRect.new()
	damage_flash.name = "DamageFlash"
	damage_flash.set_anchors_preset(Control.PRESET_FULL_RECT)
	damage_flash.color = Color(0.8, 0.0, 0.0, 0.0)
	damage_flash.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ui_layer.add_child(damage_flash)

	death_panel = ColorRect.new()
	death_panel.name = "DeathPanel"
	death_panel.set_anchors_preset(Control.PRESET_FULL_RECT)
	death_panel.color = Color(0.0, 0.0, 0.0, 0.72)
	death_panel.visible = false
	death_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ui_layer.add_child(death_panel)

	death_label = Label.new()
	death_label.name = "DeathLabel"
	death_label.text = "YOU ARE OUT\nPRESS R TO RESPAWN"
	death_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	death_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	death_label.add_theme_font_size_override("font_size", 46)
	death_label.set_anchors_preset(Control.PRESET_FULL_RECT)
	death_label.visible = false
	ui_layer.add_child(death_label)

func update_ui_throttled(delta: float) -> void:
	player_ui_update_timer -= delta
	if player_ui_update_timer > 0.0:
		return
	player_ui_update_timer = PLAYER_UI_UPDATE_INTERVAL
	update_ui()


func apply_economy_upgrades(
	sprint_level: int,
	stamina_level: int,
	arg3: int,
	arg4: int,
	arg5: Variant,
	arg6: Variant,
	arg7: Variant,
	arg8: Variant,
	arg9: Variant,
	arg10: Variant = null,
	arg11: Variant = null,
	arg12: Variant = null
) -> void:
	# Supports both versions:
	# OLD 10-argument call:
	#   sprint, stamina, health, fire_rate, sprint_bonus, stamina_bonus,
	#   health_bonus, cooldown_base, cooldown_reduction, cooldown_min
	#
	# NEW 12-argument call:
	#   sprint, stamina, stamina_regen, health, fire_rate, sprint_bonus,
	#   stamina_bonus, stamina_regen_bonus, health_bonus,
	#   cooldown_base, cooldown_reduction, cooldown_min

	var stamina_regen_level: int = 0
	var health_level: int = 0
	var fire_rate_level: int = 0

	var sprint_bonus_per_level: float = 0.0
	var stamina_bonus_per_level: float = 0.0
	var stamina_regen_bonus_per_level: float = 0.0
	var health_bonus_per_level: int = 0

	var fire_cooldown_base: float = FIRE_COOLDOWN
	var fire_cooldown_reduction_per_level: float = 0.0
	var fire_cooldown_min: float = FIRE_COOLDOWN

	if arg12 != null:
		# New 12-argument version.
		stamina_regen_level = int(arg3)
		health_level = int(arg4)
		fire_rate_level = int(arg5)

		sprint_bonus_per_level = float(arg6)
		stamina_bonus_per_level = float(arg7)
		stamina_regen_bonus_per_level = float(arg8)
		health_bonus_per_level = int(arg9)

		fire_cooldown_base = float(arg10)
		fire_cooldown_reduction_per_level = float(arg11)
		fire_cooldown_min = float(arg12)
	else:
		# Old 10-argument version.
		health_level = int(arg3)
		fire_rate_level = int(arg4)

		sprint_bonus_per_level = float(arg5)
		stamina_bonus_per_level = float(arg6)
		health_bonus_per_level = int(arg7)

		fire_cooldown_base = float(arg8)
		fire_cooldown_reduction_per_level = float(arg9)
		fire_cooldown_min = float(arg10)

	current_sprint_speed = SPRINT + float(sprint_level) * sprint_bonus_per_level
	current_max_stamina = MAX_STAMINA + float(stamina_level) * stamina_bonus_per_level
	current_stamina_recharge_rate = STAMINA_RECHARGE_RATE + float(stamina_regen_level) * stamina_regen_bonus_per_level
	current_max_health = PLAYER_MAX_HEALTH + health_level * health_bonus_per_level

	current_fire_cooldown = max(
		fire_cooldown_base - float(fire_rate_level) * fire_cooldown_reduction_per_level,
		fire_cooldown_min
	)

	stamina = min(stamina, current_max_stamina)
	player_health = min(player_health, current_max_health)

	if health_level > 0:
		player_health = current_max_health

	update_ui()




func set_ammo_upgrade(level: int, base_ammo: int, ammo_per_level: int) -> void:
	var old_max: int = current_max_ammo
	current_max_ammo = base_ammo + level * ammo_per_level

	if current_max_ammo < base_ammo:
		current_max_ammo = base_ammo

	# If the player bought more ammo capacity, give the extra ammo immediately.
	if current_max_ammo > old_max:
		ammo += current_max_ammo - old_max

	ammo = clamp(ammo, 0, current_max_ammo)
	update_ui()


func set_reload_upgrade(level: int, base_time: float, reduction_per_level: float, minimum_time: float) -> void:
	current_reload_time = max(base_time - float(level) * reduction_per_level, minimum_time)


func start_reload_from_battle_manager() -> void:
	if player_dead:
		return

	if is_reloading:
		return

	if ammo >= current_max_ammo:
		return

	start_reload()


func refill_ammo_from_battle_manager() -> void:
	# Compatibility alias. This no longer instantly refills ammo.
	start_reload_from_battle_manager()

func update_ui() -> void:
	if health_label:
		health_label.text = "HP: " + str(player_health) + "/" + str(current_max_health)

	if health_bar_fill:
		var health_ratio: float = clamp(float(player_health) / float(current_max_health), 0.0, 1.0)
		health_bar_fill.size.x = 146.0 * health_ratio

		if health_ratio > 0.50:
			health_bar_fill.color = Color(0.0, 0.75, 0.15, 0.95)
		elif health_ratio > 0.25:
			health_bar_fill.color = Color(0.95, 0.75, 0.05, 0.95)
		else:
			health_bar_fill.color = Color(0.95, 0.05, 0.05, 0.95)

	if stamina_bar_fill:
		var stamina_ratio: float = clamp(stamina / current_max_stamina, 0.0, 1.0)
		stamina_bar_fill.size.x = 146.0 * stamina_ratio

	if stamina_label:
		if sprinting:
			stamina_label.text = "STAMINA - RUN"
		elif stamina < MIN_STAMINA_TO_SPRINT:
			stamina_label.text = "STAMINA - LOW"
		else:
			stamina_label.text = "STAMINA"

	if ammo_label:
		if is_reloading:
			ammo_label.text = "RELOADING: " + str(ceil(reload_timer)) + "s"
		else:
			ammo_label.text = "AMMO: " + str(ammo) + "/" + str(current_max_ammo)

	if crosshair_label:
		crosshair_label.visible = not player_dead

	if death_panel:
		death_panel.visible = player_dead

	if death_label:
		death_label.visible = player_dead

func setup_audio() -> void:
	setup_one_audio(gun_shot)
	setup_one_audio(walk_sound)
	setup_one_audio(jump_sound)
	setup_one_audio(land_sound)


func setup_one_audio(sound_node: Node) -> void:
	if sound_node == null:
		return

	if sound_node is AudioStreamPlayer:
		var audio: AudioStreamPlayer = sound_node as AudioStreamPlayer
		audio.volume_db = SOUND_VOLUME_DB
		audio.bus = "Master"
		audio.autoplay = false
	elif sound_node is AudioStreamPlayer2D:
		var audio_2d: AudioStreamPlayer2D = sound_node as AudioStreamPlayer2D
		audio_2d.volume_db = SOUND_VOLUME_DB
		audio_2d.bus = "Master"
		audio_2d.autoplay = false
	elif sound_node is AudioStreamPlayer3D:
		var audio_3d: AudioStreamPlayer3D = sound_node as AudioStreamPlayer3D
		audio_3d.volume_db = SOUND_VOLUME_DB
		audio_3d.bus = "Master"
		audio_3d.autoplay = false
		audio_3d.max_distance = 1000.0
		audio_3d.unit_size = 1.0



func update_reload(delta: float) -> void:
	if not is_reloading:
		return

	reload_timer -= delta

	if reload_timer <= 0.0:
		reload_timer = 0.0
		ammo = current_max_ammo
		is_reloading = false


func start_reload() -> void:
	if player_dead:
		return

	if is_reloading:
		return

	if ammo >= current_max_ammo:
		return

	is_reloading = true
	reload_timer = current_reload_time
	sprinting = false


func update_stamina(delta: float, wants_to_sprint: bool, moving: bool, crouching: bool) -> void:
	if is_reloading or crouching or not moving:
		sprinting = false

	if wants_to_sprint and moving and not crouching and not is_reloading and stamina > MIN_STAMINA_TO_SPRINT:
		sprinting = true

	if sprinting and moving and not crouching and not is_reloading:
		stamina -= STAMINA_DRAIN_RATE * delta
		if stamina <= 0.0:
			stamina = 0.0
			sprinting = false
	else:
		stamina += STAMINA_RECHARGE_RATE * delta
		stamina = min(stamina, current_max_stamina)

	if stamina < MIN_STAMINA_TO_SPRINT:
		sprinting = false



func get_current_move_speed(base_speed: float) -> float:
	if is_reloading:
		return min(base_speed, RELOAD_MOVE_SPEED)

	return base_speed


func _physics_process(delta: float) -> void:
	if not online_is_local_player():
		velocity = Vector3.ZERO
		return

	apply_final_boss_reward_power_mode()
	update_reload(delta)
	update_ui_throttled(delta)
	update_damage_flash(delta)

	if in_helicopter:
		velocity = Vector3.ZERO
		return

	if player_dead:
		velocity = Vector3.ZERO
		if Input.is_key_pressed(KEY_R):
			respawn_player()
		return

	var was_on_floor: bool = is_on_floor()

	if fire_timer > 0.0:
		fire_timer = max(fire_timer - delta, 0.0)

	# More reliable shooting: Godot can miss a single mouse-click event during
	# mouse capture, focus changes, or low frame rate. Checking the held mouse
	# state every physics frame makes the laser fire consistently.
	if SHOOT_WHILE_MOUSE_HELD and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		shoot()

	camera_recoil = lerp(camera_recoil, 0.0, delta * CAMERA_RECOIL_RECOVER_SPEED)
	gun_recoil = lerp(gun_recoil, 0.0, delta * GUN_RECOIL_RECOVER_SPEED)

	if not is_on_floor():
		velocity.y -= GRAVITY * delta
	else:
		if velocity.y < 0.0:
			velocity.y = 0.0

		if Input.is_key_pressed(KEY_SPACE):
			velocity.y = JUMP
			play_sound(jump_sound)

	var crouching: bool = Input.is_key_pressed(KEY_SHIFT)

	if crouching:
		sprinting = false

	if head:
		var target_head_height: float = CROUCH_HEAD_HEIGHT if crouching else STAND_HEAD_HEIGHT
		head.position.y = lerp(head.position.y, target_head_height, delta * 12.0)

	if collision and collision.shape and collision.shape is CapsuleShape3D:
		var capsule: CapsuleShape3D = collision.shape as CapsuleShape3D
		var target_capsule_height: float = CROUCH_CAPSULE_HEIGHT if crouching else STAND_CAPSULE_HEIGHT
		capsule.height = lerp(capsule.height, target_capsule_height, delta * 12.0)
		capsule.radius = CAPSULE_RADIUS

	var direction: Vector3 = get_move_direction()
	var moving_input: bool = direction.length() > 0.0
	var wants_to_sprint: bool = sprinting and Input.is_key_pressed(KEY_W)
	update_stamina(delta, wants_to_sprint, moving_input, crouching)

	var speed: float = SPEED

	if is_reloading:
		speed = RELOAD_MOVE_SPEED
	elif crouching:
		speed = CROUCH_SPEED
	elif sprinting and Input.is_key_pressed(KEY_W):
		speed = current_sprint_speed

	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

	move_and_slide()

	if not was_on_floor and is_on_floor():
		play_sound(land_sound)

	var moving: bool = direction.length() > 0.0 and is_on_floor()
	update_walk_sound(moving, sprinting, crouching)

	var target_roll: float = clamp(last_mouse_x * -0.4, -6.0, 6.0)
	camera_roll = lerp(camera_roll, target_roll, delta * 8.0)

	if head:
		head.rotation_degrees.x = camera_angle - camera_recoil
		head.rotation_degrees.z = camera_roll

	update_gun(delta, moving, crouching)

	global_position.x = clamp(global_position.x, MIN_BOUND, MAX_BOUND)
	global_position.z = clamp(global_position.z, MIN_BOUND, MAX_BOUND)

func get_move_direction() -> Vector3:
	var direction: Vector3 = Vector3.ZERO

	var forward: Vector3 = -global_transform.basis.z
	var right: Vector3 = global_transform.basis.x

	forward.y = 0.0
	right.y = 0.0

	forward = forward.normalized()
	right = right.normalized()

	if Input.is_key_pressed(KEY_W):
		direction += forward
	else:
		sprinting = false

	if Input.is_key_pressed(KEY_S):
		direction -= forward
		sprinting = false

	if Input.is_key_pressed(KEY_A):
		direction -= right

	if Input.is_key_pressed(KEY_D):
		direction += right

	if direction.length() > 0.0:
		direction = direction.normalized()

	return direction


func update_damage_flash(delta: float) -> void:
	if damage_flash == null:
		return

	var current_color: Color = damage_flash.color
	current_color.a = move_toward(current_color.a, 0.0, delta * 2.8)
	damage_flash.color = current_color


func update_gun(delta: float, moving: bool, crouching: bool) -> void:
	if gun == null:
		return

	var target_pos: Vector3 = gun_idle_pos
	var target_rot: Vector3 = gun_idle_rot

	if moving:
		target_pos = gun_move_pos
		target_rot = gun_move_rot

	gun_base_pos = gun_base_pos.lerp(target_pos, delta * 8.0)
	gun_base_rot = gun_base_rot.lerp(target_rot, delta * 8.0)

	var bob_offset: Vector3 = Vector3.ZERO
	var rot_offset: Vector3 = Vector3.ZERO

	if moving:
		var bob_speed: float = 8.0
		var bob_strength: float = 0.08
		var rot_strength: float = 2.0

		if sprinting and not crouching:
			bob_speed = 12.0
			bob_strength = 0.15
			rot_strength = 4.0
		elif crouching:
			bob_speed = 5.0
			bob_strength = 0.035
			rot_strength = 1.0

		walk_bob_time += delta * bob_speed
		bob_offset.y = sin(walk_bob_time) * bob_strength
		bob_offset.x = cos(walk_bob_time * 0.5) * (bob_strength * 0.5)
		rot_offset.z = sin(walk_bob_time * 0.5) * rot_strength
		rot_offset.x = cos(walk_bob_time) * (rot_strength * 0.5)
	else:
		walk_bob_time = 0.0
		var pitch: float = clamp(camera_angle, -70.0, 70.0)
		rot_offset.x = -pitch * 0.15

	var crouch_offset: Vector3 = Vector3.ZERO

	if crouching:
		crouch_offset = gun_crouch_offset

	var gun_recoil_offset: Vector3 = Vector3(0.0, gun_recoil * 0.12, gun_recoil * 0.35)

	gun.position = gun_base_pos + bob_offset + crouch_offset + gun_recoil_offset
	gun.rotation_degrees = gun_base_rot + rot_offset
	gun.rotation_degrees.z += camera_roll
	gun.rotation_degrees.x -= gun_recoil * 8.0


func _input(event: InputEvent) -> void:
	if not online_is_local_player():
		return

	if in_helicopter:
		return

	if player_dead:
		return

	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		camera_angle -= event.relative.y * mouse_sensitivity
		camera_angle = clamp(camera_angle, -90.0, 90.0)
		last_mouse_x = event.relative.x

		if head:
			head.rotation_degrees.x = camera_angle - camera_recoil

	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			shoot()

	if event is InputEventKey:
		if event.pressed and not event.echo:
			if event.keycode == KEY_Q:
				start_reload()

			if event.keycode == KEY_W:
				var current_time: float = Time.get_ticks_msec() / 1000.0

				if current_time - last_w_tap_time <= DOUBLE_TAP_TIME and stamina > MIN_STAMINA_TO_SPRINT and not is_reloading:
					sprinting = true

				last_w_tap_time = current_time


func spawn_player_laser_ray(start_position: Vector3, end_position: Vector3) -> void:
	var direction: Vector3 = end_position - start_position

	if direction.length() < 0.01:
		return

	var laser: MeshInstance3D = MeshInstance3D.new()
	laser.name = "PlayerLaserRay"

	var cylinder: CylinderMesh = CylinderMesh.new()
	cylinder.top_radius = PLAYER_LASER_WIDTH
	cylinder.bottom_radius = PLAYER_LASER_WIDTH
	cylinder.height = direction.length()
	cylinder.radial_segments = 8
	laser.mesh = cylinder

	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.albedo_color = PLAYER_LASER_COLOR
	material.emission_enabled = true
	material.emission = PLAYER_LASER_COLOR
	material.emission_energy_multiplier = 3.0
	laser.material_override = material

	get_tree().current_scene.add_child(laser)

	laser.global_position = start_position + direction * 0.5
	laser.look_at(end_position, Vector3.UP)
	laser.rotate_object_local(Vector3.RIGHT, deg_to_rad(90.0))

	await get_tree().create_timer(PLAYER_LASER_LIFETIME).timeout

	if is_instance_valid(laser):
		laser.queue_free()

func get_self_exclude_rids() -> Array[RID]:
	var excludes: Array[RID] = []
	_collect_collision_rids(self, excludes)
	return excludes


func _collect_collision_rids(node: Node, excludes: Array[RID]) -> void:
	if node is CollisionObject3D:
		var collision_object: CollisionObject3D = node as CollisionObject3D
		excludes.append(collision_object.get_rid())

	for child in node.get_children():
		_collect_collision_rids(child, excludes)


func shoot() -> void:
	if player_dead:
		return

	if is_reloading:
		return

	if fire_timer > 0.0:
		return

	if ammo <= 0:
		start_reload()
		return

	ammo -= 1
	fire_timer = current_fire_cooldown
	play_sound(gun_shot)

	camera_recoil += CAMERA_RECOIL_AMOUNT
	camera_recoil = clamp(camera_recoil, 0.0, 8.0)

	gun_recoil += GUN_RECOIL_AMOUNT
	gun_recoil = clamp(gun_recoil, 0.0, 0.6)

	var camera: Camera3D = get_viewport().get_camera_3d()

	if camera == null:
		print("No camera found.")
		return

	var start_position: Vector3 = camera.global_position
	var end_position: Vector3 = start_position + (-camera.global_transform.basis.z * SHOOT_RANGE)

	var query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(start_position, end_position)
	query.exclude = get_self_exclude_rids()
	query.collide_with_bodies = true
	query.collide_with_areas = true

	var hit: Dictionary = get_world_3d().direct_space_state.intersect_ray(query)

	if hit.size() <= 0:
		spawn_player_laser_ray(start_position, end_position)
		return

	var hit_object: Node = hit["collider"] as Node
	var hit_position: Vector3 = hit["position"] as Vector3

	spawn_player_laser_ray(start_position, hit_position)
	var hit_normal: Vector3 = Vector3.UP

	if hit.has("normal"):
		hit_normal = hit["normal"] as Vector3

	var npc: Node3D = find_npc_from_hit_object(hit_object)
	var hit_zone: String = get_hit_zone(hit_object)

	if npc == null:
		spawn_dust_particles(hit_position, hit_normal)
		return

	var npc_team: String = get_npc_team(npc)

	if npc_team == "blue":
		print("FRIENDLY LASER - NO TAG")
		spawn_dust_particles(hit_position, hit_normal)
		return

	if hit_zone == "head":
		spawn_npc_hit_particles(hit_position, hit_normal, true)
		damage_npc(npc, HEADSHOT_DAMAGE, true)
	else:
		spawn_npc_hit_particles(hit_position, hit_normal, false)
		damage_npc(npc, BODY_DAMAGE, false)


func get_npc_team(npc: Node) -> String:
	if npc == null:
		return ""

	if npc.has_meta("team"):
		return str(npc.get_meta("team"))

	if npc.is_in_group("BlueTeam"):
		return "blue"

	if npc.is_in_group("RedTeam"):
		return "red"

	return ""


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
		if node.is_in_group("BattleNPC") and node is Node3D:
			return node as Node3D

		if node.has_meta("npc_root"):
			var npc_root: Node = node.get_meta("npc_root") as Node
			if npc_root != null and npc_root is Node3D:
				return npc_root as Node3D

		node = node.get_parent()

	return null


func damage_npc(npc: Node3D, amount: int, headshot: bool) -> void:
	if npc == null or not is_instance_valid(npc):
		return

	# In online play, clients do not directly change NPC health.
	# They request the dedicated server to do it.
	if online_is_active() and not multiplayer.is_server():
		server_damage_npc.rpc_id(1, npc.get_path(), amount, headshot)
		return

	_apply_npc_damage_local(npc, amount, headshot)


func _apply_npc_damage_local(npc: Node3D, amount: int, headshot: bool) -> void:
	if npc == null or not is_instance_valid(npc):
		return

	if get_npc_team(npc) == "blue":
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
		notify_battle_manager_player_kill(headshot)


func take_damage(amount: int) -> void:
	# Server sends damage to the player who owns this character.
	if online_is_active() and multiplayer.is_server() and not is_multiplayer_authority():
		client_take_damage.rpc_id(get_multiplayer_authority(), amount)
		return

	_apply_player_damage_local(amount)


func _apply_player_damage_local(amount: int) -> void:
	if player_dead:
		return

	player_health -= amount
	player_health = max(player_health, 0)

	if damage_flash != null:
		damage_flash.color = Color(0.8, 0.0, 0.0, 0.38)

	update_ui()

	if player_health <= 0:
		die()


func die() -> void:
	player_dead = true
	velocity = Vector3.ZERO
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	update_ui()




# ---------------- HELICOPTER VEHICLE HANDOFF ----------------
func enter_helicopter(helicopter: Node3D) -> void:
	if helicopter == null or not is_instance_valid(helicopter):
		return

	if player_dead:
		return

	in_helicopter = true
	active_helicopter = helicopter
	velocity = Vector3.ZERO
	stored_player_visible = visible
	vehicle_camera = get_player_camera()
	if vehicle_camera != null:
		saved_camera_top_level = vehicle_camera.top_level
		saved_camera_transform = vehicle_camera.transform
		vehicle_camera.current = true

	# Do NOT set the whole player invisible here. That can also hide the camera/UI.
	# The helicopter now moves this player's existing camera while the player is piloting.
	set_player_vehicle_visuals(false)

	if collision:
		collision.disabled = true

	if walk_sound != null:
		if walk_sound is AudioStreamPlayer:
			(walk_sound as AudioStreamPlayer).stop()
		elif walk_sound is AudioStreamPlayer2D:
			(walk_sound as AudioStreamPlayer2D).stop()
		elif walk_sound is AudioStreamPlayer3D:
			(walk_sound as AudioStreamPlayer3D).stop()

	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func exit_helicopter(exit_position: Vector3, exit_rotation_y: float) -> void:
	in_helicopter = false
	active_helicopter = null
	visible = stored_player_visible
	set_player_vehicle_visuals(true)
	global_position = exit_position
	rotation.y = exit_rotation_y
	velocity = Vector3.ZERO
	sprinting = false
	camera_angle = 0.0
	camera_recoil = 0.0
	gun_recoil = 0.0

	if head:
		head.rotation_degrees = Vector3.ZERO
		head.position.y = STAND_HEAD_HEIGHT

	if vehicle_camera != null and is_instance_valid(vehicle_camera):
		vehicle_camera.top_level = saved_camera_top_level
		vehicle_camera.transform = saved_camera_transform
		vehicle_camera.current = true
	vehicle_camera = null

	if collision:
		collision.disabled = false

	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func set_vehicle_camera_pose(camera_world_position: Vector3, yaw_degrees: float, pitch_degrees: float) -> void:
	# Called by the helicopter while the player is inside it.
	# IMPORTANT: The actual Camera3D is placed in world space.
	# This prevents the camera from inheriting any side offset from the player's Head/Gun setup.
	if not in_helicopter:
		return

	velocity = Vector3.ZERO
	global_position = camera_world_position - Vector3(0.0, STAND_HEAD_HEIGHT, 0.0)
	rotation_degrees.y = yaw_degrees

	camera_angle = clamp(pitch_degrees, -75.0, 55.0)
	camera_recoil = lerp(camera_recoil, 0.0, 0.25)
	gun_recoil = lerp(gun_recoil, 0.0, 0.25)

	if head:
		head.position.y = STAND_HEAD_HEIGHT
		head.rotation_degrees = Vector3.ZERO

	if vehicle_camera == null or not is_instance_valid(vehicle_camera):
		vehicle_camera = get_player_camera()

	if vehicle_camera != null:
		vehicle_camera.top_level = true
		vehicle_camera.current = true
		vehicle_camera.global_position = camera_world_position
		vehicle_camera.global_rotation_degrees = Vector3(camera_angle - camera_recoil, yaw_degrees, 0.0)


func set_player_vehicle_visuals(show_visuals: bool) -> void:
	# Hide first-person gun while flying, but keep the camera and UI alive.
	if gun:
		gun.visible = show_visuals

	# Hide obvious body meshes if they are direct children, but never hide Head or PlayerUI.
	for child in get_children():
		if child == head or child == ui_layer:
			continue

		if child is MeshInstance3D:
			(child as MeshInstance3D).visible = show_visuals


func get_player_camera() -> Camera3D:
	var current_camera: Camera3D = get_viewport().get_camera_3d()
	if current_camera != null:
		return current_camera

	var cameras: Array[Node] = find_children("*", "Camera3D", true, false)
	for node in cameras:
		if node is Camera3D:
			return node as Camera3D

	return null




func reset_for_new_match(new_spawn_position: Vector3) -> void:
	# Called by BattleManager every time DEPLOY starts a new match.
	# This fixes starting the next round at the last position with low health.
	in_helicopter = false
	active_helicopter = null
	visible = true
	set_player_vehicle_visuals(true)
	vehicle_camera = null

	spawn_position = new_spawn_position
	spawn_rotation = Vector3.ZERO
	global_position = spawn_position
	rotation_degrees = spawn_rotation
	velocity = Vector3.ZERO

	set_meta("team", "blue")
	set_meta("is_player", true)
	player_dead = false
	player_health = current_max_health
	ammo = current_max_ammo
	is_reloading = false
	reload_timer = 0.0
	stamina = current_max_stamina
	sprinting = false
	fire_timer = 0.0
	camera_angle = 0.0
	camera_recoil = 0.0
	gun_recoil = 0.0

	if head:
		head.rotation_degrees = Vector3.ZERO

	if death_panel:
		death_panel.visible = false
	if death_label:
		death_label.visible = false

	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	update_ui()


func respawn_player() -> void:
	in_helicopter = false
	active_helicopter = null
	visible = stored_player_visible
	set_player_vehicle_visuals(true)
	if vehicle_camera != null and is_instance_valid(vehicle_camera):
		vehicle_camera.top_level = saved_camera_top_level
		vehicle_camera.transform = saved_camera_transform
		vehicle_camera.current = true
	vehicle_camera = null

	set_meta("team", "blue") # keep team on respawn
	set_meta("is_player", true)
	player_dead = false
	player_health = current_max_health
	ammo = current_max_ammo
	is_reloading = false
	reload_timer = 0.0
	stamina = current_max_stamina
	sprinting = false
	global_position = spawn_position
	rotation_degrees = spawn_rotation
	velocity = Vector3.ZERO
	camera_angle = 0.0
	camera_recoil = 0.0
	gun_recoil = 0.0

	if head:
		head.rotation_degrees = Vector3.ZERO

	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	update_ui()


func spawn_dust_particles(hit_position: Vector3, hit_normal: Vector3) -> void:
	if PLAYER_LASER_TAG_MODE:
		return

	spawn_particle_burst(
		hit_position + hit_normal * 0.03,
		hit_normal,
		Color(0.55, 0.48, 0.38, 1.0),
		Color(0.85, 0.77, 0.62, 1.0),
		30,
		0.35,
		0.045,
		0.11,
		2.0,
		7.0
	)


func spawn_npc_hit_particles(hit_position: Vector3, hit_normal: Vector3, headshot: bool) -> void:
	if PLAYER_LASER_TAG_MODE:
		return

	var amount: int = 38

	if headshot:
		amount = 65

	spawn_particle_burst(
		hit_position + hit_normal * 0.04,
		hit_normal,
		Color(0.42, 0.0, 0.0, 1.0),
		Color(0.95, 0.04, 0.02, 1.0),
		amount,
		0.35,
		0.035,
		0.09,
		4.0,
		11.0
	)


func spawn_particle_burst(
	hit_position: Vector3,
	hit_normal: Vector3,
	color_a: Color,
	color_b: Color,
	amount: int,
	lifetime: float,
	scale_min: float,
	scale_max: float,
	velocity_min: float,
	velocity_max: float
) -> void:
	if PLAYER_LASER_TAG_MODE:
		return

	var particles: GPUParticles3D = GPUParticles3D.new()
	particles.name = "ImpactParticles"
	particles.amount = amount
	particles.lifetime = lifetime
	particles.one_shot = true
	particles.emitting = true
	particles.local_coords = false

	var particle_material: ParticleProcessMaterial = ParticleProcessMaterial.new()
	particle_material.direction = hit_normal.normalized()
	particle_material.spread = 70.0
	particle_material.initial_velocity_min = velocity_min
	particle_material.initial_velocity_max = velocity_max
	particle_material.gravity = Vector3(0.0, -7.5, 0.0)
	particle_material.scale_min = scale_min
	particle_material.scale_max = scale_max
	particle_material.color = color_a
	particle_material.color_ramp = make_two_color_ramp(color_a, color_b)

	particles.process_material = particle_material

	var particle_mesh: SphereMesh = SphereMesh.new()
	particle_mesh.radius = 0.04
	particle_mesh.height = 0.08
	particles.draw_pass_1 = particle_mesh

	get_tree().current_scene.add_child(particles)
	particles.global_position = hit_position

	await get_tree().create_timer(lifetime + 0.25).timeout

	if is_instance_valid(particles):
		particles.queue_free()


func make_two_color_ramp(color_a: Color, color_b: Color) -> GradientTexture1D:
	var gradient: Gradient = Gradient.new()
	gradient.set_color(0, color_a)
	gradient.set_color(1, color_b)

	var texture: GradientTexture1D = GradientTexture1D.new()
	texture.gradient = gradient
	return texture


func play_sound(sound_node: Node) -> void:
	if sound_node == null:
		return

	if sound_node is AudioStreamPlayer:
		var audio: AudioStreamPlayer = sound_node as AudioStreamPlayer
		if audio.stream == null:
			return
		audio.volume_db = SOUND_VOLUME_DB
		audio.stop()
		audio.play(0.0)
	elif sound_node is AudioStreamPlayer2D:
		var audio_2d: AudioStreamPlayer2D = sound_node as AudioStreamPlayer2D
		if audio_2d.stream == null:
			return
		audio_2d.volume_db = SOUND_VOLUME_DB
		audio_2d.stop()
		audio_2d.play(0.0)
	elif sound_node is AudioStreamPlayer3D:
		var audio_3d: AudioStreamPlayer3D = sound_node as AudioStreamPlayer3D
		if audio_3d.stream == null:
			return
		audio_3d.volume_db = SOUND_VOLUME_DB
		audio_3d.max_distance = 1000.0
		audio_3d.unit_size = 1.0
		audio_3d.stop()
		audio_3d.play(0.0)


func update_walk_sound(moving: bool, sprinting_now: bool, crouching_now: bool) -> void:
	if walk_sound == null:
		return

	var pitch: float = WALK_PITCH

	if sprinting_now and not crouching_now:
		pitch = SPRINT_WALK_PITCH
	elif crouching_now:
		pitch = CROUCH_WALK_PITCH

	if walk_sound is AudioStreamPlayer:
		var audio: AudioStreamPlayer = walk_sound as AudioStreamPlayer
		if audio.stream == null:
			return
		audio.volume_db = SOUND_VOLUME_DB
		audio.pitch_scale = pitch

		if moving and not audio.playing:
			audio.play(0.0)
		elif not moving and audio.playing:
			audio.stop()

	elif walk_sound is AudioStreamPlayer2D:
		var audio_2d: AudioStreamPlayer2D = walk_sound as AudioStreamPlayer2D
		if audio_2d.stream == null:
			return
		audio_2d.volume_db = SOUND_VOLUME_DB
		audio_2d.pitch_scale = pitch

		if moving and not audio_2d.playing:
			audio_2d.play(0.0)
		elif not moving and audio_2d.playing:
			audio_2d.stop()

	elif walk_sound is AudioStreamPlayer3D:
		var audio_3d: AudioStreamPlayer3D = walk_sound as AudioStreamPlayer3D
		if audio_3d.stream == null:
			return
		audio_3d.volume_db = SOUND_VOLUME_DB
		audio_3d.pitch_scale = pitch
		audio_3d.max_distance = 1000.0
		audio_3d.unit_size = 1.0

		if moving and not audio_3d.playing:
			audio_3d.play(0.0)
		elif not moving and audio_3d.playing:
			audio_3d.stop()


func notify_battle_manager_player_kill(headshot: bool) -> void:
	var battle_manager: Node = get_tree().current_scene.find_child("BattleManager", true, false)

	if battle_manager == null:
		battle_manager = get_tree().current_scene.find_child("EnemyManager", true, false)

	if battle_manager == null:
		return

	if battle_manager.has_method("record_player_kill"):
		battle_manager.call("record_player_kill", headshot)


func enable_final_boss_reward_power_mode() -> void:
	final_boss_reward_power_mode = true
	current_max_ammo = 999999
	ammo = current_max_ammo
	is_reloading = false
	reload_timer = 0.0
	current_reload_time = 0.05
	current_fire_cooldown = 0.03
	current_max_stamina = 999999.0
	stamina = current_max_stamina
	current_stamina_recharge_rate = 999999.0



func apply_final_boss_reward_power_mode() -> void:
	if not final_boss_reward_power_mode:
		return

	current_max_ammo = 999999
	ammo = current_max_ammo
	is_reloading = false
	reload_timer = 0.0
	current_reload_time = 0.05
	current_fire_cooldown = 0.03
	current_max_stamina = 999999.0
	stamina = current_max_stamina
	current_stamina_recharge_rate = 999999.0



func disable_final_boss_reward_power_mode() -> void:
	final_boss_reward_power_mode = false
	is_reloading = false
	reload_timer = 0.0
