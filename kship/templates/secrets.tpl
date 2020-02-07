{{ if and .Values.createClientSecret (not .Values.existingSecret) -}}
apiVersion: v1
kind: Secret
metadata:
  name: {{ include "kship.fullname" . }}
  labels:
    {{- include "kship.labels" . | nindent 4 }}
type: Opaque
data:
{{- if .Values.secrets }}
  {{- range $key, $value := .Values.secrets }}
  {{ $key }}: {{ randAlphaNum 10 | b64enc | quote }}
  {{- end }}
{{- end }}
  
{{- end }}