{{/*
Standard Kubernetes recommended labels for shopxpress-pro microservices.
Usage in service chart:
  metadata:
    labels: {{- include "lib.labels" . | nindent 4 }}
*/}}
{{- define "lib.labels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | default .Chart.Version | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: shopxpress-pro
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" }}
{{- end -}}

{{/*
Selector labels — subset of full labels, MUST be immutable across releases.
Usage in Deployment.spec.selector.matchLabels and Service.spec.selector.
*/}}
{{- define "lib.selectorLabels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}
