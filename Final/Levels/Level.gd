extends Node2D

signal player_died
signal player_earned_points

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
onready var platforms : Node2D = self.get_node_or_null(self.platforms_path)
onready var enemies_exist : bool = self.nodepath_exists(self.enemies_path)
onready var enemies : Node2D = self.get_node_or_null(self.enemies_path)

onready var scale_factor : Vector2 = self.get_viewport().size / Vector2(
	ProjectSettings.get("display/window/size/width"),
	ProjectSettings.get("display/window/size/height")
)

func _ready():
	self._on__node_ready(self.platforms_path, "Please add a platforms folder")
	self._on__node_ready(self.enemies_path, "Please add a enemies folder")
	self._on__node_ready(self.player_path, "Please add a player folder")
	
	var player = self.get_node_or_null(self.enemies_path)
	
	if player != null:
		player.connect("earned_points", self, "_on_player_earned_points")
	
	$Sprite.texture = self.background
	#$AudioStreamPlayer.loop = false
	$AudioStreamPlayer.stream = self.audio
	$AudioStreamPlayer.volume_db = self.volume
	
	self.scale *= scale_factor

func _physics_process(delta):
	if self.platforms_exist:
		self.platforms.position.x -= self.speed * delta
	if self.enemies_exist:
		self.enemies.position.x -= self.speed * delta
	
	if self.get_node_or_null(self.player_path) != null:
		var player_death = \
			ProjectSettings.get("display/window/size/height") <= self.get_node(self.player_path).position.y or \
			self.get_node(self.player_path).position.x <= 0
		
		if player_death:
			self.get_node(self.player_path).queue_free()
			self.emit_signal("player_died")



func _on_Timer_timeout() -> void:
	$AudioStreamPlayer.play()

func _on__node_ready(_path, error) -> void:
	if self.nodepath_exists(_path):
		var _node = self.get_node_or_null(_path)
		
		if _node != null:
			yield(_node, "ready")
			
			_node.position *= scale_factor
			_node.scale *= scale_factor
	else:
		print(error)

func _on_player_earned_points(amount : int) -> void:
	self.emit_signal("player_earned_points", amount)
