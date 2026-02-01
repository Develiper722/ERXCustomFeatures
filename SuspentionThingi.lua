-- [[ ERX Custom Suspension Feature ]] --

local stanceAmount = 2

-- Replace 'Tab' with the specific variable your ERX file uses (e.g., MainTab, VehicleTab)
local Section = Tab:Section({ Title = "Vehicle Stance" })

Section:Slider({
    Title = "Front Height",
    Desc = "Adjust FL/FR suspension height",
    Min = 0,
    Max = 10,
    Default = 2,
    Callback = function(value)
        stanceAmount = value
    end
})

Section:Button({
    Title = "Apply Stance",
    Desc = "Update suspension for current vehicle",
    Callback = function()
        xpcall(function()
            local char = game.Players.LocalPlayer.Character
            local seat = char and char:FindFirstChild("Humanoid") and char.Humanoid.SeatPart
            
            if not seat then
                WindUI:Notify({ Title = "Error", Content = "You must be in a vehicle!", Type = "Error" })
                return
            end

            -- ERX vehicles usually have a 'Wheels' folder in the parent of the seat
            local carModel = seat.Parent
            local wheels = carModel:FindFirstChild("Wheels")

            if wheels then
                for _, wheel in ipairs(wheels:GetChildren()) do
                    if wheel.Name == "FL" or wheel.Name == "FR" then
                        -- Your original logic integrated
                        local sa = wheel:FindFirstChild("#SA")
                        local sb = wheel:FindFirstChild("#SB")
                        
                        if sa and sb then
                            sa.Attach_SA.CFrame = CFrame.new(0, -stanceAmount, 1)
                            sb.Attach_SB.CFrame = CFrame.new(0, stanceAmount, -1)
                            sb.Stabilizer.D = 1000
                            wheel.Spring.MaxLength = stanceAmount * 20
                            wheel.Stabilizer.D = 1000
                        end
                    end
                end
                WindUI:Notify({ Title = "Success", Content = "Front stance applied!", Type = "Success" })
            else
                WindUI:Notify({ Title = "Error", Content = "Wheels folder not found.", Type = "Error" })
            end
        end, function(err)
            warn("ERX Custom Script Error: " .. err)
        end)
    end
})
