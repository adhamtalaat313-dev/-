import { Router } from 'express';
import { PrismaClient } from '@prisma/client';
import { requireAuth } from '../utils/jwt.js';

const prisma = new PrismaClient();
const router = Router();

router.use(requireAuth(['ADMIN']));

// Approve/Reject listing
router.post('/listings/:id/status', async (req, res) => {
  const { status } = req.body; // APPROVED | REJECTED
  const updated = await prisma.listing.update({ where: { id: req.params.id }, data: { status } });
  res.json(updated);
});

// Users
router.get('/users', async (req, res) => {
  const users = await prisma.user.findMany({ orderBy: { createdAt: 'desc' } });
  res.json(users);
});

router.post('/users/:id/ban', async (req, res) => {
  const updated = await prisma.user.update({ where: { id: req.params.id }, data: { banned: true } });
  res.json(updated);
});

// Settings
router.get('/settings', async (req, res) => {
  let s = await prisma.settings.findFirst();
  if (!s) s = await prisma.settings.create({ data: {} });
  res.json(s);
});

router.put('/settings', async (req, res) => {
  let s = await prisma.settings.findFirst();
  if (!s) s = await prisma.settings.create({ data: {} });
  const updated = await prisma.settings.update({ where: { id: s.id }, data: req.body });
  res.json(updated);
});

export default router;
