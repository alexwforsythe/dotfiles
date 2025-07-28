# This tmux statusbar config was created by tmuxline.vim
# on Thu, 17 Nov 2022

#
# Global styles
#

set -g message-style "fg=colour251,bg=colour239,italics"
# set -g message-style "fg=yellow,bg=colour239,italics"
# set -g message-command-style "fg=colour251,bg=colour239"
set -g message-command-style "fg=magenta,none"

set -g pane-active-border-style "fg=green"
set -g pane-border-style "fg=colour239"

#
# Templates
#

set -g @mode-color "#{?client_prefix,magenta,#{?pane_in_mode,yellow,#{?pane_synchronized,colour1,green}}}"

set -g @continuum-backup-age-sec "#{e|-|:%s,#{@continuum-save-last-timestamp}}"
set -g @continuum-backup-stale "#{>:#{E:@continuum-backup-age-sec},#{e|*|:60,#{@continuum-save-interval}}}"
set -g @continuum-restore-status "#{?#{@continuum-save-interval},#{?#{==:#{@continuum-restore},on},#[fg=green]󰙰,},}"

set -g @host-ping "google.com"
set -g @cmd-ping "#(ping -o -t 3 #{@host-ping}; echo $?)"
# @todo doesn't work
# - https://stackoverflow.com/questions/369758/how-to-trim-whitespace-from-a-bash-variable
# - https://web.archive.org/web/20121022051228/http://codesnippets.joyent.com/posts/show/1816
# - https://zshguide.vercel.app/docs/zshguide05#59-filename-generation-and-pattern-matching
# set -g @cmd-uptime "#(uptime | print '%s' \"${var#"${var%%[![:space:]]*}"}\" tr -s '[:blank:],' ',' | cut -d ',' -f 3-4)"
set -g @cmd-uptime "#(uptime | tr -s '[:blank:],' ' ' | cut -d ' ' -f 4-5)"

#
# Status line
#

# Config

# @todo center if really wide, probably need hook
set -g status "on"
# set -g status-justify "centre"
set -g status-justify "left"
set -g status-left-length "100"
set -g status-right-length "100"

set -g status-style "fg=colour246,bg=colour238"
set -g status-left-style ""
set -g status-right-style "fg=colour248,bg=colour239"
set -g window-status-style ""
set -g window-status-current-style "fg=colour251,bg=colour239"
set -g window-status-activity-style "fg=green,bg=colour238"
set -g window-status-separator ""

# Formats
# @todo dedupe styles into defaults and refactors into user options for reuse

set -g status-left "#[fg=colour238,bg=#{E:@mode-color}]  #h #[fg=#{E:@mode-color},bg=colour239]"
set -ga status-left "#[fg=colour248] 󰖲 ╱ #S "
set -ga status-left "#[default]#[fg=colour239]#[default]"

set -g window-status-format "#[fg=colour238]#[default]"
set -ga window-status-format " #I ╱ #W "
set -ga window-status-format "#[fg=colour238]"
set -g window-status-current-format "#[fg=colour238]#[default]"
set -ga window-status-current-format " #[fg=colour248,bold]#I ╱ #W "
set -ga window-status-current-format "#[fg=colour239,bg=colour238]"

set -g status-right "#[fg=colour238,bg=colour238]#[#{status-style}] "
# set -ga status-right "#{client_termname} "
set -ga status-right "╱ "
set -ga status-right "#{?#{@continuum-save-interval},#{?#{@continuum-save-last-timestamp},#[fg=#{?#{E:@continuum-backup-stale},yellow,green}]󰆓,? #[fg=red]󰆓}#[#{status-style}] #{t/p:@continuum-save-last-timestamp},off 󰠘} "
set -ga status-right "#{E:@continuum-restore-status}#[#{status-style}] "
set -ga status-right "#[fg=colour239]#[default] "

set -g @sysstat_cpu_view_tmpl "#[fg=#{cpu.color}]󰄨#[default] #{cpu.pused}"
set -g @sysstat_mem_view_tmpl "#[fg=#{mem.color}]󰍛#[default] #{mem.pused}"
set -ga status-right "#{sysstat_mem}#[default]  #{sysstat_cpu}#[default] "
set -ga status-right "#[fg=green]󰜷#[default] #{E:@cmd-uptime} "
set -ga status-right "#{?#{E:@cmd-ping},#[fg=yellow]󰛵,#[fg=green]󰛳}#[default] "
set -ga status-right "#[fg=colour246]"
set -ga status-right "#[fg=colour238,bg=colour246] 󰃭 %b %d ╱ 󰅐 %R "
