set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- ORACLE Application Express (APEX) export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_050000 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_api.import_begin (
 p_version_yyyy_mm_dd=>'2013.01.01'
,p_release=>'5.0.2.00.07'
,p_default_workspace_id=>1691260780111927
,p_default_application_id=>200
,p_default_owner=>'DEMO_APP'
);
end;
/
prompt --application/ui_types
begin
null;
end;
/
prompt --application/shared_components/plugins/dynamic_action/ca_maximet_apexdialogopen
begin
wwv_flow_api.create_plugin(
 p_id=>wwv_flow_api.id(130086947324930104)
,p_plugin_type=>'DYNAMIC ACTION'
,p_name=>'CA.MAXIMET.APEXDIALOGOPEN'
,p_display_name=>'Open Dialog'
,p_category=>'NAVIGATION'
,p_supported_ui_types=>'DESKTOP'
,p_plsql_code=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'/*-------------------------------------',
' * Apex Open Dialog Functions',
' * Version: 1.0 (2016-06-16)',
' * Author:  Maxime Tremblay',
' *-------------------------------------',
' */',
'',
'--',
'-- Function that initialize the Open Dialog plugin',
'function render_open_dialog(p_dynamic_action in apex_plugin.t_dynamic_action,',
'                            p_plugin         in apex_plugin.t_plugin)',
'return apex_plugin.t_dynamic_action_render_result is',
'    l_result                   apex_plugin.t_dynamic_action_render_result;',
'',
'    -- dynamic action attributes',
'    l_type              p_dynamic_action.attribute_01%type  := p_dynamic_action.attribute_01; --PAGE, URL or DYNAMIC',
'',
'    -- Type = Page',
'    l_page              p_dynamic_action.attribute_02%type  := p_dynamic_action.attribute_02;',
'    l_request           p_dynamic_action.attribute_03%type  := p_dynamic_action.attribute_03;',
'    l_clear_cache       p_dynamic_action.attribute_04%type  := p_dynamic_action.attribute_04;',
'    l_reset_pagination  p_dynamic_action.attribute_05%type  := p_dynamic_action.attribute_05;',
'    l_item_names        p_dynamic_action.attribute_06%type  := p_dynamic_action.attribute_06;',
'    l_item_values       p_dynamic_action.attribute_07%type  := p_dynamic_action.attribute_07;',
'',
'    -- Type = Url',
'    l_url               p_dynamic_action.attribute_08%type  := p_dynamic_action.attribute_08;',
'',
'    -- Type = Dynamic',
'    l_based_on          p_dynamic_action.attribute_09%type  := p_dynamic_action.attribute_09;',
'    l_selector          p_dynamic_action.attribute_10%type  := p_dynamic_action.attribute_10;',
'    l_attribute         p_dynamic_action.attribute_11%type  := p_dynamic_action.attribute_11;',
'',
'    l_min_file          varchar2(4)  := ''.min'';',
'    l_logging           varchar2(10) := ''false'';',
'begin',
'    -- Debug',
'    if apex_application.g_debug then',
'        apex_plugin_util.debug_dynamic_action(p_plugin         => p_plugin,',
'                                              p_dynamic_action => p_dynamic_action);',
'',
'        l_logging  := ''true'';',
'        l_min_file := '''';',
'    end if;',
'',
'    -- add javascript files',
'    apex_javascript.add_library(p_name      => ''apexDialogOpen'' || l_min_file,',
'                                p_directory => p_plugin.file_prefix || ''js/'');',
'',
'    l_result.javascript_function := ''apexDialogOpen.openDialog'';',
'    l_result.attribute_01        := apex_plugin.get_ajax_identifier;',
'    l_result.attribute_02        := l_logging;',
'    l_result.attribute_03        := l_type;',
'    l_result.attribute_04        := l_page;',
'    l_result.attribute_05        := l_request;',
'    l_result.attribute_06        := l_clear_cache;',
'    l_result.attribute_07        := l_reset_pagination;',
'    l_result.attribute_08        := l_item_names;',
'    l_result.attribute_09        := l_item_values;',
'    l_result.attribute_10        := l_url;',
'    l_result.attribute_11        := l_based_on;',
'    l_result.attribute_12        := l_selector;',
'    l_result.attribute_13        := l_attribute;',
'',
'    return l_result;',
'end render_open_dialog;',
'',
'--',
'-- AJAX function that runs the PLSQL code which saves the cropped',
'-- image to database tables or collections.',
'function ajax_open_dialog(p_dynamic_action in apex_plugin.t_dynamic_action,',
'                          p_plugin         in apex_plugin.t_plugin)',
'return apex_plugin.t_dynamic_action_ajax_result is',
'    -- plugin attributes',
'    l_type              apex_application.g_x01%type := apex_application.g_x01;',
'    l_page              apex_application.g_x02%type := apex_application.g_x02;',
'    l_request           apex_application.g_x03%type := apex_application.g_x03;',
'    l_clear_cache       apex_application.g_x04%type := apex_application.g_x04;',
'    l_reset_pagination  apex_application.g_x05%type := apex_application.g_x05;',
'    l_item_names        apex_application.g_x06%type := apex_application.g_x06;',
'    l_item_values       apex_application.g_x07%type := apex_application.g_x07;',
'',
'    l_url               apex_application.g_x08%type := apex_application.g_x08;',
'',
'    l_dialog_url varchar2(32000);',
'begin',
'    if l_type = ''PAGE'' then',
'        l_dialog_url := apex_page.get_url(p_page        => l_page,',
'                                          p_request     => l_request,',
'                                          p_debug       => case when apex_application.g_debug then ''YES'' end,',
'                                          p_clear_cache => ltrim(l_clear_cache || '','' || l_reset_pagination, '',''),',
'                                          p_items       => l_item_names,',
'                                          p_values      => l_item_values',
'                                          );',
'    else',
'        l_dialog_url := apex_util.prepare_url(p_url => l_url);',
'    end if;',
'',
'    apex_json.open_object;',
'    apex_json.write(''success'', true);',
'    apex_json.write(''message'', l_dialog_url);',
'    apex_json.close_object;',
'',
'    return null;',
'exception',
'    when others then',
'        apex_json.open_object;',
'        apex_json.write(''success'', false);',
'        apex_json.write(''message'', sqlerrm);',
'        apex_json.close_object;',
'',
'        return null;',
'end ajax_open_dialog;',
''))
,p_render_function=>'render_open_dialog'
,p_ajax_function=>'ajax_open_dialog'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_help_text=>'This dynamic action plugin is used to open a Dialog.'
,p_version_identifier=>'1.0'
,p_about_url=>'https://github.com/maxime-tremblay/apex-plugin-dialogopen'
,p_files_version=>11
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(130088263926940780)
,p_plugin_id=>wwv_flow_api.id(130086947324930104)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Type'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'PAGE'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(130092625222985986)
,p_plugin_attribute_id=>wwv_flow_api.id(130088263926940780)
,p_display_sequence=>10
,p_display_value=>'Page in this application'
,p_return_value=>'PAGE'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(130093049868989127)
,p_plugin_attribute_id=>wwv_flow_api.id(130088263926940780)
,p_display_sequence=>20
,p_display_value=>'Url'
,p_return_value=>'URL'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(65053458433733038)
,p_plugin_attribute_id=>wwv_flow_api.id(130088263926940780)
,p_display_sequence=>30
,p_display_value=>'Dynamic'
,p_return_value=>'DYNAMIC'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(130089390402949729)
,p_plugin_id=>wwv_flow_api.id(130086947324930104)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'Page'
,p_attribute_type=>'PAGE NUMBER'
,p_is_required=>true
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(130088263926940780)
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'PAGE'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(130089634944954304)
,p_plugin_id=>wwv_flow_api.id(130086947324930104)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_prompt=>'Request'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_display_length=>15
,p_max_length=>30
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(130088263926940780)
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'PAGE'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(130089991015959226)
,p_plugin_id=>wwv_flow_api.id(130086947324930104)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>4
,p_display_sequence=>40
,p_prompt=>'Clear Cache'
,p_attribute_type=>'PAGE NUMBERS'
,p_is_required=>false
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(130088263926940780)
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'PAGE'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(130090223434963586)
,p_plugin_id=>wwv_flow_api.id(130086947324930104)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>5
,p_display_sequence=>50
,p_prompt=>'Reset Pagination'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(130088263926940780)
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'PAGE'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(130090568533966802)
,p_plugin_id=>wwv_flow_api.id(130086947324930104)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>6
,p_display_sequence=>60
,p_prompt=>'Item Names'
,p_attribute_type=>'PAGE ITEMS'
,p_is_required=>false
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(130088263926940780)
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'PAGE'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(130090843206971246)
,p_plugin_id=>wwv_flow_api.id(130086947324930104)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>7
,p_display_sequence=>70
,p_prompt=>'Item Values'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_display_length=>15
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(130088263926940780)
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'PAGE'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(130091192700973436)
,p_plugin_id=>wwv_flow_api.id(130086947324930104)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>8
,p_display_sequence=>80
,p_prompt=>'Url'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(130088263926940780)
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'URL'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(65050343349692198)
,p_plugin_id=>wwv_flow_api.id(130086947324930104)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>9
,p_display_sequence=>90
,p_prompt=>'Based on'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'TRIG_ELEM'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(130088263926940780)
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'DYNAMIC'
,p_lov_type=>'STATIC'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(65051065878697726)
,p_plugin_attribute_id=>wwv_flow_api.id(65050343349692198)
,p_display_sequence=>10
,p_display_value=>'Triggering Element'
,p_return_value=>'TRIG_ELEM'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(65051416474700009)
,p_plugin_attribute_id=>wwv_flow_api.id(65050343349692198)
,p_display_sequence=>20
,p_display_value=>'jQuery Selector'
,p_return_value=>'JQUERY_SELECTOR'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(65055356246782658)
,p_plugin_id=>wwv_flow_api.id(130086947324930104)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>10
,p_display_sequence=>100
,p_prompt=>'jQuery Selector'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_display_length=>15
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(65050343349692198)
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'JQUERY_SELECTOR'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(65056018526784653)
,p_plugin_id=>wwv_flow_api.id(130086947324930104)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>11
,p_display_sequence=>110
,p_prompt=>'Attribute'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(130088263926940780)
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'DYNAMIC'
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '76617220617065784469616C6F674F70656E3D7B7061727365426F6F6C65616E3A66756E6374696F6E2865297B76617220743B73776974636828652E746F4C6F776572436173652829297B636173652274727565223A743D21303B627265616B3B636173';
wwv_flow_api.g_varchar2_table(2) := '652266616C7365223A743D21313B627265616B3B64656661756C743A743D766F696420307D72657475726E20747D2C6F70656E4469616C6F673A66756E6374696F6E28297B766172206461546869733D746869732C6C416A61784964656E746966696572';
wwv_flow_api.g_varchar2_table(3) := '3D6461546869732E616374696F6E2E61747472696275746530312C6C4C6F6767696E673D617065784469616C6F674F70656E2E7061727365426F6F6C65616E286461546869732E616374696F6E2E6174747269627574653032292C6C547970653D646154';
wwv_flow_api.g_varchar2_table(4) := '6869732E616374696F6E2E61747472696275746530332C6C506167652C6C526571756573742C6C436C65617243616368652C6C5265736574506167696E6174696F6E2C6C4974656D4E616D65732C6C4974656D56616C7565732C6C55726C2C6C42617365';
wwv_flow_api.g_varchar2_table(5) := '644F6E2C6C53656C6563746F722C6C4174747269627574653B2250414745223D3D6C547970653F286C506167653D6461546869732E616374696F6E2E61747472696275746530342C6C526571756573743D6461546869732E616374696F6E2E6174747269';
wwv_flow_api.g_varchar2_table(6) := '6275746530352C6C436C65617243616368653D6461546869732E616374696F6E2E61747472696275746530362C6C5265736574506167696E6174696F6E3D6461546869732E616374696F6E2E61747472696275746530372C6C4974656D4E616D65733D64';
wwv_flow_api.g_varchar2_table(7) := '61546869732E616374696F6E2E61747472696275746530382C6C4974656D56616C7565733D6461546869732E616374696F6E2E6174747269627574653039293A2255524C223D3D6C547970653F6C55726C3D6461546869732E616374696F6E2E61747472';
wwv_flow_api.g_varchar2_table(8) := '696275746531303A2244594E414D4943223D3D6C547970652626286C42617365644F6E3D6461546869732E616374696F6E2E61747472696275746531312C6C53656C6563746F723D6461546869732E616374696F6E2E61747472696275746531322C6C41';
wwv_flow_api.g_varchar2_table(9) := '74747269627574653D6461546869732E616374696F6E2E61747472696275746531332C6C55726C3D22545249475F454C454D223D3D6C42617365644F6E3F24286461546869732E74726967676572696E67456C656D656E74292E61747472286C41747472';
wwv_flow_api.g_varchar2_table(10) := '6962757465293A24286C53656C6563746F72292E61747472286C41747472696275746529292C6C4C6F6767696E67262628617065782E64656275672E747261636528226F70656E4469616C6F673A2041747472696275746520547970653A222C6C547970';
wwv_flow_api.g_varchar2_table(11) := '65292C617065782E64656275672E747261636528226F70656E4469616C6F673A2041747472696275746520506167653A222C6C50616765292C617065782E64656275672E747261636528226F70656E4469616C6F673A2041747472696275746520526571';
wwv_flow_api.g_varchar2_table(12) := '756573743A222C6C52657175657374292C617065782E64656275672E747261636528226F70656E4469616C6F673A2041747472696275746520436C6561722043616368653A222C6C436C6561724361636865292C617065782E64656275672E7472616365';
wwv_flow_api.g_varchar2_table(13) := '28226F70656E4469616C6F673A2041747472696275746520526573657420506167696E6174696F6E3A222C6C5265736574506167696E6174696F6E292C617065782E64656275672E747261636528226F70656E4469616C6F673A20417474726962757465';
wwv_flow_api.g_varchar2_table(14) := '204974656D204E616D65733A222C6C4974656D4E616D6573292C617065782E64656275672E747261636528226F70656E4469616C6F673A20417474726962757465204974656D2056616C7565733A222C6C4974656D56616C756573292C617065782E6465';
wwv_flow_api.g_varchar2_table(15) := '6275672E747261636528226F70656E4469616C6F673A2041747472696275746520436C6561722043616368653A222C6C55726C292C617065782E64656275672E747261636528226F70656E4469616C6F673A2041747472696275746520436C6561722043';
wwv_flow_api.g_varchar2_table(16) := '616368653A222C6C55726C292C617065782E64656275672E747261636528226F70656E4469616C6F673A2041747472696275746520436C6561722043616368653A222C6C55726C292C617065782E64656275672E747261636528226F70656E4469616C6F';
wwv_flow_api.g_varchar2_table(17) := '673A2041747472696275746520436C6561722043616368653A222C6C55726C29292C617065782E7365727665722E706C7567696E286C416A61784964656E7469666965722C7B7830313A6C547970652C7830323A6C506167652C7830333A6C5265717565';
wwv_flow_api.g_varchar2_table(18) := '73742C7830343A6C436C65617243616368652C7830353A6C5265736574506167696E6174696F6E2C7830363A6C4974656D4E616D65732C7830373A6C4974656D56616C7565732C7830383A6C55726C7D2C7B737563636573733A66756E6374696F6E2870';
wwv_flow_api.g_varchar2_table(19) := '44617461297B70446174612E7375636365737326266576616C2870446174612E6D657373616765297D2C6572726F723A66756E6374696F6E28652C74297B617065782E64656275672E747261636528226F70656E4469616C6F673A20617065782E736572';
wwv_flow_api.g_varchar2_table(20) := '7665722E706C7567696E204552524F523A222C74297D7D297D7D3B';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(65061313403935331)
,p_plugin_id=>wwv_flow_api.id(130086947324930104)
,p_file_name=>'js/apexDialogOpen.min.js'
,p_mime_type=>'application/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2F2F2041504558204469616C6F672053756363657373204D6573736167652066756E6374696F6E730D0A2F2F20417574686F723A204D6178696D65205472656D626C61790D0A2F2F2056657273696F6E3A20312E300D0A0D0A2F2F20676C6F62616C206E';
wwv_flow_api.g_varchar2_table(2) := '616D6573706163650D0A76617220617065784469616C6F674F70656E203D207B0D0A202020202F2F20706172736520737472696E6720746F20626F6F6C65616E0D0A202020207061727365426F6F6C65616E3A2066756E6374696F6E2870537472696E67';
wwv_flow_api.g_varchar2_table(3) := '29207B0D0A2020202020202020766172206C426F6F6C65616E3B0D0A0D0A20202020202020207377697463682870537472696E672E746F4C6F77657243617365282929207B0D0A20202020202020202020202063617365202774727565273A0D0A202020';
wwv_flow_api.g_varchar2_table(4) := '202020202020202020202020206C426F6F6C65616E203D20747275653B0D0A20202020202020202020202020202020627265616B3B0D0A20202020202020202020202063617365202766616C7365273A0D0A202020202020202020202020202020206C42';
wwv_flow_api.g_varchar2_table(5) := '6F6F6C65616E203D2066616C73653B0D0A20202020202020202020202020202020627265616B3B0D0A20202020202020202020202064656661756C743A0D0A202020202020202020202020202020206C426F6F6C65616E203D20756E646566696E65643B';
wwv_flow_api.g_varchar2_table(6) := '0D0A20202020202020207D0D0A0D0A202020202020202072657475726E206C426F6F6C65616E3B0D0A202020207D2C0D0A202020202F2F2066756E6374696F6E207468617420676574732063616C6C65642066726F6D20706C7567696E0D0A202020206F';
wwv_flow_api.g_varchar2_table(7) := '70656E4469616C6F673A2066756E6374696F6E2829207B0D0A20202020202020202F2F20706C7567696E20617474726962757465730D0A202020202020202076617220646154686973203D20746869733B0D0A0D0A2020202020202020766172206C416A';
wwv_flow_api.g_varchar2_table(8) := '61784964656E74696669657220203D206461546869732E616374696F6E2E61747472696275746530313B0D0A2020202020202020766172206C4C6F6767696E672020202020202020203D20617065784469616C6F674F70656E2E7061727365426F6F6C65';
wwv_flow_api.g_varchar2_table(9) := '616E286461546869732E616374696F6E2E6174747269627574653032293B0D0A2020202020202020766172206C547970652020202020202020202020203D206461546869732E616374696F6E2E61747472696275746530333B0D0A202020202020202076';
wwv_flow_api.g_varchar2_table(10) := '6172206C506167653B0D0A2020202020202020766172206C526571756573743B0D0A2020202020202020766172206C436C65617243616368653B0D0A2020202020202020766172206C5265736574506167696E6174696F6E3B0D0A202020202020202076';
wwv_flow_api.g_varchar2_table(11) := '6172206C4974656D4E616D65733B0D0A2020202020202020766172206C4974656D56616C7565733B0D0A2020202020202020766172206C55726C3B0D0A2020202020202020766172206C42617365644F6E3B0D0A2020202020202020766172206C53656C';
wwv_flow_api.g_varchar2_table(12) := '6563746F723B0D0A2020202020202020766172206C4174747269627574653B0D0A0D0A2020202020202020696620286C54797065203D3D20275041474527297B0D0A2020202020202020202020206C506167652020202020202020202020203D20646154';
wwv_flow_api.g_varchar2_table(13) := '6869732E616374696F6E2E61747472696275746530343B0D0A2020202020202020202020206C526571756573742020202020202020203D206461546869732E616374696F6E2E61747472696275746530353B0D0A2020202020202020202020206C436C65';
wwv_flow_api.g_varchar2_table(14) := '617243616368652020202020203D206461546869732E616374696F6E2E61747472696275746530363B0D0A2020202020202020202020206C5265736574506167696E6174696F6E203D206461546869732E616374696F6E2E61747472696275746530373B';
wwv_flow_api.g_varchar2_table(15) := '0D0A2020202020202020202020206C4974656D4E616D6573202020202020203D206461546869732E616374696F6E2E61747472696275746530383B0D0A2020202020202020202020206C4974656D56616C7565732020202020203D206461546869732E61';
wwv_flow_api.g_varchar2_table(16) := '6374696F6E2E61747472696275746530393B0D0A20202020202020207D0D0A2020202020202020656C736520696620286C54797065203D3D202755524C27297B0D0A2020202020202020202020206C55726C203D206461546869732E616374696F6E2E61';
wwv_flow_api.g_varchar2_table(17) := '747472696275746531303B0D0A20202020202020207D0D0A2020202020202020656C736520696620286C54797065203D3D202744594E414D494327297B0D0A2020202020202020202020206C42617365644F6E2020203D206461546869732E616374696F';
wwv_flow_api.g_varchar2_table(18) := '6E2E61747472696275746531313B0D0A2020202020202020202020206C53656C6563746F7220203D206461546869732E616374696F6E2E61747472696275746531323B0D0A2020202020202020202020206C417474726962757465203D20646154686973';
wwv_flow_api.g_varchar2_table(19) := '2E616374696F6E2E61747472696275746531333B0D0A0D0A202020202020202020202020696620286C42617365644F6E203D3D2027545249475F454C454D27297B0D0A202020202020202020202020202020206C55726C203D2024286461546869732E74';
wwv_flow_api.g_varchar2_table(20) := '726967676572696E67456C656D656E74292E61747472286C417474726962757465293B0D0A2020202020202020202020207D0D0A202020202020202020202020656C73657B0D0A202020202020202020202020202020206C55726C203D2024286C53656C';
wwv_flow_api.g_varchar2_table(21) := '6563746F72292E61747472286C417474726962757465293B0D0A2020202020202020202020207D0D0A20202020202020207D0D0A0D0A20202020202020202F2F204C6F6767696E670D0A2020202020202020696620286C4C6F6767696E6729207B0D0A20';
wwv_flow_api.g_varchar2_table(22) := '2020202020202020202020617065782E64656275672E747261636528276F70656E4469616C6F673A2041747472696275746520547970653A272C206C54797065293B0D0A202020202020202020202020617065782E64656275672E747261636528276F70';
wwv_flow_api.g_varchar2_table(23) := '656E4469616C6F673A2041747472696275746520506167653A272C206C50616765293B0D0A202020202020202020202020617065782E64656275672E747261636528276F70656E4469616C6F673A2041747472696275746520526571756573743A272C20';
wwv_flow_api.g_varchar2_table(24) := '6C52657175657374293B0D0A202020202020202020202020617065782E64656275672E747261636528276F70656E4469616C6F673A2041747472696275746520436C6561722043616368653A272C206C436C6561724361636865293B0D0A202020202020';
wwv_flow_api.g_varchar2_table(25) := '202020202020617065782E64656275672E747261636528276F70656E4469616C6F673A2041747472696275746520526573657420506167696E6174696F6E3A272C206C5265736574506167696E6174696F6E293B0D0A2020202020202020202020206170';
wwv_flow_api.g_varchar2_table(26) := '65782E64656275672E747261636528276F70656E4469616C6F673A20417474726962757465204974656D204E616D65733A272C206C4974656D4E616D6573293B0D0A202020202020202020202020617065782E64656275672E747261636528276F70656E';
wwv_flow_api.g_varchar2_table(27) := '4469616C6F673A20417474726962757465204974656D2056616C7565733A272C206C4974656D56616C756573293B0D0A202020202020202020202020617065782E64656275672E747261636528276F70656E4469616C6F673A2041747472696275746520';
wwv_flow_api.g_varchar2_table(28) := '436C6561722043616368653A272C206C55726C293B0D0A202020202020202020202020617065782E64656275672E747261636528276F70656E4469616C6F673A2041747472696275746520436C6561722043616368653A272C206C55726C293B0D0A2020';
wwv_flow_api.g_varchar2_table(29) := '20202020202020202020617065782E64656275672E747261636528276F70656E4469616C6F673A2041747472696275746520436C6561722043616368653A272C206C55726C293B0D0A202020202020202020202020617065782E64656275672E74726163';
wwv_flow_api.g_varchar2_table(30) := '6528276F70656E4469616C6F673A2041747472696275746520436C6561722043616368653A272C206C55726C293B0D0A20202020202020207D0D0A0D0A20202020202020202F2F204170657820416A61782043616C6C0D0A202020202020202061706578';
wwv_flow_api.g_varchar2_table(31) := '2E7365727665722E706C7567696E286C416A61784964656E7469666965722C0D0A2020202020202020202020202020202020202020202020202020207B7830313A6C547970652C0D0A202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(32) := '207830323A6C506167652C0D0A202020202020202020202020202020202020202020202020202020207830333A6C526571756573742C0D0A202020202020202020202020202020202020202020202020202020207830343A6C436C65617243616368652C';
wwv_flow_api.g_varchar2_table(33) := '0D0A202020202020202020202020202020202020202020202020202020207830353A6C5265736574506167696E6174696F6E2C0D0A202020202020202020202020202020202020202020202020202020207830363A6C4974656D4E616D65732C0D0A2020';
wwv_flow_api.g_varchar2_table(34) := '20202020202020202020202020202020202020202020202020207830373A6C4974656D56616C7565732C0D0A202020202020202020202020202020202020202020202020202020207830383A6C55726C0D0A202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(35) := '202020202020202020207D2C0D0A2020202020202020202020202020202020202020202020202020207B202F2F205355434553532066756E6374696F6E0D0A2020202020202020202020202020202020202020202020202020202020737563636573733A';
wwv_flow_api.g_varchar2_table(36) := '2066756E6374696F6E28704461746129207B0D0A20202020202020202020202020202020202020202020202020202020202020206966202870446174612E73756363657373297B0D0A202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(37) := '2020202020202020206576616C2870446174612E6D657373616765293B0D0A20202020202020202020202020202020202020202020202020202020202020207D0D0A20202020202020202020202020202020202020202020202020202020207D2C0D0A20';
wwv_flow_api.g_varchar2_table(38) := '202020202020202020202020202020202020202020202020202020202F2F204552524F522066756E6374696F6E0D0A20202020202020202020202020202020202020202020202020202020206572726F723A2066756E6374696F6E287868722C20704D65';
wwv_flow_api.g_varchar2_table(39) := '737361676529207B0D0A20202020202020202020202020202020202020202020202020202020202020202F2F206C6F67206572726F7220696E20636F6E736F6C650D0A202020202020202020202020202020202020202020202020202020202020202061';
wwv_flow_api.g_varchar2_table(40) := '7065782E64656275672E747261636528276F70656E4469616C6F673A20617065782E7365727665722E706C7567696E204552524F523A272C20704D657373616765293B0D0A20202020202020202020202020202020202020202020202020202020207D0D';
wwv_flow_api.g_varchar2_table(41) := '0A202020202020202020202020202020202020202020202020202020207D293B0D0A202020207D0D0A7D3B0D0A';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(130087230959933055)
,p_plugin_id=>wwv_flow_api.id(130086947324930104)
,p_file_name=>'js/apexDialogOpen.js'
,p_mime_type=>'application/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false), p_is_component_import => true);
commit;
end;
/
set verify on feedback on define on
prompt  ...done
