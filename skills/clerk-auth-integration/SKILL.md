---
name: clerk-auth-integration
description: Integrate Clerk authentication into Next.js and Expo applications with user management, middleware, and protected routes. Use for adding authentication to SaaS applications.
allowed-tools: fs_read fs_write execute_bash
metadata:
  author: kiro-cli
  version: "1.0"
  category: fullstack
  compatibility: Requires Next.js or Expo, Clerk account
---

# Clerk Authentication Integration

## Instructions

### 1. Next.js Clerk Integration

**Install Clerk for Next.js:**
```bash
npm install @clerk/nextjs
```

**Set up environment variables:**
```env
# .env.local
NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY=pk_test_...
CLERK_SECRET_KEY=sk_test_...
NEXT_PUBLIC_CLERK_SIGN_IN_URL=/sign-in
NEXT_PUBLIC_CLERK_SIGN_UP_URL=/sign-up
NEXT_PUBLIC_CLERK_AFTER_SIGN_IN_URL=/dashboard
NEXT_PUBLIC_CLERK_AFTER_SIGN_UP_URL=/onboarding
```

**Configure middleware:**
```typescript
// middleware.ts
import { authMiddleware } from "@clerk/nextjs";

export default authMiddleware({
  publicRoutes: ["/", "/api/webhooks/clerk", "/api/trpc/(.*)"],
  ignoredRoutes: ["/api/webhooks/(.*)"],
});

export const config = {
  matcher: ["/((?!.+\\.[\\w]+$|_next).*)", "/", "/(api|trpc)(.*)"],
};
```

**Wrap app with ClerkProvider:**
```typescript
// app/layout.tsx
import { ClerkProvider } from '@clerk/nextjs'

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <ClerkProvider>
      <html lang="en">
        <body>{children}</body>
      </html>
    </ClerkProvider>
  )
}
```

**Create auth pages:**
```typescript
// app/sign-in/[[...sign-in]]/page.tsx
import { SignIn } from "@clerk/nextjs";

export default function Page() {
  return (
    <div className="flex min-h-screen items-center justify-center">
      <SignIn />
    </div>
  );
}

// app/sign-up/[[...sign-up]]/page.tsx
import { SignUp } from "@clerk/nextjs";

export default function Page() {
  return (
    <div className="flex min-h-screen items-center justify-center">
      <SignUp />
    </div>
  );
}
```

**Protected dashboard:**
```typescript
// app/dashboard/page.tsx
import { currentUser } from "@clerk/nextjs";
import { redirect } from "next/navigation";

export default async function DashboardPage() {
  const user = await currentUser();
  
  if (!user) {
    redirect("/sign-in");
  }

  return (
    <div className="container mx-auto p-8">
      <h1 className="text-3xl font-bold">Welcome, {user.firstName}!</h1>
      <p className="mt-4">Email: {user.emailAddresses[0]?.emailAddress}</p>
    </div>
  );
}
```

### 2. Expo Clerk Integration

**Install Clerk for Expo:**
```bash
npx expo install @clerk/clerk-expo
npx expo install expo-secure-store expo-web-browser
```

**Configure Clerk provider:**
```typescript
// App.tsx
import { ClerkProvider } from '@clerk/clerk-expo';
import * as SecureStore from 'expo-secure-store';

const tokenCache = {
  async getToken(key: string) {
    try {
      return SecureStore.getItemAsync(key);
    } catch (err) {
      return null;
    }
  },
  async saveToken(key: string, value: string) {
    try {
      return SecureStore.setItemAsync(key, value);
    } catch (err) {
      return;
    }
  },
};

export default function App() {
  return (
    <ClerkProvider
      publishableKey={process.env.EXPO_PUBLIC_CLERK_PUBLISHABLE_KEY!}
      tokenCache={tokenCache}
    >
      <RootNavigator />
    </ClerkProvider>
  );
}
```

