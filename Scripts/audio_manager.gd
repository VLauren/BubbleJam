extends Node

class_name AudioManager

func play_sound(file_path: String) -> AudioStreamPlayer2D:
	# Create a new AudioStreamPlayer2D
	var audio_player = AudioStreamPlayer2D.new()

	# Load the audio file
	var audio_stream = ResourceLoader.load(file_path) as AudioStream
	if audio_stream == null:
		print("Error: Could not load audio file: ", file_path)
		return

	audio_player.stream = audio_stream

	# Connect the "finished" signal to clean up after playing
	audio_player.finished.connect(func():
		audio_player.queue_free()
	)

	# Add the audio player to the AudioManager
	add_child(audio_player)

	# Play the sound
	audio_player.play()
	return audio_player
