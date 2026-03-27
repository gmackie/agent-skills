---
name: react-project-init
description: Initialize a modern React project with Vite, TypeScript, TanStack Query, Zustand, and shadcn/ui. Use when creating new React applications or setting up React development environments.
allowed-tools: fs_read fs_write execute_bash
metadata:
  author: kiro-cli
  version: "1.0"
  category: frontend
---

# React Project Initialization

## Instructions

1. **Create Vite project with React + TypeScript**
```bash
npm create vite@latest my-app -- --template react-ts
cd my-app
npm install
```

2. **Install core dependencies**
```bash
npm install @tanstack/react-query zustand react-router-dom
npm install react-hook-form zod @hookform/resolvers
```

3. **Install and configure Tailwind CSS**
```bash
npm install -D tailwindcss postcss autoprefixer
npx tailwindcss init -p
```

Update `tailwind.config.js`:
```javascript
export default {
  darkMode: ["class"],
  content: ["./index.html", "./src/**/*.{js,ts,jsx,tsx}"],
  theme: { extend: {} },
  plugins: [],
}
```

Update `src/index.css`:
```css
@tailwind base;
@tailwind components;
@tailwind utilities;
```

4. **Initialize shadcn/ui**
```bash
npx shadcn-ui@latest init
npx shadcn-ui@latest add button card form input label toast
```

5. **Set up project structure**
```bash
mkdir -p src/{components,hooks,stores,lib,types,pages}
```

6. **Configure TanStack Query**
Create `src/lib/query-client.ts`:
```typescript
import { QueryClient } from '@tanstack/react-query';

export const queryClient = new QueryClient({
  defaultOptions: {
    queries: { staleTime: 60 * 1000, retry: 1 },
  },
});
```

Update `src/main.tsx`:
```typescript
import { QueryClientProvider } from '@tanstack/react-query';
import { queryClient } from './lib/query-client';

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <QueryClientProvider client={queryClient}>
      <App />
    </QueryClientProvider>
  </React.StrictMode>,
);
```

7. **Create Zustand store**
Create `src/stores/theme-store.ts`:
```typescript
import { create } from 'zustand';
import { persist } from 'zustand/middleware';

interface ThemeStore {
  theme: 'light' | 'dark';
  setTheme: (theme: 'light' | 'dark') => void;
  toggleTheme: () => void;
}

export const useThemeStore = create<ThemeStore>()(
  persist(
    (set) => ({
      theme: 'light',
      setTheme: (theme) => set({ theme }),
      toggleTheme: () => set((state) => ({ 
        theme: state.theme === 'light' ? 'dark' : 'light' 
      })),
    }),
    { name: 'theme-storage' }
  )
);
```

8. **Run development server**
```bash
npm run dev
```

## Examples

### Quick Start
```bash
npm create vite@latest my-react-app -- --template react-ts
cd my-react-app
npm install
npm install @tanstack/react-query zustand
npm install -D tailwindcss postcss autoprefixer
npx tailwindcss init -p
npx shadcn-ui@latest init
npm run dev
```

### With pnpm
```bash
pnpm create vite my-app --template react-ts
cd my-app
pnpm install
pnpm add @tanstack/react-query zustand
pnpm add -D tailwindcss postcss autoprefixer
pnpm dev
```

## Troubleshooting

- **Vite fails to start**: Change port in vite.config.ts or kill process using the port
- **shadcn/ui components not found**: Ensure path aliases configured in tsconfig.json and vite.config.ts
- **Tailwind styles not applying**: Verify content paths in tailwind.config.js
- **TypeScript errors with path aliases**: Install @types/node and verify tsconfig.json paths
