#!/usr/bin/env bash
set -euo pipefail

read -r token refresh_token expires_at < <(cat  ~/.claude/.credentials.json | jq '.claudeAiOauth | [.accessToken, .refreshToken, .expiresAt] | @tsv')


repos=('yuya373/claude-code-emacs')
keys=('CLAUDE_ACCESS_TOKEN' 'CLAUDE_REFRESH_TOKEN' 'CLAUDE_EXPIRES_AT')

for repo in "${repos[@]}"; do
    for key in "${keys[@]}"; do
        gh secret set $key --repo $repo --body $token
    done
done
