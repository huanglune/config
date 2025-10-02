# install ohmyzsh
git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh && cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc

# install powerlevel10k theme
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k && sed -i 's#ZSH_THEME=".*"#ZSH_THEME="powerlevel10k/powerlevel10k"#' ~/.zshrc


# Change default shell to zsh
if command -v sudo >/dev/null 2>&1; then
  sudo chsh -s $(which zsh) huangliang
else
  echo "Warning: sudo is not available, cannot change default shell"
  echo "Please run manually: chsh -s $(which zsh)"
fi


# config plugin
sed -i 's/plugins=(.*)/plugins=(git jsontools z sudo zsh-autosuggestions zsh-syntax-highlighting you-should-use)/' ~/.zshrc
echo -e "# 使用'^/'替换accept\nbindkey '^_' autosuggest-accept\nexport ZSH_AUTOSUGGEST_STRATEGY=(history completion)\nexport YSU_MESSAGE_POSITION='after'" >> ~/.zshrc
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone --depth=1 https://github.com/MichaelAquilina/zsh-you-should-use.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/you-should-use
