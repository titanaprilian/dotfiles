goto() {
  case "$1" in
    # Root folders
    projects) cd ~/Projects ;;
    dev) cd ~/Development ;;

    # Personal Projects
    personal) cd ~/Projects/personal ;;
    elysia-auth) cd ~/Projects/personal/elysia-auth-starter ;;
    portfolio) cd ~/Projects/personal/personal-portfolio ;;
    tanstack-auth) cd ~/Projects/personal/tanstack-auth-starter ;;

    # Arcanum Projects
    arcanum) cd ~/Projects/arcanum ;;
    arcanum-lp) cd ~/Projects/arcanum/arcanum-lp ;;
    arcanum-api) cd ~/Projects/arcanum/idcamp-msme-analytics-api ;;
    koinku-be) cd ~/Projects/arcanum/koinku-be ;;
    koinku-fe) cd ~/Projects/arcanum/koinku-fe ;;

    # OBE Developer Team Projects
    obe) cd ~/Projects/obe-developer-team ;;
    dosenplus-be) cd ~/Projects/obe-developer-team/dosenplus-be ;;
    dosenplus-fe) cd ~/Projects/obe-developer-team/dosenplus-fe ;;
    student) cd ~/Projects/obe-developer-team/frontend-student ;;
    siakad-be) cd ~/Projects/obe-developer-team/siakad-backend ;;
    siakad-fe) cd ~/Projects/obe-developer-team/siakad-frontend ;;
    siakad-skripsi) cd ~/Projects/obe-developer-team/siakad-skripsi-frontend ;;
    siakad-trail) cd ~/Projects/obe-developer-team/siakad-trail-frontend ;;
    backup-simak) cd ~/Projects/obe-developer-team/backup-db-simak ;;

    # Development folders
    android) cd ~/Development/android ;;
    databases) cd ~/Development/databases ;;
    flutter) cd ~/Development/flutter ;;

    *) echo "Usage: goto {projects|dev|personal|elysia-auth|portfolio|tanstack-auth|arcanum|arcanum-lp|arcanum-api|koinku-be|koinku-fe|obe|dosenplus-be|dosenplus-fe|student|siakad-be|siakad-fe|siakad-skripsi|siakad-trail|backup-simak|android|databases|flutter}" ;;
  esac
}

# Auto-completion for goto command
_goto() {
  local -a commands
  commands=(
    'projects:Root Projects directory'
    'dev:Root Development directory'
    'personal:Personal projects directory'
    'elysia-auth:Elysia Auth Starter project'
    'portfolio:Personal portfolio project'
    'tanstack-auth:TanStack Auth Starter project'
    'arcanum:Arcanum projects directory'
    'arcanum-lp:Arcanum Landing Page'
    'arcanum-api:Arcanum API'
    'koinku-be:Koinku Backend'
    'koinku-fe:Koinku Frontend'
    'obe:OBE Developer Team directory'
    'dosenplus-be:Dosenplus Backend'
    'dosenplus-fe:Dosenplus Frontend'
    'student:Student Frontend'
    'siakad-be:Siakad Backend'
    'siakad-fe:Siakad Frontend'
    'siakad-skripsi:Siakad Skripsi Frontend'
    'siakad-trail:Siakad Trail Frontend'
    'backup-simak:Backup DB Simak'
    'android:Android SDK directory'
    'databases:Databases compose directory'
    'flutter:Flutter SDK directory'
  )
  _describe 'command' commands
}

if (( $+functions[compdef] )); then
  compdef _goto goto
fi

alias psqlt='psql -U root -d root -h localhost'

alias tree='tree --charset=ascii'

