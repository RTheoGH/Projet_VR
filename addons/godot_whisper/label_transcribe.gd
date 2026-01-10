extends RichTextLabel

var fireball = ["fireball","fire ball", "for your", "thank you paul", "good boy", "fire bolt", "firebolt", "by your board, maxwell"]
var thunderbolt = ["thunderbolt","thunder bolt","sandobold","fenderbird","sander bolt","sanderbald", "fender ball", "fedo bool"]
var light = ["light","lite","lay te","late"]
var antigrav = ["gravity","gray vity","grave ity"]

var pointeur : Node = null

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

var spellbook : Dictionary[String, Spell] = {
	"light": preload("res://spells/resources/light.tres"),
	"fireball": preload("res://spells/resources/fireball.tres"),
	"antigrav":  preload("res://spells/resources/antigrav.tres"),
	"thunderbolt" : preload("res://spells/resources/thunderbolt.tres")
}

func _on_speech_to_text_transcribed_msg(is_partial, new_text):
	var spell : String = ""
	
	var full_text: String =  new_text

	if contains_spell(full_text, fireball):
		print("Fireball !!!")
		spell = "fireball"

	if contains_spell(full_text, thunderbolt):
		print("Thunderbolt !!!")
		spell = "thunderbolt"
		
	if contains_spell(full_text, light):
		print("light !!!")
		spell = "light"
		
	if contains_spell(full_text, antigrav):
		print("antigrav !!!")
		spell = "antigrav"

	if spellbook.has(spell):
		var spell_to_launch : Spell = spellbook[spell]
		if get_parent().launched_from_game:
			pointeur = get_parent().get_parent().get_node("pointeur")
			spell_to_launch.launch(pointeur.global_transform,pointeur)

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
