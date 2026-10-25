import copy
import json
import unittest
from pathlib import Path
from validate_content import validate

class ValidatorTests(unittest.TestCase):
    def setUp(self):
        self.corpus = json.loads((Path(__file__).resolve().parents[1] / 'assets/content/vocabulary.json').read_text(encoding='utf-8'))

    def test_authored_corpus_is_structurally_valid(self):
        self.assertEqual(validate(self.corpus), [])

    def test_beta_rejects_starter_content_and_pending_review(self):
        errors = validate(self.corpus, release=True, review={'status': 'pending'})
        self.assertTrue(any('3,000' in e for e in errors))
        self.assertTrue(any('review' in e.lower() for e in errors))

    def test_duplicate_ids_and_headwords(self):
        self.corpus['words'].append(copy.deepcopy(self.corpus['words'][0]))
        errors = validate(self.corpus)
        self.assertTrue(any('duplicate ID' in e for e in errors))
        self.assertTrue(any('duplicate headword' in e for e in errors))

    def test_missing_noun_metadata(self):
        del self.corpus['words'][0]['plural']
        self.assertTrue(any('plural' in e for e in validate(self.corpus)))

    def test_exactly_two_translated_examples(self):
        self.corpus['words'][0]['examples'][1]['translations'] = {}
        self.assertTrue(any('example pair' in e for e in validate(self.corpus)))
        self.corpus['words'][0]['examples'].pop()
        self.assertTrue(any('exactly two' in e for e in validate(self.corpus)))

    def test_updates_cannot_delete_or_retarget_ids(self):
        old = copy.deepcopy(self.corpus)
        self.corpus['words'][0]['german'] = 'Retargeted'
        self.corpus['words'].pop()
        errors = validate(self.corpus, previous=old)
        self.assertTrue(any('retargets' in e for e in errors))
        self.assertTrue(any('removes historical ID' in e for e in errors))

    def test_review_must_match_exact_bytes_and_all_ids(self):
        review = {'status': 'approved', 'language': 'de', 'reviewer': 'Test reviewer',
                  'reviewedAt': '2026-10-25', 'notes': 'Test only', 'corpusSha256': 'old', 'reviewedIds': []}
        errors = validate(self.corpus, release=True, review=review, digest='new')
        self.assertTrue(any('hash' in e for e in errors))
        self.assertTrue(any('every stable' in e for e in errors))

if __name__ == '__main__':
    unittest.main()
