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
Name of the serviceAccount used for creating wes jobs.
If the wes namespace is not defined, or the wes serviceAccount name is not defined, 
then the serviceAccount name {{- include "workflow-management.serviceAccountName" . -}}-wes is used, to avoid a collision in the same namespace
*/}}
{{- define "workflow-management.wesServiceAccountName" -}}
{{- $name := printf "%s" (include "workflow-management.serviceAccountName" . ) -}}
{{- $is_same_namespace := or (not .Values.kubeConfig.wes.namespace) (eq .Release.Namespace .Values.kubeConfig.wes.namespace) -}}
{{- if and $is_same_namespace  (not .Values.kubeConfig.wes.serviceAccount.name) -}}
	{{- printf "%s-%s" $name "wes" -}}
{{- else -}}
	{{- default $name .Values.kubeConfig.wes.serviceAccount.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Name of the rolebinding used for wes jobs. 
If the wes namespace is not defined, or the wes roleBinding name is not defined, 
then the rolebinding name {{- include "workflow-management.roleBindingName" . -}}-wes is used, to avoid a collision in the same namespace
*/}}
{{- define "workflow-management.wesRoleBindingName" -}}
{{- $name := printf "%s" (include "workflow-management.roleBindingName" . ) -}}
{{- $is_same_namespace := or (not .Values.kubeConfig.wes.namespace) (eq .Release.Namespace .Values.kubeConfig.wes.namespace) -}}
{{- if and $is_same_namespace (not .Values.kubeConfig.wes.roleBinding.name) -}}
	{{- printf "%s-%s" $name "wes" -}}
{{- else -}}
	{{- default $name .Values.kubeConfig.wes.roleBinding.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

