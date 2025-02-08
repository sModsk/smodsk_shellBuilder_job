RegisterNetEvent("smodsk_shellBuilder_job:notification", function(message, duration, success) Notify(message, duration, success) end)
function Notify(message, duration, success)
	if lib then
		lib.notify({
		    description = message,
		    type =  success and 'success' or 'error',
		    duration = duration or 5000,
		    position = 'center-right'
		})
	elseif QBCore then
		QBCore.Functions.Notify(message, success and 'success' or 'error', duration or 5000)
	end
end

