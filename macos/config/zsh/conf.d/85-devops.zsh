# 85-devops.zsh - Docker, Kubernetes, Terraform, and cloud daily-driver helpers.

# ============================== Docker =======================================
alias d='docker'
alias dc='docker compose'
alias dps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias dpsa='docker ps -a --format "table {{.Names}}\t{{.Status}}\t{{.Image}}"'
alias dimg='docker images'
alias dexec='docker exec -it'
alias dlogs='docker logs -f --tail=200'

# dsh: shell into a running container (fuzzy-picked), tries bash then sh.
dsh() {
  local c
  c=$(docker ps --format '{{.Names}}' | fzf) || return
  docker exec -it "$c" sh -c 'command -v bash >/dev/null && exec bash || exec sh'
}

# dclean: prune dangling images/containers/networks (asks Docker to confirm).
dclean() { docker system prune -f; }
# dcleanall: DESTRUCTIVE — remove all unused images + volumes. Confirm first.
dcleanall() {
  read -q "REPLY?This removes ALL unused images AND volumes. Continue? [y/N] " || return
  echo; docker system prune -a --volumes -f
}

# ============================== Kubernetes ===================================
alias k='kubectl'
alias kg='kubectl get'
alias kgp='kubectl get pods'
alias kgpa='kubectl get pods -A'
alias kgs='kubectl get svc'
alias kgd='kubectl get deploy'
alias kgn='kubectl get nodes -o wide'
alias kd='kubectl describe'
alias kaf='kubectl apply -f'
alias kdel='kubectl delete'
alias kl='kubectl logs -f --tail=200'
alias kex='kubectl exec -it'
alias kaf='kubectl apply -f'
alias kctx='kubectx'       # switch cluster context
alias kns='kubens'         # switch namespace

# Autocomplete for the `k` alias too.
if command -v kubectl >/dev/null 2>&1; then
  source <(kubectl completion zsh) 2>/dev/null
  compdef k=kubectl 2>/dev/null
fi

# kpick: fuzzy-select a context AND namespace in one flow.
kpick() {
  local ctx ns
  ctx=$(kubectl config get-contexts -o name | fzf --prompt='context> ') || return
  kubectl config use-context "$ctx"
  ns=$(kubectl get ns -o name 2>/dev/null | sed 's|namespace/||' | fzf --prompt='namespace> ') || return
  kubens "$ns"
}

# klf: multi-pod log tailing with stern (fuzzy pod/label selector).
klf() {
  command -v stern >/dev/null 2>&1 || { print -u2 "stern not installed"; return 1; }
  stern "${1:-.}" --tail 100
}

# kshell: exec into a pod (fuzzy-picked) in the current namespace.
kshell() {
  local pod
  pod=$(kubectl get pods -o name | sed 's|pod/||' | fzf) || return
  kubectl exec -it "$pod" -- sh -c 'command -v bash >/dev/null && exec bash || exec sh'
}

# ============================== Terraform ====================================
alias tf='terraform'
alias tfi='terraform init'
alias tfp='terraform plan'
alias tfa='terraform apply'
alias tfd='terraform destroy'   # destructive: no shorter alias on purpose
alias tff='terraform fmt -recursive'
alias tfv='terraform validate'
alias tfw='terraform workspace'

# ============================== Cloud ========================================
# gcloud config switching (you already use gcloud).
alias gcp='gcloud config configurations'
gcpx() {   # fuzzy-switch gcloud configuration
  local cfg
  cfg=$(gcloud config configurations list --format='value(name)' | fzf) || return
  gcloud config configurations activate "$cfg"
}

# AWS profile switch (you use aws-okta@1-mist).
awsx() {
  local p
  p=$(sed -n 's/^\[profile \(.*\)\]$/\1/p' "${AWS_CONFIG_FILE:-$HOME/.aws/config}" 2>/dev/null | fzf) || return
  export AWS_PROFILE="$p"
  print "AWS_PROFILE=$AWS_PROFILE"
}
