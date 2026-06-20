#!/usr/bin/env bash
set -euo pipefail

MARKETPLACE_URL="https://github.com/jurisupport/jurisupport-lawyer-profile-plugin.git"
MARKETPLACE_NAME="jurisupport-lawyer-profile-plugin"
PLUGIN_REF="jurisupport-lawyer-profile@jurisupport-lawyer-profile-plugin"
PLUGIN_NAME="jurisupport-lawyer-profile"
FULL_PLUGIN_BOOTSTRAP_URL="https://raw.githubusercontent.com/jurisupport/jurisupport-plugins/main/bootstrap.sh"

refresh_path() {
  export PATH="$HOME/.local/bin:$HOME/bin:/opt/homebrew/bin:/usr/local/bin:$PATH"
}

echo "JuriSupport lawyer profile plugin installer"

refresh_path
if ! command -v claude >/dev/null 2>&1; then
  echo "Claude Code is not installed. Installing Claude Code first..."
  curl -fsSL https://claude.ai/install.sh | bash
  refresh_path
fi

if ! command -v claude >/dev/null 2>&1; then
  echo "Could not find the claude command after installation." >&2
  echo "Open a new terminal and run this installer again." >&2
  exit 1
fi

claude --version

answer=""
if { exec 3<> /dev/tty; } 2>/dev/null; then
  printf "Install the full JuriSupport plugin set too? It can improve profile analysis. [Y/n] " >&3
  read -r answer <&3 || answer=""
  exec 3>&- 3<&-
else
  echo "No interactive terminal detected. Installing only the lawyer profile plugin."
  answer="n"
fi

case "$answer" in
  [nN]|[nN][oO])
    echo "Installing only Claude Code and the lawyer profile plugin."
    ;;
  *)
    curl -fsSL "$FULL_PLUGIN_BOOTSTRAP_URL" | bash
    ;;
esac

if ! claude plugin marketplace add "$MARKETPLACE_URL"; then
  claude plugin marketplace update "$MARKETPLACE_NAME"
fi

if ! claude plugin install "$PLUGIN_REF"; then
  claude plugin update "$PLUGIN_NAME"
fi

claude plugin list
echo "Done. Open a new Claude Code session to use /jurisupport-lawyer-profile:complete-personal-profile."
