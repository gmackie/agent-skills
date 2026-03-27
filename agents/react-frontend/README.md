# React Frontend Developer Agent

Specialized agent for modern React frontend development with TanStack Query, Zustand, and shadcn/ui.

## Quick Start

```bash
# Load this agent in Kiro CLI
kiro-cli chat --context agents/react-frontend/instructions.md

# Or with skills
kiro-cli chat --context agents/react-frontend/instructions.md --context skills/react/
```

## Capabilities

- Build type-safe React applications with TypeScript
- Implement efficient data fetching with TanStack Query
- Manage state with Zustand
- Create beautiful UIs with shadcn/ui and Tailwind CSS
- Set up routing with React Router
- Handle forms with React Hook Form
- Optimize performance and bundle size
- Ensure accessibility compliance

## Tech Stack

- **React 18+**: Modern React with hooks and concurrent features
- **TypeScript**: Type-safe development
- **Vite**: Fast build tool and dev server
- **TanStack Query**: Powerful data fetching and caching
- **Zustand**: Lightweight state management
- **shadcn/ui**: Beautiful, accessible component library
- **Tailwind CSS**: Utility-first styling
- **React Router**: Client-side routing
- **React Hook Form**: Performant form handling

## Available Skills

| Skill | Description |
|-------|-------------|
| `react/project-init` | Initialize React project with full stack |
| `react/tanstack-query-setup` | Configure TanStack Query |
| `react/zustand-store` | Create Zustand stores |
| `react/shadcn-setup` | Set up shadcn/ui components |
| `react/component-create` | Build reusable components |
| `react/form-handling` | Implement forms |
| `react/routing-setup` | Configure React Router |
| `react/api-integration` | Integrate APIs |

## Common Workflows

### Create New App
```
User: "Create a new React app with data fetching and dark mode"
Agent: [Initializes project, sets up TanStack Query, creates theme store]
```

### Add Feature
```
User: "Add a user profile page with edit functionality"
Agent: [Creates components, sets up queries/mutations, implements form]
```

### Optimize Performance
```
User: "The app is slow when rendering large lists"
Agent: [Analyzes, implements virtualization, adds memoization]
```

## Example Interactions

**Example 1: New Dashboard Project**
```
User: I need to build a dashboard that fetches data from an API 
      and displays it in cards. Users should be able to filter 
      and sort the data.

Agent: I'll create a complete dashboard with:
       1. Vite + React + TypeScript setup
       2. TanStack Query for API data fetching
       3. Zustand store for filter/sort state
       4. shadcn/ui cards and components
       5. Responsive layout with Tailwind
       
       [Proceeds with implementation]
```

**Example 2: Form Implementation**
```
User: Add a user registration form with validation

Agent: I'll implement a form using:
       - React Hook Form for performance
       - Zod for schema validation
       - shadcn/ui form components
       - Proper error handling and loading states
       
       [Creates type-safe form with validation]
```

## Best Practices

The agent follows these principles:

1. **Type Safety**: Always use TypeScript with strict mode
2. **State Management**: 
   - TanStack Query for server state
   - Zustand for global client state
   - React state for local component state
3. **Performance**: Code splitting, memoization, lazy loading
4. **Accessibility**: WCAG 2.1 AA compliance
5. **Code Organization**: Clear folder structure, reusable components
6. **Error Handling**: Error boundaries, proper error states
7. **Testing**: Unit tests for logic, integration tests for flows

## Project Structure

```
src/
├── components/       # Reusable components
│   ├── ui/          # shadcn/ui components
│   └── ...
├── hooks/           # Custom React hooks
├── stores/          # Zustand stores
├── lib/             # Utilities and configurations
├── types/           # TypeScript type definitions
├── pages/           # Page components
└── main.tsx         # Entry point
```

## Prerequisites

- Node.js 18 or later
- npm, pnpm, or yarn
- Basic React and TypeScript knowledge

## Tips

1. Use TanStack Query DevTools for debugging data fetching
2. Leverage shadcn/ui CLI to add components as needed
3. Keep Zustand stores focused and modular
4. Use React DevTools Profiler to identify performance issues
5. Implement error boundaries for graceful error handling
6. Use TypeScript strict mode for better type safety

## Related Resources

- [React Documentation](https://react.dev)
- [TanStack Query Docs](https://tanstack.com/query/latest)
- [Zustand Documentation](https://docs.pmnd.rs/zustand)
- [shadcn/ui Components](https://ui.shadcn.com)
- [Tailwind CSS](https://tailwindcss.com)
