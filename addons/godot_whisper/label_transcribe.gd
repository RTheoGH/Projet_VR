extends RichTextLabel

var fireball = ["fireball","fire ball"]
var thunderbolt = ["thunderbolt","thunder bolt"]

func _ready():
	custom_minimum_size.x = 400
	bbcode_enabled = true
	fit_content = true

func update_text():
	text = completed_text + "[color=green]" + partial_text + "[/color]"

func _process(_delta):
	update_text()

var completed_text := ""
var partial_text := ""

var spell : String

func _on_speech_to_text_transcribed_msg(is_partial, new_text):
	
	var full_text = completed_text + partial_text + new_text

	if contains_spell(full_text, fireball):
		print("Fireball !!!")
		spell = "fireball"

	if contains_spell(full_text, thunderbolt):
		print("Thunderbolt !!!")
		spell = "thunderbolt"

	if is_partial:
		completed_text += new_text
		partial_text = ""
	else:
		if new_text != "":
			partial_text = new_text

func contains_spell(text: String, spell_list: Array) -> bool:
	text = text.to_lower()
	for spell in spell_list:
		if spell.to_lower() in text:
			return true
	return false
