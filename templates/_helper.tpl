{{ define "kafkaURL" }}
{{- if .Values.kafka_broker_service -}}
{{- .Values.kafka_broker_service -}}
{{- else -}}
release-name-kafka-headless.{{- .Release.Namespace -}}.svc.cluster.local:9092
{{- end -}}
{{- end -}}
