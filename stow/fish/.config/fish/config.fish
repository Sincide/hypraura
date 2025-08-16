set -xU EDITOR nvim
set -g fish_prompt_pwd_dir_length 3
function fish_prompt
  set_color cyan
  printf '%s ' (whoami)
  set_color yellow
  printf '%s > ' (prompt_pwd)
  set_color normal
end
