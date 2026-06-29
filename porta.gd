extends Area3D

@export var cena_destino: PackedScene 

func _on_body_entered(body):
	if body.name == "Player":
		if Global.tem_chave == true:
			print("Porta aberta! Mudando de cena...")
			# Opcional: remove a chave do inventário ao usar
			Global.tem_chave = false 
			get_tree().change_scene_to_packed(cena_destino)
		else:
			print("A porta está trancada. Encontre a chave!")
