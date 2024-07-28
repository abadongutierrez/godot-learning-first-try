extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_dead = false

@onready var animation_player = get_node("AnimationPlayer")
@onready var game_world = get_node("/root/GameWorld")

func dead():
	is_dead = true
	game_world.show_dead_scene_timer_start()
	#await node.animation_finished

func _physics_process(delta):
	if not is_dead:
		# Add the gravity.
		if not is_on_floor():
			velocity.y += gravity * delta

		# Handle jump.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			animation_player.play("jump")

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction = Input.get_axis("ui_left", "ui_right")
		
		# flip player according to direction	
		if direction == -1:
			get_node("AnimatedSprite2D").flip_h = true
		elif direction == 1:
			get_node("AnimatedSprite2D").flip_h = false

		# animate direction
		# 0 = stand, 1 = right, -1 = left
		if direction:
			velocity.x = direction * SPEED
			# on the floor
			if velocity.y == 0:
				animation_player.play("run")
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			if velocity.y == 0:
				animation_player.play("idle")

		# going down
		if velocity.y > 0:
			animation_player.play("fall")
	else:
		# freeze player
		#velocity = Vector2(0, 0)
		animation_player.play("hurt")

	move_and_slide()
