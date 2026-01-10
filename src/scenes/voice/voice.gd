extends Node2D
@onready var speech_to_text: CaptureStreamToText = $SpeechToText
var launched_from_game := false
func record():
	launched_from_game = true
	speech_to_text.recording = true
	print("rec ")
	
func stop_recording():
	launched_from_game = false
	speech_to_text.recording = false
