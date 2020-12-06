extends Node2D

export (int) var speed = 1

func _ready():
	self.scale *= get_viewport().size / Vector2(
		ProjectSettings.get("display/window/size/width"),
		ProjectSettings.get("display/window/size/height")
	)

func _physics_process(delta : float) -> void:
	$StaticBody2D.position.x -= self.speed * delta
	$Enemies.position.x -= self.speed * delta
