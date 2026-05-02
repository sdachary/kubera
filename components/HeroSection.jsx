import React from 'react';
import { motion } from 'framer-motion';
import { useTheme } from '../design-system/theme-provider.jsx';
import { colors } from '../design-system/colors.js';
import { Button } from './Button.jsx';

export function HeroSection({
  title = 'Kubera Personal Finance OS',
  subtitle = 'Take control of your financial future with intelligent insights and powerful tools.',
  primaryCta = 'Get Started',
  secondaryCta = 'Learn More',
  onPrimaryClick,
  onSecondaryClick,
  className = '',
  ...props
}) {
  const { theme } = useTheme();
  const resolvedTheme = theme === 'system'
    ? (typeof window !== 'undefined' && window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light')
    : theme;

  const semantic = resolvedTheme === 'dark' ? colors.semantic.dark : colors.semantic.light;

  const itemVariants = {
    hidden: { opacity: 0, y: 30 },
    visible: (delay) => ({
      opacity: 1,
      y: 0,
      transition: { duration: 0.6, ease: 'easeOut', delay }
    })
  };

  const floatingVariants = {
    animate: (i) => ({
      y: [0, -20, 0],
      rotate: [0, i % 2 === 0 ? 10 : -10, 0],
      transition: {
        duration: 6 + i * 2,
        repeat: Infinity,
        ease: 'easeInOut',
        delay: i * 0.5
      }
    })
  };

  const shapes = [
    { size: 200, top: '10%', left: '5%', color: colors.primary[500], opacity: 0.1 },
    { size: 150, top: '60%', left: '80%', color: colors.accent[500], opacity: 0.08 },
    { size: 100, top: '30%', left: '60%', color: colors.primary[400], opacity: 0.12 }
  ];

  return (
    <section
      className={`kubera-hero ${className}`}
      style={{
        position: 'relative',
        overflow: 'hidden',
        padding: '4rem 2rem',
        minHeight: '80vh',
        display: 'flex',
        alignItems: 'center',
        background: resolvedTheme === 'dark'
          ? `radial-gradient(at 20% 30%, ${colors.primary[900]}33 0%, transparent 50%), radial-gradient(at 80% 70%, ${colors.accent[900]}22 0%, transparent 50%), ${semantic.surface_primary}`
          : `radial-gradient(at 20% 30%, ${colors.primary[200]}66 0%, transparent 50%), radial-gradient(at 80% 70%, ${colors.accent[200]}44 0%, transparent 50%), ${semantic.surface_primary}`,
      }}
      {...props}
    >
      {shapes.map((shape, i) => (
        <motion.div
          key={i}
          custom={i}
          variants={floatingVariants}
          animate="animate"
          style={{
            position: 'absolute',
            width: shape.size,
            height: shape.size,
            borderRadius: '50%',
            background: `radial-gradient(circle, ${shape.color}${Math.round(shape.opacity * 255).toString(16)} 0%, transparent 70%)`,
            top: shape.top,
            left: shape.left,
            pointerEvents: 'none',
            zIndex: 0
          }}
        />
      ))}

       <div
         style={{
           maxWidth: '1200px',
           margin: '0 auto',
           width: '100%',
           display: 'grid',
           gridTemplateColumns: 'repeat(auto-fit, minmax(300px, 1fr))',
           gap: '3rem',
           alignItems: 'center',
           position: 'relative',
           zIndex: 1
         }}
       >
         <div
           style={{ display: 'flex', flexDirection: 'column', gap: '1.5rem' }}
         >
           <motion.h1
             custom={0.1}
             variants={itemVariants}
             initial="hidden"
             animate="visible"
             style={{
               fontSize: 'clamp(2rem, 5vw, 3.5rem)',
               fontWeight: 800,
               lineHeight: 1.2,
               letterSpacing: '-0.025em',
               fontFamily: "'Inter', system-ui, sans-serif",
               color: semantic.text_primary,
               margin: 0
             }}
           >
             {title}
           </motion.h1>

           <motion.p
             custom={0.25}
             variants={itemVariants}
             initial="hidden"
             animate="visible"
             style={{
               fontSize: '1.125rem',
               lineHeight: 1.6,
               fontFamily: "'Inter', system-ui, sans-serif",
               color: semantic.text_secondary,
               margin: 0,
               maxWidth: '500px'
             }}
           >
             {subtitle}
           </motion.p>

           <motion.div
             custom={0.4}
             variants={itemVariants}
             initial="hidden"
             animate="visible"
             style={{ display: 'flex', gap: '1rem', flexWrap: 'wrap' }}
           >
             <Button variant="primary" size="lg" onClick={onPrimaryClick}>
               {primaryCta}
             </Button>
             <Button variant="secondary" size="lg" onClick={onSecondaryClick}>
               {secondaryCta}
             </Button>
           </motion.div>
         </div>

        <motion.div
          initial={{ opacity: 0, scale: 0.9 }}
          animate={{ opacity: 1, scale: 1 }}
          transition={{ duration: 0.8, delay: 0.3 }}
          style={{
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center'
          }}
        >
          <div
            style={{
              width: '100%',
              maxWidth: '500px',
              aspectRatio: '4/3',
              borderRadius: '24px',
              background: resolvedTheme === 'dark'
                ? `linear-gradient(135deg, ${colors.primary[800]}44, ${colors.accent[800]}33)`
                : `linear-gradient(135deg, ${colors.primary[100]}, ${colors.accent[100]})`,
              border: `1px solid ${semantic.divider}`,
              boxShadow: semantic.shadow_xl,
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              fontSize: '3rem',
              color: colors.primary[500]
            }}
          >
            💰
          </div>
        </motion.div>
      </div>
    </section>
  );
}
