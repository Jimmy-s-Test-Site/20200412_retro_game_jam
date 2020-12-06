extends Node2D

export (NodePath) var platforms_path
export (Texture) var background
export (AudioStream) var audio
export (float) var volume
export (float) var timer
export (int) var speed = 10

onready var platforms : Node2D = get_node(self.platforms_path)

func _ready():
	$Sprite.texture = self.background
	$AudioStreamPlayer.stream = self.audio
	$AudioStreamPlayer.volume_db = self.volume

func _physics_process(delta):
	self.platforms.position.x -= self.speed * delta

func _on_Timer_timeout():
	$AudioStreamPlayer.play()
