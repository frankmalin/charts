{{/* vim: set filetype=mustache: */}}

{{/*
Create the default zen base chart annotations
*/}}
{{- define "zenhelper.annotations" }}
productName: IBM Cloud Pak for Data
productID: ICP4D-IBMCloudPrivateForData_1210_perpetual_00000
productVersion: 1.2.1.0
{{- end }}


{{- define "zenhelper.labels" }}
  {{- $params := . }}
  {{- $top := first $params }}
  {{- $compName := (include "sch.utils.getItem" (list $params 1 "")) }}
app: {{ include "sch.names.appName" (list $top)  | quote }}
chart: {{ $top.Chart.Name | quote }}
heritage: {{ $top.Release.Service | quote }}
release: {{ $top.Release.Name | quote }}
icpdsupport/addOnId: "databases"
icpdsupport/app: "framework"
  {{- if $compName }}
component: {{ $compName | quote }}
  {{- end }}
  {{- if (gt (len $params) 2) }}
    {{- $moreLabels := (index $params 2) }}
    {{- range $k, $v := $moreLabels }}
{{ $k }}: {{ $v | quote }}
    {{- end }}
  {{- end }}
{{- end }}

{{- define "zenhelper.podAntiAffinity" }}
  {{- $params := . }}
  {{- $top := first $params }}
  {{- $compName := (include "sch.utils.getItem" (list $params 1 "")) }}
podAntiAffinity:
  preferredDuringSchedulingIgnoredDuringExecution:
  - weight: 100
    podAffinityTerm:
      labelSelector:
        matchExpressions:
        - key: component
          operator: In
          values:
          - {{$compName}}
      topologyKey: kubernetes.io/hostname
{{- end }}

{{- define "zenhelper.nodeArchAffinity" }}
nodeAffinity:
  requiredDuringSchedulingIgnoredDuringExecution:
    nodeSelectorTerms:
    - matchExpressions:
      - key: beta.kubernetes.io/arch
        operator: In
        values:
          - {{ .Values.global.architecture }}
{{- end }}
{{- define "zenhelper.user-home-pvc" }}
- name: user-home-mount
  persistentVolumeClaim:
  {{- if .Values.global.userHomePVC.persistence.existingClaimName }}
    claimName: {{ .Values.global.userHomePVC.persistence.existingClaimName }}
  {{- else }}
    claimName: "user-home-pvc"
  {{- end }}
{{- end }}


{{- define "0025.annotations" }}
  {{- $params := . }}
  {{- $compName := (include "sch.utils.getItem" (list $params 1 "")) }}
  {{- $cloudpakInstanceId := (include "sch.utils.getItem" (list $params 2 "")) }}
  {{- if $compName }}
    cloudpakName: "IBM Cloud Pak for Data"
    cloudpakId: "eb9998dcc5d24e3eb5b6fb488f750fe2"
    productName: "IBM Cloud Pak for Data Common Database Services"
    productVersion: "3.5.0"
    cloudpakInstanceId: "{{ $cloudpakInstanceId }}"
    productID: "eb9998dcc5d24e3eb5b6fb488f750fe2"
    productChargedContainers: "All"
    productMetric: "VIRTUAL_PROCESSOR_CORE"
  {{- end }}
{{- end }}

{{- define "zenhelper.cmlabels" }}
icpdata_addon: "true"
icpdata_addon_version: "3.5.0"
{{- end }}