**Auth navigation:**
```typescript
// navigation/RootNavigator.tsx
import { useAuth } from '@clerk/clerk-expo';
import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import AuthNavigator from './AuthNavigator';
import AppNavigator from './AppNavigator';

const Stack = createNativeStackNavigator();

export default function RootNavigator() {
  const { isSignedIn, isLoaded } = useAuth();

  if (!isLoaded) {
    return null; // Loading screen
  }

  return (
    <NavigationContainer>
      <Stack.Navigator screenOptions={{ headerShown: false }}>
        {isSignedIn ? (
          <Stack.Screen name="App" component={AppNavigator} />
        ) : (
          <Stack.Screen name="Auth" component={AuthNavigator} />
        )}
      </Stack.Navigator>
    </NavigationContainer>
  );
}
```

**Sign in screen:**
```typescript
// screens/SignInScreen.tsx
import { useSignIn } from '@clerk/clerk-expo';
import { useState } from 'react';
import { View, TextInput, Button, Alert } from 'react-native';

export default function SignInScreen() {
  const { signIn, setActive, isLoaded } = useSignIn();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');

  const onSignInPress = async () => {
    if (!isLoaded) return;

    try {
      const completeSignIn = await signIn.create({
        identifier: email,
        password,
      });

      await setActive({ session: completeSignIn.createdSessionId });
    } catch (err: any) {
      Alert.alert('Error', err.errors[0]?.message);
    }
  };

  return (
    <View style={{ flex: 1, justifyContent: 'center', padding: 20 }}>
      <TextInput
        placeholder="Email"
        value={email}
        onChangeText={setEmail}
        style={{ borderWidth: 1, padding: 10, marginBottom: 10 }}
      />
      <TextInput
        placeholder="Password"
        value={password}
        onChangeText={setPassword}
        secureTextEntry
        style={{ borderWidth: 1, padding: 10, marginBottom: 10 }}
      />
      <Button title="Sign In" onPress={onSignInPress} />
    </View>
  );
}
```

### 3. User Management Components

**User profile component:**
```typescript
// components/UserProfile.tsx
import { useUser, useClerk } from '@clerk/nextjs';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';

export function UserProfile() {
  const { user } = useUser();
  const { signOut } = useClerk();

  if (!user) return null;

  return (
    <Card>
      <CardHeader>
        <CardTitle>Profile</CardTitle>
      </CardHeader>
      <CardContent className="space-y-4">
        <div>
          <strong>Name:</strong> {user.fullName}
        </div>
        <div>
          <strong>Email:</strong> {user.primaryEmailAddress?.emailAddress}
        </div>
        <div>
          <strong>Member since:</strong> {user.createdAt?.toLocaleDateString()}
        </div>
        <Button onClick={() => signOut()} variant="outline">
          Sign Out
        </Button>
      </CardContent>
    </Card>
  );
}
```

**Organization management:**
```typescript
// components/OrganizationSwitcher.tsx
import { OrganizationSwitcher } from '@clerk/nextjs';

export function OrgSwitcher() {
  return (
    <OrganizationSwitcher
      appearance={{
        elements: {
          organizationSwitcherTrigger: "border border-gray-300 rounded-md px-3 py-2"
        }
      }}
      createOrganizationMode="modal"
      afterCreateOrganizationUrl="/dashboard"
      afterLeaveOrganizationUrl="/dashboard"
    />
  );
}
```

### 4. Webhooks for User Sync

