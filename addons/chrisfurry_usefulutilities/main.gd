@tool
extends EditorPlugin


func _enter_tree():
	# Resources
	add_custom_type("SpriteFont","Resource",load("res://addons/chrisfurry_usefulutilities/scripts/res_SpriteFont.gd"),preload("res://addons/chrisfurry_usefulutilities/icons/SpriteFont.png"));
	# Nodes
	add_custom_type("SpriteLabel2D","Node2D",load("res://addons/chrisfurry_usefulutilities/scripts/node_SpriteLabel2D.gd"),preload("res://addons/chrisfurry_usefulutilities/icons/SpriteLabel2D.png"));
	add_custom_type("ProgressBar2D","Node2D",load("res://addons/chrisfurry_usefulutilities/scripts/node_ProgressBar2D.gd"),preload("res://addons/chrisfurry_usefulutilities/icons/ProgressBar2D.png"));


func _exit_tree():
	# Nodes
	remove_custom_type("SpriteLabel2D");
	remove_custom_type("ProgressBar2D");
	# Resources
	remove_custom_type("SpriteFont");
