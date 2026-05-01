/**
 * Kubera - Modern JavaScript Module
 * Handles: Theme toggle, scroll animations, smooth scrolling, analytics prep
 */

(function () {
    'use strict';

    // Utility: Debounce function for performance
    const debounce = (fn, ms = 100) => {
        let timeoutId;
        return (...args) => {
            clearTimeout(timeoutId);
            timeoutId = setTimeout(() => fn.apply(this, args), ms);
        };
    };

    // Theme Management
    const ThemeManager = {
        STORAGE_KEY: 'kubera-theme',

        init() {
            this.themeToggle = document.querySelector('[data-theme-toggle]');
            this.currentTheme = this.getStoredTheme() || this.getSystemTheme();
            this.applyTheme(this.currentTheme);
            this.bindEvents();
        },

        getStoredTheme() {
            try {
                return localStorage.getItem(this.STORAGE_KEY);
            } catch {
                return null;
            }
        },

        getSystemTheme() {
            return window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light';
        },

        applyTheme(theme) {
            document.documentElement.setAttribute('data-theme', theme);
            if (this.themeToggle) {
                this.themeToggle.setAttribute('aria-pressed', theme === 'dark' ? 'true' : 'false');
                this.themeToggle.textContent = theme === 'dark' ? '☀️' : '🌙';
            }
            try {
                localStorage.setItem(this.STORAGE_KEY, theme);
            } catch {
                // Silently fail if localStorage unavailable
            }
        },

        toggleTheme() {
            this.currentTheme = this.currentTheme === 'dark' ? 'light' : 'dark';
            this.applyTheme(this.currentTheme);
        },

        bindEvents() {
            if (!this.themeToggle) return;

            const handler = () => this.toggleTheme();
            this.themeToggle.addEventListener('click', handler);
            this._themeHandler = handler;
        },

        destroy() {
            if (this.themeToggle && this._themeHandler) {
                this.themeToggle.removeEventListener('click', this._themeHandler);
            }
        }
    };

    // Scroll Animation Manager using Intersection Observer
    const ScrollAnimator = {
        init() {
            const animatedSelectors = '.feature-card, .testimonial, .step, .section-header';
            this.animatedElements = document.querySelectorAll(animatedSelectors);

            if (!this.animatedElements.length) return;

            this.observer = new IntersectionObserver(
                (entries) => {
                    for (const entry of entries) {
                        if (entry.isIntersecting) {
                            this.animateElement(entry.target);
                            this.observer.unobserve(entry.target);
                        }
                    }
                },
                { threshold: 0.1, rootMargin: '0px 0px -50px 0px' }
            );

            for (const el of this.animatedElements) {
                el.style.opacity = '0';
                this.observer.observe(el);
            }
        },

        animateElement(element) {
            const animationType = element.dataset.animate || 'fadeInUp';
            requestAnimationFrame(() => {
                element.style.animation = `${animationType} 0.6s ease-out forwards`;
                element.style.opacity = '1';
            });
        },

        destroy() {
            if (this.observer) {
                this.observer.disconnect();
            }
        }
    };

    // Smooth Scroll with event delegation and error handling
    const SmoothScroll = {
        init() {
            this.handler = (e) => {
                const anchor = e.target.closest('a[href^="#"]');
                if (!anchor) return;

                const href = anchor.getAttribute('href');
                if (!href || href === '#') return;

                e.preventDefault();

                const target = document.querySelector(href);
                if (!target) {
                    console.warn(`SmoothScroll: Target not found for "${href}"`);
                    return;
                }

                target.scrollIntoView({ behavior: 'smooth', block: 'start' });
            };

            document.addEventListener('click', this.handler);
        },

        destroy() {
            if (this.handler) {
                document.removeEventListener('click', this.handler);
            }
        }
    };

    // Analytics Preparation (queues events, no actual tracking without consent)
    const AnalyticsPrep = {
        init() {
            const trackableLinks = document.querySelectorAll('a[href*="github.com"], .primary-btn, .secondary-btn, .cta-button');

            for (const el of trackableLinks) {
                if (!el.dataset.track) {
                    const eventName = this.getEventName(el);
                    if (eventName) {
                        el.dataset.track = eventName;
                        el.dataset.trackData = JSON.stringify({
                            text: el.textContent.trim(),
                            href: el.href || ''
                        });
                    }
                }
            }

            document.addEventListener('click', (e) => {
                const trackEl = e.target.closest('[data-track]');
                if (trackEl) {
                    this.queueEvent({
                        event: trackEl.dataset.track,
                        data: trackEl.dataset.trackData ? JSON.parse(trackEl.dataset.trackData) : {},
                        timestamp: Date.now()
                    });
                }
            });
        },

        getEventName(el) {
            if (el.matches('a[href*="github.com"]')) return 'github_click';
            if (el.matches('.primary-btn, .cta-button')) return 'primary_cta_click';
            if (el.matches('.secondary-btn')) return 'secondary_cta_click';
            return null;
        },

        queueEvent(eventData) {
            try {
                const queue = JSON.parse(localStorage.getItem('kubera_analytics_queue') || '[]');
                queue.push(eventData);
                if (queue.length > 100) queue.shift();
                localStorage.setItem('kubera_analytics_queue', JSON.stringify(queue));
            } catch {
                // Silently fail
            }
        }
    };

    // Initialize when DOM ready
    function init() {
        ThemeManager.init();
        ScrollAnimator.init();
        SmoothScroll.init();
        AnalyticsPrep.init();
    }

    function destroy() {
        ThemeManager.destroy();
        ScrollAnimator.destroy();
        SmoothScroll.destroy();
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }

    window.__kuberaDestroy = destroy;
})();
