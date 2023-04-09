

/*---------------------------------------------------------
   Returns the right shoot start position 
    for a tracer - based on 'data'.
---------------------------------------------------------*/
function EFFECT:GetTracerShootPos( Position, Ent, Attachment )

	if (!Ent:IsValid()) then return Position end
	if (!Ent:IsWeapon()) then return Position end

	// Shoot from the viewmodel
	if ( Ent:IsCarriedByLocalPlayer() && GetViewEntity() == LocalPlayer() ) then
	
		local ViewModel = LocalPlayer():GetViewModel()
		
		if ( ViewModel:IsValid() ) then
			
			local att = ViewModel:GetAttachment( Attachment )
			Position = att.Pos
			
		end
	
	// Shoot from the world model
	else
	
		local att = Ent:GetAttachment( Attachment )
		Position = att.Pos
	
	end

	return Position

end
