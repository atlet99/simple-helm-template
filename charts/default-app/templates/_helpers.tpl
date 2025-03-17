{{/*
Expand the name of the chart.
*/}}
{{- define "default-app.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "default-app.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- printf "%s" .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Creating a namespace for the specified chart.
*/}}
{{- define "default-app.namespace" -}}
{{ .Values.namespaceOverride | default .Release.Namespace }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "default-app.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels for resources.
*/}}
{{- define "default-app.labels" -}}
app.kubernetes.io/name: {{ include "default-app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name | default "unknown-instance" }}
app.kubernetes.io/version: {{ .Values.appVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service | default "Helm" }}
{{- end }}

{{/*
Common annotations for resources.
*/}}
{{- define "default-app.annotations" -}}
app.kubernetes.io/release-date: {{ now | htmlDate }}
app.kubernetes.io/release-name: {{ .Release.Name | quote }}
{{- end }}

{{/*
Selector labels for a deployment, service, or ingress
*/}}
{{- define "default-app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "default-app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name | default "unknown-instance" }}
app.kubernetes.io/version: {{ .Values.appVersion | quote }}
{{- end }}

{{/*
Create the name of the service account to use with a suffix
*/}}
{{- define "default-app.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- printf "%s-sa" (default (include "default-app.fullname" .) .Values.serviceAccount.name) }}
{{- else }}
{{- default "default-sa" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Check if the CRD for External Secrets Operator is installed (only when not in --dry-run mode)
*/}}
{{- define "external-secrets.checkCRD" -}}
{{- if and .Values.externalSecrets.enabled (not .Release.IsDryRun) -}}
  {{- if not (lookup "apiextensions.k8s.io/v1" "CustomResourceDefinition" "" "externalsecrets.external-secrets.io") }}
    {{- fail "❌ ExternalSecrets CRD not found! Install External Secrets Operator before deploying. Run: helm install external-secrets external-secrets/external-secrets --namespace external-secrets --create-namespace" }}
  {{- else if not (lookup "apiextensions.k8s.io/v1" "CustomResourceDefinition" "" "secretstores.external-secrets.io") }}
    {{- fail "❌ SecretStore CRD not found! Ensure External Secrets Operator is properly installed." }}
  {{- else if not (lookup "apiextensions.k8s.io/v1" "CustomResourceDefinition" "" "clustersecretstores.external-secrets.io") }}
    {{- fail "❌ ClusterSecretStore CRD not found! Ensure External Secrets Operator is properly installed." }}
  {{- end }}
{{- end }}
{{- end }}
