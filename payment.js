// Mock payment service. Replace with Stripe/other.
export async function createCheckoutSession({ amount, currency = 'USD', metadata = {} }) {
  // Simulate a payment session
  return { id: 'sess_' + Math.random().toString(36).slice(2), amount, currency, url: 'https://example.com/checkout' };
}

export async function verifyWebhook(payload) {
  // Always accept in mock
  return { ok: true, payload };
}
