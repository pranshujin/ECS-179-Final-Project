extends CharacterBody2D

func _ready():
	add_to_group("npc")

func interact(player):
	var main = get_tree().get_root().get_node("Main")
	main.show_interaction_text("Hello!")
