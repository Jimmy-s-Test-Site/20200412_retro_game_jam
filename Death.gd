extends Node2D

signal user_wishes_to_continue

export (float) var speed := 1.0

export (float) var s_value := 1.0
export (float) var v_value := 0.8

var h_value : float = 0
var enter := false

func _process(delta):
	self.colorizer(delta)
	self.input_manager()
	self.state_manager()
	

func colorizer(delta : float) -> void:
	# max h value is 1
	self.h_value = fmod(self.h_value + (delta * self.speed), 1)
	
	$ColorRect.color = Color.from_hsv(self.h_value, self.s_value, self.v_value)

func input_manager() -> void:
	self.enter = Input.is_action_just_pressed("enter")

func state_manager() -> void:
	if self.enter:
		self.emit_signal("user_wishes_to_continue")
