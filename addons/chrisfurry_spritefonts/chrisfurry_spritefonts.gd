@tool
extends EditorPlugin


func _enter_tree():
	add_custom_type("SpriteLabel2D","Node2D",load("res://addons/chrisfurry_spritefonts/scripts/node_SpriteLabel.gd"),preload("res://addons/chrisfurry_spritefonts/icons/SpriteLabel2D.png"));
	add_custom_type("SpriteFont","Resource",load("res://addons/chrisfurry_spritefonts/scripts/res_SpriteFont.gd"),preload("res://addons/chrisfurry_spritefonts/icons/SpriteFont.png"));


func _exit_tree():
	remove_custom_type("SpriteLabel2D");
	remove_custom_type("SpriteFont");
