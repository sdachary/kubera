import React from 'react';
import { motion } from 'framer-motion';
import { useInView } from '../hooks/useInView.js';

const animationVariants = {
  fadeInUp: {
    hidden: { opacity: 0, y: 30 },
    visible: { opacity: 1, y: 0, transition: { duration: 0.6, ease: 'easeOut' } }
  },
  slideInLeft: {
    hidden: { opacity: 0, x: 50 },
    visible: { opacity: 1, x: 0, transition: { duration: 0.6, ease: 'easeOut' } }
  },
  slideInRight: {
    hidden: { opacity: 0, x: -50 },
    visible: { opacity: 1, x: 0, transition: { duration: 0.6, ease: 'easeOut' } }
  },
  scaleIn: {
    hidden: { opacity: 0, scale: 0.95 },
    visible: { opacity: 1, scale: 1, transition: { duration: 0.6, ease: 'easeOut' } }
  }
};

export function ScrollReveal({
  children,
  animation = 'fadeInUp',
  delay = 0,
  threshold = 0.1,
  triggerOnce = true,
  className = '',
  style = {},
  ...props
}) {
  const { ref, hasBeenInView } = useInView({ threshold, triggerOnce });

  const variants = animationVariants[animation];
  if (!variants) {
    console.warn(`ScrollReveal: unknown animation "${animation}". Using fadeInUp.`);
  }
  const selected = variants || animationVariants.fadeInUp;

  return (
    <motion.div
      ref={ref}
      className={`kubera-scroll-reveal ${className}`}
      variants={selected}
      initial="hidden"
      animate={hasBeenInView ? 'visible' : 'hidden'}
      transition={{ delay, duration: 0.6, ease: 'easeOut' }}
      style={{ willChange: 'transform, opacity', ...style }}
      {...props}
    >
      {children}
    </motion.div>
  );
}
