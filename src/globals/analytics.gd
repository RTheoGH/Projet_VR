extends Node



var template_spell_data: Dictionary = {
	"number_cast": 0,
	"kills_by_spell": [] as Array[int],
	
}
# should be const but then we can't use duplicate. Oh well...
var template_session_data: Dictionary = {
	"general": {
		"meta": {
			"player_age": 0,
			"player_gender": "",
			"player_proficiency_of_VR": 5, # [0, 10]
			"player_proficiency_of_videogames": 5, # [0, 10]
		}
	},
	"room1": {
		"general": {
			"completion_time": 0.0,
			"time_before_first_spell": 0.0,
			},
		"spells": {
			"fireball": template_spell_data.duplicate_deep(),
			"antigrav": template_spell_data.duplicate_deep(),
			"light":  template_spell_data.duplicate_deep(),
			"lightning":  template_spell_data.duplicate_deep(),
		}
	},
	"room2": {
		# TODO etc
	}
}


var save_directory: String = "./"
var current_session_id: String
var current_session_data: Dictionary

func save_session() -> bool:
	return false

# call this. It saves
func new_session(identifier: String) -> bool:
	current_session_id = identifier
	
	var could_save := save_session()
	if not could_save:
		return false
		
	current_session_data = template_session_data.duplicate_deep()
	return true

func set_value(path: String, value: Variant) -> void:
	# access the dict as a path, for easier access
	var path_elems: Array[String] = path.split("/", false)
	var elem: String = path_elems.pop_back()
	var current_dict_ref: Dictionary = current_session_data
	for dict_name in path_elems:
		if not current_dict_ref.has(dict_name):
			push_error("ANALYTICS : Path not resolved : (", path, "). Please check the template in analytics.gd.")
			return
		current_dict_ref = current_dict_ref[dict_name]
	
	if not current_dict_ref.has(elem) or (typeof(elem) != typeof(current_dict_ref[elem])):
			push_error("ANALYTICS : Wrong type at: (", path, ") : You tried to set this value : (", value, ") of type ", typeof(elem), "(expected ",  typeof(current_dict_ref[elem]), "). Please check the template in analytics.gd.")
			return
	current_dict_ref[elem] = value

func push_value(path: String, value: Variant) -> void:
	# access the dict as a path, for easier access
	var path_elems: Array[String] = path.split("/", false)
	var elem: String = path_elems.pop_back()
	var current_dict_ref: Dictionary = current_session_data
	for dict_name in path_elems:
		if not current_dict_ref.has(dict_name):
			push_error("ANALYTICS : Path not resolved : (", path, "). Please check the template in analytics.gd.")
			return
		current_dict_ref = current_dict_ref[dict_name]
	
	if not current_dict_ref.has(elem) or (typeof(elem) != typeof(current_dict_ref[elem])):
			push_error("ANALYTICS : Wrong type at: (", path, ") : You tried to push this value : (", value, ") of type ", typeof(elem), "(into array of type ",  typeof(current_dict_ref[elem]), "). Please check the template in analytics.gd.")
			return
	current_dict_ref[elem].push_back(value)

func add_monitored(object: Object, var_name: String, targt_analytics_path: String):
	pass
