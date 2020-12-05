extends KinematicBody2D

export (int) var run_speed = 100
export (int) var jump_speed = -600
export (int) var gravity = 1200

var velocity = Vector2()
var midAir = false

func get_input():
	velocity.x = 0
	var jump = Input.is_action_just_pressed("jump")
	var head = Input.is_action_just_pressed("action1")
	var shake = Input.is_action_just_pressed("action2")
	var stomp = Input.is_action_just_pressed("action3")

	if jump and is_on_floor():
		$AnimationPlayer.play("Jump")
		midAir = true
		velocity.y = jump_speed
	
	if head:
		$AnimationPlayer.play("Headbang")
	elif shake:
		$AnimationPlayer.play("Tailshake")
	elif stomp:
		$AnimationPlayer.play("Stomp")

func _physics_process(delta):
	get_input()
	velocity.y += gravity * delta
	if midAir and is_on_floor():
		midAir = false
	velocity = move_and_slide(velocity, Vector2(0, -1))

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


