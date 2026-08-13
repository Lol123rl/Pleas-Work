extends Node3D

# Dark fog zone centered on world origin.
const DARK_ZONE_CENTER: Vector3 = Vector3(0.0, 0.0, 0.0)
const DARK_ZONE_SIZE: Vector3 = Vector3(700.0, 700.0, 700.0)

# Fog settings.
const FOG_COLOR: Color = Color(0.0, 0.0, 0.0, 1.0)
const FOG_DENSITY: float = 0.12
const FOG_ENERGY: float = 0.35

# Optional darker world background.
const BACKGROUND_COLOR: Color = Color(0.005, 0.007, 0.012, 1.0)

var world_environment: WorldEnvironment = null
var fog_volume: FogVolume = null


func _ready() -> void:
	setup_dark_world_environment()
	setup_dark_fog_volume()


func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("random"):
		if has_node("Environment"):
			$Environment.rotate_y(0.075)

	if Input.is_action_pressed("lighting"):
		if has_node("Environment/AnimationPlayer"):
			$Environment/AnimationPlayer.speed_scale = 2.0
			await get_tree().create_timer(0.5).timeout
			$Environment/AnimationPlayer.speed_scale = 0.01


func setup_dark_world_environment() -> void:
	# Use an existing WorldEnvironment if the scene already has one.
	world_environment = find_child("WorldEnvironment", true, false) as WorldEnvironment

	# If no WorldEnvironment exists, create one.
	if world_environment == null:
		world_environment = WorldEnvironment.new()
		world_environment.name = "WorldEnvironment"
		add_child(world_environment)

	if world_environment.environment == null:
		world_environment.environment = Environment.new()

	var env: Environment = world_environment.environment

	# Dark background.
	env.background_mode = Environment.BG_COLOR
	env.background_color = BACKGROUND_COLOR

	# Basic environment fog.
	env.fog_enabled = true
	env.fog_light_color = FOG_COLOR
	env.fog_density = FOG_DENSITY

	# Version-safe optional fog settings.
	set_env_property_if_available(env, "fog_sky_affect", 1.0)
	set_env_property_if_available(env, "fog_light_energy", FOG_ENERGY)
	set_env_property_if_available(env, "fog_aerial_perspective", 0.45)

	# Tone down brightness.
	set_env_property_if_available(env, "ambient_light_energy", 0.08)
	set_env_property_if_available(env, "ambient_light_color", Color(0.04, 0.05, 0.07, 1.0))


func setup_dark_fog_volume() -> void:
	# Godot 4 FogVolume. This creates the large local fog block.
	fog_volume = find_child("DarkFogVolume", true, false) as FogVolume

	if fog_volume == null:
		fog_volume = FogVolume.new()
		fog_volume.name = "DarkFogVolume"
		add_child(fog_volume)

	fog_volume.global_position = DARK_ZONE_CENTER
	fog_volume.size = DARK_ZONE_SIZE

	var fog_material: FogMaterial = FogMaterial.new()

	fog_material.albedo = FOG_COLOR
	fog_material.density = FOG_DENSITY

	# Darker/denser looking fog.
	set_fog_material_property_if_available(fog_material, "emission", Color(0.0, 0.0, 0.0, 1.0))
	set_fog_material_property_if_available(fog_material, "height_falloff", 0.0)

	fog_volume.material = fog_material


func set_env_property_if_available(env: Environment, property_name: String, value: Variant) -> void:
	if env == null:
		return

	for property_info in env.get_property_list():
		if property_info.has("name") and property_info["name"] == property_name:
			env.set(property_name, value)
			return


func set_fog_material_property_if_available(material: FogMaterial, property_name: String, value: Variant) -> void:
	if material == null:
		return

	for property_info in material.get_property_list():
		if property_info.has("name") and property_info["name"] == property_name:
			material.set(property_name, value)
			return
