import React from 'react';
import { motion } from 'framer-motion';
import { useTheme } from '../design-system/theme-provider.jsx';
import { colors } from '../design-system/colors.js';

export function Card({
  variant = 'elevated',
  children,
  className = '',
  padding = '1.5rem',
  borderRadius = '16px',
  onClick,
  role = 'region',
  ariaLabel,
  ...props
}) {
  const { theme } = useTheme();
  const resolvedTheme = theme === 'system'
    ? (typeof window !== 'undefined' && window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light')
    : theme;

  const semantic = resolvedTheme === 'dark' ? colors.semantic.dark : colors.semantic.light;

  const baseStyle = {
    borderRadius,
    padding,
    border: `1px solid ${semantic.divider}`,
    position: 'relative',
    overflow: 'hidden',
    transition: 'background-color 0.2s ease',
    cursor: onClick ? 'pointer' : 'default',
    backgroundColor: semantic.surface_primary
  };

  const variants = {
    elevated: {
      backgroundColor: semantic.surface_primary,
      boxShadow: semantic.shadow_md
    },
    glass: {
      backgroundColor: 'rgba(255, 255, 255, 0.08)',
      backdropFilter: 'blur(20px)',
      border: '1px solid rgba(255, 255, 255, 0.15)',
      boxShadow: semantic.shadow_md
    }
  };

  const variantStyle = variants[variant] || variants.elevated;

  return (
    <motion.div
      className={`kubera-card kubera-card--${variant} ${className}`}
      style={{ ...baseStyle, ...variantStyle }}
      whileHover={
        variant === 'elevated'
          ? {
              y: -8,
              boxShadow: semantic.shadow_xl,
              transition: { duration: 0.3, ease: [0.4, 0, 0.2, 1] }
            }
          : {}
      }
      onClick={onClick}
      role={onClick ? 'button' : role}
      aria-label={ariaLabel}
      tabIndex={onClick ? 0 : undefined}
      onKeyDown={onClick ? (e) => { if (e.key === 'Enter' || e.key === ' ') onClick(e); } : undefined}
      {...props}
    >
      {children}
    </motion.div>
  );
}
