import React from 'react'
import { ThemeProvider } from '../design-system/theme-provider'
import { HeroSection } from '../components/HeroSection'
import { FeatureCard } from '../components/FeatureCard'
import { Testimonial } from '../components/Testimonial'
import { DeploymentSteps } from '../components/DeploymentSteps'
import { ScrollReveal } from '../components/ScrollReveal'

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
              icon="💰"
              title="Smart Budgeting"
              description="AI-powered budgeting that adapts to your spending patterns."
            />
            <FeatureCard
              icon="📊"
              title="Analytics"
              description="Deep insights into your financial health with real-time data."
            />
            <FeatureCard
              icon="🎯"
              title="Goals"
              description="Set and track financial goals with intelligent recommendations."
            />
          </div>
        </section>
        <Testimonial />
        <DeploymentSteps />
      </div>
    </ThemeProvider>
  )
}

export default App
