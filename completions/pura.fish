# fish completion for pura
complete -c pura -f -n '__fish_use_subcommand' -a 'scan clean doctor explain version help' -d 'command'
complete -c pura -f -n '__fish_use_subcommand' -l dry-run -s n -d 'show plan only'
complete -c pura -f -n '__fish_use_subcommand' -l yes -s y -d 'skip safe confirmation'
complete -c pura -f -n '__fish_use_subcommand' -l aggressive -d 'clean more rebuildable cache'
complete -c pura -f -n '__fish_seen_subcommand_from clean' -a 'all caches packages logs temp trash disk'
