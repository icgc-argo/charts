{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "workflow-graph-node.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "workflow-graph-node.fullname" -}}
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
{{- define "workflow-graph-node.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "workflow-graph-node.labels" -}}
helm.sh/chart: {{ include "workflow-graph-node.chart" . }}
{{ include "workflow-graph-node.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "workflow-graph-node.selectorLabels" -}}
app.kubernetes.io/name: {{ include "workflow-graph-node.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{ include "workflow-graph-node.workflowGraphLabels" . }}
{{- end }}

{{/*
Workflow Graph Labels (added to selector labels)
*/}}
{{- define "workflow-graph-node.workflowGraphLabels" -}}
common.k8s.org.icgc.argo/type: workflow-graph-node
workflow-graph-node.k8s.org.icgc.argo/pipeline-id: {{ .Values.kubeConfig.pipelineId }}
workflow-graph-node.k8s.org.icgc.argo/node-id: {{ .Values.kubeConfig.nodeId }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "workflow-graph-node.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "workflow-graph-node.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
