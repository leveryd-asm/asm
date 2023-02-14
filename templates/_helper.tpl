{{ define "kafkaURL" }}
{{- if .Values.kafka_broker_service -}}
{{- .Values.kafka_broker_service -}}
{{- else -}}
release-name-kafka-headless.{{- .Release.Namespace -}}.svc.cluster.local:9092
{{- end -}}
{{- end -}}

{{ define "interactsh_server" }}
{{- if .Values.interactsh_server -}}
-iserver '{{ .Values.interactsh_server }}'
{{- end -}}
{{- end -}}
