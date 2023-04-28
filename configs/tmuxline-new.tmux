#
# Options
#

set -g status "on"
set -g status-justify "left"

set -g status-left-length "100"
set -g status-left-style "none"

set -g status-right-length "100"
set -g status-right-style "none"

#
# Style
#

# Colors
set @bg-3 "colour238"
set @fg-3 "colour246"
set @bg-2 "colour239"
set @fg-2 "colour251"
set @s-3 "fg=#{@fg-3},bg=#{@bg-3}"

# Messages
set -g message-command-style "fg=#{fg-2},bg=#{@bg-2}"
set -g message-style "fg=#{fg-2},bg=#{@bg-2}"
set -g pane-border-style "fg=#{@bg-2}"
set -g pane-active-border-style "fg=colour2"
set -g status-style "none,bg=#{@bg-3}"

# Global
setw -g window-status-separator "" # none; we're using colors
setw -g window-status-style "none,fg=#{@fg-3},bg=#{@bg-3}"
setw -g window-status-activity-style "none,fg=colour2,bg=#{@bg-3}"

# Separators
set @font-sep "nobold,nounderscore,noitalics"
set @s-sep-3 "fg=#{@bg-3},bg=#{@bg-3}],#{@font-sep}" # c, x, windows
set @s-sep-2 "fg=#{@bg-2},bg=#{@bg-3}],#{@font-sep}" # b, y
set @s-sep-3 "fg=#{@fg-3},bg=#{@bg-2},#{@font-sep}"  # a, z

# Sections
set @s-a "fg=colour236,bg=colour2" # @todo fg
set @s-sep-a "fg=colour2,bg=#{@bg-2},#{@font-sep}"
set @s-b "fg=#{fg-2},bg=#{@bg-2}"
set @s-x "fg=#{fg-3},bg=#{bg-3}"
set @s-y "fg=colour248,bg=#{@bg-2}" # @todo fg
set @s-z "fg=#{@bg-3},bg=#{@fg-3}"

set @s-win "fg=#{bg-3},bg=#{@bg-3}],#{@font-sep}"
set @s-cwin "fg=#{fg-2},bg=#{@bg-2}"
set @s-sep-cwin "fg=#{bg-3},bg=#{@bg-2},#{@font-sep}"

#
# Glyphs
#

set @sep-l "\ue0bc" # left (upper) triangle
set @sep-r "\ue0ba" # right (lower) triangle
set @sep-2 "\u2571" # tall slash
set @dot "\uea71"

#
# Indicators
#

set @stat-mode "#{?client_prefix,#[fg=colour5],#{?pane_in_mode,#[fg=colour3],#{?pane_synchronized,#[fg=colour1],#[fg=colour2]}}} #{@dot}"

set @stat-mem "#{sysstat_mem}#[@s-3] \ufb18"
set @stat-cpu "#{sysstat_cpu}#[@s-3] \ue266"
set @stat-ping "#{?#(ping -o -t 3 google.com; echo $?),#[fg=green],#[fg=red]}#{@dot}"
set @stat-uptime "#(uptime | cut -d ',' -f 1 | cut -d ' ' -f 4-) \uf924"

#
# Format
#

set -g status-left "#[@s-a]#{E:@stat-mode}#[@s-sep-a]#{@sep-l}#[@s-b] #{session_name} #[@s-sep-2]#{@sep-l}#[@s-3]#[@s-sep-3]#{@sep-l}"
setw -g window-status-format "#[@s-win]#{@sep-l}#[@s-3] #{window_index} #{@sep-2} #{window_name} #[@s-sep-3]#{@sep-l}"
setw -g window-status-current-format "#[@s-sep-cwin]#{@sep-l}#[@s-cwin] #{window_index} #{@sep-2} #{window_name}#{window_flags} #[@s-sep-2]#{set-l}"
set -g status-right "#[@s-sep-3]#{sep-r}#[@s-x] #{E:@stat-mem} #{@sep-2} #{E:@stat-cpu} #{@sep-2} #{E:@stat-ping}#[@s-x] \uf6d5 #{@sep-2} #{E:@stat-uptime}#[@s-sep-2]#{sep-r}#[@s-y] %a #{@sep-2} %b %d #[@s-sep-3]#{sep-r}#[@s-z] %R "
