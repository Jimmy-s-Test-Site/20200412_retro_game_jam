extends KinematicBody2D

signal dead
signal earned_points

export (int) var run_speed = 100
export (int) var jump_speed = -600
export (int) var gravity = 1200

export (Dictionary) var animations = {
	"stomp": 10,
	"headbang": 10,
	"tailshake": 1
}

enum Dances {
	NONE   = 0,
	DANCE1 = 1,
	DANCE2 = 2,
	DANCE3 = 3
}

onready var animation_player = $AnimationPlayer
onready var enemy_detector : Area2D = $EnemyDetector

var velocity := Vector2.ZERO
var jumping := false
var dancing := false
var dance = Dances.NONE

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
			if   self.input.action1: self.dance = Dances.DANCE1
			elif self.input.action2: self.dance = Dances.DANCE2
			elif self.input.action3: self.dance = Dances.DANCE3
			
			self.dancing = true
		
		elif self.dancing:
			yield(self.animation_player, "animation_finished")
			self.dance = Dances.NONE
			
			self.dancing = false
	
	var overlaping_bodies = self.enemy_detector.get_overlapping_bodies()
	if overlaping_bodies.size() > 0 and self.dancing:
		for body in overlaping_bodies:
			var matching_dance = [
				self.dance == Dances.DANCE1 and body.name == "Enemy1",
				self.dance == Dances.DANCE2 and body.name == "Enemy2",
				self.dance == Dances.DANCE3 and body.name == "Enemy3"
			]
			
			if matching_dance[0] or matching_dance[1] or matching_dance[2]:
				if   matching_dance[0]: emit_signal("earned_points",  5)
				elif matching_dance[1]: emit_signal("earned_points", 10)
				elif matching_dance[2]: emit_signal("earned_points", 15)
				body.queue_free()
		#print(self.dance)
		#print(self.raycast2d.get_collider().name)

func life_manager():
	if self.enemy_detector.get_overlapping_bodies().size() > 0:
		for i in self.get_slide_count():
			var collision := self.get_slide_collision(i)
			
			if ([
				"Enemy1",
				"Enemy2",
				"Enemy3"
			].has(get_slide_collision(i).collider.name)):
				pass#self.queue_free()

func animation_manager() -> void:
	if self.jumping:
		play_at_speed("Jump", 10)
	elif self.dancing:
		if   self.input.action1: play_at_speed("Stomp", self.animations.stomp)
		elif self.input.action2: play_at_speed("Headbang", self.animations.headbang)
		elif self.input.action3: play_at_speed("Tailshake", self.animations.tailshake)
	else:
		play_at_speed("Walking", 2)
