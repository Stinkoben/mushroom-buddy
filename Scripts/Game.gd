extends Node2D

var banner_exists = false
var killable = true

signal _send_new_dirt(pos)

var chunks: Array = []
var chunk_scene

var stone_scene

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("fade_in")
	$Music.play()
	Global.move_speed = 1.5
	chunk_scene = preload("res://Scenes/RandomChunk.tscn").instantiate()
	stone_scene = preload("res://Scenes/Stone.tscn").instantiate()
	if Global._in_tutorial:
		banner_exists = true
		setup_tutorial_obstacles()
		for i in range(0,12):
			create_chunk(8500 + i * Global.chunk_width)
		await get_tree().create_timer(89.44).timeout
		banner_exists = false
		$InstructionBanner.queue_free()
		Global._in_tutorial = false
	else:
		$InstructionBanner.queue_free()
		for i in range(0,12):
			create_chunk(960 + i * Global.chunk_width)
	
func _process(_delta):
	if Input.is_action_just_pressed("esc"):
		get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
		
func _physics_process(_delta):
	if $Buddy.position.x <= 5 and killable:
		$BloodSplatter.position.y = $Buddy.position.y
		$BloodSplatter/Particles.emitting = true
		$Buddy.kill()
		$Music.stop()
		killable = false
	if banner_exists:
		$InstructionBanner.position.x -= 1.5
	if not Global._in_tutorial:
		pass
	else:
		$BuriedRock.position.x -= 1.5
	
	move_chunks()
	if not Global._in_tutorial:
		if len(chunks) < 10:
			create_chunk()
		
func setup_tutorial_obstacles():
	for dd in $DirtTower.get_children():
		var pos_offset = Vector2(dd.position.x + $DirtTower.position.x, dd.position.y + $DirtTower.position.y)
		emit_signal("_send_new_dirt", pos_offset)
	for dr in $BuriedRock.get_children():
		if dr.name.substr(0,4) == "Dirt":
			var pos_offset2 = Vector2(dr.position.x + $BuriedRock.position.x, dr.position.y + $BuriedRock.position.y)
			dr.queue_free()
			emit_signal("_send_new_dirt", pos_offset2)
	"res://Scenes/Clouds.tscn"

func create_chunk(x_offset=970):
	var rng = RandomNumberGenerator.new()
	var new_chunk = chunk_scene.duplicate()
	new_chunk.position.x = x_offset
	new_chunk.init(0)
	chunks.append(new_chunk)
	$Ground.add_child(new_chunk)
	for pos in new_chunk.pos_array:
		var pos_offset = Vector2(pos.x + new_chunk.position.x, pos.y + new_chunk.position.y)
		emit_signal("_send_new_dirt", pos_offset)
	if rng.randi_range(0,3) == 0:
		var new_stone = stone_scene.duplicate()
		new_stone.position.x += rng.randf_range(-20 + x_offset,20 + x_offset);
		new_stone.position.y = rng.randf_range(570,630)
		$Obstacles.add_child(new_stone)
		
func move_chunks():
	for i in range(len(chunks) -1, -1, -1):
		chunks[i].position.x -= Global.move_speed
		if chunks[i].position.x < -1 * Global.chunk_width:
			chunks[i].queue_free()
			chunks.remove_at(i)
	
	var children = $Obstacles.get_children()
	for i in range(len(children) -1, -1, -1):
		children[i].position.x -= Global.move_speed
		if children[i].position.x <= -10:
			children[i].queue_free()
			
