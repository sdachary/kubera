import React, { useState, useCallback, useRef } from 'react';
import { motion } from 'framer-motion';
import { useTheme } from '../design-system/theme-provider.jsx';
import { colors } from '../design-system/colors.js';

const getVariantStyles = (variant, theme) => {
  const isDark = theme === 'dark';
  const semantic = isDark ? colors.semantic.dark : colors.semantic.light;

  const base = {
    primary: {
      background: `linear-gradient(135deg, ${colors.primary[500]}, ${colors.primary[700]})`,
      color: '#ffffff',
      border: 'none',
      boxShadow: semantic.shadow_md
    },
    secondary: {
      background: 'transparent',
      color: semantic.text_accent,
      border: `2px solid ${colors.primary[500]}`,
      boxShadow: 'none'
    },
    outline: {
      background: 'transparent',
      color: semantic.text_primary,
      border: `2px solid ${semantic.divider}`,
      boxShadow: 'none'
    },
    ghost: {
      background: 'transparent',
      color: semantic.text_primary,
      border: 'none',
      boxShadow: 'none'
    }
  };

  return base[variant] || base.primary;
};

export function Button({
  variant = 'primary',
  size = 'md',
  loading = false,
  disabled = false,
  children,
  onClick,
  className = '',
  ariaLabel,
  type = 'button',
  ...props
}) {
  const { theme } = useTheme();
  const [ripples, setRipples] = useState([]);
  const buttonRef = useRef(null);
  const resolvedTheme = theme === 'system'
    ? (typeof window !== 'undefined' && window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light')
    : theme;

  const variantStyles = getVariantStyles(variant, resolvedTheme);

  const sizeStyles = {
    sm: { padding: '0.5rem 1rem', fontSize: '0.875rem' },
    md: { padding: '0.75rem 1.5rem', fontSize: '1rem' },
    lg: { padding: '1rem 2rem', fontSize: '1.125rem' }
  };

  const handleClick = useCallback((e) => {
    if (loading || disabled) return;

    const button = buttonRef.current;
    if (!button) return;

    const rect = button.getBoundingClientRect();
    const x = e.clientX - rect.left;
    const y = e.clientY - rect.top;
    const id = Date.now();

    setRipples(prev => [...prev, { id, x, y }]);

    setTimeout(() => {
      setRipples(prev => prev.filter(r => r.id !== id));
    }, 600);

    onClick?.(e);
  }, [loading, disabled, onClick]);

  const isDisabled = disabled || loading;

  return (
    <motion.button
      ref={buttonRef}
      type={type}
      className={`kubera-button kubera-button--${variant} ${className}`}
      style={{
        ...variantStyles,
        ...sizeStyles[size],
        minWidth: '44px',
        minHeight: '44px',
        borderRadius: '8px',
        cursor: isDisabled ? 'not-allowed' : 'pointer',
        opacity: isDisabled ? 0.6 : 1,
        fontFamily: "'Inter', system-ui, sans-serif",
        fontWeight: 600,
        display: 'inline-flex',
        alignItems: 'center',
        justifyContent: 'center',
        gap: '0.5rem',
        position: 'relative',
        overflow: 'hidden',
        transition: 'transform 0.2s ease, box-shadow 0.2s ease',
        outline: 'none'
      }}
      whileHover={!isDisabled ? { y: -4, boxShadow: colors.semantic[resolvedTheme === 'dark' ? 'dark' : 'light'].shadow_xl } : {}}
      whileTap={!isDisabled ? { y: -2, scale: 0.98 } : {}}
      onClick={handleClick}
      disabled={isDisabled}
      aria-label={ariaLabel}
      aria-disabled={isDisabled}
      aria-busy={loading}
      {...props}
    >
      {loading && (
        <motion.span
          style={{
            display: 'inline-block',
            width: '16px',
            height: '16px',
            border: '2px solid currentColor',
            borderTopColor: 'transparent',
            borderRadius: '50%'
          }}
          animate={{ rotate: 360 }}
          transition={{ duration: 0.6, repeat: Infinity, ease: 'linear' }}
        />
      )}
      <span style={{ visibility: loading ? 'hidden' : 'visible' }}>
        {children}
      </span>
      {ripples.map(ripple => (
        <motion.span
          key={ripple.id}
          style={{
            position: 'absolute',
            left: ripple.x,
            top: ripple.y,
            width: '5px',
            height: '5px',
            borderRadius: '50%',
            backgroundColor: variant === 'primary' ? 'rgba(255,255,255,0.6)' : 'rgba(0,0,0,0.2)',
            transform: 'translate(-50%, -50%)',
            pointerEvents: 'none'
          }}
          initial={{ width: 0, height: 0, opacity: 1 }}
          animate={{ width: 500, height: 500, opacity: 0 }}
          transition={{ duration: 0.6, ease: 'easeOut' }}
        />
      ))}
    </motion.button>
  );
}
