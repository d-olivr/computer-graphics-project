extends Node

var last_location
var player: Node = null

func _ready() -> void:
	# 1. A ESPERA DE FRAMES:
	# O comando 'await' pausa a execução deste script por 1 frame da engine.
	# Isso garante 100% que todos os outros nós (incluindo o Player) 
	# já nasceram, já carregaram e já entraram nos seus grupos globais.
	await get_tree().process_frame
	
	# 2. VERIFIQUE A ORTOGRAFIA:
	# Confirme se a palavra "Player" aqui está EXATAMENTE igual ao 
	# que está digitado no painel 'Groups' do seu nó de jogador.
	var players = get_tree().get_nodes_in_group("Player")
	print("Lista de players recebida: ", players)
	
	for no in players:
		if no.name == "Player":
			player = no
			break
			
	# 3. A TRAVA DE SEGURANÇA:
	# Só permitimos que o motor acesse a 'global_position' 
	# se tivermos certeza matemática de que o player existe na memória.
	if player != null:
		last_location = player.global_position
		print("CheckpointManager iniciado! Posição salva: ", last_location)
	else:
		# Se der erro, ele avisa no console em vermelho, mas NÃO crasha o seu jogo.
		push_error("Erro Crítico: CheckpointManager não encontrou o Player.")
