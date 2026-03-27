---
name: react-debugging-advanced
description: Advanced React debugging techniques using browser DevTools, React DevTools, performance profiling, and error boundaries. Use for troubleshooting complex React applications and performance issues.
allowed-tools: fs_read fs_write execute_bash
metadata:
  author: kiro-cli
  version: "1.0"
  category: frontend
  compatibility: Requires React DevTools browser extension, modern browser
---

# React Advanced Debugging

## Instructions

### 1. Set up debugging environment

**Install React DevTools:**
```bash
# Browser extensions (install from browser store)
# Chrome: React Developer Tools
# Firefox: React Developer Tools
# Edge: React Developer Tools

# Standalone app for React Native
npm install -g react-devtools
```

**Configure development build:**
```javascript
// vite.config.ts
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  define: {
    __DEV__: true, // Enable development mode
  },
  build: {
    sourcemap: true, // Enable source maps for production debugging
  },
})
```

### 2. Error boundaries and error handling

**Comprehensive error boundary:**
```typescript
import React, { Component, ErrorInfo, ReactNode } from 'react';

interface Props {
  children: ReactNode;
  fallback?: ReactNode;
  onError?: (error: Error, errorInfo: ErrorInfo) => void;
}

interface State {
  hasError: boolean;
  error?: Error;
  errorInfo?: ErrorInfo;
}

export class ErrorBoundary extends Component<Props, State> {
  constructor(props: Props) {
    super(props);
    this.state = { hasError: false };
  }

  static getDerivedStateFromError(error: Error): State {
    return { hasError: true, error };
  }

  componentDidCatch(error: Error, errorInfo: ErrorInfo) {
    console.error('ErrorBoundary caught an error:', error, errorInfo);
    
    // Log to external service
    this.logErrorToService(error, errorInfo);
    
    // Call custom error handler
    this.props.onError?.(error, errorInfo);
    
    this.setState({ errorInfo });
  }

  private logErrorToService(error: Error, errorInfo: ErrorInfo) {
    // Example: Send to logging service
    console.log('Logging error to service:', {
      message: error.message,
      stack: error.stack,
      componentStack: errorInfo.componentStack,
      timestamp: new Date().toISOString(),
      userAgent: navigator.userAgent,
      url: window.location.href,
    });
  }

  render() {
    if (this.state.hasError) {
      if (this.props.fallback) {
        return this.props.fallback;
      }

      return (
        <div className="error-boundary">
          <h2>Something went wrong</h2>
          <details style={{ whiteSpace: 'pre-wrap' }}>
            <summary>Error Details</summary>
            <p><strong>Error:</strong> {this.state.error?.message}</p>
            <p><strong>Stack:</strong> {this.state.error?.stack}</p>
            <p><strong>Component Stack:</strong> {this.state.errorInfo?.componentStack}</p>
          </details>
          <button onClick={() => window.location.reload()}>
            Reload Page
          </button>
        </div>
      );
    }

    return this.props.children;
  }
}
```

### 3. Performance debugging with React DevTools Profiler

**Performance monitoring component:**
```typescript
import { Profiler, ProfilerOnRenderCallback } from 'react';

const onRenderCallback: ProfilerOnRenderCallback = (
  id,
  phase,
  actualDuration,
  baseDuration,
  startTime,
  commitTime,
  interactions
) => {
  console.log('Profiler:', {
    id,
    phase,
    actualDuration,
    baseDuration,
    startTime,
    commitTime,
    interactions: Array.from(interactions),
  });

  // Log slow renders
  if (actualDuration > 16) { // More than one frame at 60fps
    console.warn(`Slow render detected in ${id}: ${actualDuration}ms`);
  }
};

export const PerformanceProfiler: React.FC<{ children: React.ReactNode; id: string }> = ({ 
  children, 
  id 
}) => {
  return (
    <Profiler id={id} onRender={onRenderCallback}>
      {children}
    </Profiler>
  );
};

// Usage
function App() {
  return (
    <PerformanceProfiler id="App">
      <Header />
      <PerformanceProfiler id="MainContent">
        <MainContent />
      </PerformanceProfiler>
      <Footer />
    </PerformanceProfiler>
  );
}
```

