import React from 'react';
import { motion } from 'framer-motion';
import { useTheme } from '../design-system/theme-provider.jsx';
import { colors } from '../design-system/colors.js';
import { useInView } from '../hooks/useInView.js';

export function FeatureCard({
  icon,
  title,
  description,
  index = 0,
  className = '',
  ...props
}) {
  const { theme } = useTheme();
  const { ref, hasBeenInView } = useInView({ threshold: 0.1, triggerOnce: true });
  const resolvedTheme = theme === 'system'
    ? (typeof window !== 'undefined' && window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light')
    : theme;

  const semantic = resolvedTheme === 'dark' ? colors.semantic.dark : colors.semantic.light;

  const cardVariants = {
    hidden: { opacity: 0, y: 30 },
    visible: {
      opacity: 1,
      y: 0,
      transition: {
        duration: 0.6,
        ease: 'easeOut',
        delay: index * 0.1
      }
    }
  };

  const iconVariants = {
    rest: { rotate: 0, scale: 1 },
    hover: {
      rotate: -10,
      scale: 1.1,
      transition: { duration: 0.3, ease: 'easeOut' }
    }
  };

  const glowVariants = {
    animate: {
      opacity: [0.5, 1, 0.5],
      scale: [1, 1.2, 1],
      transition: { duration: 3, repeat: Infinity, ease: 'easeInOut' }
    }
  };

  return (
    <motion.div
      ref={ref}
      className={`kubera-feature-card ${className}`}
      variants={cardVariants}
      initial="hidden"
      animate={hasBeenInView ? 'visible' : 'hidden'}
      whileHover="hover"
      style={{
        padding: '2rem',
        borderRadius: '16px',
        backgroundColor: semantic.surface_primary,
        border: `1px solid ${semantic.divider}`,
        boxShadow: semantic.shadow_md,
        position: 'relative',
        overflow: 'hidden'
      }}
      {...props}
    >
      <motion.div
        style={{
          width: '64px',
          height: '64px',
          borderRadius: '50%',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          marginBottom: '1.5rem',
          position: 'relative'
        }}
        variants={iconVariants}
      >
        <motion.div
          variants={glowVariants}
          animate="animate"
          style={{
            position: 'absolute',
            inset: '-8px',
            borderRadius: '50%',
            background: `radial-gradient(circle, ${colors.primary[500]}33 0%, transparent 70%)`,
            zIndex: 0
          }}
        />
        <span style={{ fontSize: '32px', position: 'relative', zIndex: 1 }}>
          {icon}
        </span>
      </motion.div>

      <h3
        style={{
          fontSize: 'clamp(1.25rem, 3vw, 2rem)',
          fontWeight: 600,
          lineHeight: 1.4,
          fontFamily: "'Inter', system-ui, sans-serif",
          color: semantic.text_primary,
          margin: '0 0 0.75rem 0'
        }}
      >
        {title}
      </h3>

      <p
        style={{
          fontSize: '1rem',
          lineHeight: 1.6,
          fontFamily: "'Inter', system-ui, sans-serif",
          color: semantic.text_secondary,
          margin: 0
        }}
      >
        {description}
      </p>
    </motion.div>
  );
}
