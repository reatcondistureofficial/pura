# bash completion for pura
_pura_complete() {
    local cur prev commands targets
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    commands="scan clean doctor explain version help"
    targets="all caches cache packages package logs log temp tmp trash disk"
    case "$prev" in
        pura) COMPREPLY=( $(compgen -W "$commands --dry-run --yes --aggressive --help --version" -- "$cur") ) ;;
        clean) COMPREPLY=( $(compgen -W "$targets" -- "$cur") ) ;;
        *) COMPREPLY=() ;;
    esac
}
complete -F _pura_complete pura
