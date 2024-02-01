extends Control

signal change_dirt(dirt_level)

var dirt_scene

const erase_buffer = 10
const DIRT_MAX = 200
var dirt_meter = 0 if Global._in_tutorial else 40
var dirt_array: Array = []
var dirt_pos: Array = []

func _ready():
	dirt_scene = preload("res://Scenes/Dirt.tscn").instantiate()
	emit_signal("change_dirt", dirt_meter)

func _physics_process(_delta):
	move_and_clean_all()
	queue_redraw()


func _input(_event):
		
	if Input.is_action_pressed("mouse2"):
		var mouse_pos = get_global_mouse_position()
		var erase_indexes = find_pos_indexes(mouse_pos)
		for i in erase_indexes:
			if dirt_array[i].erasable:
				destroy_dirt(dirt_array[i])
				dirt_meter = min(dirt_meter + 1, DIRT_MAX)
				emit_signal("change_dirt", dirt_meter)
			
	elif Input.is_action_pressed("mouse1") and dirt_meter > 0:
		var mouse_pos = get_global_mouse_position()
		dirt_meter -= 1
		emit_signal("change_dirt", dirt_meter)
		create_dirt(mouse_pos)
			
			

		
func find_pos_indexes(pos: Vector2):
	var result_set = []
	for i in len(dirt_array):
		var p = dirt_array[i].position
		if (abs(p.x - pos.x) <= erase_buffer) and (abs(p.y - pos.y) <= erase_buffer):
			result_set.append(i)
	return result_set

	
func move_and_clean_all():
	for i in range(len(dirt_array) -1, -1, -1):
		dirt_array[i].position.x -= Global.move_speed
		if dirt_array[i].position.x <= -10:
			dirt_array[i].queue_free()
			dirt_array.remove_at(i)

			


func create_dirt(pos):
	var dirt = dirt_scene.duplicate()
	add_child(dirt)
	dirt.position.x = pos.x
	dirt.position.y = pos.y
	dirt.rotation = RandomNumberGenerator.new().randf_range(0,2*PI)
	dirt_array.append(dirt)


func destroy_dirt(dirt):
	if dirt:
		dirt.destroy()
		#dirt.queue_free()
		await get_tree().create_timer(0.2).timeout
		dirt_array.erase(dirt)


func _on_game__send_new_dirt(pos):
	create_dirt(pos)
