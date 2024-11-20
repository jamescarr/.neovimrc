# A handy alias to automatically load up nvim within a poetry context if it exists.
function nvim_with_poetry_check() {
    if [ -f ./pyproject.toml ]; then
        echo "Using pyproject.toml in $(pwd)"
        poetry run -- nvim "$@"
    elif [ -f ./backend/pyproject.toml ]; then
        echo "Using pyproject.toml in $(pwd)/backend"
        poetry -C ./backend run -- nvim "$@"
    else
        command nvim "$@"
    fi
}

alias nvim="nvim_with_poetry_check"
