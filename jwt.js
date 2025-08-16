import jwt from 'jsonwebtoken';
const JWT_SECRET = process.env.JWT_SECRET || 'devsecret';

export const sign = (payload) => jwt.sign(payload, JWT_SECRET, { expiresIn: '7d' });
export const verify = (token) => jwt.verify(token, JWT_SECRET);

export const requireAuth = (roles = []) => (req, res, next) => {
  const auth = req.headers.authorization || '';
  const token = auth.startsWith('Bearer ') ? auth.slice(7) : null;
  if (!token) return res.status(401).json({ error: 'Unauthorized' });
  try {
    const decoded = verify(token);
    if (roles.length && !roles.includes(decoded.role)) {
      return res.status(403).json({ error: 'Forbidden' });
    }
    req.user = decoded;
    next();
  } catch {
    return res.status(401).json({ error: 'Invalid token' });
  }
};
