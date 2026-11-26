--information:ディザポリトーンσ@Dither_S ${PACKAGE_VERSION} by ${AUTHOR}
---$script_tips:輝度に応じたグラデーションを，選んだディザリングのパターンで適用します．
--label:Dither_S
--filter
--require:${LEAST_AVIUTL_VERSION}
---$tips:全体的なフィルタの影響度
---$track:強さ, min = 0, max = 100, step = 0.01
local filter_intensity = 100

--group:色設定,true
-- ---$tips:元画像の輝度 0% (黒) に対応する色
--colorlist@colors:暗い色|中間色,0x202028|0x307060|0xb08048,15,position
---$tips:元画像の輝度 100% (白) に対応する色
---$color:明るい色
local color_white = 0xfff0d0

--group:パターン設定,true
---$nolang: options
---$select:パターン
---Flat = 0
---Checker = 1
---Bayer 2x2 = 2
---Bayer 4x4 = 3
---Bayer 256x256 = 4
---IGN = 5
---White Noise = 6
---Perlin Noise = 7
---Halftone = 8
---Halftone Honeycomb = 9
---Halftone Square = 10
---Stripe = 11
local pattern = 3

---$track:ディザ強さ, min = 0, max = 100, step = 0.01
local intensity = 100

---$tips:パターンの拡大率
---$track:ドットサイズ, min = 100, max = 6400, step = 0.01, scale = 0.0625
local scale = 100

--hide@scale:pattern==0
---$nolang: name
---$tips:パターンの移動量
---$track:X, min = -4000, max = 4000, step = 0.01, scale = 0.25
local X = 0

--hide@X:pattern==0
---$nolang: name
---$tips:パターンの移動量
---$track:Y, min = -4000, max = 4000, step = 0.01, scale = 0.25
local Y = 0

--hide@Y:pattern==0
--trackgroup@X,Y:Origin
---$tips:パターンの回転角度
---$track:回転, min = -3600, max = 3600, step = 0.01, scale = 0.1
local angle = 0

--hide@angle:pattern==0
---$tips:0 以上だと同じシードでも別オブジェクトだと別の乱数．
---     :負だと同じシードなら別オブジェクトでも同じ乱数．
---$track:ノイズシード, min = -65536, max = 65535, step = 1
local dither_seed = 10000

--hide@dither_seed:pattern==0
--hide@dither_seed:pattern==1
--hide@dither_seed:pattern==2
--hide@dither_seed:pattern==3
--hide@dither_seed:pattern==4
--hide@dither_seed:pattern==8
--hide@dither_seed:pattern==9
--hide@dither_seed:pattern==10
--hide@dither_seed:pattern==11
--group:その他,false
---$nolang: name
---$tips:PI = {
---     :  filter_intensity: number?,
---     :  color_black: number?,
---     :  mid_colors: table?,
---     :  color_white: number?,
---     :  pattern: string?,
---     :  intensity: number?,
---     :  scale: number?,
---     :  X, Y: number?,
---     :  angle: number?,
---     :  dither_seed: number?,
---     :}
---$value:PI
local PI = {}

--[[pixelshader@apply_tone:
---$include "apply_tone.hlsl"
]]
const dither_s = require("Dither_S");
const obj, tonumber, type, math = obj, tonumber, type, math;

-- set anchor.
if pattern ~= 0 then dither_s.setanchor("X,Y") end

--#region PI / normalize parameters.

-- take parameters.
filter_intensity = tonumber(PI.filter_intensity) ?? filter_intensity;
colors[1].col = tonumber(PI.color_black) ?? colors[1].col;
if type(PI.mid_colors) == "table" then
	const N = math.min(#PI.mid_colors, 14);
	for i = 1, N do
		local C = colors[i + 1];
		if not C then
			C = {
				col = colors[i].col,
				pos = (100 + (N - i + 1) * colors[i].pos) / (N - i + 2),
			};
			colors[i + 1] = C;
		end
		const c = PI.mid_colors[i];
		if type(c) == "table" then
			C.col = tonumber(c.col) ?? C.col;
			C.pos = tonumber(c.pos) ?? C.pos;
		end
	end
	for i = #colors, N + 2, -1 do colors[i] = nil end
end
color_white = tonumber(PI.color_white) ?? color_white;
pattern = dither_s.PI.pattern(PI.pattern, pattern);
intensity = tonumber(PI.intensity) ?? intensity;
scale = tonumber(PI.scale) ?? scale;
X = tonumber(PI.X) ?? X;
Y = tonumber(PI.Y) ?? Y;
angle = tonumber(PI.angle) ?? angle;
dither_seed = tonumber(PI.dither_seed) ?? dither_seed;

-- normalize parameters.
filter_intensity = math.min(math.max(filter_intensity / 100, 0), 1);
if filter_intensity <= 0 then return end

const col_list = {}; -- { index, luma, color }[].
for i, c in ipairs(colors) do
	col_list[i] = { i, math.min(math.max(c.pos / 100, 0), 1), c.col };
end
col_list[1][2] = 0;
col_list[#col_list + 1] = { #col_list + 1, 1, color_white };
-- table.sort() is not stable sorting, so the comparison takes the indices into account.
table.sort(col_list, |a, b|-> a[2] < b[2] ? true : a[2] > b[2] ? false : a[1] < b[1]);
const cols = {};
for i, v in ipairs(col_list) do
	const c = math.floor(0.5 + v[3]);
	cols[4 * i - 3], cols[4 * i - 2], cols[4 * i - 1], cols[4 * i] =
		(c & 0xff0000) / 0xff0000,
		(c & 0x00ff00) / 0x00ff00,
		(c & 0x0000ff) / 0x0000ff, v[2];
end
while #cols < 4 * 16 do
	cols[#cols + 1], cols[#cols + 2], cols[#cols + 3], cols[#cols + 4] =
		0, 0, 0, 2;
end

dither_seed = dither_s.modify_seed(dither_seed);
intensity = math.min(math.max(intensity / 100, 0), 1 - 2 ^ -10);
scale = math.max(scale / 100, 1);
const cx, cy = obj.getvalue("center");
X += cx + obj.cx + obj.w / 2; Y += cy + obj.cy + obj.h / 2;
angle = 2 * math.pi * ((angle / 360) % 1);
const c, s = math.cos(angle) / scale, math.sin(angle) / scale;

--#endregion PI / normalize parameters.

-- generate the dither pattern.
const cache_pat = "cache:dither_s/pat";
obj.clearbuffer(cache_pat, obj.w, obj.h);
obj.pixelshader("gen_pat@ディザマスクσ@Dither_S", cache_pat, nil, {
	1, 0, 0, 0,
	0, 1; 0, 0;
	1, 0, 0, 0,
	0, 1; 0, 0;
	1, 0, 0, 0,
	0, 1; 0, 0;
	c, -s, 0, 0,
	s, c; X, Y;
	pattern; dither_seed;
});

-- apply shader.
obj.pixelshader("apply_tone@ディザポリトーンσ@Dither_S", "object", { "object", cache_pat }, {
	filter_intensity; intensity; 0, 0;
	unpack(cols)
});
