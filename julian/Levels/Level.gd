extends Node2D

export (NodePath) var platforms_path
export (Texture) var background
export (int) var speed = 10

onready var platforms : Node2D = get_node(self.platforms_path)

func _ready():
	$Sprite.texture = self.background

func _physics_process(delta):
	self.platforms.position.x -= self.speed * delta
