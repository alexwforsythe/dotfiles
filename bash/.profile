WORKSPACE="$HOME/workspace"

### OS X

if [[ "$OSTYPE" == "darwin"* ]]; then
    export PATH="$HOME/bin:$PATH"
fi

### Java
if [[ "$OSTYPE" == "gnu-linux" ]]; then
    export JAVA_HOME=$(readlink -f /usr/bin/javac | sed "s:/bin/javac::")
elif [[ "$OSTYPE" == "darwin"* ]]; then
    export JAVA_HOME=$(/usr/libexec/java_home)
fi

### Python
export PYTHONSTARTUP=$HOME/.pystartup

## virtualenvwrapper
VIRTUALENVWRAPPER="/usr/local/bin/virtualenvwrapper.sh"
if [[ -s "$VIRTUALENVWRAPPER" ]]; then
    export WORKON_HOME=$HOME/.virtualenvs
    PROJECT_HOME=$WORKSPACE
    mkdir -p $PROJECT_HOME
    export PROJECT_HOME
    # source $VIRTUALENVWRAPPER
fi

### Ruby
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

### Android
if [[ "$OSTYPE" == "gnu-linux" ]]; then
    ANDROID_HOME=$HOME/Android/Sdk
elif [[ "$OSTYPE" == "darwin"* ]]; then
    ANDROID_HOME=$HOME/Library/Android/Sdk
fi

if [[ -d "$ANDROID_HOME" ]]; then
    export ANDROID_HOME
    export PATH=$ANDROID_HOME/tools:$PATH
    export PATH=$ANDROID_HOME/platform-tools:$PATH
fi

### Misc
export PATH="/opt/bin:$PATH"

## Heroku
HEROKU="/usr/local/heroku/bin"
if [[ -d "$HEROKU" ]]; then
    export PATH="$HEROKU:$PATH"
fi
