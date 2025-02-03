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
Common labels
*/}}
{{- define "default-app.labels" -}}
helm.sh/chart: {{ include "default-app.chart" . | default "unknown-chart" }}
{{ include "default-app.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Values.appVersion | default .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service | default "Helm" }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "default-app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "default-app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name | default "unknown-instance" }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "default-app.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "default-app.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}