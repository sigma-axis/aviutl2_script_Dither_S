# Dither_S AviUtl ExEdit2 パターンディザリングスクリプト

パターン模様でのディザリングを利用した様々なフィルタ効果やシーンチェンジを追加するスクリプトです．

画像の減色や，アルファ値グラデーションの2値化，トライトーンやテトラトーンなどを，パターンディザリングを利用して適用できます．

[ダウンロードはこちら．](https://github.com/sigma-axis/aviutl2_script_Dither_S/releases) [紹介動画．](https://www.nicovideo.jp/watch/sm47091286)

次のフィルタ効果やシーンチェンジが追加されます:

- フィルタ効果:
  1.  [ディザ減色σ](#ディザ減色σ)
  1.  [透明度ディザσ](#透明度ディザσ)
  1.  [ディザポリトーンσ](#ディザポリトーンσ)
  1.  [ディザマスクσ](#ディザマスクσ)
  1.  [ディザ斜めクリッピングσ](#ディザ斜めクリッピングσ)
  1.  [ディザ境界ぼかしσ](#ディザ境界ぼかしσ)

- シーンチェンジ:
  1.  [ディザ斜めワイプσ](#ディザ斜めワイプσ)
  1.  [ディザシーンチェンジσ](#ディザシーンチェンジσ)

![ディザ減色σの適用例](https://github.com/user-attachments/assets/4ba34576-14e0-45a8-a468-28d75d38a4f7)

![ディザポリトーンσの適用例](https://github.com/user-attachments/assets/58a6e431-fe6d-49b3-9c62-242ce8168a15)

![ディザ斜めクリッピングσの適用例](https://github.com/user-attachments/assets/242c7484-ba94-4750-8346-55fa7395f16f)

- <details>
  <summary>元画像出典 (クリックで表示):</summary>

  1.  https://www.pexels.com/photo/scenic-view-of-lake-against-sky-during-sunset-258136
  1.  https://www.pexels.com/photo/green-leafed-tree-beside-body-of-water-during-daytime-158063
  1.  https://www.pexels.com/photo/assorted-color-kittens-45170
  1.  https://www.pexels.com/photo/four-ace-game-cards-534181
  </details>

##  お願い

このスクリプトを使った動画などでは，ニコニコの親作品にこのスクリプトの紹介動画を登録してくれると嬉しいです．任意ではありますが，登録してくれたほうが励みになります．

- 登録 ID: `sm47091286`

##  動作要件

- AviUtl ExEdit2

  http://spring-fragrance.mints.ne.jp/aviutl

  - `2.1.19a` で動作確認済み．

## 導入方法

ダウンロードした `aviutl2_script_Dither_S-v*.**.au2pkg.zip` を AviUtl2 のウィンドウにドラッグ & ドロップしてください．

初期状態だと「フィルタオブジェクトを追加」や「フィルタ効果を追加」メニューの「Dither_S」に各種フィルタ効果やシーンチェンジが追加されています．
- 「オブジェクト追加メニューの設定」の「ラベル」項目で分類を変更できます．

### For non-Japanese speaking users

You may be able to find a language translation file for this script from [this repository](https://github.com/sigma-axis/aviutl2_translations_sigma-axis). 
Translation files enable names and parameters of the scripts / filters to be displayed in other languages.

However, usage documentations for this script in languages other than Japanese are not available now.

##  ディザ減色σ

選んだディザリングのパターンで，画像の色成分を階段状にして減色します．レトロゲームの雰囲気にしたり，網点の印刷物のような演出ができます．

![ディザ減色σの適用例](https://github.com/user-attachments/assets/4ba34576-14e0-45a8-a468-28d75d38a4f7)

[:arrow_right: ディザリングのパターンの設定項目はこちら．](#ディザリングのパターンに関する設定項目)

### 色空間

減色計算に利用する色の座標系を指定します．

次の選択肢があります:

| 色空間 | 説明 |
|:---:|:---|
| `RGB` | 通常の RGB 色空間． |
| `RGB Linear` | ガンマ補正を外した線形 RGB 色空間． |
| `CMY` | `RGB` の白色からの補数で計算． |
| `CMY Linear` | `RGB Linear` の白色からの補数で計算． |

- `RGB` と `CMY` の違いは，減色計算の原点が黒から白に変わるほか，[ディザリングのパターン](#パターン)も反転するので，`Halftone` など一部は見え方が異なります．

初期値は `RGB Linear`.

### 諧調数 1/2/3

色の各 3 成分の諧調数を指定します．小数点以下の調整も可能です．

1/2/3 は[「色空間」](#色空間)で指定した色空間の各成分に対応しています．
- `RGB` :arrow_right: 1 が R (赤) 成分 / 2 が G (緑) 成分 / 3 が B (青) 成分．
- `CMY` :arrow_right: 1 が C (シアン) 成分 / 2 が M (マゼンタ) 成分 / 3 が Y (黄) 成分．

最小値は 2, 最大値は 512, 初期値は 3.

### 成分 1/2/3 個別設定

[ディザリングのパターンに関する設定](#ディザリングのパターンに関する設定項目)に加えて，色の各成分ごとに個別に一部設定を追加調整できます．

次の項目が調整可能です．

- **ディザ強さ**

  % 単位で指定して，[「ディザ強さ」](#ディザ強さ)に乗算されます．

  最小値は 0, 最大値は 100, 初期値は 100.

- **ドットサイズ**

  % 単位で指定して，[「ドットサイズ」](#ドットサイズ--x--y--回転)に乗算されます．

  最小値は 100, 最大値は 6400, 初期値は 100.

- **X / Y**

  ピクセル単位で指定して，[「X / Y」](#ドットサイズ--x--y--回転)に加算されます．

  最小値は -4000, 最大値は 4000, 初期値は 0.

- **回転**

  度数単位で指定して，[「回転」](#ドットサイズ--x--y--回転)に加算されます．

  最小値は -3600, 最大値は 3600, 初期値は 0.

##  透明度ディザσ

選んだディザリングのパターンを透明度に適用して，透明度が階段状に変化するようにします．

![透明度ディザσの適用例](https://github.com/user-attachments/assets/ec3c8903-5c0a-4384-8fbb-89a3028baa12)

[:arrow_right: ディザリングのパターンの設定項目はこちら．](#ディザリングのパターンに関する設定項目)

### 諧調数

透明度の諧調数を整数単位で指定します．

- [「ディザ減色σ」の「諧調数」](#諧調数-123)とは異なり，整数単位での指定です．

最小値は 2, 最大値は 512, 初期値は 2.

##  ディザポリトーンσ

輝度に応じたグラデーションを，選んだディザリングのパターンで適用します．

グラデーションには複数色指定でき，トライトーンやテトラトーンなどの表現が可能です．それに加えてディザリングも適用した表現も可能です．

![ディザポリトーンσの適用例](https://github.com/user-attachments/assets/58a6e431-fe6d-49b3-9c62-242ce8168a15)

[:arrow_right: ディザリングのパターンの設定項目はこちら．](#ディザリングのパターンに関する設定項目)

### 強さ

全体的なフィルタの影響度を % 単位で指定します．100 % でかけた場合と未適用の場合を線形補間します．

最小値は 0, 最大値は 100, 初期値は 100.

### 暗い色 / 中間色 / 明るい色

グラデーションの設定をします．「中間色」は「暗い色」の右の :heavy_plus_sign: ボタンで追加でき，合計で最大 16 色まで指定できます．

- 「暗い色」は元画像の輝度 0% (黒) に対応する色で，その色の個所が指定色に置き換わります．
- 「明るい色」は元画像の輝度 100% (白) に対応する色です．
- 「中間色」は白と黒の間の輝度に対応する色で，対応する輝度の個所が指定色に置き換わります．
  - 右にある「色の位置を指定」ボタンで対応する輝度を個別に指定します．個別指定がない場合は均等に割り当てられます．
  - 指定した輝度は必ずしも昇順である必要はありません．大きさに応じて並べ替えられます．

初期値は以下の通り:

- 暗い色: `202028`.
- 中間色 (1つ目): `307060`.
- 中間色 (2つ目): `B08048`.
- 明るい色: `FFF0D0`.

輝度指定の最小値は 0, 最大値は 100.

##  ディザマスクσ

選んだディザリングのパターンで画像を切り抜きます．

![ディザマスクσの適用例](https://github.com/user-attachments/assets/399492f6-9564-4a8f-a6c1-bc3cf31a89aa)

[:arrow_right: ディザリングのパターンの設定項目はこちら．](#ディザリングのパターンに関する設定項目)

### 透明度

透明部分の面積比を % 単位で指定します．

- 必ずしも結果の透明度の平均値が指定値になるわけではありません．いくらか近似計算している部分が含まれるため，大まかな指定ととらえてください．

最小値は 0, 最大値は 100, 初期値は 50.

##  ディザ斜めクリッピングσ

斜めクリッピングのぼかし部分を選んだディザリングのパターンにします．標準の「斜めクリッピング」の拡張版としても使えます．

![ディザ斜めクリッピングσの適用例](https://github.com/user-attachments/assets/242c7484-ba94-4750-8346-55fa7395f16f)

[:arrow_right: ディザリングのパターンの設定項目はこちら．](#ディザリングのパターンに関する設定項目)

### 諧調数

透明度の諧調数を指定します．

[「透明度ディザσ」の「諧調数」](#諧調数)と同等のパラメタです．

### 中心X / 中心Y / 角度 / ぼかし / 幅

標準の「斜めクリッピング」と同等のパラメタです．

- **中心X / 中心Y**

  斜め線の中心位置を指定します．プレビュー画面のアンカーをマウスでドラッグすることでも指定できます．

  最小値は -5000, 最大値は 5000, 初期値は $(0, 0)$.

- **角度**

  斜め線の角度を度数単位で指定します．0 で水平方向で下側をクリッピング，時計回りに正．

  最小値は -3600, 最大値は 3600, 初期値は 0.

- **ぼかし**

  クリッピング境界のぼかし幅をピクセル単位で指定します．このぼかし幅にディザリングのパターンが現れます．

  最小値は 0, 最大値は 2000, 初期値は 100.

- **幅**

  斜めクリッピングの形状を指定します．

  - 0 のとき，指定したラインの片側だけがクリッピングされます．
  - 正のとき，ラインから遠い部分がクリッピングされます．残る部分のライン幅をピクセル単位で指定．
  - 負のとき，ラインから近い部分がクリッピングされます．透明化する部分のライン幅をピクセル単位で，負号をつけて指定．

  最小値は -2000, 最大値は 2000, 初期値は 0.

### 補間方法

[ぼかし幅](#中心x--中心y--角度--ぼかし--幅)のアルファ値グラデーションのカーブを，次の 2 種類から指定します．

| 補間方法 | `線形補間` | `エルミート補間` |
|:---:|:---:|:---:|
| 画像 | ![線形補間の図](https://github.com/user-attachments/assets/2c9c96f4-87df-45ff-86f9-ae08a78d8e50) | ![エルミート補間の図](https://github.com/user-attachments/assets/d6529e4f-d11c-4602-929b-4586d227b8ff) |
| 説明 | 錯視効果で開始・終了点にラインが見える． | 標準の「斜めクリッピング」や<br>「グラデーション」がこの補間法． |

初期値は `線形補間`.

### アンカー基準

[「中心X」「中心Y」](#中心x--中心y--角度--ぼかし--幅)と，そのアンカー位置の基準点を選びます．次の選択肢があります:

| アンカー基準 | 説明 |
|:---:|:---|
| `回転中心` | オブジェクトの回転中心． |
| `左上` | 画像の左上の端 |
| `上` | 画像の上の端 |
| `右上` | 画像の右上の端 |
| `左` | 画像の左の端 |
| `中央` | 画像の中央の端 |
| `右` | 画像の右の端 |
| `左下` | 画像の左下の端 |
| `下` | 画像の下の端 |
| `右下` | 画像の右下の端 |

初期値は `回転中心`.

##  ディザ境界ぼかしσ

選んだディザリングのパターンで境界ぼかしをします．標準の「境界ぼかし」の代わりに使うこともでき，複雑な境界に対しても不連続になりにくくなっています．

![ディザ境界ぼかしσの適用例](https://github.com/user-attachments/assets/1935ba29-2e9b-493c-88ca-b3ea3985f352)

[:arrow_right: ディザリングのパターンの設定項目はこちら．](#ディザリングのパターンに関する設定項目)

### 諧調数

透明度の諧調数を指定します．

[「透明度ディザσ」の「諧調数」](#諧調数)と同等のパラメタです．

### 範囲 / 縦横比 / 透明度の境界をぼかす

標準の「境界ぼかし」と同等のパラメタです (一部は初期値が異なります).

- **範囲**

  ぼかし幅をピクセル単位で指定します．

  最小値は 0, 最大値は 2000, 初期値は 40.

- **縦横比**

  縦横に不均等なぼかしにできます．

  - 正でぼかし幅が横長 (ぼかしがかからない部分が縦長) になります．
  - 負でぼかし幅が縦長 (ぼかしがかからない部分が横長) になります．

  最小値は -100, 最大値は 100, 初期値は 0.

- **透明度の境界をぼかす**

  - OFF の場合，オブジェクト領域の長方形の上下左右端に対して，ぼかし幅の分だけ半透明化します．
  - ON の場合，オブジェクトの透明ピクセルと不透明ピクセルの境界から，ぼかし幅の分だけ半透明化します．

  初期値は ON.

### αしきい値

[「透明度の境界をぼかす」](#範囲--縦横比--透明度の境界をぼかす)が ON の場合のみ有効な設定項目です．

透明度の境界を決定するアルファ値のしきい値を % 単位で指定します．

- 0 だと完全透明と半透明ピクセルの境界．
- 100 だと半透明ピクセルと完全不透明ピクセルの境界．

最小値は 0, 最大値は 100, 初期値は 0.

### 補間方法

アルファ値のグラデーションのカーブを，2 種類から指定します．

[「ディザ斜めクリッピングσ」の「補間方法」](#補間方法)と同等のパラメタです．

##  ディザ斜めワイプσ

[「ディザ斜めクリッピングσ」](#ディザ斜めクリッピングσ)のシーンチェンジ版スクリプトです．

![ディザ斜めワイプσのデモ](https://github.com/user-attachments/assets/0c1753cb-d177-470a-952a-f32251e9c22a)

### 進捗

シーンチェンジの変化割合を調整できます．時間制御で 0 から 100 まで緩急を付けた移動を設定します．

- この項目のトラックバー移動方法が **「移動無し」** の場合，シーンチェンジオブジェクトの時間割合から変化割合を決定します．この場合，この設定項目の数値は無視されます．
- トラックバー移動方法に **「移動無し」** *以外* が割り当てられている場合，この項目の数値がシーンチェンジの変化割合になります．0 から 100 までの % 単位で指定．

最小値は 0, 最大値は 100, 初期値は 0.

### 反転

シーンチェンジの変化を反転させます．次シーンと前シーン，時間の変化方向が逆転します．

初期値は OFF.

### 諧調数

変化割合の諧調数を整数単位で指定します．

最小値は 2, 最大値は 512, 初期値は 2.

### 角度 / ぼかし / 補間方法

[「ディザ斜めクリッピングσ」](#ディザ斜めクリッピングσ)と同等のパラメタです．

##  ディザシーンチェンジσ

シーンチェンジ素材でのシーンチェンジに，選んだディザリングのパターンを適用する，シーンチェンジスクリプトです．

![ディザシーンチェンジσのデモ](https://github.com/user-attachments/assets/018dc807-a6df-4b5b-af7b-20faadd001a9)

### 進捗 / 反転 / 諧調数 / 補間方法

[「ディザ斜めワイプσ」](#ディザ斜めワイプσ)と同等のパラメタです．

### ワイプ画像

シーンチェンジ素材の画像ファイルを指定します．画像の輝度が低い部分から高い部分にかけて，だんだんと次シーンに移っていきます．

- Transition フォルダ内の画像などの利用を想定しています．

未指定，または画像ファイルが読み込めなかった場合は，画面全体が均等にシーンチェンジします．

初期値は `未選択`.

### 縦横比固定

[「ワイプ画像」](#ワイプ画像)を指定している場合のみ有効な設定です．

指定した画像の縦横比を保つかどうかを指定します．

- OFF の場合，ワイプ画像の縦横比も変化させて画面のサイズに拡大縮小されます．
- ON の場合，ワイプ画像の縦横比は保ったまま，画面全体を覆うサイズに拡大縮小されます．

初期値は ON.

### ぼかし幅

[「ワイプ画像」](#ワイプ画像)を指定している場合のみ有効な設定です．

シーンチェンジで前シーンと次シーンの混在する，ワイプ画像の輝度範囲の大きさを調整します．

- 0 の場合，どの時間やワイプ画像の輝度でも前シーン 100% または 次シーン 100% の割合になります．
- 50 の場合，シーンチェンジの中間で「ワイプ画像の輝度 0% だと次シーンが 100%, 輝度 100% だと前シーンが 100%」となるタイミングがあります．
- 100 の場合，ワイプ画像の輝度は無視されて時間経過のみで前シーンと次シーンの混在率が決定します．

最小値は 0, 最大値は 100, 初期値は 20.

##  ディザリングのパターンに関する設定項目

各種スクリプトに共通する，パターン設定に関する設定項目をまとめています．

### パターン

ディザリングのパターン模様を選びます．次の選択肢があります:

| パターン | サンプル |
|:---:|:---:|
| `Flat` | ![ディザリングなし](https://github.com/user-attachments/assets/6ca13b21-b652-4e06-9701-dec46a7fc33a) |
| `Checker` | ![Checker でのディザリング](https://github.com/user-attachments/assets/51ae3815-f4f0-4f88-ac7f-9139c991606d) |
| `Bayer 2x2` | ![Bayer 2x2 でのディザリング](https://github.com/user-attachments/assets/90105ade-c77a-4017-8011-4879c9f52be6) |
| `Bayer 4x4` | ![Bayer 4x4 でのディザリング](https://github.com/user-attachments/assets/ab653d91-fa7e-4fe8-8daf-4fbe7867ed3a) |
| `Bayer 256x256` | ![Bayer 256x256 でのディザリング](https://github.com/user-attachments/assets/ea018a2e-1d1a-404a-a779-55769243a867) |
| `IGN` | ![Interleaved Gradient Noise でのディザリング](https://github.com/user-attachments/assets/e04bd74f-719e-4bfa-b1e6-870116ee8e1e) |
| `White Noise` | ![White Noise でのディザリング](https://github.com/user-attachments/assets/3a588a5c-e36b-4749-b837-ff78d950648f) |
| `Perlin Noise` | ![Perlin Noise でのディザリング](https://github.com/user-attachments/assets/5893e0c7-1a6e-4486-aaeb-ef90a459dbdd) |
| `Halftone` | ![Halftone でのディザリング](https://github.com/user-attachments/assets/31468a32-bddb-41b9-83fb-fa0b5b4263e8) |
| `Halftone Honeycomb` | ![Halftone Honeycomb でのディザリング](https://github.com/user-attachments/assets/e2c475d4-2b2b-4923-bb83-2b2136a90dcb) |
| `Halftone Square` | ![Halftone Square でのディザリング](https://github.com/user-attachments/assets/19fe9190-e54f-4039-9e93-c6d07dea63b1) |
| `Stripe` | ![Stripe でのディザリング](https://github.com/user-attachments/assets/f6bebb0c-d0d1-43e8-b4f1-43748c26589e) |

- `Flat` はディザリングをせず，パターンなしでの通常の2値化適用です．

- `IGN` は “Interleaved Gradient Noise” の略．

  Interleaved Gradient Noise by Jorge Jimenez

  https://www.iryoku.com/next-generation-post-processing-in-call-of-duty-advanced-warfare

- 一部パターンは厳密には，ディザリングには分類されないかもしれません．

初期値は `Bayer 4x4`.

### ディザ強さ

ディザリングの影響の強さを調整します．0 だとディザリングなし，100 だとディザリングありで，その間をスムーズにつなぎます．

最小値は 0, 最大値は 100, 初期値は 100.

> [!TIP]
> [「パターン」](#パターン)に Halftone などの連続性のあるものを選んでいる場合，「ディザ強さ」が 100% だとジャギーな見え方になってしまいます．90 % など少し低い値にするとアンチエイリアスがかかってくれます．

### ドットサイズ / X / Y / 回転

パターンを拡大・縮小・回転・平行移動します．

- **ドットサイズ**

  パターン模様の拡大率を % 単位で指定します．

  最小値は 100, 最大値は 6400, 初期値は 100.

- **X / Y**

  パターン模様を上下左右に平行移動します．移動量をピクセル単位で指定．

  最小値は -4000, 最大値は 4000, 初期値は $(0,0)$.

- **回転**

  パターン模様を回転します．回転角度を度数単位で指定．

  最小値は -3600, 最大値は 3600, 初期値は 0.

### ノイズシード

パターンの一部にはランダムなノイズを生成するものがあります．そのランダムさを決定する乱数のシードを指定します．

- 0 以上のシードだと同じシードでも別オブジェクトだと別の乱数．
- 負のシードだと，同じシードなら別オブジェクトでも同じ乱数．

最小値は -65536, 最大値は 65535, 初期値は 10000 (一部 20000 のものも).

## `PI` について

各種スクリプトにある設定項目で，パラメタインジェクション (parameter injection) です．初期値は空欄．テーブル型の中身として解釈され，各種パラメタの代替値として使用されます．また，任意のスクリプトコードを実行する記述領域にもなります．

テーブルを指定するテキストボックスには，冒頭末尾の波括弧 (`{}`) を省略して記述してください．

### ディザ減色σ の `PI`

```lua
{
  space = str,           -- string 型で "色空間" の項目を上書き，または nil.
  comp1_steps = num,     -- number 型で "諧調数1" の項目を上書き，または nil.
  comp2_steps = num,     -- number 型で "諧調数2" の項目を上書き，または nil.
  comp3_steps = num,     -- number 型で "諧調数3" の項目を上書き，または nil.
  pattern = str,         -- string 型で "パターン" の項目を上書き，または nil.
  intensity = num,       -- number 型で "ディザ強さ" の項目を上書き，または nil.
  scale = num,           -- number 型で "ドットサイズ" の項目を上書き，または nil.
  X = num, Y = num,      -- number 型で "X" や "Y" の項目を上書き，または nil.
  angle = num,           -- number 型で "回転" の項目を上書き，または nil.
  dither_seed = num,     -- number 型で "ノイズシード" の項目を上書き，または nil.
  comp1_intensity = num, -- number 型で "comp1::ディザ強さ" の項目を上書き，または nil.
  comp1_scale = num,     -- number 型で "comp1::ドットサイズ" の項目を上書き，または nil.
  comp1_X = num,         -- number 型で "comp1::X" の項目を上書き，または nil.
  comp1_Y = num,         -- number 型で "comp1::Y" の項目を上書き，または nil.
  comp1_angle = num,     -- number 型で "comp1::回転" の項目を上書き，または nil.
  comp2_intensity = num, -- number 型で "comp2::ディザ強さ" の項目を上書き，または nil.
  comp2_scale = num,     -- number 型で "comp2::ドットサイズ" の項目を上書き，または nil.
  comp2_X = num,         -- number 型で "comp2::X" の項目を上書き，または nil.
  comp2_Y = num,         -- number 型で "comp2::Y" の項目を上書き，または nil.
  comp2_angle = num,     -- number 型で "comp2::回転" の項目を上書き，または nil.
  comp3_intensity = num, -- number 型で "comp3::ディザ強さ" の項目を上書き，または nil.
  comp3_scale = num,     -- number 型で "comp3::ドットサイズ" の項目を上書き，または nil.
  comp3_X = num,         -- number 型で "comp3::X" の項目を上書き，または nil.
  comp3_Y = num,         -- number 型で "comp3::Y" の項目を上書き，または nil.
  comp3_angle = num,     -- number 型で "comp3::回転" の項目を上書き，または nil.
}
```

- `space` に指定できる string は以下の通りです:

  ```lua
  "RGB", "RGB Linear", "CMY", "CMY Linear",
  ```

- `pattern` に指定できる string は以下の通りです:

  ```lua
  "Flat",
  "Checker", "Bayer 2x2", "Bayer 4x4", "Bayer 256x256",
  "IGN", "White Noise", "Perlin Noise",
  "Halftone", "Halftone Honeycomb", "Halftone Square",
  "Stripe"
  ```

[:arrow_right: スクリプトの説明はこちら．](#ディザ減色σ)

### 透明度ディザσ の `PI`

```lua
{
  steps = num,       -- number 型で "諧調数" の項目を上書き，または nil.
  pattern = str,     -- string 型で "パターン" の項目を上書き，または nil.
  intensity = num,   -- number 型で "ディザ強さ" の項目を上書き，または nil.
  scale = num,       -- number 型で "ドットサイズ" の項目を上書き，または nil.
  X = num, Y = num,  -- number 型で "X" や "Y" の項目を上書き，または nil.
  angle = num,       -- number 型で "回転" の項目を上書き，または nil.
  dither_seed = num, -- number 型で "ノイズシード" の項目を上書き，または nil.
}
```

- `pattern` に指定できる string は以下の通りです:

  ```lua
  "Flat",
  "Checker", "Bayer 2x2", "Bayer 4x4", "Bayer 256x256",
  "IGN", "White Noise", "Perlin Noise",
  "Halftone", "Halftone Honeycomb", "Halftone Square",
  "Stripe"
  ```

[:arrow_right: スクリプトの説明はこちら．](#透明度ディザσ)

### ディザポリトーンσ の `PI`

```lua
{
  filter_intensity = num, -- number 型で "強さ" の項目を上書き，または nil.
  color_black = num,      -- number 型で "暗い色" の項目を上書き，または nil.
  mid_colors = tab,       -- table 型で各 "中間色" や，対応する色の位置を上書き，または nil.
  color_white = num,      -- number 型で "明るい色" の項目を上書き，または nil.
  pattern = str,          -- string 型で "パターン" の項目を上書き，または nil.
  intensity = num,        -- number 型で "ディザ強さ" の項目を上書き，または nil.
  scale = num,            -- number 型で "ドットサイズ" の項目を上書き，または nil.
  X = num, Y = num,       -- number 型で "X" や "Y" の項目を上書き，または nil.
  angle = num,            -- number 型で "回転" の項目を上書き，または nil.
  dither_seed = num,      -- number 型で "ノイズシード" の項目を上書き，または nil.
}
```

- `mid_colors` は次の形の配列です:

  ```lua
  {
    { col = num, pos = num }, -- 1つ目の中間色．
    { col = num, pos = num }, -- 2つ目の中間色．
    ...
  }
  ```

  - `col` フィールドは number 型で，色を `0xRRGGBB` の形式で指定．`nil` だと上書きしない．
  - `pos` フィールドは number 型で，対応する輝度を % 単位で指定．`nil` だと上書きしない．
  - 配列の終わりに達するか，最初の 14 個まで読み取られ，残りは無視されます．
  - 「中間色」の個数も，指定の配列の長さで上書きされます．
  - 配列の終わりではない空欄を指定する場合は `nil` ではなく空のテーブル `{}` を記述すること．

- `pattern` に指定できる string は以下の通りです:

  ```lua
  "Flat",
  "Checker", "Bayer 2x2", "Bayer 4x4", "Bayer 256x256",
  "IGN", "White Noise", "Perlin Noise",
  "Halftone", "Halftone Honeycomb", "Halftone Square",
  "Stripe"
  ```

[:arrow_right: スクリプトの説明はこちら．](#ディザポリトーンσ)

### ディザマスクσ の `PI`

```lua
{
  alpha = num,       -- number 型で "透明度" の項目を上書き，または nil.
  pattern = str,     -- string 型で "パターン" の項目を上書き，または nil.
  intensity = num,   -- number 型で "ディザ強さ" の項目を上書き，または nil.
  scale = num,       -- number 型で "ドットサイズ" の項目を上書き，または nil.
  X = num, Y = num,  -- number 型で "X" や "Y" の項目を上書き，または nil.
  angle = num,       -- number 型で "回転" の項目を上書き，または nil.
  dither_seed = num, -- number 型で "ノイズシード" の項目を上書き，または nil.
}
```

- `pattern` に指定できる string は以下の通りです:

  ```lua
  "Flat",
  "Checker", "Bayer 2x2", "Bayer 4x4", "Bayer 256x256",
  "IGN", "White Noise", "Perlin Noise",
  "Halftone", "Halftone Honeycomb", "Halftone Square",
  "Stripe"
  ```

[:arrow_right: スクリプトの説明はこちら．](#ディザマスクσ)

### ディザ斜めクリッピングσ の `PI`

```lua
{
  steps = num,            -- number 型で "諧調数" の項目を上書き，または nil.
  grad_x = num,           -- number 型で "中心X" の項目を上書き，または nil.
  grad_y = num,           -- number 型で "中心Y" の項目を上書き，または nil.
  grad_angle = num,       -- number 型で "角度" の項目を上書き，または nil.
  grad_blur = num,        -- number 型で "ぼかし" の項目を上書き，または nil.
  grad_width = num,       -- number 型で "幅" の項目を上書き，または nil.
  grad_interpol = str,    -- string 型で "補間方法" の項目を上書き，または nil.
  mode_anchor_base = str, -- string 型で "アンカー基準" の項目を上書き，または nil.
  pattern = str,          -- string 型で "パターン" の項目を上書き，または nil.
  intensity = num,        -- number 型で "ディザ強さ" の項目を上書き，または nil.
  scale = num,            -- number 型で "ドットサイズ" の項目を上書き，または nil.
  X = num, Y = num,       -- number 型で "X" や "Y" の項目を上書き，または nil.
  angle = num,            -- number 型で "回転" の項目を上書き，または nil.
  dither_seed = num,      -- number 型で "ノイズシード" の項目を上書き，または nil.
}
```

- `grad_interpol` に指定できる string は以下の通りです:

  ```lua
  "線形補間", "エルミート補間"
  ```

- `mode_anchor_base` に指定できる string は以下の通りです:

  ```lua
  "回転中心", "左上", "上", "右上", "左", "中央", "右", "左下", "下", "右下"
  ```

- `pattern` に指定できる string は以下の通りです:

  ```lua
  "Flat",
  "Checker", "Bayer 2x2", "Bayer 4x4", "Bayer 256x256",
  "IGN", "White Noise", "Perlin Noise",
  "Halftone", "Halftone Honeycomb", "Halftone Square",
  "Stripe"
  ```

[:arrow_right: スクリプトの説明はこちら．](#ディザ斜めクリッピングσ)


### ディザ境界ぼかしσ の `PI`

```lua
{
  steps = num,            -- number 型で "諧調数" の項目を上書き，または nil.
  blur_range = num,       -- number 型で "範囲" の項目を上書き，または nil.
  blur_aspect = num,      -- number 型で "縦横比" の項目を上書き，または nil.
  blur_alpha_edge = bool, -- boolean 型で "透明度の境界をぼかす" の項目を上書き，または nil. 0 を false, 0 以外を true として number 型も可能．
  blur_threshold = num,   -- number 型で "αしきい値" の項目を上書き，または nil.
  grad_interpol = str,    -- string 型で "補間方法" の項目を上書き，または nil.
  pattern = str,          -- string 型で "パターン" の項目を上書き，または nil.
  intensity = num,        -- number 型で "ディザ強さ" の項目を上書き，または nil.
  scale = num,            -- number 型で "ドットサイズ" の項目を上書き，または nil.
  X = num, Y = num,       -- number 型で "X" や "Y" の項目を上書き，または nil.
  angle = num,            -- number 型で "回転" の項目を上書き，または nil.
  dither_seed = num,      -- number 型で "ノイズシード" の項目を上書き，または nil.
}
```

- `grad_interpol` に指定できる string は以下の通りです:

  ```lua
  "線形補間", "エルミート補間"
  ```

- `pattern` に指定できる string は以下の通りです:

  ```lua
  "Flat",
  "Checker", "Bayer 2x2", "Bayer 4x4", "Bayer 256x256",
  "IGN", "White Noise", "Perlin Noise",
  "Halftone", "Halftone Honeycomb", "Halftone Square",
  "Stripe"
  ```

### ディザ斜めワイプσ の `PI`

```lua
{
  progress = num,      -- number 型で "進捗" の項目を上書き，または nil.
  invert = bool,       -- boolean 型で "反転" の項目を上書き，または nil. 0 を false, 0 以外を true として number 型も可能．
  steps = num,         -- number 型で "諧調数" の項目を上書き，または nil.
  grad_angle = num,    -- number 型で "角度" の項目を上書き，または nil.
  grad_blur = num,     -- number 型で "ぼかし" の項目を上書き，または nil.
  grad_interpol = str, -- string 型で "補間方法" の項目を上書き，または nil.
  pattern = str,       -- string 型で "パターン" の項目を上書き，または nil.
  intensity = num,     -- number 型で "ディザ強さ" の項目を上書き，または nil.
  scale = num,         -- number 型で "ドットサイズ" の項目を上書き，または nil.
  X = num, Y = num,    -- number 型で "X" や "Y" の項目を上書き，または nil.
  angle = num,         -- number 型で "回転" の項目を上書き，または nil.
  dither_seed = num,   -- number 型で "ノイズシード" の項目を上書き，または nil.
}
```

- `grad_interpol` に指定できる string は以下の通りです:

  ```lua
  "線形補間", "エルミート補間"
  ```

- `pattern` に指定できる string は以下の通りです:

  ```lua
  "Flat",
  "Checker", "Bayer 2x2", "Bayer 4x4", "Bayer 256x256",
  "IGN", "White Noise", "Perlin Noise",
  "Halftone", "Halftone Honeycomb", "Halftone Square",
  "Stripe"
  ```

### ディザシーンチェンジσ の `PI`

```lua
{
  progress = num,      -- number 型で "進捗" の項目を上書き，または nil.
  invert = bool,       -- boolean 型で "反転" の項目を上書き，または nil. 0 を false, 0 以外を true として number 型も可能．
  steps = num,         -- number 型で "諧調数" の項目を上書き，または nil.
  file_path = str,     -- string 型で "ワイプ画像" の項目を上書き，または nil.
  fix_aspect = bool,   -- boolean 型で "縦横比固定" の項目を上書き，または nil. 0 を false, 0 以外を true として number 型も可能．
  grad_angle = num,    -- number 型で "角度" の項目を上書き，または nil.
  grad_blur = num,     -- number 型で "ぼかし" の項目を上書き，または nil.
  grad_interpol = str, -- string 型で "補間方法" の項目を上書き，または nil.
  pattern = str,       -- string 型で "パターン" の項目を上書き，または nil.
  intensity = num,     -- number 型で "ディザ強さ" の項目を上書き，または nil.
  scale = num,         -- number 型で "ドットサイズ" の項目を上書き，または nil.
  X = num, Y = num,    -- number 型で "X" や "Y" の項目を上書き，または nil.
  angle = num,         -- number 型で "回転" の項目を上書き，または nil.
  dither_seed = num,   -- number 型で "ノイズシード" の項目を上書き，または nil.
}
```

- `grad_interpol` に指定できる string は以下の通りです:

  ```lua
  "線形補間", "エルミート補間"
  ```

- `pattern` に指定できる string は以下の通りです:

  ```lua
  "Flat",
  "Checker", "Bayer 2x2", "Bayer 4x4", "Bayer 256x256",
  "IGN", "White Noise", "Perlin Noise",
  "Halftone", "Halftone Honeycomb", "Halftone Square",
  "Stripe"
  ```

##  改版履歴

- **v1.00** (2026-11-26)

  - 初版．

## ライセンス

このプログラムの利用・改変・再頒布等に関しては MIT ライセンスに従うものとします．

---

The MIT License (MIT)

Copyright (C) 2026 sigma-axis

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

https://mit-license.org/


#  連絡・バグ報告

- GitHub: https://github.com/sigma-axis
- Twitter: https://x.com/sigma_axis
- nicovideo: https://www.nicovideo.jp/user/51492481
- Misskey.io: https://misskey.io/@sigma_axis
- Bluesky: https://bsky.app/profile/sigma-axis.bsky.social
