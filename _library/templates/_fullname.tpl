{{/*
Fully qualified app name truncated at 63 chars (DNS-1123 limit for Service/Pod names).
Pattern: <release-name>-<chart-name>, deduplicated when release-name == chart-name.
Usage:
  metadata:
    name: {{ include "lib.fullname" . }}
*/}}
{{- define "lib.fullname" -}}
{{- $name := .Chart.Name -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
ServiceAccount name. Defaults to fullname; can override via .Values.serviceAccount.name.
*/}}
{{- define "lib.serviceAccountName" -}}
{{- default (include "lib.fullname" .) .Values.serviceAccount.name -}}
{{- end -}}
