require('dotenv').config();
const Fastify = require('fastify');
const fastify = Fastify({ logger: true });

const PORT = process.env.PORT || 4000;

// Register plugins (placeholders)
fastify.register(require('fastify-jwt'), {
  secret: process.env.JWT_SECRET || 'dev-secret'
});

fastify.register(require('fastify-rate-limit'), {
  max: 100,
  timeWindow: '1 minute'
});

// Health
fastify.get('/health', async (request, reply) => {
  return { status: 'ok', ts: new Date().toISOString() };
});

// Placeholder verify endpoint (to implement HMAC verification later)
fastify.get('/verify/:credentialNumber', async (request, reply) => {
  const { credentialNumber } = request.params;
  // TODO: implement DB lookup and HMAC verification
  return { credentialNumber, valid: false, message: 'Not implemented' };
});

const start = async () => {
  try {
    await fastify.listen({ port: PORT, host: '0.0.0.0' });
    fastify.log.info(`Server listening on ${PORT}`);
  } catch (err) {
    fastify.log.error(err);
    process.exit(1);
  }
};

start();
