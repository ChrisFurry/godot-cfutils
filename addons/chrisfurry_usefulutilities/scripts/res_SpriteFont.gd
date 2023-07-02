## Fonts used with SpriteLabel2D.
@tool
extends Resource;

@export var texture:Texture2D;
@export var h_frames:int = 1;
@export var v_frames:int = 1;
## Adds spacing to all characters, even the space. Supports negative numbers.
@export var character_spacing:int = 0;
## Extends specifically only the spaces, supports negative numbers
@export var space_extend:int = 0;
## The characters (in order) left to right, top to bottom on the texture.
@export_multiline var character_map:String = "";

var saved_character_sizes:Array = [];

func _init(): pre_calculate_character_sizes();

func pre_calculate_character_sizes():
	for i in character_map:
		saved_character_sizes.append(get_letter_size(i));

func is_valid()->bool:
	if(h_frames <= 0 || v_frames <= 0 || character_map.length() <= 0): return false;
	return true;

func get_base_letter_size()->Vector2i: return Vector2i(texture.get_width() / h_frames,texture.get_height() / v_frames);

func get_letter_size(letter:String)->Vector2i:
	# You used a space that's not a valid letter
	if(letter == " "): return Vector2i(get_space_size(),get_base_letter_size().y);
	# If there is no alpha, just return the base size
	if(!has_character(letter)): return get_base_letter_size();
	# Pre-calculated the sizes already? just take one from those lol
	if(saved_character_sizes.size() > get_character(letter)): return saved_character_sizes[get_character(letter)];
	# Time to calculate how large the letter really is
	# Get the letter position
	var letter_position = get_character_texture_position(letter);
	# Get the image and crop it
	var img = texture.get_image().get_region(Rect2i(letter_position,get_base_letter_size()));
	# Get the rect used
	var used_rect = img.get_used_rect();
	# Return size
	return used_rect.position + used_rect.size;

func get_space_size()->int: return get_base_letter_size().x + space_extend;

func get_text_size(text:String, monospaced:bool = true)->Vector2:
	if(monospaced): return Vector2i(get_base_letter_size().x * text.length(),get_base_letter_size().y);
	# Just generate them if it hasn't been done yet, so then no lag is caused later.
	if(saved_character_sizes.size() <= 0): pre_calculate_character_sizes();
	var sizex = 0;
	for letter in text: sizex += get_letter_size(letter).x;
	return Vector2(sizex + (character_spacing * text.length()),get_base_letter_size().y);

func has_character(character:String)->bool:
	if(character == " "): return false;
	return (character_map.find(character) != -1);

func get_character(character:String)->int:
	if(character == " "): return -1;
	return character_map.find(character);

func get_character_texture_position(character:String)->Vector2:
	if(!has_character(character)): return Vector2.ZERO;
	var id = character_map.find(character);
	return Vector2(id % h_frames,floor(id) / h_frames) * Vector2(get_base_letter_size());

