{{/*
@AI_SPACE
@purpose : Logique d'auto-linking et de génération de noms.
@logic   : Itère sur les 'links' d'un composant et génère des variables d'env HOST/PORT.
*/}}

{{- define "universal.fullname" -}}
{{- printf "%s-%s" .Release.Name .Values.project | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Injecte les variables d'environnement basées sur les liens
Exemple : si link = [db], injecte DB_HOST={{release}}-db
*/}}
{{- define "universal.envLinks" -}}
{{- $root := .root -}}
{{- range .links -}}
{{- $linkName := . -}}
{{- $linkConfig := index $root.Values.components $linkName -}}
- name: {{ $linkName | upper | replace "-" "_" }}_HOST
  value: {{ $linkName | quote }}
{{- if eq $linkConfig.type "database" }}
- name: {{ $linkName | upper | replace "-" "_" }}_PORT
  value: "5432"
{{- else if eq $linkConfig.type "cache" }}
- name: {{ $linkName | upper | replace "-" "_" }}_PORT
  value: "6379"
{{- else }}
- name: {{ $linkName | upper | replace "-" "_" }}_PORT
  value: "80"
{{- end }}
{{- end }}
{{- end }}
