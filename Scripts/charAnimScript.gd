extends Node3D


func step():
	# var vfx = get_parent().vfxSalto.instantiate()
	# get_tree().root.add_child(vfx)
	# (vfx as GPUParticles3D).position = position + Vector3(0,-0.7,0)
	# (vfx as GPUParticles3D).restart()
	
	AudioManagerGlobal.play_sound("res://Audio/paso" + str(randi_range(1, 5)) + ".ogg")
