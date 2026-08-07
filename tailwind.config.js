module.exports = {
  content: [
    "./app/views/**/*.html.erb",
    "./app/helpers/**/*.rb",
    "./app/assets/stylesheets/**/*.css",
    "./app/javascript/**/*.js",
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ["JetBrains Mono", "monospace"],
        mono: ["JetBrains Mono", "monospace"],
        inter: ["JetBrains Mono", "monospace"],
        jetbrains: ["JetBrains Mono", "monospace"],
      },
      colors: {
        ruby: {
          50: "#fff1f1",
          100: "#ffd7d7",
          300: "#ff7878",
          500: "#ef2020",
          600: "#CC342D",
          700: "#b01820",
          800: "#8b1219",
        },
        gold: {
          400: "#F4A261",
          500: "#e08c45",
        },
      },
    },
  },
  daisyui: {
    themes: [
      {
        mytheme: {
          primary: "#CC342D",
          "primary-content": "#FFFFFF",
          secondary: "#F4A261",
          accent: "#37CDBE",
          neutral: "#3D4451",
          "base-100": "#FFFFFF",
          "base-content": "#1A1A1A",
          info: "#3ABFF8",
          success: "#36D399",
          warning: "#FBBD23",
          error: "#F87272",
        },
      },
      {
        dark: {
          primary: "#E05450",
          "primary-content": "#FFFFFF",
          secondary: "#F4A261",
          accent: "#37CDBE",
          neutral: "#374151",
          "base-100": "#111827",
          "base-200": "#1F2937",
          "base-300": "#374151",
          "base-content": "#F9FAFB",
          info: "#3ABFF8",
          success: "#36D399",
          warning: "#FBBD23",
          error: "#F87272",
        },
      },
    ],
    darkTheme: "dark",
    base: true,
    styled: true,
    utils: true,
  },
  screens: {
    xs: "576px",
    sm: "640px",
    md: "768px",
    lg: "1024px",
    xl: "1280px",
    "2xl": "1536px",
  },
  plugins: [require("@tailwindcss/typography"), require("daisyui")],
};
