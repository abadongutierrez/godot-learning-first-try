extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player
var on_chase = false
var on_dead = false
var player_is_dead = false
var frog_speed = 50

func _ready():
	get_node("AnimatedSprite2D").play("idle")
	var rng = RandomNumberGenerator.new()
	frog_speed = rng.randi_range(50, 100)

func _physics_process(delta):
	if not player_is_dead:
		# gravity
		if not is_on_floor():
			velocity.y += gravity * delta
		
		if on_chase == true:
			var node = get_node("AnimatedSprite2D")
			node.play("jump")
			player = get_node("../../Player/Player")
			var player_direction = (player.position - self.position).normalized()
			if player_direction.x > 0:
				node.flip_h = true
				velocity.x = player_direction.x * frog_speed
			else:
				node.flip_h = false
				velocity.x = player_direction.x * frog_speed
		else:
			var node = get_node("AnimatedSprite2D")
			if on_dead == false:
				node.play("idle")
			velocity.x = 0
	
		move_and_slide()

func _on_player_detection_body_entered(body):
	if body.name == "Player":
		on_chase = true
		var node = get_node("AnimatedSprite2D")
		node.position += Vector2(0, -5)
		print("Player detected!")


func _on_player_detection_body_exited(body): 
	if body.name == "Player":
		on_chase = false
		var node = get_node("AnimatedSprite2D")
		node.position += Vector2(0, +5)
		print("Player undetected!")


func _on_deadly_area_body_entered(body):
	if body.name == "Player":
		on_dead = true
		on_chase = false
		var node = get_node("AnimatedSprite2D")
		node.play("death")
		await node.animation_finished
		self.queue_free()

func _on_player_damage_body_entered(body):
	if body.name == "Player":
		body.dead()
		player_is_dead = true
		var node = get_node("AnimatedSprite2D")
		node.play("idle")
		node.position += Vector2(0, +5)
		#get_tree().change_scene_to_file("res://enemies/dead.tscn")
