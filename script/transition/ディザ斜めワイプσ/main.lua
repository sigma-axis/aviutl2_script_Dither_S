--information:ディザ斜めワイプσ@Dither_S ${PACKAGE_VERSION} by ${AUTHOR}
---$script_tips:「ディザ斜めクリッピングσ」のシーンチェンジ版です．
--label:Dither_S
--require:${LEAST_AVIUTL_VERSION}
---$tips:時間制御で 0 から 100 まで緩急を付けた移動を設定できます．
---$track:進捗, min = 0, max = 100, step = 0.01
local progress = 0

---$check:反転
local invert = false

---$tips:0% から 100% までの段階の個数．
---$track:諧調数, min = 2, max = 512, step = 1, scale = 0.015625
local steps = 2

--group:斜めクリッピング設定,true
---$track:角度, min = -3600, max = 3600, step = 0.01, scale = 0.1
local grad_angle = 0

---$track:ぼかし, min = 0, max = 2000, step = 0.01, scale = 0.25
local grad_blur = 100

---$select:補間方法
---線形補間 = 0
---エルミート補間 = 1
local grad_interpol = 0

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
---     :  progress: number?,
---     :  invert: boolean|number|nil,
---     :  steps: number?,
---     :  grad_angle: number?,
---     :  grad_blur: number?,
---     :  grad_interpol: number?,
---     :  pattern: string?,
---     :  intensity: number?,
---     :  scale: number?,
---     :  X, Y: number?,
---     :  angle: number?,
---     :  dither_seed: number?,
---     :}
---$value:PI
local PI = {}

--[[pixelshader@apply_lerp:
---$include "apply_lerp.hlsl"
]]
const dither_s = require("Dither_S");
const obj, tonumber, math = obj, tonumber, math;

-- set anchor.
if pattern ~= 0 then dither_s.setanchor("X,Y") end

--#region PI / normalize parameters.

-- take parameters.
if type(PI.progress) == "number" then progress = PI.progress / 100;
elseif obj.getoption("track_mode", "progress") ~= 0 then progress /= 100;
else progress = obj.getvalue("scenechange") end
invert = dither_s.PI.as_bool(PI.invert, invert);
steps = tonumber(PI.steps) ?? steps;
grad_angle = tonumber(PI.grad_angle) ?? grad_angle;
grad_blur = tonumber(PI.grad_blur) ?? grad_blur;
grad_interpol = dither_s.PI.interpol_mode(PI.grad_interpol, grad_interpol);
pattern = dither_s.PI.pattern(PI.pattern, pattern);
intensity = tonumber(PI.intensity) ?? intensity;
scale = tonumber(PI.scale) ?? scale;
X = tonumber(PI.X) ?? X;
Y = tonumber(PI.Y) ?? Y;
angle = tonumber(PI.angle) ?? angle;
dither_seed = tonumber(PI.dither_seed) ?? dither_seed;

-- normalize parameters.
progress = math.min(math.max(progress, 0), 1);
steps = math.min(math.max(math.floor(0.5 + steps), 2), 2 ^ 12);
grad_angle = 2 * math.pi * ((grad_angle / 360) % 1);
const grad_c, grad_s = math.sin(grad_angle), -math.cos(grad_angle); -- 0 is up, clockwise.
grad_blur = math.max(grad_blur, 2 ^ -10);

dither_seed = dither_s.modify_seed(dither_seed);
intensity = math.min(math.max(intensity / 100, 0), 1 - 2 ^ -10);
scale = math.max(scale / 100, 1);
X += obj.screen_w / 2; Y += obj.screen_h / 2;
angle = 2 * math.pi * ((angle / 360) % 1);
const c, s = math.cos(angle) / scale, math.sin(angle) / scale;

--#endregion PI / normalize parameters.

-- further calculations.
const cache_pat = "cache:dither_s/pat";
if invert then progress = 1 - progress end
const grad_x, grad_y, grad_dx, grad_dy =
	grad_c > 0 ? 0 : obj.screen_w, grad_s > 0 ? 0 : obj.screen_h,
	(grad_c > 0 ? 1 : -1) * obj.screen_w, (grad_s > 0 ? 1 : -1) * obj.screen_h;
const grad_len =
	(grad_c * grad_x + grad_s * grad_y) +
	(grad_c * grad_dx + grad_s * grad_dy) * progress - grad_blur * (1 - progress);

-- generate the dither pattern.
obj.clearbuffer(cache_pat, obj.screen_w, obj.screen_h);
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
obj.pixelshader("apply_lerp@ディザ斜めワイプσ@Dither_S", "framebuffer", {
	invert ? "framebuffer" : "object",
	invert ? "object" : "framebuffer", cache_pat }, {
	grad_c, grad_s;
	grad_len; grad_blur;
	1 / (steps - 1); intensity; grad_interpol;
});
