/**
 * Unit tests for known-user privacy helpers (no DB).
 */
const {
  normalizeInstitution,
} = require('../src/utils/knownUsers');

describe('knownUsers.normalizeInstitution', () => {
  test('trims and lowercases', () => {
    expect(normalizeInstitution('  AIIMS Delhi ')).toBe('aiims delhi');
  });

  test('collapses whitespace', () => {
    expect(normalizeInstitution('Apollo   Hospital')).toBe('apollo hospital');
  });

  test('empty for nullish', () => {
    expect(normalizeInstitution(null)).toBe('');
    expect(normalizeInstitution(undefined)).toBe('');
  });
});
