import { Router } from 'express';
import { PrismaClient, ListingStatus } from '@prisma/client';
import { requireAuth } from '../utils/jwt.js';

const prisma = new PrismaClient();
const router = Router();

// Create listing (goes PENDING)
router.post('/', requireAuth(), async (req, res) => {
  const data = req.body;
  const listing = await prisma.listing.create({
    data: {
      title: data.title,
      description: data.description,
      type: data.type,
      price: data.price,
      currency: data.currency || 'USD',
      city: data.city,
      address: data.address,
      latitude: data.latitude,
      longitude: data.longitude,
      bedrooms: data.bedrooms,
      bathrooms: data.bathrooms,
      areaSqm: data.areaSqm,
      mediaUrls: data.mediaUrls || [],
      ownerId: req.user.id
    }
  });
  res.json(listing);
});

// Public search (only APPROVED)
router.get('/', async (req, res) => {
  const { city, type, min, max, bedrooms, q } = req.query;
  const where = {
    status: ListingStatus.APPROVED,
    ...(city ? { city: { contains: String(city), mode: 'insensitive' } } : {}),
    ...(type ? { type: String(type) } : {}),
    ...(bedrooms ? { bedrooms: { gte: Number(bedrooms) } } : {}),
    ...(min || max ? { price: { gte: min ? Number(min) : undefined, lte: max ? Number(max) : undefined } } : {}),
    ...(q ? { OR: [{ title: { contains: String(q), mode: 'insensitive' } }, { description: { contains: String(q), mode: 'insensitive' } }] } : {})
  };
  const items = await prisma.listing.findMany({ where, orderBy: { createdAt: 'desc' } });
  res.json(items);
});

// Get single
router.get('/:id', async (req, res) => {
  const item = await prisma.listing.findUnique({ where: { id: req.params.id }, include: { owner: true, reviews: true } });
  if (!item || item.deletedAt) return res.status(404).json({ error: 'Not found' });
  if (item.status !== 'APPROVED') return res.status(403).json({ error: 'Not approved' });
  res.json(item);
});

// Update own listing
router.put('/:id', requireAuth(), async (req, res) => {
  const target = await prisma.listing.findUnique({ where: { id: req.params.id } });
  if (!target || target.ownerId !== req.user.id) return res.status(403).json({ error: 'Forbidden' });
  const updated = await prisma.listing.update({ where: { id: target.id }, data: { ...req.body, status: 'PENDING' } });
  res.json(updated);
});

// Soft delete
router.delete('/:id', requireAuth(), async (req, res) => {
  const target = await prisma.listing.findUnique({ where: { id: req.params.id } });
  if (!target || target.ownerId !== req.user.id) return res.status(403).json({ error: 'Forbidden' });
  const updated = await prisma.listing.update({ where: { id: target.id }, data: { deletedAt: new Date() } });
  res.json({ ok: true, id: updated.id });
});

export default router;
