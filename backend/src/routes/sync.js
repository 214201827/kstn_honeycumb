'use strict'

// Sync routes (import jobs, webhooks)
module.exports = async function (fastify, opts) {
  const { prisma } = fastify

  // Trigger a user import job (dryRun=true to only simulate)
  fastify.post('/admin/sync/import-users', async function (request, reply) {
    const { dryRun } = request.query || {}
    const job = await prisma.importJob.create({
      data: {
        status: dryRun ? 'PENDING_DRYRUN' : 'PENDING',
        details: { source: 'alumnos', dryRun: !!dryRun },
      },
    })

    // In a real deployment we'd enqueue this to a queue (BullMQ, RabbitMQ)
    return reply.code(202).send({ jobId: job.id, status: job.status })
  })
}
