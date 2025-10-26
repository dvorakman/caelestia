# Personal configurations for dvorakman

if status is-interactive
    # Claude Code abbreviations
    abbr cc 'claude'
    abbr ccs 'claude --dangerously-skip-permissions'
    abbr ccd 'cd ~ && claude --dangerously-skip-permissions'

    # GitHub CLI shortcuts
    abbr ghpr 'gh pr create'
    abbr ghpv 'gh pr view'
    abbr ghpc 'gh pr checks'
    abbr ghpm 'gh pr merge'
    abbr ghrv 'gh repo view'
    abbr ghrw 'gh repo view --web'
    abbr ghrc 'gh repo clone'
    abbr ghi 'gh issue'
    abbr ghil 'gh issue list'
    abbr ghic 'gh issue create'
    abbr ghiv 'gh issue view'

    # Combined git + gh workflows
    abbr gpc 'git push && gh pr create'
    abbr gpv 'git push && gh pr view --web'
end
