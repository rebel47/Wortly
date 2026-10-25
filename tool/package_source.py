"""Package portable source without SDKs, caches, local config or signing keys."""
from pathlib import Path
from zipfile import ZipFile, ZIP_DEFLATED

ROOT = Path(__file__).resolve().parents[1]
TARGET = ROOT / 'output/wortly-source.zip'
ROOT_FILES = {'README.md', 'VALIDATION.md', 'pubspec.yaml', 'pubspec.lock',
              'analysis_options.yaml', '.gitignore', '.metadata', '.flutter-version'}
FOLDERS = {'lib', 'test', 'integration_test', 'tool', 'assets', 'content',
           'android', 'ios', '.github'}
SKIP_PARTS = {'build', '.dart_tool', '.gradle', '.kotlin', '.cxx', '.idea', 'Pods', '.symlinks',
              'ephemeral', '__pycache__', 'xcuserdata'}
SKIP_FILES = {'local.properties', 'key.properties', 'Generated.xcconfig',
              'flutter_export_environment.sh', '.last_build_id'}
TARGET.parent.mkdir(exist_ok=True)
with ZipFile(TARGET, 'w', ZIP_DEFLATED) as archive:
    for file in sorted(ROOT.rglob('*')):
        relative = file.relative_to(ROOT)
        if not file.is_file() or (relative.parts[0] not in FOLDERS and str(relative) not in ROOT_FILES):
            continue
        if any(part in SKIP_PARTS for part in relative.parts) or file.name in SKIP_FILES:
            continue
        if file.suffix.lower() in {'.jks', '.keystore', '.p12', '.mobileprovision', '.pyc', '.iml', '.log'}:
            continue
        archive.write(file, f'wortly/{relative.as_posix()}')
print(f'{TARGET} ({TARGET.stat().st_size:,} bytes)')
