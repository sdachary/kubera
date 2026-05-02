import React, { useRef, useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { useTheme } from '../design-system/theme-provider.jsx';
import { colors } from '../design-system/colors.js';
import { useGesture } from '../hooks/useGesture.js';
import { useInView } from '../hooks/useInView.js';

export function Testimonial({
  testimonials = [],
  className = '',
  autoPlay = false,
  interval = 5000,
  ...props
}) {
  const { theme } = useTheme();
  const scrollRef = useRef(null);
  const { ref: inViewRef, hasBeenInView } = useInView({ threshold: 0.1, triggerOnce: true });
  const [activeIndex, setActiveIndex] = useState(0);

  const resolvedTheme = theme === 'system'
    ? (typeof window !== 'undefined' && window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light')
    : theme;

  const semantic = resolvedTheme === 'dark' ? colors.semantic.dark : colors.semantic.light;

  useGesture(scrollRef, {
    onSwipeLeft: () => {
      setActiveIndex(prev => Math.min(prev + 1, testimonials.length - 1));
    },
    onSwipeRight: () => {
      setActiveIndex(prev => Math.max(prev - 1, 0));
    },
    threshold: 50
  });

  React.useEffect(() => {
    if (!autoPlay || testimonials.length <= 1) return;
    const timer = setInterval(() => {
      setActiveIndex(prev => (prev + 1) % testimonials.length);
    }, interval);
    return () => clearInterval(timer);
  }, [autoPlay, interval, testimonials.length]);

  React.useEffect(() => {
    if (scrollRef.current) {
      const cardWidth = scrollRef.current.children[0]?.offsetWidth || 320;
      scrollRef.current.scrollTo({ left: activeIndex * (cardWidth + 24), behavior: 'smooth' });
    }
  }, [activeIndex]);

   const getCardVariants = (index) => ({
     hidden: {
       opacity: 0,
       x: index % 2 === 0 ? 50 : -50
     },
     visible: {
       opacity: 1,
       x: 0,
       transition: { duration: 0.5, delay: index * 0.1 }
     },
     exit: {
       opacity: 0,
       x: index % 2 === 0 ? -50 : 50,
       transition: { duration: 0.3 }
     }
   });

  return (
    <section
      ref={inViewRef}
      className={`kubera-testimonial ${className}`}
      style={{ padding: '4rem 2rem', position: 'relative' }}
      {...props}
    >
      <motion.div
        initial="hidden"
        animate={hasBeenInView ? 'visible' : 'hidden'}
        variants={{ hidden: { opacity: 0, y: 20 }, visible: { opacity: 1, y: 0, transition: { duration: 0.6 } } }}
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
          What Our Users Say
        </h2>
      </motion.div>

      <div
        ref={scrollRef}
        style={{
          display: 'flex',
          gap: '1.5rem',
          overflowX: 'auto',
          scrollSnapType: 'x mandatory',
          paddingBottom: '1rem',
          scrollbarWidth: 'none',
          msOverflowStyle: 'none',
          scrollBehavior: 'smooth'
        }}
      >
        {testimonials.map((testimonial, index) => (
          <motion.div
            key={index}
            variants={getCardVariants(index)}
            initial="hidden"
            animate={hasBeenInView ? 'visible' : 'hidden'}
            style={{
              minWidth: '300px',
              maxWidth: '400px',
              flex: '0 0 auto',
              scrollSnapAlign: 'center',
              padding: '2rem',
              borderRadius: '16px',
              backgroundColor: semantic.surface_primary,
              border: `1px solid ${semantic.divider}`,
              boxShadow: semantic.shadow_md,
              display: 'flex',
              flexDirection: 'column',
              gap: '1rem'
            }}
          >
            <div
              style={{
                fontSize: '3rem',
                color: colors.primary[500],
                lineHeight: 1,
                opacity: 0.5
              }}
            >
              &ldquo;
            </div>

            <p
              style={{
                fontSize: '1rem',
                lineHeight: 1.6,
                fontFamily: "'Inter', system-ui, sans-serif",
                color: semantic.text_secondary,
                fontStyle: 'italic',
                margin: 0
              }}
            >
              {testimonial.quote}
            </p>

            <div style={{ display: 'flex', alignItems: 'center', gap: '0.75rem', marginTop: 'auto' }}>
              <div
                style={{
                  width: '48px',
                  height: '48px',
                  borderRadius: '50%',
                  backgroundColor: colors.primary[100],
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center',
                  fontSize: '1.5rem',
                  flexShrink: 0
                }}
              >
                {testimonial.avatar || '👤'}
              </div>
              <div>
                <div
                  style={{
                    fontSize: '0.875rem',
                    fontWeight: 600,
                    color: semantic.text_primary,
                    fontFamily: "'Inter', system-ui, sans-serif"
                  }}
                >
                  {testimonial.author}
                </div>
                <div
                  style={{
                    fontSize: '0.75rem',
                    color: semantic.text_secondary,
                    fontFamily: "'Inter', system-ui, sans-serif"
                  }}
                >
                  {testimonial.title}
                </div>
              </div>
            </div>
          </motion.div>
        ))}
      </div>

      {testimonials.length > 1 && (
        <div
          style={{
            display: 'flex',
            justifyContent: 'center',
            gap: '0.5rem',
            marginTop: '2rem'
          }}
          role="tablist"
          aria-label="Testimonial navigation"
        >
          {testimonials.map((_, index) => (
            <button
              key={index}
              role="tab"
              aria-selected={index === activeIndex}
              aria-label={`View testimonial ${index + 1}`}
              onClick={() => setActiveIndex(index)}
              style={{
                width: '10px',
                height: '10px',
                borderRadius: '50%',
                border: 'none',
                backgroundColor: index === activeIndex ? colors.primary[500] : semantic.divider,
                cursor: 'pointer',
                padding: 0,
                transition: 'background-color 0.3s ease'
              }}
            />
          ))}
        </div>
      )}
    </section>
  );
}
