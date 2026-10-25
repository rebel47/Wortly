"""Generate native raster sizes of the original leaf mark. Requires Pillow."""
import json
from pathlib import Path
from PIL import Image, ImageDraw

ROOT = Path(__file__).resolve().parents[1]

def bezier(points, count=100):
    p0, p1, p2, p3 = points
    result = []
    for i in range(count + 1):
        t = i / count
        result.append(tuple((1-t)**3*p0[k] + 3*(1-t)**2*t*p1[k] +
                            3*(1-t)*t*t*p2[k] + t**3*p3[k] for k in [0, 1]))
    return result

image = Image.new('RGB', (1080, 1080), '#244C3D')
draw = ImageDraw.Draw(image)
leaf = bezier([(820, 240), (500, 200), (230, 350), (260, 600)])
leaf += bezier([(260, 600), (280, 760), (390, 820), (510, 780)])
leaf += bezier([(510, 780), (660, 730), (760, 520), (820, 240)])
draw.polygon(leaf, fill='#D5DFC8')
stem = [(280, 910), (360, 940)]
stem += bezier([(360, 940), (390, 700), (520, 530), (700, 380)])
stem += bezier([(700, 380), (470, 480), (320, 680), (280, 910)])
draw.polygon(stem, fill='#D5DFC8')
icons = ROOT / 'ios/Runner/Assets.xcassets/AppIcon.appiconset'
for icon in json.loads((icons / 'Contents.json').read_text())['images']:
    size = round(float(icon['size'].split('x')[0]) * float(icon['scale'][:-1]))
    image.resize((size, size), Image.Resampling.LANCZOS).save(icons / icon['filename'])
for directory, size in [('mdpi', 48), ('hdpi', 72), ('xhdpi', 96), ('xxhdpi', 144), ('xxxhdpi', 192)]:
    target = ROOT / f'android/app/src/main/res/mipmap-{directory}/ic_launcher.png'
    image.resize((size, size), Image.Resampling.LANCZOS).save(target)
print('Wrote native leaf icons')
