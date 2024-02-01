extends Node2D

var pos_array: Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func init(x_offset: int):
	var rng = RandomNumberGenerator.new()
	for d in rng.randi_range(1,4):
		var pos = Vector2(rng.randf_range(0,Global.chunk_width) + x_offset, rng.randf_range(570,630))
		pos_array.append(pos)
