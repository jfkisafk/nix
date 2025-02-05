{ pkgs, inputs, ... }: with pkgs; [
  atuin
  awscli2
  bat
  bat-extras.batman
  bat-extras.batgrep
  bat-extras.batwatch
  bat-extras.batdiff
  bat-extras.batpipe
  bat-extras.prettybat
  btop
  carapace
  delta
  direnv
  docker
  dotnet-sdk
  fd
  fish
  fzf
  gcc
  gh
  git
  gitleaks
  grc
  grpcui
  grpcurl
  htop
  minikube
  inputs.home-manager.packages.${pkgs.system}.default
  istioctl
  jq
  jqp
  k9s
  kind
  kubectl-ktop
  kube-prompt
  kubecolor
  kubectl
  kubectx
  kubefetch
  kubelogin
  kubetail
  kubernetes-helm
  helm-dashboard
  lazygit
  lazydocker
  mas
  minikube
  mise
  mongosh
  neofetch
  neovim
  nerdfetch
  nushell
  oh-my-posh
  ollama
  openssh
  postgresql
  protobuf
  protoc-gen-go
  protoc-gen-go-grpc
  redis
  ripgrep
  silver-searcher
  slack-cli
  starship
  stow
  tig
  tmux
  tmuxifier
  tree
  vim
  yazi
  yq
  zoxide
  zsh
]
