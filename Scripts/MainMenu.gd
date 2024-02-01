extends Control

func _ready():
	$EscTipLabel.visible = false
	$AnimationPlayer.play("buddy_idle")
	$VBoxContainer/BTN_NewGame.grab_focus()
	if Global._in_tutorial:
		$HighscoreLabel.visible = false
	else:
		$HighscoreLabel.visible = true
		$HighscoreLabel.text = "Highscore: " + str(Global._highscore)

func _process(delta):
	if Input.is_action_just_pressed("0"):
		Global._in_tutorial = false
		$StartJingle.play()
		$AnimationPlayer.play("fade_out")
		$EscTipLabel.visible = true
		await get_tree().create_timer(3.0).timeout
		get_tree().change_scene_to_file("res://Scenes/Game.tscn")

func _on_btn_new_game_pressed():
	$StartJingle.play()
	$AnimationPlayer.play("fade_out")
	$EscTipLabel.visible = true
	await get_tree().create_timer(3.0).timeout
	get_tree().change_scene_to_file("res://Scenes/Game.tscn")

func _on_btn_controls_pressed():
	get_tree().change_scene_to_file("res://Scenes/ControlsScreen.tscn")

func _on_btn_credits_pressed():
	get_tree().change_scene_to_file("res://Scenes/CreditsScreen.tscn")
	
func _on_btn_exit_pressed():
	get_tree().quit()


func _on_h_slider_drag_ended(value_changed):
	var val = $VolumeSlider.value
	print(val)
	val = -100 if val == 0 else (val-15) / 6
	val = clamp(val,-100,15)
	print(val)
	print()

	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), val)
	
