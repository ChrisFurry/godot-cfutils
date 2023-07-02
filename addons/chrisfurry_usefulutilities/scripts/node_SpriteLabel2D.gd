## A label for SpriteFonts.
@tool
extends Node2D;

@export_multiline var text:String	= "":
	set(value):
		if(text == value): return;
		text = value;
		queue_redraw();

@export var font:Resource:
	set(value):
		if(value == null): font = null;
		if(value.has_method("is_valid")):
			if(value.is_valid()): 
				font = value;
				font.pre_calculate_character_sizes();
				queue_redraw();
				return;
		print_debug("FONT IS NOT VALID PROGRAMMER FIX YOUR RESOURCE");

@export var monospaced:bool			= false:
	set(value):
		monospaced = value;
		queue_redraw();

@export_enum("Left","Center","Right") var h_align:int = 0:
	set(value):
		h_align = value;
		queue_redraw();

@export_enum("Top","Center","Bottom") var v_align:int = 0:
	set(value):
		v_align = value;
		queue_redraw();

@export var character_spacing:Vector2i = Vector2i.ZERO:
	set(value):
		character_spacing = value;
		queue_redraw();

func _draw():
	# If there is no text, do not draw
	if(text.length() <= 0): return;
	# If there is no font, do not draw
	if(font == null): return;
	# Split the paragraphs into an array
	var lines = text.split("\n");
	var paragraph = 0;
	# V Align
	var line_y_offset = 0;
	match(v_align):
		1: line_y_offset = -(lines.size() * (font.get_base_letter_size().y + character_spacing.y)) * 0.5;
		2: line_y_offset = -(lines.size() * (font.get_base_letter_size().y + character_spacing.y));
		_: line_y_offset = 0;
	# Go through each line
	for line in lines:
		var line_x_offset = 0;
		match(h_align):
			1: line_x_offset = -(font.get_text_size(line,monospaced).x + (character_spacing.x * line.length())) * 0.5;
			2: line_x_offset = -(font.get_text_size(line,monospaced).x + (character_spacing.x * line.length()));
			_: line_x_offset = 0;
		# Check if the current line has words.
		if(line.length() > 0):
			# Create temp vars
			var text_pos = line_x_offset;
			# Itirate through each letter
			for letter in line:
				# Check if this is even possible
				if(font.has_character(letter) && letter != " "):
					# Draw the letter
					draw_letter(letter,Vector2(text_pos,line_y_offset + paragraph * (font.get_base_letter_size().y + character_spacing.y)));
					# Add to text pos
					if(monospaced): text_pos += font.get_base_letter_size().x + font.character_spacing + character_spacing.x;
					else: text_pos += font.get_letter_size(letter).x + font.character_spacing + character_spacing.x;
				else:
					text_pos += font.get_space_size();
		# Move down a paragraph
		paragraph += 1;

func draw_letter(letter:String,letter_position:Vector2)->void:
	var letter_pos = font.get_character_texture_position(letter);
	draw_texture_rect_region(font.texture,Rect2(letter_position,font.get_base_letter_size()),Rect2(letter_pos,font.get_base_letter_size()));
