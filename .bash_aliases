
if [ -d ~/.aliases ]; then
    for a in $(ls -1 ~/.aliases/*); do
        if [ -f ${a} ]; then
            . ${a}
        fi
    done
fi

