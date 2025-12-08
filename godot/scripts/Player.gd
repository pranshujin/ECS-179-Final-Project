extends CharacterBody2D

const SPEED := 200
const INTERACT_RANGE := 120.0

func _physics_process(delta):
	var input_vector = Vector2.ZERO

	if Input.is_action_pressed("move_right"):
		input_vector.x += 1
	if Input.is_action_pressed("move_left"):
		input_vector.x -= 1
	if Input.is_action_pressed("move_down"):
		input_vector.y += 1
	if Input.is_action_pressed("move_up"):
		input_vector.y -= 1

	if Input.is_action_just_pressed("interact"):
		check_npc_interaction()

	input_vector = input_vector.normalized()
	velocity = input_vector * SPEED
	move_and_slide()


func check_npc_interaction():
	var npcs = get_tree().get_nodes_in_group("npc")
	var closest_npc: CharacterBody2D = null
	var closest_dist: float = INF

	for npc in npcs:
		var dist = global_position.distance_to(npc.global_position)
		if dist < INTERACT_RANGE and dist < closest_dist:
			closest_dist = dist
			closest_npc = npc

	if closest_npc != null:
		closest_npc.interact(self)
	else:
		print("No NPCs nearby.")
