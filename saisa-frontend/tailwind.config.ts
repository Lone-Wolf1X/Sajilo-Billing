import type { Config } from 'tailwindcss';

const config: Config = {
  darkMode: 'class',
  content: [
    './index.html',
    './src/**/*.{js,ts,jsx,tsx}',
  ],
  theme: {
    extend: {
      colors: {
        brand: {
          navy: '#1e3a5f',
          'navy-hover': '#162c47',
          'navy-light': '#e8eef6',
          maroon: '#7a2e2e',
          'maroon-hover': '#5e2323',
          'maroon-light': '#f5e8e8',
        },
        paper: {
          DEFAULT: '#faf8f3',
          alt: '#f5f2ea',
          surface: '#ffffff',
          border: '#e0dcd0',
          'border-strong': '#c9c2b3',
          text: '#2b2b28',
          muted: '#6b6b62',
          subtle: '#999999',
          zebra: '#f9f7f1',
          hover: '#f0ece0',
        },
        ledger: {
          green: '#2d6a4f',
          'green-light': '#e3f0ea',
          amber: '#b8860b',
          'amber-light': '#fdf6e3',
          red: '#a83232',
          'red-light': '#f9e8e8',
        },
      },
      fontFamily: {
        serif: ['Georgia', 'Merriweather', 'Times New Roman', 'serif'],
        sans: [
          '-apple-system',
          'BlinkMacSystemFont',
          'Segoe UI',
          'Inter',
          'Roboto',
          'sans-serif',
        ],
        mono: [
          'JetBrains Mono',
          'SF Mono',
          'Monaco',
          'Consolas',
          'Courier New',
          'monospace',
        ],
      },
      boxShadow: {
        subtle: '0 1px 2px rgba(43, 43, 40, 0.06)',
        ledger: '0 2px 4px rgba(43, 43, 40, 0.08), 0 1px 2px rgba(43, 43, 40, 0.04)',
      },
      borderRadius: {
        sm: '3px',
        md: '4px',
        lg: '6px',
      },
    },
  },
  plugins: [],
};

export default config;

