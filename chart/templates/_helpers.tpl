{{/*
Expand the name of the chart.
*/}}
{{- define "name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Expand the name of the release.
*/}}
{{- define "release" -}}
{{- default .Release.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "selectorLabels" -}}
app.kubernetes.io/name: {{ include "name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "labels" -}}
helm.sh/chart: {{ include "chart" . }}
{{ include "selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
release: {{ $.Release.Name | quote }}
heritage: {{ $.Release.Service | quote }}
chart: "{{ include "name" . }}"
{{- end }}

{{- define "labels.reverseProxy" -}}
{{ include "labels" . }}
app: "{{ .Release.Name }}-reverse-proxy"
{{- end -}}

{{- define "labels.api" -}}
{{ include "labels" . }}
app: "{{ include "release" . }}-api"
{{- end -}}

{{- define "labels.worker.datasets" -}}
{{ include "labels" . }}
app: "{{ include "release" . }}-worker-datasets"
{{- end -}}

{{- define "labels.worker.splits" -}}
{{ include "labels" . }}
app: "{{ include "release" . }}-worker-splits"
{{- end -}}

{{- define "labels.worker.firstRows" -}}
{{ include "labels" . }}
app: "{{ include "release" . }}-worker-first-rows"
{{- end -}}

{{- define "labels.worker.splitsNext" -}}
{{ include "labels" . }}
app: "{{ include "release" . }}-worker-splits-next"
{{- end -}}

{{- define "labels.admin" -}}
{{ include "labels" . }}
app: "{{ include "release" . }}-admin"
{{- end -}}

{{/*
The assets base URL
*/}}
{{- define "assets.baseUrl" -}}
{{- printf "https://%s/assets" .Values.apiDomain }}
{{- end }}

{{/*
The assets/ subpath in the NFS
- in a subdirectory named as the chart (datasets-server/), and below it,
- in a subdirectory named as the Release, so that Releases will not share the same dir
*/}}
{{- define "assets.subpath" -}}
{{- printf "%s/%s/%s/" .Chart.Name .Release.Name "assets" }}
{{- end }}

{{/*
The cache/ subpath in the NFS
- in a subdirectory named as the chart (datasets-server/), and below it,
- in a subdirectory named as the Release, so that Releases will not share the same dir
*/}}
{{- define "cache.datasets.subpath" -}}
{{- printf "%s/%s/%s/" .Chart.Name .Release.Name "cache-datasets-2" }}
{{- end }}

{{/*
The numba-cache/ subpath in the NFS
- in a subdirectory named as the chart (datasets-server/), and below it,
- in a subdirectory named as the Release, so that Releases will not share the same dir
*/}}
{{- define "cache.numba.subpath" -}}
{{- printf "%s/%s/%s/" .Chart.Name .Release.Name "cache-numba-2" }}
{{- end }}

{{/*
The nginx-cache/ subpath in the NFS
- in a subdirectory named as the chart (datasets-server/), and below it,
- in a subdirectory named as the Release, so that Releases will not share the same dir
*/}}
{{- define "cache.nginx.subpath" -}}
{{- printf "%s/%s/%s/" .Chart.Name .Release.Name "cache-nginx-2" }}
{{- end }}

{{/*
The URL to access the mongodb instance created if mongodb.enable is true
It's named using the Release name
*/}}
{{- define "mongodb.url" -}}
{{- printf "mongodb://%s-mongodb" .Release.Name }}
{{- end }}

{{/*
The URL to access the admin service from another container
See https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/#a-aaaa-records
*/}}
{{- define "admin.url" -}}
{{- printf "http://%s-admin.%s.svc.cluster.local:80" ( include "release" . ) ( .Release.Namespace ) }}
{{- end }}

{{/*
The URL to access the API service from another container
See https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/#a-aaaa-records
*/}}
{{- define "api.url" -}}
{{- printf "http://%s-api.%s.svc.cluster.local:80" ( include "release" . ) ( .Release.Namespace ) }}
{{- end }}