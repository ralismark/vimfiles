setlocal commentstring=#\ %s
let b:undo_ftplugin = get(b:, "undo_ftplugin", "") .. "\nsetl commentstring<"
