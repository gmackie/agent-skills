# Next.js Web App Developer Agent

Specialized agent for building full-stack web applications with Next.js, Clerk authentication, and Stripe payments.

## Quick Start

```bash
# Load this agent in Kiro CLI
kiro-cli chat --context agents/nextjs-webapp/instructions.md

# Or with skills
kiro-cli chat --context agents/nextjs-webapp/instructions.md --context skills/nextjs/
```

## Capabilities

- Build full-stack Next.js applications with App Router
- Implement authentication with Clerk
- Integrate Stripe for payments and subscriptions
- Set up databases with Prisma ORM
- Create API routes and Server Actions
- Implement webhooks for Stripe events
- Optimize for SEO and performance
- Deploy to Vercel or AWS

## Tech Stack

- **Next.js 14+**: React framework with App Router
- **TypeScript**: Type-safe development
- **Clerk**: Authentication and user management
- **Stripe**: Payment processing and subscriptions
- **Prisma**: Type-safe database ORM
- **Tailwind CSS**: Utility-first styling
- **PostgreSQL**: Recommended database

## Available Skills

| Skill | Description |
|-------|-------------|
| `nextjs/project-init` | Initialize Next.js project with full stack |
| `nextjs/clerk-auth-setup` | Configure Clerk authentication |
| `nextjs/stripe-integration` | Integrate Stripe payments |
| `nextjs/database-setup` | Set up Prisma and database |
| `nextjs/api-routes` | Create API route handlers |
| `nextjs/webhooks` | Implement Stripe webhooks |
| `nextjs/email-integration` | Add email functionality |
| `nextjs/seo-optimization` | Optimize for search engines |
| `nextjs/deployment` | Deploy to production |

## Common Workflows

### Create SaaS App
```
User: "Create a SaaS app with user authentication and subscriptions"
Agent: [Initializes Next.js, sets up Clerk, integrates Stripe, creates database]
```

### Add Payment Flow
```
User: "Add a subscription checkout flow"
Agent: [Creates Stripe products, implements checkout, sets up webhooks]
```

### Deploy to Production
```
User: "Deploy the app to Vercel"
Agent: [Configures environment, sets up database, deploys, tests]
```

## Example Interactions

**Example 1: New SaaS Project**
```
User: I need to build a SaaS platform where users can sign up,
      subscribe to a monthly plan, and access premium features.

Agent: I'll create a complete SaaS application with:
       1. Next.js 14 with App Router and TypeScript
       2. Clerk for authentication (sign up/in, user management)
       3. Stripe for subscription payments
       4. PostgreSQL database with Prisma
       5. Protected routes and middleware
       6. Subscription management dashboard
       
       [Proceeds with full implementation]
```

**Example 2: Payment Integration**
```
User: Add a one-time payment option for premium features

Agent: I'll implement:
       - Stripe Checkout for one-time payments
       - Server Action to create checkout session
       - Webhook to handle successful payments
       - Database to track purchases
       - UI to display purchase status
       
       [Implements payment flow]
```

## Best Practices

The agent follows Next.js and SaaS best practices:

1. **App Router**: Use Server Components by default
2. **Authentication**: Protect routes with Clerk middleware
3. **Payments**: Handle Stripe webhooks for reliability
4. **Database**: Use Prisma for type-safe queries
5. **Security**: Validate environment variables, secure API routes
6. **Performance**: Optimize images, implement caching
7. **SEO**: Add metadata, sitemaps, structured data
8. **Error Handling**: Implement error boundaries and fallbacks

## Project Structure

```
src/
├── app/
│   ├── api/              # API routes
│   │   └── webhooks/     # Webhook handlers
│   ├── dashboard/        # Protected pages
│   ├── sign-in/          # Auth pages
│   └── layout.tsx        # Root layout
├── components/           # React components
├── lib/                  # Utilities
│   ├── db.ts            # Prisma client
│   └── stripe.ts        # Stripe client
├── hooks/               # Custom hooks
└── types/               # TypeScript types
```

## Prerequisites

- Node.js 18 or later
- npm, pnpm, or yarn
- Clerk account (free tier available)
- Stripe account (test mode)
- PostgreSQL database (or other supported DB)

## Environment Variables

Required environment variables:
```env
NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY=
CLERK_SECRET_KEY=
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=
STRIPE_SECRET_KEY=
STRIPE_WEBHOOK_SECRET=
DATABASE_URL=
```

## Tips

1. Use Clerk's middleware for route protection
2. Test Stripe webhooks locally with Stripe CLI
3. Use Server Actions for mutations instead of API routes
4. Implement proper error handling for payments
5. Use Prisma Studio for database management
6. Deploy to Vercel for optimal Next.js performance
7. Set up monitoring and error tracking (Sentry, etc.)
8. Use environment variable validation at build time

## Related Resources

- [Next.js Documentation](https://nextjs.org/docs)
- [Clerk Documentation](https://clerk.com/docs)
- [Stripe Documentation](https://stripe.com/docs)
- [Prisma Documentation](https://www.prisma.io/docs)
- [Vercel Deployment](https://vercel.com/docs)
