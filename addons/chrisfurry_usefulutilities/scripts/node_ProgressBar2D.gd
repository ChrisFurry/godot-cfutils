## A simple progress bar that tiles.
@tool
extends Node2D;

@export var stretch			:= false;

@export_range(0.0,1.0) var progress:float	= 0.5:
	set(value):
		progress = value;
		queue_redraw();

@export var bar_size:int = 16:
	set(value):
		bar_size = value;
		queue_redraw();

@export var bar_texture:Texture2D:
	set(value):
		bar_texture = value;
		queue_redraw();
@export var back_texture:Texture2D:
	set(value):
		back_texture = value;
		queue_redraw();
@export_enum("Left","Middle","Right") var h_align:int = 0:
	set(value):
		h_align = clamp(value,0,2);
		queue_redraw();
@export_enum("Top","Middle","Bottom") var v_align:int = 0:
	set(value):
		v_align = clamp(value,0,2);
		queue_redraw();
@export_enum("Left","Middle","Right") var progress_align:int = 0:
	set(value):
		progress_align = clamp(value,0,2);
		queue_redraw();

func _draw():
	if(bar_size <= 0): return;
	if(back_texture != null): 
		var offset_x:int = 0;
		var offset_y:int = 0;
		match(h_align):
			1: offset_x = -bar_size / 2;
			2: offset_x = -bar_size;
		match(v_align):
			1: offset_y = -back_texture.get_height() / 2;
			2: offset_y = -back_texture.get_height();
		var texture_width = back_texture.get_width();
		# Ensure the texture repeats even if it is an atlas texture.
		if(texture_width >= 2 && back_texture is AtlasTexture):
			for pos in ceil(bar_size / float(texture_width)):
				var size = Vector2(min(bar_size - (pos * texture_width),texture_width),back_texture.get_height());
				draw_texture_rect_region(
					back_texture,Rect2(Vector2(offset_x + pos * texture_width,offset_y),size),
					Rect2(Vector2.ZERO,size));
		else:
			var size = Vector2(ceil(bar_size),back_texture.get_height());
			draw_texture_rect(back_texture,Rect2(Vector2(offset_x,offset_y),size),true);
	if(progress <= 0.): return;
	if(bar_texture != null && bar_texture is AtlasTexture):
		# Define offset temps
		var offset_x:int = 0;
		var offset_y:int = 0;
		# Horizontal Align
		match(h_align):
			1: offset_x = -bar_size / 2;	# Middle
			2: offset_x = -bar_size;		# Right
		match(v_align):
			1: offset_y = -back_texture.get_height() / 2;	# Middle
			2: offset_y = -back_texture.get_height();		# Bottom
		match(progress_align):
			1: offset_x += bar_size / 2 - ceil(progress * bar_size) / 2;
			2: offset_x += bar_size - ceil(progress * bar_size);
		var texture_width = bar_texture.get_width();
		if(texture_width >= 2 && !stretch):
			for pos in ceil((bar_size * progress) / float(texture_width)):
				var size = Vector2(min(ceil(bar_size * progress) - (pos * texture_width),texture_width),bar_texture.get_height());
				draw_texture_rect_region(
					bar_texture,Rect2(Vector2(offset_x + pos * texture_width,offset_y),size),
					Rect2(Vector2.ZERO,size));
		else:
			var size = Vector2(ceil(bar_size * progress),bar_texture.get_height());
			draw_texture_rect(bar_texture,Rect2(Vector2(offset_x,offset_y),size),true);
	
