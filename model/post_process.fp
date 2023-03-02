// Adapted from: https://www.shadertoy.com/view/Nl33zX

varying mediump vec2 var_texcoord0;
varying mediump vec2 pos;
uniform lowp sampler2D effects;


const vec3 RESOLUTION = vec3(960.0, 640.0, 0);
const float BLURAMOUNT = 4.0;
void main()
{
    vec2 uv = var_texcoord0.xy;

    vec3 average = vec3(0.0);

    float amount = 0.0;
    for (float y = -BLURAMOUNT; y <= BLURAMOUNT; y += 1.0) {
        for (float x = -BLURAMOUNT; x <= BLURAMOUNT; x += 1.0) {
            vec3 t = texture(effects, uv + vec2(x, y) / RESOLUTION.xy).rgb;
            average += t;
            amount += 1.0;

        }
    } 

    vec3 col = average / amount;
    
    gl_FragColor = vec4(col,1.0);
}