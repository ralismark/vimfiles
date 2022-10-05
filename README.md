# My Neovim Configuration

A lot of it is specific to how my machine is set up -- in particular, using Nix to manage plugins -- and there is a lot of legacy bits that have accumulated over the years, including from when I used the original Vim.

If you're interested in how I do things, see:

- [How I Use Vim #1: Core Editor Functionality](https://www.ralismark.xyz/posts/how-i-use-vim-1)
- [How I Use Vim #2: Plugins](https://www.ralismark.xyz/posts/how-i-use-vim-2)

## Regular (Hosted) Installation

For this, clone/symlink the repository to `~/.config/nvim`.
Then run `nix build` to produce `result`, and symlink `~/.config/nvim/result/bin/vim` (which is a wrapped neovim) into a folder in \$PATH.

Neovim will read its configuration from the default location of `~/.config/nvim`, and so the vimrc can be edited and loaded without needing to rebuild.
Changes to the wrapper, as well as changing plugins, will require a rebuild though.

## Freestanding Installation

I was also able to make a build in which bundles the vimrc into the nix build.
This allows you to do fun Nix things, such as copying the closure to another system.

The trick I was most interested in was bundling everything into a single portable binary.
To do this, run

```
nix bundle --bundler github:ralismark/nix-appimage .#freestanding
```

Which will produce `nvim-x86_64.AppImage`.
This produced binary runs completely standalone and can be copied onto other systems without Neovim or even Nix installed and runs with this vimrc.
