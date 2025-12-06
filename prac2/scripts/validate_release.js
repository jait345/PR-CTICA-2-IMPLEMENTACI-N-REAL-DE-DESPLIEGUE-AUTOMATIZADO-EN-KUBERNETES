const https = require('https')
const http = require('http')

function get(url) {
  return new Promise((resolve) => {
    const c = url.startsWith('https') ? https : http
    const start = Date.now()
    const req = c.get(url, (res) => {
      const chunks = []
      res.on('data', (d) => chunks.push(d))
      res.on('end', () => {
        const latency = Date.now() - start
        resolve({ ok: res.statusCode >= 200 && res.statusCode < 300, latency })
      })
    })
    req.on('error', () => resolve({ ok: false, latency: Date.now() - start }))
  })
}

async function run() {
  const base = process.env.RELEASE_URL
  const samples = parseInt(process.env.SAMPLES || '20', 10)
  const results = []
  for (let i = 0; i < samples; i++) {
    const r = await get(`${base}/api/products`)
    results.push(r)
  }
  const errors = results.filter((r) => !r.ok).length
  const errorRate = (errors / samples) * 100
  const sorted = results.map((r) => r.latency).sort((a, b) => a - b)
  const p95 = sorted[Math.floor(sorted.length * 0.95) - 1] || 0
  const pass = errorRate <= 2 && p95 <= 500
  console.log(`errorRate=${errorRate.toFixed(2)} p95=${p95}`)
  if (!pass) {
    process.exit(1)
  }
}

run()
