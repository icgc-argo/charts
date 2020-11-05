{{/* vim: set filetype=mustache: */}}

{{/*
Expand the name of the chart.
*/}}
{{- define "workflow-management.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "workflow-management.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "workflow-management.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "workflow-management.labels" -}}
helm.sh/chart: {{ include "workflow-management.chart" . }}
{{ include "workflow-management.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "workflow-management.selectorLabels" -}}
app.kubernetes.io/name: {{ include "workflow-management.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "workflow-management.serviceAccountName" -}}
{{- if .Values.kubeConfig.app.serviceAccount.create -}}
    {{ default (include "workflow-management.fullname" .) .Values.kubeConfig.app.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.kubeConfig.app.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the rolebinding to use
*/}}
{{- define "workflow-management.roleBindingName" -}}
{{- if .Values.kubeConfig.app.roleBinding.create -}}
    {{ default (include "workflow-management.fullname" .) .Values.kubeConfig.app.roleBinding.name }}
{{- else -}}
    {{ default "default" .Values.kubeConfig.app.roleBinding.name }}
{{- end -}}
{{- end -}}

{{/*
Name of the namespace where wes jobs will be created
*/}}
{{- define "workflow-management.wesNamespace" -}}
{{- default .Release.Namespace .Values.kubeConfig.wes.namespace | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Name of the serviceAccount used for creating wes jobs
*/}}
{{- define "workflow-management.wesServiceAccountName" -}}
{{- if not .Values.kubeConfig.wes.namespace -}}
	{{- if or (not .Values.kubeConfig.wes.serviceAccount.name) (eq (include "workflow-management.serviceAccountName" .) .Values.kubeConfig.wes.serviceAccount.name) -}}
		{{- include "workflow-management.serviceAccountName" . -}}-wes
	{{- else -}}
		{{- default (include "workflow-management.serviceAccountName" .) .Values.kubeConfig.wes.serviceAccount.name | trunc 63 | trimSuffix "-" -}}
	{{- end -}}
{{- else -}}
	{{- default (include "workflow-management.serviceAccountName" .) .Values.kubeConfig.wes.serviceAccount.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Name of the rolebinding used for wes jobs
*/}}
{{- define "workflow-management.wesRoleBindingName" -}}
{{- if not .Values.kubeConfig.wes.namespace -}}
	{{- if or (not .Values.kubeConfig.wes.roleBinding.name) (eq (include "workflow-management.roleBindingName" .) .Values.kubeConfig.wes.roleBinding.name) -}}
		{{- include "workflow-management.roleBindingName" . -}}-wes
	{{- else -}}
		{{- default (include "workflow-management.roleBindingName" .) .Values.kubeConfig.wes.roleBinding.name | trunc 63 | trimSuffix "-" -}}
	{{- end -}}
{{- else -}}
	{{- default (include "workflow-management.roleBindingName" .) .Values.kubeConfig.wes.roleBinding.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

