--[[                                                                           ]]--
--[[  Automatically generated code (do not edit)                               ]]--
--[[                                                                           ]]--
--[[                                                                           ]]--
--[[  Scenario                                                                 ]]--
--[[                                                                           ]]--
Scenario = {
    next_area_id = '1',
    --[[                                                                           ]]--
    --[[  Props                                                                    ]]--
    --[[                                                                           ]]--
    Props = {
    },
    --[[                                                                           ]]--
    --[[  Areas                                                                    ]]--
    --[[                                                                           ]]--
    Areas = {
    },
    --[[                                                                           ]]--
    --[[  Markers                                                                  ]]--
    --[[                                                                           ]]--
    MasterChain = {
        ['_MASTERCHAIN_'] = {
            Markers = {
                ['TopRightMarker'] = {
                    ['hint'] = BOOLEAN( true ),
                    ['graph'] = STRING( 'DefaultAir' ),
                    ['adjacentTo'] = STRING( '' ),
                    ['color'] = STRING( 'ffffffff' ),
                    ['type'] = STRING( 'Air Path Node' ),
                    ['prop'] = STRING( '/env/common/props/markers/M_Path_prop.bp' ),
                    ['orientation'] = VECTOR3( 0, -0, 0 ),
                    ['position'] = VECTOR3( 0, 64, 512 ),
                },
                ['CenterMarker'] = {
                    ['hint'] = BOOLEAN( true ),
                    ['graph'] = STRING( 'DefaultAmphibious' ),
                    ['adjacentTo'] = STRING( '' ),
                    ['color'] = STRING( 'ff00ffff' ),
                    ['type'] = STRING( 'Amphibious Path Node' ),
                    ['prop'] = STRING( '/env/common/props/markers/M_Path_prop.bp' ),
                    ['orientation'] = VECTOR3( 0, -0, 0 ),
                    ['position'] = VECTOR3( 256, 64, 256 ),
                },
                ['TopLeftMarker'] = {
                    ['color'] = STRING( 'ff800080' ),
                    ['type'] = STRING( 'Blank Marker' ),
                    ['prop'] = STRING( '/env/common/props/markers/M_Blank_prop.bp' ),
                    ['orientation'] = VECTOR3( 0, -0, 0 ),
                    ['position'] = VECTOR3( 0, 64, 0 ),
                },
            },
        },
    },
    Chains = {
    },
    --[[                                                                           ]]--
    --[[  Orders                                                                   ]]--
    --[[                                                                           ]]--
    next_queue_id = '1',
    Orders = {
    },
    --[[                                                                           ]]--
    --[[  Platoons                                                                 ]]--
    --[[                                                                           ]]--
    next_platoon_id = '1',
    Platoons = 
    {
    },
    --[[                                                                           ]]--
    --[[  Armies                                                                   ]]--
    --[[                                                                           ]]--
    next_army_id = '4',
    next_group_id = '12',
    next_unit_id = '9',
    Armies = 
    {
        --[[                                                                           ]]--
        --[[  Army                                                                     ]]--
        --[[                                                                           ]]--
        ['ARMY_1'] =  
        {
            personality = '',
            plans = '',
            color = 0,
            faction = 0,
            Economy = {
                mass = 0,
                energy = 0,
            },
            Alliances = {
            },
            ['Units'] = GROUP {
                orders = '',
                platoon = '',
                Units = {
                    ['INITIAL'] = GROUP {
                        orders = '',
                        platoon = '',
                        Units = {
                        },
                    },
                    ['GROUP_1'] = GROUP {
                        orders = '',
                        platoon = '',
                        Units = {
                            ['GROUP_2'] = GROUP {
                                orders = '',
                                platoon = '',
                                Units = {
                                    ['UNIT_2'] = {
                                        type = 'urs0201',
                                        orders = '',
                                        platoon = '',
                                        Position = { 0.0, 64.000000, 0.0 },
                                        Orientation = { 0.000000, 0.000000, 0.000000 },
                                    },
                                },
                            },
                            ['UNIT_1'] = {
                                type = 'uea0001',
                                orders = '',
                                platoon = '',
                                Position = { 512.0, 64.000000, 512.00 },
                                Orientation = { 0.000000, 0.000000, 0.000000 },
                            },
                        },
                    },
                    ['GROUP_3'] = GROUP {
                        orders = '',
                        platoon = '',
                        Units = {
                        },
                    },
                },
            },
            PlatoonBuilders = {
                next_platoon_builder_id = '0',
                Builders = {
                },
            },
        },
    },
}
