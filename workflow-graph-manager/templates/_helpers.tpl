{{/*
Expand the name of the chart.
*/}}
{{- define "workflow-graph-manager.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "workflow-graph-manager.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "workflow-graph-manager.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "workflow-graph-manager.labels" -}}
helm.sh/chart: {{ include "workflow-graph-manager.chart" . }}
{{ include "workflow-graph-manager.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "workflow-graph-manager.selectorLabels" -}}
app.kubernetes.io/name: {{ include "workflow-graph-manager.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "workflow-graph-manager.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "workflow-graph-manager.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the rolebinding to use
*/}}
{{- define "workflow-graph-manager.roleBindingName" -}}
{{- if .Values.rbac.create -}}
    {{ default (include "workflow-graph-manager.fullname" .) .Values.rbac.name }}
{{- else -}}
    {{ default "default" .Values.rbac.name }}
{{- end -}}
{{- end -}}

