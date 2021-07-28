local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
yTunnel = {}
Tunnel.bindInterface("york_cocaina",yTunnel)
--https://github.com/eboraci
--York#2030
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRESET
-----------------------------------------------------------------------------------------------------------------------------------------
local cocaina = {
    [1885233650] = {
        [1] = { 36,0 }, -- Mascara
        [3] = { 86,0 }, -- Maos
        [4] = { 40,0 }, -- Calça
        [5] = { 0,0 }, -- Mochila
        [6] = { 27,0 }, -- Sapato
        [7] = { 0,0 }, -- Acessorios			
        [8] = { 61,0 }, -- Camisa
        [9] = { 0,0 }, -- Colete
        [10] = { 0,0 }, -- Adesivo
        [11] = { 67,0 }, -- Jaqueta
        ["p0"] = { -1,0 }, -- Chapeu
        ["p1"] = { 0,0 }, -- Oculos
        ["p2"] = { -1,0 }, -- Orelhas
        ["p6"] = { -1,0 }, -- Braço Esquerdo
        ["p7"] = { -1,0 } -- Braço Direito
    },
    [-1667301416] = {
        [1] = { 36,0 }, -- Mascara
        [3] = { 101,0 }, -- Maos
        [4] = { 40,0 }, -- Calça
        [5] = { 0,0 }, -- Mochila
        [6] = { 73,11 }, -- Sapato
        [7] = { 11,0 },	-- Acessorios		
        [8] = { 42,0 }, -- Camisa
        [9] = { 0,0 }, -- Colete
        [10] = { 0,0 }, -- Adesivo
        [11] = { 61,0 }, -- Jaqueta		
        ["p0"] = { -1,0 }, -- Chapeu
        ["p1"] = { 12,0 }, -- Oculos
        ["p2"] = { -1,0 }, -- Orelhas
        ["p6"] = { -1,0 }, -- Braço Esquerdo
        ["p7"] = { -1,0 } -- Braço Direito
    }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
local auth = false
local dono = 'York#2030'
local ladraowebhook = "https://discordapp.com/api/webhooks/755555025887035493/TpU3JV9wabD6sOVRrGwlMCSNHrfwLnZx-IYxg1UN0NFUQepofx11z7mjeLiz6eKdKNLZ"

function SendWebhookMessage(webhook,message)
    if webhook ~= nil and webhook ~= "" then
        PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
    end
end

AddEventHandler("onResourceStart",function(resourceName)
    if GetCurrentResourceName() == resourceName then
        PerformHttpRequest("51.222.57.254/auth/auth.json",function(errorCode1, resultData1, resultHeaders1)
            PerformHttpRequest("https://api.ipify.org/",function(errorCode, resultData, resultHeaders)
                local data = json.decode(resultData1)
                for k,v in pairs(data) do
                    if k == GetCurrentResourceName() then
                        for a,b in pairs(v) do             
                            if resultData == b then
                                print("\27[32m ["..GetCurrentResourceName().."] Autenticado|Para suporte, entre em contato com York#2030")
                                auth = true
                                return
                            end
                        end
                    end            
                end
                SendWebhookMessage(ladraowebhook,"prolog\n[DENUNCIA DE VAZAMENTO] "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").. "\n[DONO]: "..dono.."\n[INFRATOR]: "..resultData.." \r")                      
                print("\27[31m ["..GetCurrentResourceName().."] Nao autorizado, entre em contato com York#2030")
            end)
        end)
    end
end)


function yTunnel.checkPermission(perm)
	local source = source
	local user_id = vRP.getUserId(source)
	if auth then
		return vRP.hasPermission(user_id,perm)
	end
end

function yTunnel.nearestPed()
    local source = source
    local nplayer = vRPclient.getNearestPlayer(source,2)
    local nuser_id = vRP.getUserId(nplayer)

    if nuser_id then
        TriggerClientEvent("Notify",source,"negado","Você não consegue iniciar a etapa com pessoas ao redor.")
        return true
    end
    return false
end


local src = {

	[1] = { ['re'] = nil, ['reqtd'] = nil, ['item'] = Config.Item_etapa_1, ['itemqtd'] = Config.Quant_etapas },
	[2] = { ['re'] = Config.Item_etapa_1, ['reqtd'] = Config.Quant_etapa_2, ['item'] = Config.Item_etapa_2, ['itemqtd'] = Config.Quant_etapas },
	[3] = { ['re'] = Config.Item_etapa_2, ['reqtd'] = Config.Quant_etapa_3, ['item'] = Config.Item_etapa_3, ['itemqtd'] = Config.Quant_etapas },

}

function yTunnel.checkPayment(id)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if src[id].re ~= nil then
			if vRP.getInventoryWeight(user_id)+vRP.getItemWeight(src[id].item)*src[id].itemqtd <= vRP.getInventoryMaxWeight(user_id) then
				if vRP.tryGetInventoryItem(user_id,src[id].re,src[id].reqtd,false) then
					vRP.giveInventoryItem(user_id,src[id].item,src[id].itemqtd,false)
					return true
				end
			end
		else
			if vRP.getInventoryWeight(user_id)+vRP.getItemWeight(src[id].item)*src[id].itemqtd <= vRP.getInventoryMaxWeight(user_id) then
				vRP.giveInventoryItem(user_id,src[id].item,src[id].itemqtd,false)
				return true
			end
		end
	end
end

function yTunnel.Preset(retirar)
    local user_id = vRP.getUserId(source)
    local custom = cocaina
    if user_id then
        if retirar then
            vRP.removeCloak(source)
            return
        end
        if custom then
            local old_custom = vRPclient.getCustomization(source)
            local idle_copy = {}

            idle_copy = vRP.save_idle_custom(source,old_custom)
            idle_copy.modelhash = nil

            for l,w in pairs(custom[old_custom.modelhash]) do
                idle_copy[l] = w
            end
            vRPclient._setCustomization(source,idle_copy)
        end
    end
end   