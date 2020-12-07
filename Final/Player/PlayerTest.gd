extends Node2D

func _ready():
	self.scale *= get_viewport().size / Vector2(
		ProjectSettings.get("display/window/size/width"),
		ProjectSettings.get("display/window/size/height")
	)
