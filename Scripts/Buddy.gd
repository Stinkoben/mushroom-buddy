extends CharacterBody2D

@export var RECOVER_SPEED: float
@export var X_OFFSET: float

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("Run")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	if position.x < 225:
		velocity.x = min(RECOVER_SPEED, X_OFFSET - position.x) 
	elif position.x >= 225:
		velocity.x = 0

	move_and_slide()


func kill():
	$AudioStreamPlayer2D.play()
	visible = false
	position.x = -1000
	await get_tree().create_timer(1.5).timeout
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
	
