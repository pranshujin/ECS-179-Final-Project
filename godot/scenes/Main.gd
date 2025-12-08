extends Node2D

const LANDMARK_COUNT := 4

var landmarks := []
var npcs := []

@onready var player := $Player
@onready var interaction_label := $CanvasLayer/InteractionLabel

var npc_scene := preload("res://scenes/NPC.tscn")

var client := StreamPeerTCP.new()


func _ready() -> void:
	randomize()
	_style_interaction_label()
	generate_landmarks()
	spawn_npcs_near_landmarks()
	connect_to_server()


func _style_interaction_label() -> void:
	interaction_label.visible = false

	interaction_label.anchor_left = 0.0
	interaction_label.anchor_right = 1.0
	interaction_label.anchor_top = 0.0
	interaction_label.anchor_bottom = 0.0

	interaction_label.offset_left = 0
	interaction_label.offset_right = 0
	interaction_label.offset_top = 0
	interaction_label.offset_bottom = 80

	interaction_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	interaction_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	interaction_label.add_theme_constant_override("font_size", 500)

	var box := StyleBoxFlat.new()
	box.bg_color = Color(0, 0, 0, 0.75)
	box.corner_radius_top_left = 20
	box.corner_radius_top_right = 20
	box.corner_radius_bottom_left = 20
	box.corner_radius_bottom_right = 20

	box.border_color = Color.WHITE
	box.border_width_left = 3
	box.border_width_right = 3
	box.border_width_top = 3
	box.border_width_bottom = 3

	interaction_label.add_theme_stylebox_override("normal", box)
	interaction_label.add_theme_color_override("font_color", Color(1, 1, 1))
	interaction_label.add_theme_color_override("font_outline_color", Color(0, 0, 0))
	interaction_label.add_theme_constant_override("outline_size", 3)


func show_interaction_text(msg: String) -> void:
	interaction_label.text = msg
	interaction_label.visible = true

	await get_tree().create_timer(2.0).timeout
	interaction_label.visible = false


func generate_landmarks() -> void:
	for i in LANDMARK_COUNT:
		var lm := Sprite2D.new()

		lm.texture = preload("res://Blue_star_icon_stylized.png")
		lm.scale = Vector2(0.05, 0.05)

		lm.position = Vector2(
			randf_range(-200, 200),
			randf_range(-200, 200)
		)

		add_child(lm)
		landmarks.append(lm)

	print("Generated", LANDMARK_COUNT, "landmarks")


func spawn_npcs_near_landmarks() -> void:
	for lm in landmarks:
		var npc = npc_scene.instantiate()

		var angle = randf() * TAU
		var radius = randf_range(80, 120)

		var offset = Vector2(cos(angle), sin(angle)) * radius
		npc.position = lm.position + offset

		add_child(npc)
		npcs.append(npc)

	print("Spawned", npcs.size(), "NPCs near landmarks")


func connect_to_server():
	var err = client.connect_to_host("127.0.0.1", 9000)
	if err != OK:
		print("Could not connect to server:", err)
		return

	print("Godot connected to Node server!")
