function fish_user_key_bindings
  fish_vi_key_bindings
  bind -M insert -m default jk backward-char force-repaint
  # bind \co accept-autosuggestion
  # bind -k nul accept-autosuggestion
  for mode in insert default visual
    bind -M $mode \co forward-char
  end
  fzf_configure_bindings --directory=\ef --git_log=\el --git_status=\es --history=\eh --process=\ep
  
end
