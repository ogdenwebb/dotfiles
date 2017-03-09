# ~/ files

dothome_path=~/.dotfiles/home/*
dotconf_path=~/.dotfiles/config/*
dotemacs_path=~/.dotfiles/emacs.d/

# $HOME files
for file in $dothome_path; do
    if [ ! -L $HOME/.$(basename $file) ]; then
        ln -s $file $HOME/.$(basename $file)
        echo "Created symbolic link to $file"
    fi
done

# $HOME/.config files
for file in $dotconf_path; do
    if [ ! -L $HOME/.config/$(basename $file) ]; then
        ln -s $file $HOME/.config/$(basename $file)
        echo "Created symbolic link to $file"
    fi
done

# Emacs config files
if [ ! -d $HOME/.emacs.d ]; then
    mkdir $HOME/.emacs.d

    ln -s $dotemacs_path/init.el $HOME/.emacs.d/init.el

    # Copy emacs configuration files
    ln -s $dotemacs_path/env $HOME/.emacs.d/
fi
