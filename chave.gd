extends Area3D

func _on_body_entered(body):
	# Lembre-se de manter o nome exato com "P" maiúsculo na verificação
	if body.name == "Player": 
		Global.tem_chave = true 
		queue_free() # Coleta a chave e remove da cena
