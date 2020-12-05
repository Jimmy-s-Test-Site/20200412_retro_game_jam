extends KinematicBody2D

const GRAVITY = 1200.0
var velocity = Vector2()
const WALK_SPEED = 200


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	velocity.y += delta * GRAVITY

	var motion = velocity * delta
	move_and_collide(motion)
	
	if Input.is_action_pressed("left"):
		velocity.x = -WALK_SPEED
	elif Input.is_action_pressed("right"):
		velocity.x =  WALK_SPEED
	else:
		velocity.x = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


