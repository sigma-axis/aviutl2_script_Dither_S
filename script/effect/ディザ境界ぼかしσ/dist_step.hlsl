Texture2D prev : register(t0);
cbuffer constant0 : register(b0) {
	float2 size_f, range;
	float step_len_f;
};
static const uint2 size = uint2(size_f);
static const int step_len = int(step_len_f);

float4 dist_step(float4 pos : SV_Position) : SV_Target
{
	const uint2 p0 = int2(pos.xy);

	uint2 p_min = p_none;
	float len_sq_min = 4;
	[unroll] for (int j = -1; j <= 1; j++) {
		[unroll] for (int i = -1; i <= 1; i++) {
			uint2 p = uint2(p0 + int2(i, j) * step_len);
			if (all(p < size)) p = dec(prev[p].xy);

			const int2 dp = int2(p) - int2(p0);
			const float2 dp1 = range > 0 ? dp / range : dp == 0 ? 0 : 1;
			const float len_sq = dot(dp1, dp1);
			if (valid(p) && len_sq < len_sq_min) {
				p_min = p;
				len_sq_min = len_sq;
			}
		}
	}

	return half4(enc(p_min), 0, 1);
}
