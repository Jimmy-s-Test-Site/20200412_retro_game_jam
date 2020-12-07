extends Node2D

export (Resource) var raw_death_scene

onready var death_scene

var rng = RandomNumberGenerator.new()

export (Array, Resource) var raw_levels

var curr_level

var levels = []

func load_levels():
	for level in self.raw_levels:
		self.levels.append(load(level.resource_path))

func instance_rand_level():
	var random_index = rng.randi() % self.levels.size()
	var random_level = self.levels[random_index]
	self.curr_level = random_level.instance()
	
	self.curr_level.get_node("Level").connect("player_died", self, "_on_player_died")
	self.curr_level.get_node("Level").connect("player_earned_points", self, "_on_player_earned_points")
	self.curr_level.z_index = -1
	add_child(self.curr_level)
	
	$ScoreContainer.scale *= get_viewport().size / Vector2(
		ProjectSettings.get("display/window/size/width"),
		ProjectSettings.get("display/window/size/height")
	)

func _ready():
	OS.window_size = Vector2(384,384)
	rng.randomize()
	self.load_levels()
	self.instance_rand_level()
	
	self.death_scene = load(self.raw_death_scene.resource_path)

func _on_player_died():
	self.curr_level.queue_free()
	
	var death_scene_instance = self.death_scene.instance()
	add_child(death_scene_instance)
	
	death_scene_instance.scale *= get_viewport().size / Vector2(
		ProjectSettings.get("display/window/size/width"),
		ProjectSettings.get("display/window/size/height")
	)

func _on_player_earned_points(amount : float) -> void:
	print("amount earned")
