export const spacing = {};
for (let i = 1; i <= 16; i++) {
  spacing[i] = `${i * 0.25}rem`;
}

export const size = {
  sm: { padding: '0.5rem 1rem', fontSize: '0.875rem' },
  md: { padding: '0.75rem 1.5rem', fontSize: '1rem' },
  lg: { padding: '1rem 2rem', fontSize: '1.125rem' }
};
