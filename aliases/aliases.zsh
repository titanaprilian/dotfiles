goto() {
  case "$1" in
    web) cd ~/dev/web ;;
    web-php) cd ~/dev/web/php ;;
    web-node) cd ~/dev/web/node ;;
    web-frontend) cd ~/dev/web/frontend ;;
    ml) cd ~/dev/ml ;;
    mobile) cd ~/dev/mobile ;;
    cli) cd ~/dev/cli ;;
    sandbox) cd ~/dev/sandbox ;;
    *) echo "Usage: goto {web|ml|mobile|cli|sandbox}" ;;
  esac
}

alias psqlt='psql -U root -d root -h localhost'
