import React from 'react';
import { motion } from 'framer-motion';
import { useTheme } from '../design-system/theme-provider.jsx';
import { colors } from '../design-system/colors.js';
import { useInView } from '../hooks/useInView.js';

export function DeploymentSteps({
  steps = [],
  title = 'Deployment Steps',
  className = '',
  ...props
}) {
  const { theme } = useTheme();
  const { ref, hasBeenInView } = useInView({ threshold: 0.1, triggerOnce: true });

  const resolvedTheme = theme === 'system'
    ? (typeof window !== 'undefined' && window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light')
    : theme;

  const semantic = resolvedTheme === 'dark' ? colors.semantic.dark : colors.semantic.light;

  const containerVariants = {
    hidden: {},
    visible: {
      transition: { staggerChildren: 0.15 }
    }
  };

  const stepVariants = {
    hidden: { opacity: 0, scale: 0.95 },
    visible: (index) => ({
      opacity: 1,
      scale: 1,
      transition: {
        duration: 0.6,
        delay: index * 0.1,
        ease: 'easeOut'
      }
    })
  };

  return (
    <section
      ref={ref}
      className={`kubera-deployment-steps ${className}`}
      style={{ padding: '4rem 2rem' }}
      {...props}
    >
      <h2
        style={{
          fontSize: 'clamp(1.5rem, 4vw, 2.5rem)',
          fontWeight: 700,
          lineHeight: 1.3,
          letterSpacing: '-0.025em',
          fontFamily: "'Inter', system-ui, sans-serif",
          color: semantic.text_primary,
          textAlign: 'center',
          marginBottom: '3rem'
        }}
      >
        {title}
      </h2>

      <motion.div
        variants={containerVariants}
        initial="hidden"
        animate={hasBeenInView ? 'visible' : 'hidden'}
        style={{
          maxWidth: '800px',
          margin: '0 auto',
          display: 'flex',
          flexDirection: 'column',
          gap: '2rem'
        }}
      >
        {steps.map((step, index) => (
          <motion.div
            key={index}
            custom={index}
            variants={stepVariants}
            style={{
              display: 'flex',
              gap: '1.5rem',
              alignItems: 'flex-start',
              padding: '1.5rem',
              borderRadius: '16px',
              backgroundColor: semantic.surface_primary,
              border: `1px solid ${semantic.divider}`,
              boxShadow: semantic.shadow_md,
              position: 'relative'
            }}
          >
            <motion.div
              style={{
                width: '48px',
                height: '48px',
                borderRadius: '50%',
                backgroundColor: colors.primary[500],
                color: '#ffffff',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                fontSize: '1.25rem',
                fontWeight: 700,
                flexShrink: 0,
                fontFamily: "'Inter', system-ui, sans-serif"
              }}
              whileHover={{ scale: 1.1 }}
              transition={{ type: 'spring', stiffness: 400, damping: 17 }}
            >
              {index + 1}
            </motion.div>

            <div style={{ flex: 1 }}>
              <h3
                style={{
                  fontSize: '1.25rem',
                  fontWeight: 600,
                  lineHeight: 1.4,
                  fontFamily: "'Inter', system-ui, sans-serif",
                  color: semantic.text_primary,
                  margin: '0 0 0.5rem 0'
                }}
              >
                {step.title}
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
                {step.description}
              </p>
              {step.code && (
                <pre
                  style={{
                    marginTop: '1rem',
                    padding: '1rem',
                    borderRadius: '8px',
                    backgroundColor: resolvedTheme === 'dark' ? '#1e293b' : '#f1f5f9',
                    color: semantic.text_primary,
                    fontSize: '0.875rem',
                    fontFamily: "'Space Mono', monospace",
                    overflow: 'auto',
                    margin: '1rem 0 0 0'
                  }}
                >
                  <code>{step.code}</code>
                </pre>
              )}
            </div>
          </motion.div>
        ))}
      </motion.div>
    </section>
  );
}
