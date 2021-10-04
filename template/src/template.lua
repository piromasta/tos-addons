--dofile("../data/addon_d/template/template.lua");

-- areas defined
local author = 'meldavy'
local addonName = 'template'
_G['ADDONS'] = _G['ADDONS'] or {}
_G['ADDONS'][author] = _G['ADDONS'][author] or {}
_G['ADDONS'][author][addonName] = _G['ADDONS'][author][addonName] or {}

-- get a pointer to the area
local Template = _G['ADDONS'][author][addonName]
local acutil = require('acutil')

Template.SettingsFileLoc = string.format('../addons/%s/settings.json', addonName)

Template.Settings = {
    Position = {
        X = 400,
        Y = 400
    }
};

function TEMPLATE_ON_INIT(addon, frame)
    Template.addon = addon;
    Template.frame = frame;
    -- load settings
    if not Template.Loaded then
        local t, err = acutil.loadJSON(Template.SettingsFileLoc, Template.Settings);
        if err then
        else
            Template.Settings = t;
            Template.Loaded = true;
        end
    end
    -- initialize frame
    TEMPLATE_ON_FRAME_INIT(frame)
end

function TEMPLATE_ON_FRAME_INIT(frame)
    -- enable frame reposition through drag and move
    frame:EnableMove(1);
    frame:EnableHitTest(1);
    frame:SetEventScript(ui.LBUTTONUP, "TEMPLATE_END_DRAG");

    -- draw the frame
    frame:SetSkinName('chat_window');

    -- set default position of frame
    frame:Move(Template.Settings.Position.X, Template.Settings.Position.Y);
    frame:SetOffset(Template.Settings.Position.X, Template.Settings.Position.Y);
    frame:Resize(100, 100);
    frame:ShowWindow(1); -- delete this line for invisible addon
end

function TEMPLATE_END_DRAG(frame, ctrl)
    Template.Settings.Position.X = Template.frame:GetX();
    Template.Settings.Position.Y = Template.frame:GetY();
    TEMPLATE_SAVE_SETTINGS();
end

function TEMPLATE_SAVE_SETTINGS()
    acutil.saveJSON(Template.SettingsFileLoc, Template.Settings);
end