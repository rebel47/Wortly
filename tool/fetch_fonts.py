"""Development-only asset download; the shipped app never downloads fonts."""
from pathlib import Path
from urllib.request import urlretrieve

ROOT = Path(__file__).resolve().parents[1] / 'assets/fonts'
ROOT.mkdir(parents=True, exist_ok=True)
for folder, filename, target in [
    ('fraunces', 'Fraunces%5BSOFT,WONK,opsz,wght%5D.ttf', 'Fraunces.ttf'),
    ('dmsans', 'DMSans%5Bopsz,wght%5D.ttf', 'DMSans.ttf'),
]:
    base = f'https://raw.githubusercontent.com/google/fonts/main/ofl/{folder}/'
    urlretrieve(base + filename, ROOT / target)
    urlretrieve(base + 'OFL.txt', ROOT / (folder + '-OFL.txt'))
    print(f'Downloaded {target} and its OFL license')
