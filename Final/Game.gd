extends Node2D

var rng = RandomNumberGenerator.new()

export (Array, Resource) var raw_levels

var levels = []

func load_levels():
	for level in self.raw_levels:
		self.levels.append(load(level.resource_path))

func instance_rand_level():
	var random_index = rng.randi() % self.levels.size()
	var random_level = self.levels[random_index]
	var scene_instance = random_level.instance()
	
	scene_instance.set_name("Level")
	scene_instance.z_index = -1
	add_child(scene_instance)
	
	$ScoreContainer.scale *= get_viewport().size / Vector2(
		ProjectSettings.get("display/window/size/width"),
		ProjectSettings.get("display/window/size/height")
	)

func _ready():
	OS.window_size = Vector2(384,384)
	rng.randomize()
	self.load_levels()
	self.instance_rand_level()
