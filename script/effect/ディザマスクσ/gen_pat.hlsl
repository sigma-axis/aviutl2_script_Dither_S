cbuffer constant0 : register(b0) {
	float2x2 rot0;
	float2 mov0;
	float2x2 rot1;
	float2 mov1;
	float2x2 rot2;
	float2 mov2;
	float2x2 rot3;
	float2 mov3;
	float pattern_f, seed_f;
};
static const uint pattern = uint(pattern_f), seed = uint(seed_f);
float4 gen_pat(float4 pos : SV_Position) : SV_Target {
	return float4(
		dither_func(mul(rot0, pos.xy - mov0), uint2(seed, 1481), pattern),
		dither_func(mul(rot1, pos.xy - mov1), uint2(seed, 1483), pattern),
		dither_func(mul(rot2, pos.xy - mov2), uint2(seed, 1487), pattern),
		dither_func(mul(rot3, pos.xy - mov3), uint2(seed, 1489), pattern));
}
