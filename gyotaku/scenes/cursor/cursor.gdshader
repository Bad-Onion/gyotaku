shader_type canvas_item;

uniform vec4 paint_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

void fragment() {
    vec4 current_color = texture(TEXTURE, UV);
    
    // Se o pixel for 100% branco (cerda do pincel)
    if (current_color.rgb == vec3(1.0, 1.0, 1.0) && current_color.a > 0.0) {
        // Troca pra cor da tinta, mantendo a transparência original do pixel
        COLOR = vec4(paint_color.rgb, current_color.a);
    } else {
        // Se for o cabo de madeira do pincel, ou contorno preto, não faz nada
        COLOR = current_color;
    }
}