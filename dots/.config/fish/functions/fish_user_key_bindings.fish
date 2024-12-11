function fish_user_key_bindings
  if type -q fzf
      fzf --fish | source
      fzf_key_bindings
  else
      echo "fzf not found. Please install fzf to enable fuzzy key bindings."
  end
end
