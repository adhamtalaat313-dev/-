import 'dotenv/config';
import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import morgan from 'morgan';
import { PrismaClient } from '@prisma/client';
import authRouter from './routes/auth.js';
import listingsRouter from './routes/listings.js';
import adminRouter from './routes/admin.js';
import messagesRouter from './routes/messages.js';
import reviewsRouter from './routes/reviews.js';

const prisma = new PrismaClient();
const app = express();

const allowed = (process.env.ALLOWED_ORIGINS || '').split(',').filter(Boolean);
app.use(cors({ origin: allowed.length ? allowed : true, credentials: true }));
app.use(helmet());
app.use(morgan('dev'));
app.use(express.json({ limit: '5mb' }));

app.get('/', (_, res) => res.json({ ok: true, service: 'realestate-server' }));

app.use('/api/auth', authRouter);
app.use('/api/listings', listingsRouter);
app.use('/api/admin', adminRouter);
app.use('/api/messages', messagesRouter);
app.use('/api/reviews', reviewsRouter);

// 404
app.use((req, res) => res.status(404).json({ error: 'Not found' }));

// error handler
app.use((err, req, res, next) => {
  console.error(err);
  res.status(500).json({ error: 'Server error' });
});

const port = process.env.PORT || 4000;
app.listen(port, () => console.log(`API on http://localhost:${port}`));
