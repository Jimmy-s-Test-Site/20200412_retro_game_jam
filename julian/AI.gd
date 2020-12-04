extends KinematicBody2D

export (int) var run_speed := 20
export (int) var gravity := 1200

var input := Vector2.ZERO
var velocity := Vector2.ZERO

func _ready() -> void:
	self.input = Vector2.LEFT
	$AnimationPlayer.play("left")

func get_input():
	if not $PlatformEdge.is_colliding():
		if self.input == Vector2.LEFT:
			self.input = Vector2.RIGHT
			$AnimationPlayer.play("right")
		
		if self.input == Vector2.RIGHT:
			self.input = Vector2.LEFT
			$AnimationPlayer.play("left")

func _physics_process(delta) -> void:
	get_input()
	
	self.velocity.x = self.input.x
	self.velocity = self.velocity.normalized() * self.run_speed * self.scale
	
	self.velocity.y += self.gravity * delta
	
	print(self.velocity.x)
	self.velocity = self.move_and_slide(self.velocity, Vector2.UP)
