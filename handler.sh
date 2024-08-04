case "$1" in
  button/lid)
    case "$3" in
      open)
        /usr/local/bin/restart-kmscon.sh
        ;;
    esac
    ;;
esac
