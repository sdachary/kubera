import { useState, useEffect, useRef } from 'react';

export function useInView(options = {}) {
  const [isInView, setIsInView] = useState(false);
  const [hasBeenInView, setHasBeenInView] = useState(false);
  const ref = useRef(null);

  const {
    threshold = 0.1,
    rootMargin = '0px',
    triggerOnce = false,
    skip = false
  } = options;

  useEffect(() => {
    const element = ref.current;
    if (!element || skip) return;

    const observer = new IntersectionObserver(
      ([entry]) => {
        if (entry.isIntersecting) {
          setIsInView(true);
          setHasBeenInView(true);
          if (triggerOnce) {
            observer.unobserve(element);
          }
        } else if (!triggerOnce) {
          setIsInView(false);
        }
      },
      { threshold, rootMargin }
    );

    observer.observe(element);

    return () => observer.disconnect();
  }, [threshold, rootMargin, triggerOnce, skip]);

  return { ref, isInView, hasBeenInView };
}
