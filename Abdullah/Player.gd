extends KinematicBody2D

export (int) var run_speed = 100
export (int) var jump_speed = -600
export (int) var gravity = 1200

var velocity = Vector2()
var midAir = false

var jumpInput 
var headInput
var shake
var stomp

func get_input():
	velocity.x = 0

	jumpInput = Input.is_action_just_pressed("jump")
	headInput = Input.is_action_just_pressed("action1")
	shake = Input.is_action_just_pressed("action2")
	stomp = Input.is_action_just_pressed("action3")

	if jumpInput and is_on_floor():
		midAir = true
		velocity.y = jump_speed

func _physics_process(delta):
	get_input()

	velocity.y += gravity * delta

	if midAir and is_on_floor():
		midAir = false

	velocity = move_and_slide(velocity, Vector2.UP)

	animation_manager()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func animation_manager():
	if is_on_floor():
		if headInput:
			$AnimationPlayer.play("Headbang")
		elif shake:
			$AnimationPlayer.play("Tailshake")
		elif stomp:
			$AnimationPlayer.play("Stomp")
		else:
			$AnimationPlayer.play("Walking")
	else:
		$AnimationPlayer.play("Jump")

