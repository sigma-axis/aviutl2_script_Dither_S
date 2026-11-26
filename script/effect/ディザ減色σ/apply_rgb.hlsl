Texture2D src : register(t0);
Texture2D pat : register(t1);
cbuffer constant0 : register(b0) {
	float3 step_size;
	float cff;
	float3 intensity;
	float modified_f;
};
static const bool modified = modified_f > 0;
float3 to_linear(float3 c)
{
	static const float4 K = { 0.055, 1 / 1.055, 1 / 12.92, 0.04045 };
	return abs(c) <= K.w ? K.z * c : sign(c) * pow((abs(c) + K.x) * K.y, 2.4);
}
float3 from_linear(float3 c)
{
	static const float4 K = { 0.055, 1.055, 12.92, 0.0031308 };
	return abs(c) <= K.w ? K.z * c : sign(c) * (K.y * pow(abs(c), 1 / 2.4) - K.x);
}
float4 apply_rgb(float4 pos : SV_Position) : SV_Target {
	float4 c = src[pos.xy]; const float3 noise = pat[pos.xy].rgb;
	c.rgb = c.a != 0 ? c.rgb / c.a : 0;
	if (modified) c.rgb = to_linear(c.rgb);
	c.rgb = (1 - 2 * cff) * c.rgb + cff;

	float3 i = floor(c.rgb / step_size), f = frac(c.rgb / step_size);
	f = saturate((f - intensity * noise) / (1 - intensity));
	c.rgb = (i + f) * step_size;

	c.rgb = (1 - 2 * cff) * c.rgb + cff;
	if (modified) c.rgb = from_linear(c.rgb);
	c.rgb = saturate(c.rgb);
	c.rgb *= c.a;
	return c;
}
