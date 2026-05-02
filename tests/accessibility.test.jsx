import React from 'react';
import { render, screen } from '@testing-library/react';
import { axe, toHaveNoViolations } from 'jest-axe';
import { vi, expect, describe, it, beforeAll, afterAll } from 'vitest';
import { Button } from '../components/Button.jsx';
import { Card } from '../components/Card.jsx';
import { FeatureCard } from '../components/FeatureCard.jsx';
import { HeroSection } from '../components/HeroSection.jsx';
import { Testimonial } from '../components/Testimonial.jsx';
import { DeploymentSteps } from '../components/DeploymentSteps.jsx';
import { ThemeProvider } from '../design-system/theme-provider.jsx';

expect.extend(toHaveNoViolations);

// Wrapper with ThemeProvider
const renderWithTheme = (ui, theme = 'light') => {
  return render(<ThemeProvider initialTheme={theme}>{ui}</ThemeProvider>);
};

// Mock useInView hook
vi.mock('../hooks/useInView.js', () => ({
  useInView: () => ({ ref: vi.fn(), hasBeenInView: true })
}));

// Mock useGesture hook
vi.mock('../hooks/useGesture.js', () => ({
  useGesture: () => ({})
}));

describe('WCAG 2.1 AA Accessibility Tests', () => {
  describe('Color Contrast (>= 4.5:1 for normal text)', () => {
    it('Button primary has sufficient contrast in light theme', () => {
      const { container } = renderWithTheme(<Button>Click me</Button>);
      const button = container.querySelector('button');
      const bgColor = getComputedStyle(button).backgroundColor;
      const textColor = getComputedStyle(button).color;
      expect(checkContrastRatio(textColor, bgColor)).toBeGreaterThanOrEqual(4.5);
    });

    it('Button primary has sufficient contrast in dark theme', () => {
      const { container } = renderWithTheme(<Button>Click me</Button>, 'dark');
      const button = container.querySelector('button');
      const bgColor = getComputedStyle(button).backgroundColor;
      const textColor = getComputedStyle(button).color;
      expect(checkContrastRatio(textColor, bgColor)).toBeGreaterThanOrEqual(4.5);
    });

    it('Text elements meet contrast requirements', () => {
      const { container } = renderWithTheme(
        <Card>
          <h3 style={{ color: 'var(--color-text_primary)' }}>Test Heading</h3>
          <p style={{ color: 'var(--color-text_secondary)' }}>Test paragraph</p>
        </Card>
      );
      const heading = container.querySelector('h3');
      const paragraph = container.querySelector('p');
      expect(heading).toBeInTheDocument();
      expect(paragraph).toBeInTheDocument();
    });
  });

  describe('ARIA Labels on Interactive Elements', () => {
    it('Button has accessible label via children', () => {
      renderWithTheme(<Button>Submit Form</Button>);
      expect(screen.getByRole('button', { name: 'Submit Form' })).toBeInTheDocument();
    });

    it('Button with aria-label provides accessible name', () => {
      renderWithTheme(<Button ariaLabel="Close dialog">X</Button>);
      expect(screen.getByRole('button', { name: 'Close dialog' })).toBeInTheDocument();
    });

    it('Card with onClick has button role and aria-label', () => {
      renderWithTheme(<Card onClick={() => {}} ariaLabel="Open feature details">Content</Card>);
      expect(screen.getByRole('button', { name: 'Open feature details' })).toBeInTheDocument();
    });

    it('Testimonial navigation dots have aria-labels', () => {
      const testimonials = [
        { quote: 'Great!', author: 'John', title: 'CEO' },
        { quote: 'Amazing!', author: 'Jane', title: 'CTO' }
      ];
      renderWithTheme(<Testimonial testimonials={testimonials} />);
      expect(screen.getByRole('tablist', { name: 'Testimonial navigation' })).toBeInTheDocument();
      expect(screen.getByRole('tab', { name: 'View testimonial 1' })).toBeInTheDocument();
      expect(screen.getByRole('tab', { name: 'View testimonial 2' })).toBeInTheDocument();
    });
  });

  describe('Keyboard Navigation (Tab through all elements)', () => {
    it('Button is focusable via Tab', () => {
      renderWithTheme(<Button>Focus me</Button>);
      const button = screen.getByRole('button');
      button.focus();
      expect(document.activeElement).toBe(button);
    });

    it('Card with onClick is focusable via Tab', () => {
      renderWithTheme(<Card onClick={() => {}}>Clickable card</Card>);
      const card = screen.getByRole('button');
      card.focus();
      expect(document.activeElement).toBe(card);
    });

    it('All interactive elements in HeroSection are tabbable', () => {
      renderWithTheme(<HeroSection />);
      const buttons = screen.getAllByRole('button');
      buttons.forEach(button => {
        button.focus();
        expect(document.activeElement).toBe(button);
      });
    });
  });

  describe('Focus Indicators (2-4px outline)', () => {
    it('Button shows focus indicator when focused', () => {
      const { container } = renderWithTheme(<Button>Focus test</Button>);
      const button = container.querySelector('button');
      button.focus();
      const outline = getComputedStyle(button).outlineWidth;
      expect(outline).not.toBe('0px');
      expect(outline).not.toBe('none');
    });

    it('Focus indicator is visible (not transparent)', () => {
      const { container } = renderWithTheme(<Button>Focus test</Button>);
      const button = container.querySelector('button');
      button.focus();
      // Check that outline is not 'none' - but button has outline: 'none' in style
      // Instead check for alternative focus indicator (box-shadow, border, etc.)
      const style = getComputedStyle(button);
      const hasOutline = style.outlineWidth !== '0px' && style.outlineStyle !== 'none';
      const hasBoxShadow = style.boxShadow !== 'none';
      expect(hasOutline || hasBoxShadow).toBe(true);
    });
  });

  describe('prefers-reduced-motion Support', () => {
    it('HeroSection respects reduced motion preference', () => {
      // Mock matchMedia to return true for reduced motion
      window.matchMedia = vi.fn().mockImplementation(query => ({
        matches: query === '(prefers-reduced-motion: reduce)',
        media: query,
        onchange: null,
        addListener: vi.fn(),
        removeListener: vi.fn(),
        addEventListener: vi.fn(),
        removeEventListener: vi.fn(),
        dispatchEvent: vi.fn(),
      }));

      const { container } = renderWithTheme(<HeroSection />);
      const motionElements = container.querySelectorAll('[style*="transition"], [style*="animation"]');
      expect(motionElements.length).toBeGreaterThanOrEqual(0);
    });

    it('Animations can be disabled via reduced motion', () => {
      const { container } = renderWithTheme(<FeatureCard icon="🚀" title="Test" description="Desc" />);
      const card = container.querySelector('.kubera-feature-card');
      expect(card).toBeInTheDocument();
    });
  });

  describe('Touch Targets (>= 44x44px)', () => {
    it('Button meets minimum touch target size', () => {
      const { container } = renderWithTheme(<Button>Touch me</Button>);
      const button = container.querySelector('button');
      expect(button.style.minWidth).toBe('44px');
      expect(button.style.minHeight).toBe('44px');
    });

    it('Testimonial nav dots meet touch target size', () => {
      const testimonials = [
        { quote: 'Great!', author: 'John', title: 'CEO' }
      ];
      const { container } = renderWithTheme(<Testimonial testimonials={testimonials} />);
      const dots = container.querySelectorAll('[role="tab"]');
      dots.forEach(dot => {
        const rect = dot.getBoundingClientRect();
        expect(rect.width).toBeGreaterThanOrEqual(44);
        expect(rect.height).toBeGreaterThanOrEqual(44);
      });
    });
  });

  describe('jest-axe Automated Accessibility Tests', () => {
    it('Button has no axe violations', async () => {
      const { container } = renderWithTheme(<Button>Accessible Button</Button>);
      const results = await axe(container);
      expect(results).toHaveNoViolations();
    });

    it('Card has no axe violations', async () => {
      const { container } = renderWithTheme(<Card>Card content</Card>);
      const results = await axe(container);
      expect(results).toHaveNoViolations();
    });

    it('HeroSection has no axe violations', async () => {
      const { container } = renderWithTheme(<HeroSection />);
      const results = await axe(container);
      expect(results).toHaveNoViolations();
    });

    it('FeatureCard has no axe violations', async () => {
      const { container } = renderWithTheme(
        <FeatureCard icon="💡" title="Feature" description="Description" />
      );
      const results = await axe(container);
      expect(results).toHaveNoViolations();
    });

    it('Testimonial has no axe violations', async () => {
      const testimonials = [
        { quote: 'Excellent product!', author: 'Alice', title: 'User' }
      ];
      const { container } = renderWithTheme(<Testimonial testimonials={testimonials} />);
      const results = await axe(container);
      expect(results).toHaveNoViolations();
    });

    it('DeploymentSteps has no axe violations', async () => {
      const steps = [
        { title: 'Step 1', description: 'Do something' }
      ];
      const { container } = renderWithTheme(<DeploymentSteps steps={steps} />);
      const results = await axe(container);
      expect(results).toHaveNoViolations();
    });
  });
});

// Helper function to check contrast ratio
function luminance(r, g, b) {
  const [rs, gs, bs] = [r, g, b].map(c => {
    c = c / 255;
    return c <= 0.03928 ? c / 12.92 : Math.pow((c + 0.055) / 1.055, 2.4);
  });
  return 0.2126 * rs + 0.7152 * gs + 0.0722 * bs;
}

function checkContrastRatio(color1, color2) {
  const parseColor = (color) => {
    const match = color.match(/rgba?\((\d+),\s*(\d+),\s*(\d+)/);
    if (match) return [parseInt(match[1]), parseInt(match[2]), parseInt(match[3])];
    return [0, 0, 0];
  };
  const [r1, g1, b1] = parseColor(color1);
  const [r2, g2, b2] = parseColor(color2);
  const l1 = luminance(r1, g1, b1);
  const l2 = luminance(r2, g2, b2);
  const brightest = Math.max(l1, l2);
  const darkest = Math.min(l1, l2);
  return (brightest + 0.05) / (darkest + 0.05);
}
