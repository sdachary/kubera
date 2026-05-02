import { useState, useEffect, useRef } from 'react';

export function useGesture(elementRef, options = {}) {
  const [gesture, setGesture] = useState(null);
  const startPos = useRef({ x: 0, y: 0 });
  const startTime = useRef(0);

  const {
    onSwipeLeft,
    onSwipeRight,
    onSwipeUp,
    onSwipeDown,
    threshold = 50,
    preventDefault = false
  } = options;

  useEffect(() => {
    const element = elementRef?.current || elementRef;
    if (!element) return;

    const handleTouchStart = (e) => {
      const touch = e.touches[0];
      startPos.current = { x: touch.clientX, y: touch.clientY };
      startTime.current = Date.now();
    };

    const handleTouchEnd = (e) => {
      if (preventDefault) e.preventDefault();

      const touch = e.changedTouches[0];
      const deltaX = touch.clientX - startPos.current.x;
      const deltaY = touch.clientY - startPos.current.y;
      const deltaTime = Date.now() - startTime.current;

      const gestureData = {
        deltaX,
        deltaY,
        deltaTime,
        velocity: Math.sqrt(deltaX * deltaX + deltaY * deltaY) / deltaTime
      };

      if (Math.abs(deltaX) > threshold || Math.abs(deltaY) > threshold) {
        if (Math.abs(deltaX) > Math.abs(deltaY)) {
          if (deltaX > 0) {
            gestureData.direction = 'right';
            onSwipeRight?.(gestureData);
          } else {
            gestureData.direction = 'left';
            onSwipeLeft?.(gestureData);
          }
        } else {
          if (deltaY > 0) {
            gestureData.direction = 'down';
            onSwipeDown?.(gestureData);
          } else {
            gestureData.direction = 'up';
            onSwipeUp?.(gestureData);
          }
        }
        setGesture(gestureData);
      }
    };

    element.addEventListener('touchstart', handleTouchStart, { passive: true });
    element.addEventListener('touchend', handleTouchEnd, { passive: !preventDefault });

    return () => {
      element.removeEventListener('touchstart', handleTouchStart);
      element.removeEventListener('touchend', handleTouchEnd);
    };
  }, [elementRef, threshold, onSwipeLeft, onSwipeRight, onSwipeUp, onSwipeDown, preventDefault]);

  return gesture;
}
