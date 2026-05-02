import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  base: '/kubera/',  // GitHub Pages repo name
  build: {
    outDir: 'docs',
    assetsDir: 'assets'
  }
})