### 4. Custom debugging hooks

**Debug hook for component lifecycle:**
```typescript
import { useEffect, useRef } from 'react';

export function useDebugValue(value: any, label: string = 'Debug') {
  const prevValue = useRef(value);
  
  useEffect(() => {
    if (prevValue.current !== value) {
      console.log(`[${label}] Changed:`, {
        from: prevValue.current,
        to: value,
        timestamp: new Date().toISOString(),
      });
      prevValue.current = value;
    }
  });

  // Show in React DevTools
  React.useDebugValue(value, (val) => `${label}: ${JSON.stringify(val)}`);
}

export function useRenderCount(componentName: string) {
  const renderCount = useRef(0);
  
  useEffect(() => {
    renderCount.current += 1;
    console.log(`[${componentName}] Render #${renderCount.current}`);
  });

  React.useDebugValue(renderCount.current, (count) => `Renders: ${count}`);
  
  return renderCount.current;
}

export function useWhyDidYouUpdate(name: string, props: Record<string, any>) {
  const previousProps = useRef<Record<string, any>>();
  
  useEffect(() => {
    if (previousProps.current) {
      const allKeys = Object.keys({ ...previousProps.current, ...props });
      const changedProps: Record<string, { from: any; to: any }> = {};
      
      allKeys.forEach(key => {
        if (previousProps.current![key] !== props[key]) {
          changedProps[key] = {
            from: previousProps.current![key],
            to: props[key],
          };
        }
      });
      
      if (Object.keys(changedProps).length) {
        console.log(`[${name}] Props changed:`, changedProps);
      }
    }
    
    previousProps.current = props;
  });
}

// Usage example
function MyComponent({ userId, data, onUpdate }: Props) {
  useRenderCount('MyComponent');
  useDebugValue(userId, 'Current User ID');
  useWhyDidYouUpdate('MyComponent', { userId, data, onUpdate });
  
  // Component logic...
}
```

### 5. State debugging with Redux DevTools

**Enhanced store configuration:**
```typescript
import { configureStore } from '@reduxjs/toolkit';
import { createLogger } from 'redux-logger';

const logger = createLogger({
  predicate: () => process.env.NODE_ENV === 'development',
  collapsed: true,
  duration: true,
  timestamp: true,
  logErrors: true,
  diff: true,
});

export const store = configureStore({
  reducer: {
    // your reducers
  },
  middleware: (getDefaultMiddleware) =>
    getDefaultMiddleware({
      serializableCheck: {
        // Ignore these action types
        ignoredActions: ['persist/PERSIST'],
      },
    }).concat(logger),
  devTools: process.env.NODE_ENV === 'development' && {
    trace: true,
    traceLimit: 25,
    actionSanitizer: (action) => ({
      ...action,
      // Sanitize sensitive data
      payload: action.type.includes('password') ? '[REDACTED]' : action.payload,
    }),
    stateSanitizer: (state) => ({
      ...state,
      // Sanitize sensitive state
      auth: state.auth ? { ...state.auth, token: '[REDACTED]' } : state.auth,
    }),
  },
});
```

### 6. Network debugging and API monitoring

**API debugging wrapper:**
```typescript
import axios, { AxiosRequestConfig, AxiosResponse, AxiosError } from 'axios';

// Request/Response interceptor for debugging
const apiClient = axios.create({
  baseURL: process.env.REACT_APP_API_URL,
});

apiClient.interceptors.request.use(
  (config: AxiosRequestConfig) => {
    const requestId = Math.random().toString(36).substr(2, 9);
    config.metadata = { requestId, startTime: Date.now() };
    
    console.log(`[API Request ${requestId}]`, {
      method: config.method?.toUpperCase(),
      url: config.url,
      params: config.params,
      data: config.data,
      headers: config.headers,
    });
    
    return config;
  },
  (error: AxiosError) => {
    console.error('[API Request Error]', error);
    return Promise.reject(error);
  }
);

