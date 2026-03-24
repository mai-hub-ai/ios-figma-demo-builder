/** @type {import('tailwindcss').Config} */
export default {
  content: [
    './index.html',
    './src/**/*.{js,ts,jsx,tsx}',
  ],
  theme: {
    extend: {
      colors: {
        primary: '#1A73E8',
        secondary: '#34A853',
        background: '#F2F2F7',
        surface: '#FFFFFF',
        success: '#34A853',
        warning: '#FBBC05',
        error: '#EA4335',
        // 商业转化色彩
        cta: {
          primary: '#FFD700',
          secondary: '#FF4500',
        },
        // 文本色彩
        text: {
          primary: '#202124',
          secondary: '#5F6368',
          hint: '#9AA0A6',
        },
        // 状态色彩
        status: {
          available: '#34A853',
          limited: '#FBBC05',
          soldOut: '#EA4335',
          selected: '#4285F4',
        },
      },
      spacing: {
        'safe-top': 'env(safe-area-inset-top)',
        'safe-bottom': 'env(safe-area-inset-bottom)',
        'safe-left': 'env(safe-area-inset-left)',
        'safe-right': 'env(safe-area-inset-right)',
      },
      fontSize: {
        'h1': ['28px', { fontWeight: '800' }],
        'h2': ['22px', { fontWeight: '700' }],
        'h3': ['18px', { fontWeight: '600' }],
        'body': ['17px', { fontWeight: '400' }],
        'body-s': ['15px', { fontWeight: '400' }],
        'caption': ['13px', { fontWeight: '400' }],
        'small': ['11px', { fontWeight: '400' }],
      },
      borderRadius: {
        'card': '12px',
        'button': '8px',
        'tag': '20px',
      },
      boxShadow: {
        'card': '0 2px 8px rgba(0, 0, 0, 0.1)',
        'button': '0 2px 4px rgba(0, 0, 0, 0.2)',
      },
    },
  },
  plugins: [],
}
