while read -r plugin; do
  plugin_name=$(printf "%s" "$plugin" | awk -F '/' '{print $2}')
  echo "_------------------------------"
  echo "Installing $plugin ..."
  echo "https://github.com/$plugin.git into $HOME/.vim/bundle/$plugin_name"
  echo "_------------------------------"
  git clone https://github.com/"$plugin".git $HOME/.vim/bundle/"$plugin_name"
done < "/tmp/vim-requirements.txt"
