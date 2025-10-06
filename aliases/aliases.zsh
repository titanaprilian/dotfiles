goto() {
  case "$1" in
    web) cd ~/dev/web ;;
    ml) cd ~/dev/ml ;;
    mobile) cd ~/dev/mobile ;;
    cli) cd ~/dev/cli ;;
    sandbox) cd ~/dev/sandbox ;;
    *) echo "Usage: goto {web|ml|mobile|cli|sandbox}" ;;
  esac
}

