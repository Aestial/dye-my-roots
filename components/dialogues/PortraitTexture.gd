extends TextureRect

func clear():
	texture = null
	
func set_character_emotion(root, character, emotion):
	var declaration = "/root/" + character.replace(" ","") + "Declaration"
	var character_dict = get_node(declaration).data
	var file_name = character_dict[emotion]
	print("1. %s " % file_name)
	var image = load(file_name)
	print("2. %s " % image)
	var it = ImageTexture.new()
	print("3. %s " % it)
	it.create_from_image(image)
	var f = File.new()
	if f.file_exists(file_name):
		texture = it
	else:
		texture = null
