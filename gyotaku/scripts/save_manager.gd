extends Node2D

var tempo_segurando_enter : float = 0.0
var cheat_ativado : bool = false
const CAMINHO_SAVE = "user://save_do_jogo.json"

func _ready() -> void:
	inicializar_save_se_nao_existir()

func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_ENTER) or Input.is_key_pressed(KEY_KP_ENTER):
		if not cheat_ativado:
			tempo_segurando_enter += delta
			
			if tempo_segurando_enter >= 10.0:
				cheat_ativado = true
				print("CHEAT ATIVADO: 10 segundos de Enter detectados!")
				ativar_trapaca_pegar_todos()
	else:
		tempo_segurando_enter = 0.0

func ativar_trapaca_pegar_todos() -> void:
	var save_temporario : Dictionary = {}
	
	if FileAccess.file_exists(CAMINHO_SAVE):
		var file = FileAccess.open(CAMINHO_SAVE, FileAccess.READ)
		var json_convertido = JSON.parse_string(file.get_as_text())
		file.close()
		
		if typeof(json_convertido) == TYPE_DICTIONARY:
			save_temporario = json_convertido
			
			for chave_peixe in save_temporario.keys():
				save_temporario[chave_peixe]["pego"] = true
				
			var texto_json = JSON.stringify(save_temporario, "\t")
			var save_file = FileAccess.open(CAMINHO_SAVE, FileAccess.WRITE)
			save_file.store_string(texto_json)
			save_file.close()
			
			print("Todos os peixes liberados! Recarregando...")
			get_tree().reload_current_scene()

func inicializar_save_se_nao_existir() -> void:
	if not FileAccess.file_exists(CAMINHO_SAVE):
		print("Save não encontrado. Gerando save padrão...")
		criar_save_padrao_do_zero()
	else:
		print("Save já existe!")

func criar_save_padrao_do_zero() -> void:
	var banco_de_dados_inicial: Dictionary = {
		"gurukun": {
			"nome": "Gurukun",
			"apelido": "",
			"descricao": "Um peixe tropical colorido muito ágil. É o símbolo de Okinawa e fica lindo em carimbos de papel de arroz.",
			"pego": false,
			"carimbado": false
		},
		"raya": {
			"nome": "Arraia Pintada",
			"apelido": "",
			"descricao": "Majestosa e gigante. Desliza pela água como se estivesse voando. Cuidado com o ferrão!",
			"pego": false,
			"carimbado": false
		},
		"enguia_demonio": {
			"nome": "Enguia Demônio",
			"apelido": "",
			"descricao": "Enguia do diabo",
			"pego": false,
			"carimbado": false
		},
		"peixe_fantasma": {
			"nome": "Peixe Fantasma",
			"apelido": "",
			"descricao": "Buuuuuuuu",
			"pego": false,
			"carimbado": false
		}
	}
	
	var texto_json = JSON.stringify(banco_de_dados_inicial, "\t") 
	
	var file = FileAccess.open(CAMINHO_SAVE, FileAccess.WRITE)
	if file:
		file.store_string(texto_json)
		file.close()
		print("Arquivo criado na pasta user:// !")
	else:
		print("Não foi possível criar o arquivo de save.")
