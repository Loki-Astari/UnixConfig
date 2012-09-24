[![endorse](http://api.coderwall.com/lokiastari/endorsecount.png)](http://coderwall.com/lokiastari)

Setup simple UNIX configuration files in source control
I used to keep these files in a zip file on my server. So when I started a new job I just donwloaded the one file and unzipped and I was ready to go. This is just an extension of that but I don't need to keep the files on my server :-)


This assumes you have vim pathagin installed:

    In one line: ( read below for what is on this line)

        cd;git clone git@github.com:Loki-Astari/UnixConfig.git ~/.config;cd .config;git submodule init;git submodule update;./init;cd

    Pathagin install instructions:

        mkdir -p ~/.vim/autoload ~/.vim/bundle; \
        curl -so ~/.vim/autoload/pathogen.vim \
        https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim

    Install with: 

        cd
        git clone git@github.com:Loki-Astari/UnixConfig.git ~/.config
        cd .config
        git submodule init
        git submodule update

    Add symbolic Links

        ln -s ~/.config/vim/vimrc       ~/.vimrc
        ln -s ~/.config/vim/vim         ~/.vim
        ln -s ~/.config/git/gitconfig   ~/.gitconfig
        ln -s ~/.config/shell/profile   ~/.profile
        ln -s ~/.config/shell/tcshrc    ~/.tcshrc
        ln -s ~/.config/bin             ~/bin

