-- Tmux-style prefix: Ctrl+B, then one command. Escape cancels.
rex.mode("tmux", { exclusive = true })
rex.bind("ctrl+b", "client.mode.enter", { name = "tmux", once = true })

rex.bind("tmux/h", "pane.focus.left")
rex.bind("tmux/j", "pane.focus.down")
rex.bind("tmux/k", "pane.focus.up")
rex.bind("tmux/l", "pane.focus.right")

rex.bind("tmux/c", "client.tab.new")
rex.bind("tmux/n", "client.tab.next")
rex.bind("tmux/p", "client.tab.previous")
for index = 1, 9 do
  rex.bind("tmux/" .. index, "client.tab.goto", { index = index })
end

-- Keys use their unshifted names: Shift+5 is %, Shift+' is double quote.
rex.bind("tmux/shift+5", "pane.split", { direction = "right" })
rex.bind("tmux/shift+'", "pane.split", { direction = "down" })
rex.bind("tmux/z", "pane.zoom")
rex.bind("tmux/escape", "client.mode.exit")
rex.bind("tmux/ctrl+b", "pane.send_key", { key = "ctrl+b" })
