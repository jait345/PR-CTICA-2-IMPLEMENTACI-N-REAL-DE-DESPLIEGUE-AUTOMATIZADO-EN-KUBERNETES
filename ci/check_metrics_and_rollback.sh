#!/usr/bin/env bash
set -euo pipefail

PROM_URL="${PROM_URL:-http://prometheus.monitoring.svc:9090}"
NAMESPACE=${NAMESPACE:-production}
DEPLOYMENT=${DEPLOYMENT:-sample-app}
ROLLBACK_THRESHOLD_ERROR_RATE=0.02       # 2%
ROLLBACK_THRESHOLD_P95_MS=500

# Queries (ajusta según tus métricas)
# error rate: ratio of 5m http errors / total
ERROR_RATE_QUERY='sum(rate(http_requests_total{job="sample-app",status=~"5.."}[5m])) / sum(rate(http_requests_total{job="sample-app"}[5m]))'
P95_LATENCY_QUERY='histogram_quantile(0.95, sum(rate(http_request_duration_seconds_bucket{job="sample-app"}[5m])) by (le)) * 1000'

echo "Querying Prometheus at ${PROM_URL}..."

er=$(curl -sG --data-urlencode "query=${ERROR_RATE_QUERY}" "${PROM_URL}/api/v1/query" | jq -r '.data.result[0].value[1] // "0"')
p95=$(curl -sG --data-urlencode "query=${P95_LATENCY_QUERY}" "${PROM_URL}/api/v1/query" | jq -r '.data.result[0].value[1] // "0"')

if [[ -z "$er" ]]; then er=0; fi
if [[ -z "$p95" ]]; then p95=0; fi

echo "Error rate: $er"
echo "p95 latency (ms): $p95"

er_float=$(printf "%f" "$er")
p95_float=$(printf "%f" "$p95")

# Compare thresholds
er_over=$(awk "BEGIN{print ($er_float > $ROLLBACK_THRESHOLD_ERROR_RATE)}")
p95_over=$(awk "BEGIN{print ($p95_float > $ROLLBACK_THRESHOLD_P95_MS)}")

if [[ "$er_over" -eq 1 ]] || [[ "$p95_over" -eq 1 ]]; then
  echo "Threshold breached. Triggering rollback..."
  kubectl -n ${NAMESPACE} rollout undo deployment/${DEPLOYMENT}
  kubectl -n ${NAMESPACE} rollout status deployment/${DEPLOYMENT} --timeout=120s
  exit 0
else
  echo "Metrics OK. No action."
fi
