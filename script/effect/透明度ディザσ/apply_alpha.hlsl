Texture2D src : register(t0);
Texture2D pat : register(t1);
cbuffer constant0 : register(b0) {
	float step_size, intensity;
};
float4 apply_alpha(float4 pos : SV_Position) : SV_Target {
	float4 c = src[pos.xy]; const float noise = pat[pos.xy].a;
	c.rgb = c.a != 0 ? c.rgb / c.a : 0;

	float i = floor(c.a / step_size), f = frac(c.a / step_size);
	f = saturate((f - intensity * noise) / (1 - intensity));
	c.a = (i + f) * step_size;

	c.rgb *= c.a;
	return c;
}