apiClient.interceptors.response.use(
  (response: AxiosResponse) => {
    const { requestId, startTime } = response.config.metadata || {};
    const duration = Date.now() - (startTime || 0);
    
    console.log(`[API Response ${requestId}] ${duration}ms`, {
      status: response.status,
      statusText: response.statusText,
      data: response.data,
      headers: response.headers,
    });
    
    // Log slow requests
    if (duration > 1000) {
      console.warn(`[API] Slow request detected: ${duration}ms for ${response.config.url}`);
    }
    
    return response;
  },
  (error: AxiosError) => {
    const { requestId, startTime } = error.config?.metadata || {};
    const duration = Date.now() - (startTime || 0);
    
    console.error(`[API Error ${requestId}] ${duration}ms`, {
      message: error.message,
      status: error.response?.status,
      statusText: error.response?.statusText,
      data: error.response?.data,
      config: {
        method: error.config?.method,
        url: error.config?.url,
        params: error.config?.params,
      },
    });
    
    return Promise.reject(error);
  }
);
```

### 7. Memory leak detection

**Memory monitoring hook:**
```typescript
import { useEffect, useRef } from 'react';

export function useMemoryMonitor(componentName: string, interval: number = 5000) {
  const intervalRef = useRef<NodeJS.Timeout>();
  
  useEffect(() => {
    if (process.env.NODE_ENV === 'development' && 'memory' in performance) {
      intervalRef.current = setInterval(() => {
        const memory = (performance as any).memory;
        console.log(`[Memory ${componentName}]`, {
          used: `${Math.round(memory.usedJSHeapSize / 1048576)} MB`,
          total: `${Math.round(memory.totalJSHeapSize / 1048576)} MB`,
          limit: `${Math.round(memory.jsHeapSizeLimit / 1048576)} MB`,
          timestamp: new Date().toISOString(),
        });
      }, interval);
    }
    
    return () => {
      if (intervalRef.current) {
        clearInterval(intervalRef.current);
      }
    };
  }, [componentName, interval]);
}

// Detect potential memory leaks
export function useLeakDetection(componentName: string) {
  const mountTime = useRef(Date.now());
  const cleanupFunctions = useRef<(() => void)[]>([]);
  
  const addCleanup = (fn: () => void) => {
    cleanupFunctions.current.push(fn);
  };
  
  useEffect(() => {
    return () => {
      const lifetime = Date.now() - mountTime.current;
      console.log(`[${componentName}] Unmounted after ${lifetime}ms`);
      
      // Run all cleanup functions
      cleanupFunctions.current.forEach(fn => {
        try {
          fn();
        } catch (error) {
          console.error(`[${componentName}] Cleanup error:`, error);
        }
      });
    };
  }, [componentName]);
  
  return { addCleanup };
}
```

## Examples

### Complete debugging setup
```typescript
// App.tsx with comprehensive debugging
import React from 'react';
import { ErrorBoundary } from './components/ErrorBoundary';
import { PerformanceProfiler } from './components/PerformanceProfiler';

function App() {
  return (
    <ErrorBoundary
      onError={(error, errorInfo) => {
        // Send to error tracking service
        console.error('App Error:', error, errorInfo);
      }}
    >
      <PerformanceProfiler id="App">
        <div className="app">
          <Header />
          <MainContent />
          <Footer />
        </div>
      </PerformanceProfiler>
    </ErrorBoundary>
  );
}

export default App;
```

### Debug component with all hooks
```typescript
function DebugComponent({ userId, data }: Props) {
  useRenderCount('DebugComponent');
  useMemoryMonitor('DebugComponent');
  useDebugValue(userId, 'User ID');
  useWhyDidYouUpdate('DebugComponent', { userId, data });
  
  const { addCleanup } = useLeakDetection('DebugComponent');
  
  useEffect(() => {
    const timer = setInterval(() => {
      console.log('Timer tick');
    }, 1000);
    
    addCleanup(() => clearInterval(timer));
  }, [addCleanup]);
  
  return <div>Debug Component Content</div>;
}
```

## Troubleshooting

- **React DevTools not showing**: Ensure development build and extension installed
- **Performance profiler not recording**: Check if Profiler component wraps target components
- **Error boundary not catching errors**: Async errors need separate handling
- **Memory leaks detected**: Check for uncleared intervals, event listeners, subscriptions
- **API calls not logged**: Verify interceptors are properly configured
- **State changes not visible**: Ensure Redux DevTools extension is installed and enabled
