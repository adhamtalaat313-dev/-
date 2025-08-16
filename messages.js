import { Router } from 'express';
import { PrismaClient } from '@prisma/client';
import { requireAuth } from '../utils/jwt.js';

const prisma = new PrismaClient();
const router = Router();

router.get('/:listingId', requireAuth(), async (req, res) => {
  const messages = await prisma.message.findMany({ where: { listingId: req.params.listingId }, orderBy: { createdAt: 'asc' } });
  res.json(messages);
});

router.post('/:listingId', requireAuth(), async (req, res) => {
  const { content } = req.body;
  const msg = await prisma.message.create({ data: { content, senderId: req.user.id, listingId: req.params.listingId } });
  res.json(msg);
});

export default router;
