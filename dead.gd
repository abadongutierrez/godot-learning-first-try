extends Node2D


func _ready():
	pass
	#get_node("Player").play_death_animation

func _on_play_again_button_pressed():
	get_tree().change_scene_to_file("res://main.tscn")
