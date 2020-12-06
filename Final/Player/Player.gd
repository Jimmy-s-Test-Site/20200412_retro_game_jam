extends KinematicBody2D

export (int) var run_speed = 100
export (int) var jump_speed = -600
export (int) var gravity = 1200

onready var animation_player = $AnimationPlayer
onready var raycast2d = $RayCast2D

var velocity := Vector2.ZERO
var jumping := false
var dancing := false

var input = {
	"jump": false,
	"action1": false,
	"action2": false,
	"action3": false
}

# helper functions

func play_at_speed(animation : String, speed : float) -> void:
	self.animation_player.playback_speed = speed
	self.animation_player.play(animation)

# engine defined functions

func _ready() -> void:
	$AnimationPlayer.playback_speed = 2
	$AnimationPlayer.play("Walking")

func _physics_process(delta : float) -> void:
	self.input_manager()
	self.movement_manager(delta)
	self.dance_manager()
	self.animation_manager()
	self.life_manager()

# user defined functions

func input_manager() -> void:
	self.input.jump    = Input.is_action_just_pressed("jump")
	self.input.action1 = Input.is_action_just_pressed("action1")
	self.input.action2 = Input.is_action_just_pressed("action2")
	self.input.action3 = Input.is_action_just_pressed("action3")

func movement_manager(delta : float) -> void:
	self.velocity.x = 0
	
	if self.is_on_floor() and not self.dancing:
		self.jumping = false
		
		if self.input.jump:
			self.jumping = true
			self.velocity.y = self.jump_speed
	
	self.velocity.y += self.gravity * delta
	
	self.velocity = self.move_and_slide(self.velocity, Vector2.UP)

func dance_manager() -> void:
	var dance_input : bool = \
		self.input.action1 or \
		self.input.action2 or \
		self.input.action3
	
	if not self.jumping:
		if not self.dancing and dance_input:
			self.dancing = true
		elif self.dancing:
			yield(self.animation_player, "animation_finished")
			self.dancing = false

func life_manager():
	if self.raycast2d.is_colliding() and not self.dancing:
		print("You dead")

func animation_manager() -> void:
	if self.jumping:
		play_at_speed("Jump", 5)
	elif self.dancing:
		if self.input.action1:
			play_at_speed("Headbang", 2)
		elif self.input.action2:
			play_at_speed("Tailshake", 2)
		elif self.input.action3:
			play_at_speed("Stomp", 10)
	else:
		play_at_speed("Walking", 2)
