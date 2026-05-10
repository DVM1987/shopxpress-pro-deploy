{{/*
Pod-level securityContext — applies to all containers in the pod.
Hardened defaults: nonroot user, no privileged, seccomp RuntimeDefault.
Usage in Deployment.spec.template.spec:
  securityContext: {{- include "lib.podSecurityContext" . | nindent 8 }}
*/}}
{{- define "lib.podSecurityContext" -}}
runAsNonRoot: true
runAsUser: 65532
runAsGroup: 65532
fsGroup: 65532
seccompProfile:
  type: RuntimeDefault
{{- end -}}

{{/*
Container-level securityContext — read-only rootfs, drop all caps, no privilege escalation.
Usage in Deployment.spec.template.spec.containers[].securityContext:
  securityContext: {{- include "lib.containerSecurityContext" . | nindent 12 }}
*/}}
{{- define "lib.containerSecurityContext" -}}
allowPrivilegeEscalation: false
readOnlyRootFilesystem: true
runAsNonRoot: true
runAsUser: 65532
capabilities:
  drop:
    - ALL
{{- end -}}
