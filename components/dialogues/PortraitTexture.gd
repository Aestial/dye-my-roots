extends TextureRect

func clear():
	texture = null
	
func set_emotion(declaration, emotion):
	var emotion_file = get_node(declaration).portraits[emotion]
	var image = Image.new()
	var stream_texture = load(emotion_file)
	var image_texture = ImageTexture.new()
	image = stream_texture.get_data()
	image.lock()
	image_texture.create_from_image(image, 0)
	image.unlock()
	texture = image_texture
