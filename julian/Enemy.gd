extends StaticBody2D

export (int) var playback_speed := 1

func _ready():
	$AnimationPlayer.play("main")
	$AnimationPlayer.playback_speed(self.playback_speed)
