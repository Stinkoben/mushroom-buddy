extends Node2D

var erasable = true

func destroy():
	$StaticBody2D/CollisionShape2D.disabled = true;
	$AnimationPlayer.play("destroy")
	erasable = false
	await get_tree().create_timer(0.2).timeout
	self.queue_free()
	
