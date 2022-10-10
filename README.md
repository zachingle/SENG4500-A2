# SENG4500 Assignment 2 - Battleships

Run with Ruby 3.1.2

## Windows

Go to the [Ruby Installer for Windows](https://rubyinstaller.org/) website and download Ruby+Devkit 3.1.2-1 (x64).

## Linux/MacOS
To install Ruby on a Unix-like system it is recommended to install a version manager like [asdf](https://asdf-vm.com/guide/getting-started.html).

After core installation is done, install the [asdf Ruby plugin](https://github.com/asdf-vm/asdf-ruby).
```sh
asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git
```

When plugin installation is done run:
```sh
asdf install ruby latest
asdf global ruby latest
```

Ruby should now be installed!
```sh
ruby -v
=> ruby 3.1.2p20 (2022-04-12 revision 4491bb740a) [x86_64-linux]
```

## Battleship Client
```sh
ruby client.rb 127.0.0.1 5000
```

Note: If binding to the same broadcast and address port on Windows, automatic detection of the OS might not work and so the #on_windows? method in in the `client.rb` might need to be modified to always return true
