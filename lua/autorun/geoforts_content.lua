
if SERVER then
	AddCSLuaFile()
	return
end

timer.Simple(0.01, function()
	if table.HasValue(list.GetTable(), "OverrideMaterials") then
		geoforts_override_materials = {
			"models/buildingblocks/metal_logo_1_0",
			"models/buildingblocks/metal_logo_1_1",
			"models/buildingblocks/metal_logo_1_2",
			"models/buildingblocks/metal_logo_1_3",
			"models/buildingblocks/metal_logo_1_4",
		}

		for _, mat in ipairs(geoforts_override_materials) do
			list.Add("OverrideMaterials", mat)
		end

		print("GeoForts - content for sandbox use - materials: Added " .. #geoforts_override_materials .. " materials to Material tool.")
	end
end)

geoforts_spawnlist_props = {
	"models/buildingblocks/3d_1_1.mdl",
	"models/buildingblocks/3d_1_2.mdl",
	"models/buildingblocks/2d_1_2.mdl",
	"models/buildingblocks/2d_2_3.mdl",
	"models/buildingblocks/2d_1_8.mdl",
	"models/buildingblocks/blockspawn_1.mdl",
	"models/buildingblocks/playerspawn_1.mdl",
}

geoforts_spawnlist_teams = {
	{ skin = nil, label = "Neutral" },
	{ skin = 1,   label = "Team Blue" },
	{ skin = 2,   label = "Team Yellow" },
	{ skin = 3,   label = "Team Green" },
	{ skin = 4,   label = "Team Red" },
}

hook.Add("PopulatePropMenu", "GeoFortsPopulatePropMenu", function()	
	local contents = {}

	function header(text)
		table.insert(contents, { type = "header", text = text })
	end
	
	function prop(model, skin)
		table.insert(contents, { type = "model", model = model, skin = skin })
	end
	
	total_props_added = 0
	for _, team_definition in pairs(geoforts_spawnlist_teams) do
		header(team_definition.label)
		for _, model in pairs(geoforts_spawnlist_props) do
			prop(model, team_definition.skin)
			total_props_added = total_props_added + 1
		end
	end

	spawnmenu.AddPropCategory("GeoFortsContent", "GeoForts Reloaded", contents, "icon16/geoforts.png")

	print("GeoForts - content for sandbox use - prop menu: Added "
		..total_props_added.." prop entries ("
		..#geoforts_spawnlist_props.." prop models, "
		..#geoforts_spawnlist_teams.." skins each) to GeoForts prop category."
	)
end)
