extends Node2D

var count : float = 0

func _process(delta):
	self.count = (self.count delta) % 256
	$ColorRect.color = Color.from_hsv()
