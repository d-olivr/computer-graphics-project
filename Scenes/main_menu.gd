extends Control

func _on_start_button_pressed():
	# Carrega a cena do seu jogo principal
	get_tree().change_scene_to_file("res://Actors/Player/jojin.tscn")

func _on_story_button_pressed():
	# Substitua pelo caminho exato de onde você salvar a cena da história
	get_tree().change_scene_to_file("res://Scenes/story_scene.tscn")

func _on_credits_button_pressed():
	# Substitua pelo caminho exato de onde você salvar a cena dos créditos
	get_tree().change_scene_to_file("res://Scenes/credits_scene.tscn")
