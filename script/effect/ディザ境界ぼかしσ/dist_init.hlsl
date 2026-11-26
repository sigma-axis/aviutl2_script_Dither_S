Texture2D src : register(t0);
cbuffer constant0 : register(b0) {
	float threshold;
};
float4 dist_init(float4 pos : SV_Position) : SV_Target {
	const float a = src[pos.xy].a;
	const uint2 p = a > threshold ? p_none : uint2(pos.xy);
	return half4(enc(p), 0, 1);
}
