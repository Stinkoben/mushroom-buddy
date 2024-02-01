extends Control

var delta_sum = 0.0
var score = 0
var score_lock = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if Global._in_tutorial:
		$Distance.visible = false
		$Meter.visible = false
		await get_tree().create_timer(38.6).timeout
		flicker_meter()
		$Meter.visible = true
		await get_tree().create_timer(50.84).timeout
		score = 0
		delta_sum = 0
		$Distance.text = "0 cm"
		$Distance.visible = true

func _physics_process(delta):
	delta_sum += delta
	if delta_sum >= 1.111111111111111 and not Global._in_tutorial:
		score += 1
		delta_sum = 0
		$Distance.text = str(score) + " cm"
		if score > Global._highscore and not Global._in_tutorial:
			Global._highscore = score
	
	if score % 10 == 1 and not score_lock:
		score_lock = true
		Global.move_speed += 0.3
		Global.move_speed = min(Global.move_speed, 4)
	elif score % 10 != 1:
		score_lock = false

func set_distance_visible():
	$Distance.visible = true

func set_meter_visible():
	$Meter.visible = true
	
func flicker_meter():
	$Meter.visible = true
	await get_tree().create_timer(0.1).timeout
	$Meter.visible = false
	await get_tree().create_timer(0.1).timeout
	$Meter.visible = true
	await get_tree().create_timer(0.1).timeout
	$Meter.visible = false
	await get_tree().create_timer(0.1).timeout
	$Meter.visible = true
		
#


func _on_drawing_layer_change_dirt(dirt_level):
	$Meter.value = dirt_level
