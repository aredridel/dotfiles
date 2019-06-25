# This theme for gitprompt.sh is optimized for the "Solarized Dark" and "Solarized Light" color schemes 
# tweaked for Ubuntu terminal fonts

override_git_prompt_colors() {
  GIT_PROMPT_THEME_NAME="aredridel"
  GIT_PROMPT_STAGED="${Yellow}●"
  GIT_PROMPT_STASHED="${BoldMagenta}⚑ "
  GIT_PROMPT_CLEAN="${Green}✔"
  GIT_PROMPT_END_USER="\n:; "
  GIT_PROMPT_END_ROOT="\n:; "
}

reload_git_prompt_colors "aredridel"
