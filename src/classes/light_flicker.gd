@tool
extends OmniLight3D

@export var base_energy: float = 3.0
@export_range(0.0, 1.0, 0.01) var flicker_strength: float = 1.0
@export var flicker_speed: float = 1.0

static var noise : FastNoiseLite = FastNoiseLite.new()

func _process(_delta:float):
	var val: float = 0.1 * flicker_speed * ((Time.get_ticks_msec() % 10000) + global_position.length_squared())
	light_energy = base_energy - (flicker_strength * base_energy * (noise.get_noise_1d(val) + 1.0) / 2.0)
