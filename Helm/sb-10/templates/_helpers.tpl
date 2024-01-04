{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "monitoring.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}


{{/*
Expand the name of the chart.
*/}}
{{- define "monitoring.name" -}}
{{- default .Chart.Name .Values.global.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}


{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "monitoring.fullname" -}}
{{- if .Values.global.fullnameOverride }}
{{- .Values.global.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.global.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}


{{/*
Define a namespace
*/}}
{{- define "monitoring.namespace" -}}
{{- if .Values.namespace.enabled -}}
{{- default (printf "%s-%s" (include "monitoring.fullname" .) "monitoring") .Values.namespace.name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- .Release.Namespace | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}


{{/*
Create the name of the service account to use
*/}}
{{- define "monitoring.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (printf "%s-%s" (include "monitoring.fullname" .) "sa") .Values.serviceAccount.name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}


{{/*
Create the name of the statefullSet to use
*/}}
{{- define "monitoring.statefullSetName" -}}
{{- default (printf "%s-%s" (include "monitoring.fullname" .) "ss") .Values.statefullSet.name | trunc 63 | trimSuffix "-" }}
{{- end }}


{{/*
Create the name of the statefullSet Service name to use
*/}}
{{- define "monitoring.statefullSetServiceName" -}}
{{- default (printf "%s-%s" (include "monitoring.statefullSetName" .) "srv") .Values.statefullSet.serviceName | trunc 63 | trimSuffix "-" }}
{{- end }}


{{/*
Common labels
*/}}
{{- define "monitoring.labels" -}}
helm.sh/chart: {{ include "monitoring.chart" . }}
{{ include "monitoring.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}


{{/*
Selector labels
*/}}
{{- define "monitoring.selectorLabels" -}}
app: {{ include "monitoring.fullname" . }}
instance: {{ .Release.Name }}
{{- end }}

