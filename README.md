# RealEstate App (Sell & Rent Homes)

Monorepo includes:
- `server/` Node.js + Express + Prisma (PostgreSQL)
- `mobile/` Flutter client (Android/iOS)
- `admin/` React + Vite admin dashboard

## Features (MVP)
- User auth (JWT), roles: `USER`, `AGENCY`, `ADMIN`
- Create/approve listings (sell/rent), media URLs, map coords
- Advanced search (city, price range, type, bedrooms)
- In-app messages (thread per listing)
- Favorites & reviews
- Payments (mock service + pluggable providers), commission settings
- Admin controls: users, listings, payouts, settings
- Soft delete, audit timestamps

## Quick Start

### 1) Server
```
cd server
cp .env.example .env   # update DATABASE_URL and JWT_SECRET
npm install
npm run prisma:generate
npm run prisma:migrate
npm run dev
```
Default: http://localhost:4000

### 2) Mobile (Flutter)
```
cd mobile
flutter pub get
flutter run
```

### 3) Admin
```
cd admin
npm install
npm run dev
```

## Commission
Change percentage in Admin -> Settings or via `server/.env` default and `Settings` table.

## Notes
- Image upload uses external URLs in MVP. Integrate S3/Cloudinary later.
- Payment is mocked; replace in `server/src/services/payment.js` with Stripe/Tap/Paymob/etc.
