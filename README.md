# shopxpress-pro-deploy

Lab A++ Helm chart manifest repo for ArgoCD GitOps. Source of truth for Kubernetes workloads in the `shopxpress-pro-nonprd-eks` cluster (account A, ap-southeast-1).

## Structure

```
.
├── _library/                       # shared template helpers (type: library, NOT deployed)
│   └── templates/
│       ├── _labels.tpl             # lib.labels, lib.selectorLabels
│       ├── _fullname.tpl           # lib.fullname, lib.serviceAccountName
│       └── _security.tpl           # lib.podSecurityContext, lib.containerSecurityContext
└── services/
    ├── gateway/                    # BFF, Internet-facing (Ingress enabled)
    ├── products/                   # internal API, Postgres-backed (ExternalSecret)
    └── orders/                     # internal API, Postgres-backed (ExternalSecret)
```

Each service contains:

```
services/<svc>/
├── Chart.yaml                      # depends on file://../../_library
├── values.yaml                     # base defaults
├── values-dev.yaml                 # dev override (bot bumps image.tag here)
├── values-stg.yaml                 # stg override
├── values-prd.yaml                 # prd override
└── templates/
    ├── deployment.yaml
    ├── service.yaml
    ├── ingress.yaml                # gateway only (gated by .Values.ingress.enabled)
    └── externalsecret.yaml         # products/orders only (gated by .Values.externalSecret.enabled)
```

## ArgoCD wiring

ApplicationSet `shopxpress-pro-appset` (in `shopxpress-pro` IaC repo, Sub-comp 0.7.7) generates a 3×3 matrix of Applications, one per `(service, env)` pair, each pointing to:

```yaml
source:
  repoURL: https://github.com/DVM1987/shopxpress-pro-deploy.git
  path: services/{{service}}
  helm:
    valueFiles:
      - values.yaml
      - values-{{env}}.yaml
```

## Local render

```bash
cd services/products
helm dependency build
helm template products . -f values.yaml -f values-dev.yaml
```

## Image tag flow

Bot workflow `bump-tag.yml` (in `shopxpress-pro-app` repo, Sub-comp 0.7.8) auto-updates `image.tag` in `values-dev.yaml` after each successful build-push. Stg/prd promotions are manual PRs.

## Related repos

- `DVM1987/shopxpress-pro` — Terraform IaC (cluster, ALB, ECR, ArgoCD)
- `DVM1987/shopxpress-pro-app` — Go service code, Dockerfile, GHA build-push
- `DVM1987/shopxpress-pro-deploy` — this repo (Helm chart manifests)
