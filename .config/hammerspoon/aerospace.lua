require("hs.ipc")

hs.hotkey.bind({"ctrl"}, "`", function()
    local app = hs.application.get("kitty")

    -- hs.execute("aerospace workspace 0", true)
    if app then
        if not app:mainWindow() then
            app:selectMenuItem({"kitty", "New OS window"})
        elseif app:isFrontmost() then
            -- app:hide()
            hs.execute("/opt/homebrew/bin/aerospace workspace-back-and-forth", false)
        else
            app:activate()
        end
    else
        hs.application.launchOrFocus("kitty")
        app = hs.application.get("kitty")
    end

    -- app:mainWindow():moveToUnit '[99,99,0.5,0.5]'
end)
