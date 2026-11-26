--information:ディザマスクσ@Dither_S ${PACKAGE_VERSION} by ${AUTHOR}
---$script_tips:選んだディザリングのパターンで画像を切り抜きます．
--label:Dither_S
--filter
--require:${LEAST_AVIUTL_VERSION}
---$tips:透明部分の面積比
---$track:透明度, min = 0, max = 100, step = 0.01
local alpha = 50

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
---     :  alpha: number?,
---     :  pattern: string?,
---     :  intensity: number?,
---     :  scale: number?,
---     :  X, Y: number?,
---     :  angle: number?,
---     :  dither_seed: number?,
---     :}
---$value:PI
local PI = {}

--[[pixelshader@gen_pat:
---$include "../../ibukihash.hlsl"
---$include "../../dither_func.hlsl"
---$include "gen_pat.hlsl"
]]
--[[pixelshader@apply_mask:
---$include "apply_mask.hlsl"
]]
const dither_s = require("Dither_S");
const obj, tonumber, math = obj, tonumber, math;

-- set anchor.
if pattern ~= 0 then dither_s.setanchor("X,Y") end

--#region PI / normalize parameters.

-- take parameters.
alpha = tonumber(PI.alpha) ?? alpha;
pattern = dither_s.PI.pattern(PI.pattern, pattern);
intensity = tonumber(PI.intensity) ?? intensity;
scale = tonumber(PI.scale) ?? scale;
X = tonumber(PI.X) ?? X;
Y = tonumber(PI.Y) ?? Y;
angle = tonumber(PI.angle) ?? angle;
dither_seed = tonumber(PI.dither_seed) ?? dither_seed;

-- normalize parameters.
alpha = math.min(math.max(1 - alpha / 100, 0), 1);
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

-- apply dithering.
obj.pixelshader("apply_mask@ディザマスクσ@Dither_S", "object", cache_pat, {
	alpha; intensity;
}, "mask");
