"""Validate a Wortly import. --release additionally enforces beta conditions.

Python 3.10+, standard library only. Run from any directory.
"""
import argparse
import hashlib
import json
import re
import sys
import unicodedata
from datetime import date
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
TYPES = {'noun', 'verb', 'adjective', 'adverb', 'preposition', 'conjunction', 'pronoun', 'particle', 'phrase', 'numeral'}


def normal(value):
    return unicodedata.normalize('NFC', value).casefold().strip()


def validate(corpus, previous=None, release=False, review=None, digest=None):
    errors = []
    if not isinstance(corpus, dict):
        return ['The corpus must be an object.']
    for key in ['version', 'language', 'translationLanguages', 'editorialStatus', 'words']:
        if key not in corpus:
            errors.append(f'Missing corpus field: {key}')
    if not isinstance(corpus.get('version'), str) or not corpus.get('version', '').strip():
        errors.append('A non-empty content version is required.')
    if corpus.get('language') != 'de':
        errors.append('Source language must be de.')
    if 'en' not in (corpus.get('translationLanguages') or []):
        errors.append('English translations are required.')
    words = corpus.get('words')
    if not isinstance(words, list) or not words:
        return errors + ['words must be a non-empty list.']
    ids, lemmas, ranks = set(), set(), set()
    for i, word in enumerate(words):
        where = f'words[{i}]'
        if not isinstance(word, dict):
            errors.append(f'{where}: record must be an object')
            continue
        for field in ['id', 'german', 'type', 'answerKey']:
            if not isinstance(word.get(field), str) or not word.get(field, '').strip():
                errors.append(f'{where}: missing {field}')
        identifier = word.get('id', '')
        if not isinstance(identifier, str) or not re.fullmatch(r'de-[a-z0-9-]{3,64}', identifier):
            errors.append(f'{where}: invalid stable ID')
        if identifier in ids:
            errors.append(f'{where}: duplicate ID {identifier}')
        ids.add(identifier)
        lemma = (normal(str(word.get('german', ''))), word.get('type'))
        if lemma in lemmas:
            errors.append(f'{where}: duplicate headword/type {lemma}')
        lemmas.add(lemma)
        rank = word.get('rank')
        if type(rank) is not int or rank < 1 or rank in ranks:
            errors.append(f'{where}: rank must be a unique positive integer')
        ranks.add(rank)
        if word.get('type') not in TYPES:
            errors.append(f'{where}: unknown grammatical type')
        if word.get('type') == 'noun':
            if word.get('article') not in ['der', 'die', 'das']:
                errors.append(f'{where}: noun requires der/die/das')
            if not isinstance(word.get('plural'), str) or not word.get('plural', '').strip():
                errors.append(f'{where}: noun requires plural (use — for no usual plural)')
        translations = word.get('translations')
        langs = set()
        if not isinstance(translations, list):
            translations = []
        for t in translations:
            if not isinstance(t, dict):
                errors.append(f'{where}: translation must be an object')
                continue
            lang = t.get('language')
            if lang in langs:
                errors.append(f'{where}: duplicate translation language')
            langs.add(lang)
            for field in ['language', 'meaning', 'answerKey']:
                if not isinstance(t.get(field), str) or not t.get(field, '').strip():
                    errors.append(f'{where}: incomplete translation {field}')
        if 'en' not in langs:
            errors.append(f'{where}: missing English meaning')
        examples = word.get('examples')
        if not isinstance(examples, list) or len(examples) != 2:
            errors.append(f'{where}: exactly two examples required')
            examples = examples if isinstance(examples, list) else []
        seen_examples = set()
        for ex in examples:
            if not isinstance(ex, dict):
                errors.append(f'{where}: example must be an object')
                continue
            german = ex.get('german')
            if not isinstance(german, str) or not german.strip():
                errors.append(f'{where}: missing German example')
            elif normal(german) in seen_examples:
                errors.append(f'{where}: duplicate example within record')
            else:
                seen_examples.add(normal(german))
            translated = ex.get('translations')
            for lang in langs:
                if not isinstance(translated, dict) or not isinstance(translated.get(lang), str) or not translated.get(lang, '').strip():
                    errors.append(f'{where}: incomplete example pair for {lang}')
    if ranks != set(range(1, len(words) + 1)):
        errors.append('Usefulness ranks must be contiguous from 1 to record count.')
    if previous:
        old = {w['id']: w for w in previous['words']}
        new = {w.get('id'): w for w in words}
        for identifier, word in old.items():
            if identifier not in new:
                errors.append(f'Content update removes historical ID {identifier}')
            elif (word['german'], word['type']) != (new[identifier].get('german'), new[identifier].get('type')):
                errors.append(f'Content update retargets stable ID {identifier}')
        if corpus.get('version') == previous.get('version') and corpus != previous:
            errors.append('Content changed without a version increment.')
    if release:
        if not 2900 <= len(words) <= 3100:
            errors.append(f'Beta requires approximately 3,000 records (2,900–3,100); found {len(words)}.')
        if corpus.get('editorialStatus') != 'approved':
            errors.append('German-language editorial review is not approved.')
        if not isinstance(review, dict):
            errors.append('A documented editorial review manifest is required.')
        else:
            if review.get('status') != 'approved' or review.get('language') != 'de':
                errors.append('Review must be approved and conducted in German.')
            for field in ['reviewer', 'reviewedAt', 'notes']:
                if not isinstance(review.get(field), str) or not review.get(field, '').strip():
                    errors.append(f'Review requires {field}.')
            try:
                date.fromisoformat(review.get('reviewedAt', ''))
            except (TypeError, ValueError):
                errors.append('reviewedAt must be an ISO calendar date.')
            if review.get('corpusSha256') != digest:
                errors.append('Review hash does not match this exact corpus.')
            if set(review.get('reviewedIds') or []) != ids:
                errors.append('Editorial review must cover every stable word ID.')
    return errors


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('file', nargs='?', type=Path, default=ROOT / 'assets/content/vocabulary.json')
    parser.add_argument('--previous', type=Path, help='Prior corpus; rejects ID removal or reassignment')
    parser.add_argument('--release', action='store_true', help='Enforce corpus size and documented editorial approval')
    parser.add_argument('--review', type=Path, default=ROOT / 'content/editorial_review.json')
    args = parser.parse_args()
    try:
        raw = args.file.read_bytes()
        corpus = json.loads(raw)
        old = json.loads(args.previous.read_text(encoding='utf-8')) if args.previous else None
        review = json.loads(args.review.read_text(encoding='utf-8')) if args.review.exists() else None
        errors = validate(corpus, previous=old, release=args.release, review=review,
                          digest=hashlib.sha256(raw).hexdigest())
    except (OSError, ValueError, TypeError, KeyError) as error:
        print(f'INVALID: {error}', file=sys.stderr)
        return 1
    if errors:
        for error in errors:
            print(f'ERROR: {error}', file=sys.stderr)
        return 1
    print(f'VALID: {len(corpus["words"])} records · {corpus["version"]} · '
          f'{"release gate passed" if args.release else "structural validation only; not editorial approval"}')
    return 0


if __name__ == '__main__':
    sys.exit(main())
