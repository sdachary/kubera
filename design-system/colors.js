const teal = {
  50: '#f0fdfa',
  100: '#ccfbf1',
  200: '#99f6e4',
  300: '#5eead4',
  400: '#2dd4bf',
  500: '#0d9488',
  600: '#0f766e',
  700: '#115e59',
  800: '#134e4a',
  900: '#0f3d38'
};

const orange = {
  50: '#fff7ed',
  100: '#ffedd5',
  200: '#fed7aa',
  300: '#fdba74',
  400: '#fb923c',
  500: '#f97316',
  600: '#ea580c',
  700: '#c2410c',
  800: '#9a3412',
  900: '#7c2d12'
};

export const colors = {
  primary: teal,
  accent: orange,
  semantic: {
    light: {
      surface_primary: '#ffffff',
      surface_secondary: '#f8fafc',
      surface_overlay: 'rgba(0, 0, 0, 0.5)',
      text_primary: '#0f172a',
      text_secondary: '#334155',
      text_accent: teal[700],
      divider: '#e2e8f0',
      shadow_sm: '0 1px 2px rgba(0, 0, 0, 0.05)',
      shadow_md: '0 4px 6px rgba(0, 0, 0, 0.1)',
      shadow_lg: '0 10px 15px rgba(0, 0, 0, 0.1)',
      shadow_xl: '0 20px 25px rgba(0, 0, 0, 0.15)'
    },
    dark: {
      surface_primary: '#0f172a',
      surface_secondary: '#1e293b',
      surface_overlay: 'rgba(0, 0, 0, 0.7)',
      text_primary: '#f8fafc',
      text_secondary: '#94a3b8',
      text_accent: teal[300],
      divider: '#334155',
      shadow_sm: '0 1px 2px rgba(0, 0, 0, 0.3)',
      shadow_md: '0 4px 6px rgba(0, 0, 0, 0.4)',
      shadow_lg: '0 10px 15px rgba(0, 0, 0, 0.4)',
      shadow_xl: '0 20px 25px rgba(0, 0, 0, 0.5)'
    }
  }
};

export const generateCssVars = () => {
  let css = ':root, [data-theme="light"] {\n';
  Object.entries(colors.primary).forEach(([k, v]) => {
    css += `  --color-primary-${k}: ${v};\n`;
  });
  Object.entries(colors.accent).forEach(([k, v]) => {
    css += `  --color-accent-${k}: ${v};\n`;
  });
  Object.entries(colors.semantic.light).forEach(([k, v]) => {
    css += `  --color-${k}: ${v};\n`;
  });
  css += '}\n';
  css += '[data-theme="dark"] {\n';
  Object.entries(colors.semantic.dark).forEach(([k, v]) => {
    css += `  --color-${k}: ${v};\n`;
  });
  css += '}';
  return css;
};
