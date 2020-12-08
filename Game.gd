extends Node2D

export (Resource) var raw_death_scene
export (Resource) var raw_score_scene
export (Array, Resource) var raw_levels

onready var death_scene = load(self.raw_death_scene.resource_path)
onready var score_scene = load(self.raw_score_scene.resource_path)

var rng = RandomNumberGenerator.new()

enum DEATH_OR_SCORE {
	NULL, DEATH, SCORE
}

var death_or_score = DEATH_OR_SCORE.NULL

var death_scene_instance
var score_scene_instance
var curr_level_idx : int
var curr_level
var score = 0
var levels = []

func pixelate() -> void:
	OS.window_size = Vector2(384,384)

func load_levels():
	for level in self.raw_levels:
		self.levels.append(load(level.resource_path))

func instance_level_idx(idx : int) -> void:
	self.curr_level = self.levels[idx].instance()
	
	var level_template_node = self.curr_level.get_node("Level")
	var player_node = level_template_node.get_node(level_template_node.player_path)
	
	level_template_node.connect("player_died", self, "_on_player_died")
	level_template_node.connect("player_win_level", self, "_on_player_win_level")
	player_node.connect("earned_points", self, "_on_player_earned_points")
	
	self.add_child(self.curr_level)
	
	$ScoreContainer.scale *= get_viewport().size / Vector2(
		ProjectSettings.get("display/window/size/width"),
		ProjectSettings.get("display/window/size/height")
	)

func instance_rand_level():
	self.rng.randomize()
	self.curr_level_idx = self.rng.randi() % self.levels.size()
	self.instance_level_idx(self.curr_level_idx)

func instance_next_level():
	self.curr_level_idx = (self.curr_level_idx + 1) % self.levels.size()
	self.instance_level_idx(self.curr_level_idx)

func _ready():
	self.pixelate()
	self.load_levels()
	self.instance_rand_level()

func _on_player_died():
	self.death_or_score = DEATH_OR_SCORE.DEATH
	self.curr_level.queue_free()
	
	self.death_scene_instance = self.death_scene.instance()
	self.add_child(self.death_scene_instance)
	
	self.death_scene_instance.scale *= get_viewport().size / Vector2(
		ProjectSettings.get("display/window/size/width"),
		ProjectSettings.get("display/window/size/height")
	)
	
	self.death_scene_instance.connect("user_wishes_to_continue", self, "_on_user_wishes_to_continue")

func _on_player_win_level():
	self.death_or_score = DEATH_OR_SCORE.SCORE
	
	self.curr_level.queue_free()
	
	self.score_scene_instance = self.score_scene.instance()
	self.add_child(self.score_scene_instance)
	
	self.score_scene_instance.get_node("Label").text = \
		self.score_scene_instance.get_node("Label").text.replace("<score>", String(self.score).pad_zeros(3))
	
	self.score_scene_instance.scale *= get_viewport().size / Vector2(
		ProjectSettings.get("display/window/size/width"),
		ProjectSettings.get("display/window/size/height")
	)
	
	self.score_scene_instance.connect("user_wishes_to_continue", self, "_on_user_wishes_to_continue")

func _on_player_earned_points(amount : float) -> void:
	self.score += amount
	$ScoreContainer/Score/Label.text = String(self.score).pad_zeros(3)

func _on_user_wishes_to_continue() -> void:
	if self.death_or_score == DEATH_OR_SCORE.DEATH:
		self.death_scene_instance.queue_free()
	elif self.death_or_score == DEATH_OR_SCORE.SCORE:
		self.score_scene_instance.queue_free()
	
	self.death_or_score = DEATH_OR_SCORE.NULL
	
	self.instance_next_level()
	
	$ScoreContainer/Score/Label.text = "000"
	self.score = 0
