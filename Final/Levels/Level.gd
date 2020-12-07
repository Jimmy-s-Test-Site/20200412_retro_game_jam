extends Node2D

export (NodePath) var platforms_path
export (NodePath) var enemies_path
export (NodePath) var player_path

export (Texture) var background
export (AudioStream) var audio
export (float) var volume
export (float) var timer
export (int) var speed = 10

func nodepath_exists(nodepath : NodePath) -> bool:
	return nodepath != null

onready var platforms_exist : bool = self.nodepath_exists(self.platforms_path)
onready var platforms : Node2D = self.get_node(self.platforms_path)
onready var enemies_exist : bool = self.nodepath_exists(self.enemies_path)
onready var enemies : Node2D = self.get_node(self.enemies_path)

onready var scale_factor : Vector2 = self.get_viewport().size / Vector2(
	ProjectSettings.get("display/window/size/width"),
	ProjectSettings.get("display/window/size/height")
)

func _ready():
	self.scale_factor = get_viewport().size / Vector2(
		ProjectSettings.get("display/window/size/width"),
		ProjectSettings.get("display/window/size/height")
	)
	
	self._on__node_ready(self.platforms_path, "Please add a platforms folder")
	self._on__node_ready(self.enemies_path, "Please add a enemies folder")
	self._on__node_ready(self.player_path, "Please add a player folder")
	
	$Sprite.texture = self.background
	$AudioStreamPlayer.stream = self.audio
	$AudioStreamPlayer.volume_db = self.volume
	
	self.scale *= scale_factor

func _physics_process(delta):
	if self.platforms_exist:
		self.platforms.position.x -= self.speed * delta
	if self.enemies_exist:
		self.enemies.position.x -= self.speed * delta



func _on_Timer_timeout():
	$AudioStreamPlayer.play()

func _on__node_ready(_path, error):
	if self.nodepath_exists(_path):
		var _node = self.get_node(_path)
		
		yield(_node, "ready")
		
		_node.position *= scale_factor
		_node.scale *= scale_factor
	else:
		print(error)
