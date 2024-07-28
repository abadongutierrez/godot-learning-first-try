extends Node2D

var Frog = preload("res://enemies/frog.tscn")

func _ready():
	get_node("Timer").connect("timeout", _show_dead_scene)
	var frog_timer = get_node("FrogSpawnerTimer")
	frog_timer.connect("timeout", _spawn_frog)
	frog_timer.start()

# Called when the node enters the scene tree for the first time.
func _show_dead_scene():
	get_tree().change_scene_to_file("res://dead.tscn")

func _spawn_frog():
	var new_frog = Frog.instantiate()
	var rng = RandomNumberGenerator.new()
	new_frog.position = Vector2(
		rng.randi_range(0, 1000),
		rng.randi_range(150, 250)
	)
	get_node("Mobs").add_child(new_frog)
	
func show_dead_scene_timer_start():
	get_node("Timer").start()
