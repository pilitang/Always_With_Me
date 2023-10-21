class_name ToastStyle
extends Resource



enum Position{
	Top,
	Bottom
};

enum Type{
	Float,
	Full
};

@export var position: Position = Position.Bottom;
@export var toastType: Type = Type.Float;

@export var backgroundColor = Color( 1, 1, 1, 1); # (Color, RGBA)
@export var fontColor = Color( 0.01, 0.01, 0.01, 1); # (Color, RGBA)

@export var cornerRadius: int = 50;
@export var contentMarginLeft: float = 45.0;
@export var contentMarginRight: float = 45.0;
@export var contentMarginTop: float = 20.0;
@export var contentMarginBottom: float = 20.0;

@export var textAlign = 1; # (int, "Left", "Center", "Right", "Fill")
