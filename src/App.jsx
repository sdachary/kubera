import React from 'react'
import { ThemeProvider } from '../design-system/theme-provider'
import { useTheme } from '../design-system/theme-provider'
import { HeroSection } from '../components/HeroSection'
import { FeatureCard } from '../components/FeatureCard'
import { Testimonial } from '../components/Testimonial'
import { DeploymentSteps } from '../components/DeploymentSteps'
import { ScrollReveal } from '../components/ScrollReveal'
import { colors } from '../design-system/colors'

function JourneySection() {
  const { theme } = useTheme();
  const resolvedTheme = theme === 'system'
    ? (typeof window !== 'undefined' && window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light')
    : theme;

  const phases = [
    {
      icon: '💳',
      title: 'Phase 1: Debt Freedom',
      description: 'Clear all high-interest debt using avalanche or snowball strategies. See your debt-free date projected in real-time.',
      color: colors.negative[500],
      bgColor: resolvedTheme === 'dark' ? `${colors.negative[500]}22` : `${colors.negative[100]}`
    },
    {
      icon: '🎯',
      title: 'Phase 2: Foundation Building',
      description: 'Build your emergency fund and establish a solid financial foundation. Monthly check-ins keep you on track.',
      color: colors.primary[500],
      bgColor: resolvedTheme === 'dark' ? `${colors.primary[500]}22` : `${colors.primary[100]}`
    },
    {
      icon: '💰',
      title: 'Phase 3: Income Target',
      description: 'Build wealth with dividend SIPs. AI suggests 2-3 dividend stocks based on your income target.',
      color: colors.positive[500],
      bgColor: resolvedTheme === 'dark' ? `${colors.positive[500]}22` : `${colors.positive[100]}`
    }
  ];

  return (
    <section className="max-w-6xl mx-auto px-4 py-16">
      <ScrollReveal>
        <h2 className="text-3xl font-bold text-center mb-4">Your Financial Journey</h2>
        <p className="text-center text-secondary mb-12 max-w-2xl mx-auto">
          Kubera guides you through three clear phases to transform your financial life
        </p>
      </ScrollReveal>
      <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
        {phases.map((phase, index) => (
          <ScrollReveal key={index}>
            <div
              style={{
                padding: '2rem',
                borderRadius: '16px',
                backgroundColor: phase.bgColor,
                border: `2px solid ${phase.color}33`,
                textAlign: 'center'
              }}
            >
              <div style={{ fontSize: '3rem', marginBottom: '1rem' }}>{phase.icon}</div>
              <h3 style={{ color: phase.color, fontWeight: 700, marginBottom: '0.75rem' }}>{phase.title}</h3>
              <p style={{ fontSize: '0.875rem', lineHeight: 1.6 }}>{phase.description}</p>
            </div>
          </ScrollReveal>
        ))}
      </div>
    </section>
  );
}

function WhyOpenSourceSection() {
  const differentiators = [
    {
      icon: '🔒',
      title: 'Your Data Stays Yours',
      description: 'Self-hosted on your own infrastructure. No data mining, no surveillance capitalism.'
    },
    {
      icon: '🤖',
      title: 'Free AI Options',
      description: 'Works with OpenRouter free tier or Ollama (fully local). No $20/month subscription.'
    },
    {
      icon: '🍴',
      title: 'Fork & Customize',
      description: 'AGPL-3.0 licensed. Modify, extend, and adapt Kubera to your exact needs.'
    },
    {
      icon: '🌍',
      title: 'Community-Driven',
      description: 'No VC pressure. Built by people who need it, for people who need it.'
    }
  ];

  return (
    <section className="max-w-6xl mx-auto px-4 py-16">
      <ScrollReveal>
        <h2 className="text-3xl font-bold text-center mb-4">Why Open Source?</h2>
        <p className="text-center text-secondary mb-12 max-w-2xl mx-auto">
          We believe personal finance tools should be transparent, customizable, and free from conflicts of interest
        </p>
      </ScrollReveal>
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        {differentiators.map((item, index) => (
          <ScrollReveal key={index}>
            <div style={{ padding: '1.5rem', textAlign: 'center' }}>
              <div style={{ fontSize: '2.5rem', marginBottom: '0.75rem' }}>{item.icon}</div>
              <h3 style={{ fontWeight: 600, marginBottom: '0.5rem' }}>{item.title}</h3>
              <p style={{ fontSize: '0.875rem', lineHeight: 1.6, color: 'var(--text-secondary)' }}>{item.description}</p>
            </div>
          </ScrollReveal>
        ))}
      </div>
    </section>
  );
}

function InstallSection() {
  return (
    <section className="max-w-6xl mx-auto px-4 py-16">
      <ScrollReveal>
        <h2 className="text-3xl font-bold text-center mb-4">Install Kubera</h2>
        <p className="text-center text-secondary mb-8 max-w-2xl mx-auto">
          One-line installation. Self-hosted in minutes.
        </p>
      </ScrollReveal>
      <div className="max-w-2xl mx-auto mb-12">
        <div
          style={{
            padding: '1.5rem',
            borderRadius: '12px',
            backgroundColor: 'var(--surface-secondary)',
            border: '1px solid var(--divider)',
            fontFamily: 'monospace',
            fontSize: '0.875rem',
            overflow: 'auto'
          }}
        >
          <code>curl -fsSL https://raw.githubusercontent.com/sdachary/kubera/main/install.sh | bash</code>
        </div>
      </div>
      <DeploymentSteps />
    </section>
  );
}

function App() {
  const handleGetStarted = () => {
    const featuresSection = document.querySelector('section');
    if (featuresSection) {
      featuresSection.scrollIntoView({ behavior: 'smooth' });
    }
  };

  const handleLearnMore = () => {
    window.open('https://github.com/sdachary/kubera', '_blank');
  };

  return (
    <ThemeProvider>
      <div className="min-h-screen bg-background text-foreground">
        <HeroSection onPrimaryClick={handleGetStarted} onSecondaryClick={handleLearnMore} />
        <section className="max-w-6xl mx-auto px-4 py-16">
          <ScrollReveal>
            <h2 className="text-3xl font-bold text-center mb-8">Features</h2>
          </ScrollReveal>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
            <FeatureCard
              icon="💳"
              title="Debt Payoff Tracker"
              description="Avalanche & snowball strategies. Projects your debt-free date."
            />
            <FeatureCard
              icon="📈"
              title="Dividend SIP Planner"
              description="AI suggests 2-3 dividend stocks based on your income target. Works with free AI models."
            />
            <FeatureCard
              icon="🔄"
              title="Portfolio Rebalancing"
              description="Monthly check-ins show if you're on/off track. Reverse-engineers your wealth-building path."
            />
            <FeatureCard
              icon="🔔"
              title="Recurring Reminders"
              description="Never miss an EMI or subscription. Smart alerts for all your recurring expenses."
            />
            <FeatureCard
              icon="🤖"
              title="Free AI Included"
              description="Works with OpenRouter (free tier) or Ollama (fully local). Your data stays yours."
            />
            <FeatureCard
              icon="🇮🇳"
              title="Built for Indian Markets"
              description="NSE/BSE support. Handles EMIs, SIPs, and dividend stocks native to Indian investors."
            />
          </div>
        </section>
        <JourneySection />
        <WhyOpenSourceSection />
        <Testimonial
          testimonials={[
            {
              quote: "Kubera's debt-first approach changed everything. I could see exactly when I'd be debt-free, and it kept me motivated. Now I'm building wealth with the same tool.",
              author: "Priya S.",
              title: "Debt-free in 18 months",
              avatar: "👩"
            }
          ]}
          autoPlay={true}
        />
        <InstallSection />
      </div>
    </ThemeProvider>
  )
}

export default App
