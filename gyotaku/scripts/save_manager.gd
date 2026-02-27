extends Node2D

const CAMINHO_SAVE = "user://save_do_jogo.json"

func _ready() -> void:
	inicializar_save_se_nao_existir()

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
