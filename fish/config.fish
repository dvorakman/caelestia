if status is-interactive
    # Starship custom prompt
    starship init fish | source

    # Direnv + Zoxide
    command -v direnv &> /dev/null && direnv hook fish | source
    command -v zoxide &> /dev/null && zoxide init fish --cmd cd | source

    # Better ls
    alias ls='eza --icons --group-directories-first -1'

    # Abbrs
    abbr lg 'lazygit'
    abbr gd 'git diff'
    abbr ga 'git add .'
    abbr gc 'git commit -am'
    abbr gl 'git log'
    abbr gs 'git status'
    abbr gst 'git stash'
    abbr gsp 'git stash pop'
    abbr gp 'git push'
    abbr gpl 'git pull'
    abbr gsw 'git switch'
    abbr gsm 'git switch main'
    abbr gb 'git branch'
    abbr gbd 'git branch -d'
    abbr gco 'git checkout'
    abbr gsh 'git show'

    abbr l 'ls'
    abbr ll 'ls -l'
    abbr la 'ls -a'
    abbr lla 'ls -la'

    # Claude Code
    abbr cc 'claude'
    abbr ccs 'claude --dangerously-skip-permissions'
    abbr ccd 'cd ~ && claude --dangerously-skip-permissions'

    # GitHub CLI
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
    abbr gpc 'git push && gh pr create'
    abbr gpv 'git push && gh pr view --web'

    # Custom colours
    cat ~/.local/state/caelestia/sequences.txt 2> /dev/null

    # For jumping between prompts in foot terminal
    function mark_prompt_start --on-event fish_prompt
        echo -en "\e]133;A\e\\"
    end
end