**Clerk webhook handler:**
```typescript
// app/api/webhooks/clerk/route.ts
import { headers } from 'next/headers';
import { NextRequest, NextResponse } from 'next/server';
import { Webhook } from 'svix';
import { db } from '@/lib/db';

const webhookSecret = process.env.CLERK_WEBHOOK_SECRET!;

export async function POST(req: NextRequest) {
  const headerPayload = headers();
  const svix_id = headerPayload.get('svix-id');
  const svix_timestamp = headerPayload.get('svix-timestamp');
  const svix_signature = headerPayload.get('svix-signature');

  if (!svix_id || !svix_timestamp || !svix_signature) {
    return new NextResponse('Error occured -- no svix headers', { status: 400 });
  }

  const payload = await req.json();
  const body = JSON.stringify(payload);

  const wh = new Webhook(webhookSecret);
  let evt: any;

  try {
    evt = wh.verify(body, {
      'svix-id': svix_id,
      'svix-timestamp': svix_timestamp,
      'svix-signature': svix_signature,
    });
  } catch (err) {
    console.error('Error verifying webhook:', err);
    return new NextResponse('Error occured', { status: 400 });
  }

  const { id } = evt.data;
  const eventType = evt.type;

  switch (eventType) {
    case 'user.created':
      await db.user.create({
        data: {
          clerkId: id,
          email: evt.data.email_addresses[0]?.email_address,
          firstName: evt.data.first_name,
          lastName: evt.data.last_name,
        },
      });
      break;

    case 'user.updated':
      await db.user.update({
        where: { clerkId: id },
        data: {
          email: evt.data.email_addresses[0]?.email_address,
          firstName: evt.data.first_name,
          lastName: evt.data.last_name,
        },
      });
      break;

    case 'user.deleted':
      await db.user.delete({
        where: { clerkId: id },
      });
      break;
  }

  return new NextResponse('', { status: 200 });
}
```

### 5. tRPC Integration with Clerk

**Protected tRPC procedures:**
```typescript
// server/trpc/context.ts
import { auth } from '@clerk/nextjs';
import { db } from '@/lib/db';

export async function createContext() {
  const { userId } = auth();
  
  return {
    db,
    userId,
  };
}

// server/trpc/procedures.ts
import { TRPCError } from '@trpc/server';
import { t } from './trpc';

export const protectedProcedure = t.procedure.use(({ ctx, next }) => {
  if (!ctx.userId) {
    throw new TRPCError({ code: 'UNAUTHORIZED' });
  }
  return next({
    ctx: {
      ...ctx,
      userId: ctx.userId,
    },
  });
});

// Usage in router
export const userRouter = t.router({
  getProfile: protectedProcedure.query(async ({ ctx }) => {
    return await ctx.db.user.findUnique({
      where: { clerkId: ctx.userId },
    });
  }),
});
```

### 6. Role-based Access Control

**Custom roles and permissions:**
```typescript
// lib/auth.ts
import { auth, clerkClient } from '@clerk/nextjs';

export async function checkRole(role: string) {
  const { userId } = auth();
  
  if (!userId) {
    return false;
  }

  const user = await clerkClient.users.getUser(userId);
  return user.publicMetadata?.role === role;
}

export async function requireRole(role: string) {
  const hasRole = await checkRole(role);
  
  if (!hasRole) {
    throw new Error('Insufficient permissions');
  }
}

// Usage in API routes
export async function GET() {
  await requireRole('admin');
  // Admin-only logic
}
```

## Examples

### Complete Next.js setup
```bash
# Install and configure
npm install @clerk/nextjs
# Add environment variables
# Create middleware.ts
# Add auth pages
# Set up webhooks
```

### Expo authentication flow
```bash
# Install dependencies
npx expo install @clerk/clerk-expo expo-secure-store
# Configure ClerkProvider
# Set up navigation
# Create auth screens
```

### User management dashboard
```typescript
// Dashboard with user info and org switcher
export function Dashboard() {
  return (
    <div className="p-6">
      <div className="flex justify-between items-center mb-6">
        <h1 className="text-2xl font-bold">Dashboard</h1>
        <OrgSwitcher />
      </div>
      <UserProfile />
    </div>
  );
}
```

## Troubleshooting

- **Middleware not working**: Ensure middleware.ts is in project root
- **Webhooks failing**: Verify webhook secret and endpoint URL
- **Expo auth not persisting**: Check SecureStore token cache implementation
- **tRPC unauthorized errors**: Verify context creation and auth middleware
- **Role checks failing**: Ensure publicMetadata is set correctly in Clerk
- **Redirect loops**: Check public/protected route configuration
