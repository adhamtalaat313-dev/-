import { Router } from 'express';
import { PrismaClient } from '@prisma/client';
import { requireAuth } from '../utils/jwt.js';

const prisma = new PrismaClient();
const router = Router();

router.post('/:listingId', requireAuth(), async (req, res) => {
  const { rating, comment } = req.body;
  const review = await prisma.review.create({ data: { rating, comment, authorId: req.user.id, listingId: req.params.listingId } });
  res.json(review);
});

export default router;
