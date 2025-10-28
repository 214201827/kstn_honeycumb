#!/usr/bin/env node
'use strict'

// Simple worker scaffold: processes ImportJob records and runs the migrate script
const { exec } = require('child_process')
const path = require('path')

async function main() {
  console.log('Import worker starting (scaffold)')

  // NOTE: This scaffold expects Prisma client usage to query ImportJob records
  // For now we'll run the migrate_usuarios script in dry-run as an example
  const script = path.join(__dirname, '..', 'scripts', '..', 'scripts', 'migrate_usuarios.js')
  // The path above is intentionally conservative; prefer executing via npm script or require the module.

  console.log('Running migrate_usuarios in dry-run (example)')
  const cmd = `node scripts/migrate_usuarios.js --dry-run`
  const p = exec(cmd, { cwd: path.join(__dirname, '..') }, (err, stdout, stderr) => {
    if (err) {
      console.error('migrate_usuarios failed:', err)
      return
    }
    console.log('migrate_usuarios output:\n', stdout)
    if (stderr) console.error('stderr:\n', stderr)
  })

  p.on('exit', (code) => {
    console.log('Worker finished with code', code)
    process.exit(code)
  })
}

main().catch((err) => {
  console.error(err)
  process.exit(1)
})
