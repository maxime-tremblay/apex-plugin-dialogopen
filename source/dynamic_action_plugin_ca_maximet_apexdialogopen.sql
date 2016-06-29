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
 p_id=>wwv_flow_api.id(275510363157454799)
,p_plugin_type=>'DYNAMIC ACTION'
,p_name=>'CA.MAXIMET.APEXDIALOGOPEN'
,p_display_name=>'Open Dialog'
,p_category=>'NAVIGATION'
,p_supported_ui_types=>'DESKTOP'
,p_plsql_code=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'/*-------------------------------------',
' * Apex Open Dialog Functions',
' * Version: 1.1 (2016-06-29)',
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
'    l_type                   p_dynamic_action.attribute_01%type  := p_dynamic_action.attribute_01; --PAGE, URL or DYNAMIC',
'',
'    -- Type = Dynamic',
'    l_based_on               p_dynamic_action.attribute_09%type  := p_dynamic_action.attribute_09;',
'    l_selector               p_dynamic_action.attribute_10%type  := p_dynamic_action.attribute_10;',
'    l_attribute              p_dynamic_action.attribute_11%type  := p_dynamic_action.attribute_11;',
'    l_javascript             p_dynamic_action.attribute_12%type  := p_dynamic_action.attribute_12;',
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
'    l_result.attribute_04        := l_based_on;',
'    l_result.attribute_05        := l_selector;',
'    l_result.attribute_06        := l_attribute;',
'    l_result.attribute_07        := l_javascript;',
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
'    l_type                   p_dynamic_action.attribute_01%type  := p_dynamic_action.attribute_01; --PAGE, URL or DYNAMIC',
'',
'    -- Type = Page',
'    l_page                   p_dynamic_action.attribute_02%type  := p_dynamic_action.attribute_02;',
'    l_request                p_dynamic_action.attribute_03%type  := p_dynamic_action.attribute_03;',
'    l_clear_cache            p_dynamic_action.attribute_04%type  := p_dynamic_action.attribute_04;',
'    l_reset_pagination       p_dynamic_action.attribute_05%type  := p_dynamic_action.attribute_05;',
'    l_item_names             p_dynamic_action.attribute_06%type  := p_dynamic_action.attribute_06;',
'    l_item_values            p_dynamic_action.attribute_07%type  := p_dynamic_action.attribute_07;',
'',
'    -- Type = Url',
'    l_custom_url             p_dynamic_action.attribute_08%type  := p_dynamic_action.attribute_08;',
'',
'    -- Type = Dynamic',
'    l_based_on               p_dynamic_action.attribute_09%type  := p_dynamic_action.attribute_09;',
'    l_selector               p_dynamic_action.attribute_10%type  := sys.htf.escape_sc(p_dynamic_action.attribute_10);',
'    l_attribute              p_dynamic_action.attribute_11%type  := sys.htf.escape_sc(p_dynamic_action.attribute_11);',
'    l_javascript             p_dynamic_action.attribute_12%type  := p_dynamic_action.attribute_12;',
'    l_dialog_triggering_elem p_dynamic_action.attribute_13%type  := sys.htf.escape_sc(p_dynamic_action.attribute_13);',
'    l_url_checksum           p_dynamic_action.attribute_14%type  := p_dynamic_action.attribute_14;',
'',
'    l_dynamic_url            apex_application.g_x01%type := apex_application.g_x01;',
'',
'    l_url        varchar2(32000);',
'    l_dialog_url varchar2(32000);',
'begin',
'    if l_type = ''PAGE'' then',
'        l_url := ''f?p='' || :APP_ID || '':'' || l_page || '':'' || :APP_SESSION || '':'' || l_request || '':'' || :DEBUG || '':'' || ltrim(l_clear_cache || '','' || l_reset_pagination, '','') || '':'' || l_item_names || '':'' || l_item_values;',
'    elsif l_type = ''URL'' then',
'        l_url := l_custom_url;',
'    elsif l_type = ''DYNAMIC'' then',
'        l_url := l_dynamic_url;',
'    end if;',
'',
'    l_dialog_url := apex_util.prepare_url(p_url                => l_url,',
'                                          p_checksum_type      => l_url_checksum,',
'                                          p_triggering_element => ''$('''''' || l_dialog_triggering_elem || '''''')'' -- undocumented parameter',
'                                          );',
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
'end ajax_open_dialog;'))
,p_render_function=>'render_open_dialog'
,p_ajax_function=>'ajax_open_dialog'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_help_text=>'This dynamic action plugin is used to open a Dialog.'
,p_version_identifier=>'1.1'
,p_about_url=>'https://github.com/maxime-tremblay/apex-plugin-dialogopen'
,p_files_version=>24
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(275511679759465475)
,p_plugin_id=>wwv_flow_api.id(275510363157454799)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Type'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'PAGE'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>'Type of the URL.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(275516041055510681)
,p_plugin_attribute_id=>wwv_flow_api.id(275511679759465475)
,p_display_sequence=>10
,p_display_value=>'Page in this application'
,p_return_value=>'PAGE'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(275516465701513822)
,p_plugin_attribute_id=>wwv_flow_api.id(275511679759465475)
,p_display_sequence=>20
,p_display_value=>'Url'
,p_return_value=>'URL'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(210476874266257733)
,p_plugin_attribute_id=>wwv_flow_api.id(275511679759465475)
,p_display_sequence=>30
,p_display_value=>'Dynamic'
,p_return_value=>'DYNAMIC'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(275512806235474424)
,p_plugin_id=>wwv_flow_api.id(275510363157454799)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'Page'
,p_attribute_type=>'PAGE NUMBER'
,p_is_required=>true
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(275511679759465475)
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'PAGE'
,p_help_text=>'Page number or alphanumeric page alias.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(275513050777478999)
,p_plugin_id=>wwv_flow_api.id(275510363157454799)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_prompt=>'Request'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_display_length=>15
,p_max_length=>30
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(275511679759465475)
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'PAGE'
,p_help_text=>'Page request.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(275513406848483921)
,p_plugin_id=>wwv_flow_api.id(275510363157454799)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>4
,p_display_sequence=>40
,p_prompt=>'Clear Cache'
,p_attribute_type=>'PAGE NUMBERS'
,p_is_required=>false
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(275511679759465475)
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'PAGE'
,p_help_text=>'To clear cached items on a single page, specify the numeric page number. To clear cached items on multiple pages, use a comma-separated list of page numbers. Clearing a page''s cache also resets any stateful processes on the page. Individual or comma-'
||'separated values can also include collection names to be reset.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(275513639267488281)
,p_plugin_id=>wwv_flow_api.id(275510363157454799)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>5
,p_display_sequence=>50
,p_prompt=>'Reset Pagination'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(275511679759465475)
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'PAGE'
,p_help_text=>'Resets region pagination on the requested page.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(275513984366491497)
,p_plugin_id=>wwv_flow_api.id(275510363157454799)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>6
,p_display_sequence=>60
,p_prompt=>'Item Names'
,p_attribute_type=>'PAGE ITEMS'
,p_is_required=>false
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(275511679759465475)
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'PAGE'
,p_help_text=>'Comma-delimited list of item names used to set session state.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(275514259039495941)
,p_plugin_id=>wwv_flow_api.id(275510363157454799)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>7
,p_display_sequence=>70
,p_prompt=>'Item Values'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_display_length=>15
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(275511679759465475)
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'PAGE'
,p_help_text=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'List of item values used to set session state within a URL. To pass a comma in an item value, enclose the characters with backslashes.',
'<br>For example:',
'<pre>',
'\123,45\',
'</pre>',
'<br>Every character sequence except backslash comma (\,) can be enclosed with backslash.'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(275514608533498131)
,p_plugin_id=>wwv_flow_api.id(275510363157454799)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>8
,p_display_sequence=>80
,p_prompt=>'Url'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(275511679759465475)
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'URL'
,p_help_text=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'An f?p relative URL with all substitutions resolved.',
'',
'<br>f?p syntax:',
'<pre>',
'f?p=App:Page:Session:Request:Debug:ClearCache:itemNames:itemValues:PrinterFriendly',
'</pre>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(210473759182216893)
,p_plugin_id=>wwv_flow_api.id(275510363157454799)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>9
,p_display_sequence=>90
,p_prompt=>'Based on'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'TRIG_ELEM'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(275511679759465475)
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'DYNAMIC'
,p_lov_type=>'STATIC'
,p_help_text=>'Dynamic url based on.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(210474481711222421)
,p_plugin_attribute_id=>wwv_flow_api.id(210473759182216893)
,p_display_sequence=>10
,p_display_value=>'Triggering Element'
,p_return_value=>'TRIG_ELEM'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(210474832307224704)
,p_plugin_attribute_id=>wwv_flow_api.id(210473759182216893)
,p_display_sequence=>20
,p_display_value=>'jQuery Selector'
,p_return_value=>'JQUERY_SELECTOR'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(145426108723594792)
,p_plugin_attribute_id=>wwv_flow_api.id(210473759182216893)
,p_display_sequence=>30
,p_display_value=>'Javascript Expression'
,p_return_value=>'JAVASCRIPT'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(210478772079307353)
,p_plugin_id=>wwv_flow_api.id(275510363157454799)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>10
,p_display_sequence=>100
,p_prompt=>'jQuery Selector'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_display_length=>15
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(210473759182216893)
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'JQUERY_SELECTOR'
,p_help_text=>'jQuery selector of the element from which the url is going to be retrieved.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(210479434359309348)
,p_plugin_id=>wwv_flow_api.id(275510363157454799)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>11
,p_display_sequence=>110
,p_prompt=>'Attribute'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(210473759182216893)
,p_depending_on_condition_type=>'IN_LIST'
,p_depending_on_expression=>'TRIG_ELEM,JQUERY_SELECTOR'
,p_help_text=>'Element''s attribute of the url.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(145425765775591103)
,p_plugin_id=>wwv_flow_api.id(275510363157454799)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>12
,p_display_sequence=>120
,p_prompt=>'Javascript Expression'
,p_attribute_type=>'JAVASCRIPT'
,p_is_required=>true
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(210473759182216893)
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'JAVASCRIPT'
,p_help_text=>'JavaScript expression returning the url.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(145753794101581017)
,p_plugin_id=>wwv_flow_api.id(275510363157454799)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>13
,p_display_sequence=>130
,p_prompt=>'Dialog Triggering Element Selector'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_is_translatable=>false
,p_help_text=>'jQuery selector of the element from which the dialog is going to be triggered.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(145878253669955773)
,p_plugin_id=>wwv_flow_api.id(275510363157454799)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>14
,p_display_sequence=>140
,p_prompt=>'Page Checksum'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>false
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_null_text=>'Unrestricted'
,p_help_text=>'Page checksum.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(145879677283966556)
,p_plugin_attribute_id=>wwv_flow_api.id(145878253669955773)
,p_display_sequence=>10
,p_display_value=>'Session Level'
,p_return_value=>'SESSION'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(145880074159971345)
,p_plugin_attribute_id=>wwv_flow_api.id(145878253669955773)
,p_display_sequence=>20
,p_display_value=>'User Level'
,p_return_value=>'PRIVATE_BOOKMARK'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(145880487746973974)
,p_plugin_attribute_id=>wwv_flow_api.id(145878253669955773)
,p_display_sequence=>30
,p_display_value=>'Application Level'
,p_return_value=>'PUBLIC_BOOKMARK'
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '76617220617065784469616C6F674F70656E3D7B7061727365426F6F6C65616E3A66756E6374696F6E2861297B76617220653B73776974636828612E746F4C6F776572436173652829297B636173652274727565223A653D21303B627265616B3B636173';
wwv_flow_api.g_varchar2_table(2) := '652266616C7365223A653D21313B627265616B3B64656661756C743A653D766F696420307D72657475726E20657D2C6F70656E4469616C6F673A66756E6374696F6E28297B766172206461546869733D746869732C6C416A61784964656E746966696572';
wwv_flow_api.g_varchar2_table(3) := '3D6461546869732E616374696F6E2E61747472696275746530312C6C4C6F6767696E673D617065784469616C6F674F70656E2E7061727365426F6F6C65616E286461546869732E616374696F6E2E6174747269627574653032292C6C44796E616D696355';
wwv_flow_api.g_varchar2_table(4) := '726C2C6C547970653D6461546869732E616374696F6E2E61747472696275746530333B2244594E414D4943223D3D6C547970652626286C42617365644F6E3D6461546869732E616374696F6E2E61747472696275746530342C6C53656C6563746F723D64';
wwv_flow_api.g_varchar2_table(5) := '61546869732E616374696F6E2E61747472696275746530352C6C4174747269627574653D6461546869732E616374696F6E2E61747472696275746530362C6C4A61766173637269707445787072657373696F6E3D6461546869732E616374696F6E2E6174';
wwv_flow_api.g_varchar2_table(6) := '7472696275746530372C6C44796E616D696355726C3D22545249475F454C454D223D3D6C42617365644F6E3F24286461546869732E74726967676572696E67456C656D656E74292E61747472286C417474726962757465293A224A415641534352495054';
wwv_flow_api.g_varchar2_table(7) := '223D3D6C42617365644F6E3F6576616C286C4A61766173637269707445787072657373696F6E293A24286C53656C6563746F72292E61747472286C41747472696275746529292C6C4C6F6767696E672626617065782E64656275672E747261636528226F';
wwv_flow_api.g_varchar2_table(8) := '70656E4469616C6F673A2055726C3A222C6C44796E616D696355726C292C617065782E7365727665722E706C7567696E286C416A61784964656E7469666965722C7B7830313A6C44796E616D696355726C7D2C7B737563636573733A66756E6374696F6E';
wwv_flow_api.g_varchar2_table(9) := '287044617461297B70446174612E7375636365737326266576616C2870446174612E6D657373616765297D2C6572726F723A66756E6374696F6E28612C65297B617065782E64656275672E747261636528226F70656E4469616C6F673A20617065782E73';
wwv_flow_api.g_varchar2_table(10) := '65727665722E706C7567696E204552524F523A222C65297D7D297D7D3B';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(210484729236460026)
,p_plugin_id=>wwv_flow_api.id(275510363157454799)
,p_file_name=>'js/apexDialogOpen.min.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2F2F2041706578204F70656E204469616C6F672046756E6374696F6E730D0A2F2F20417574686F723A204D6178696D65205472656D626C61790D0A2F2F2056657273696F6E3A20312E310D0A0D0A2F2F20676C6F62616C206E616D6573706163650D0A76';
wwv_flow_api.g_varchar2_table(2) := '617220617065784469616C6F674F70656E203D207B0D0A202020202F2F20706172736520737472696E6720746F20626F6F6C65616E0D0A202020207061727365426F6F6C65616E3A2066756E6374696F6E2870537472696E6729207B0D0A202020202020';
wwv_flow_api.g_varchar2_table(3) := '2020766172206C426F6F6C65616E3B0D0A0D0A20202020202020207377697463682870537472696E672E746F4C6F77657243617365282929207B0D0A20202020202020202020202063617365202774727565273A0D0A2020202020202020202020202020';
wwv_flow_api.g_varchar2_table(4) := '20206C426F6F6C65616E203D20747275653B0D0A20202020202020202020202020202020627265616B3B0D0A20202020202020202020202063617365202766616C7365273A0D0A202020202020202020202020202020206C426F6F6C65616E203D206661';
wwv_flow_api.g_varchar2_table(5) := '6C73653B0D0A20202020202020202020202020202020627265616B3B0D0A20202020202020202020202064656661756C743A0D0A202020202020202020202020202020206C426F6F6C65616E203D20756E646566696E65643B0D0A20202020202020207D';
wwv_flow_api.g_varchar2_table(6) := '0D0A0D0A202020202020202072657475726E206C426F6F6C65616E3B0D0A202020207D2C0D0A202020202F2F2066756E6374696F6E207468617420676574732063616C6C65642066726F6D20706C7567696E0D0A202020206F70656E4469616C6F673A20';
wwv_flow_api.g_varchar2_table(7) := '66756E6374696F6E2829207B0D0A20202020202020202F2F20706C7567696E20617474726962757465730D0A202020202020202076617220646154686973203D20746869733B0D0A0D0A2020202020202020766172206C416A61784964656E7469666965';
wwv_flow_api.g_varchar2_table(8) := '7220203D206461546869732E616374696F6E2E61747472696275746530313B0D0A2020202020202020766172206C4C6F6767696E672020202020202020203D20617065784469616C6F674F70656E2E7061727365426F6F6C65616E286461546869732E61';
wwv_flow_api.g_varchar2_table(9) := '6374696F6E2E6174747269627574653032293B0D0A2020202020202020766172206C44796E616D696355726C3B0D0A2020202020202020766172206C547970652020202020202020202020203D206461546869732E616374696F6E2E6174747269627574';
wwv_flow_api.g_varchar2_table(10) := '6530333B0D0A0D0A2020202020202020696620286C54797065203D3D202744594E414D494327297B0D0A2020202020202020202020206C42617365644F6E2020203D206461546869732E616374696F6E2E61747472696275746530343B0D0A2020202020';
wwv_flow_api.g_varchar2_table(11) := '202020202020206C53656C6563746F7220203D206461546869732E616374696F6E2E61747472696275746530353B0D0A2020202020202020202020206C417474726962757465203D206461546869732E616374696F6E2E61747472696275746530363B0D';
wwv_flow_api.g_varchar2_table(12) := '0A2020202020202020202020206C4A61766173637269707445787072657373696F6E203D206461546869732E616374696F6E2E61747472696275746530373B0D0A0D0A202020202020202020202020696620286C42617365644F6E203D3D202754524947';
wwv_flow_api.g_varchar2_table(13) := '5F454C454D27297B0D0A202020202020202020202020202020206C44796E616D696355726C203D2024286461546869732E74726967676572696E67456C656D656E74292E61747472286C417474726962757465293B0D0A2020202020202020202020207D';
wwv_flow_api.g_varchar2_table(14) := '0D0A202020202020202020202020656C736520696620286C42617365644F6E203D3D20274A41564153435249505427297B0D0A202020202020202020202020202020206C44796E616D696355726C203D206576616C286C4A617661736372697074457870';
wwv_flow_api.g_varchar2_table(15) := '72657373696F6E293B0D0A2020202020202020202020207D0D0A202020202020202020202020656C73657B0D0A202020202020202020202020202020206C44796E616D696355726C203D2024286C53656C6563746F72292E61747472286C417474726962';
wwv_flow_api.g_varchar2_table(16) := '757465293B0D0A2020202020202020202020207D0D0A20202020202020207D0D0A0D0A20202020202020202F2F204C6F6767696E670D0A2020202020202020696620286C4C6F6767696E6729207B0D0A202020202020202020202020617065782E646562';
wwv_flow_api.g_varchar2_table(17) := '75672E747261636528276F70656E4469616C6F673A2055726C3A272C206C44796E616D696355726C293B0D0A20202020202020207D0D0A0D0A20202020202020202F2F204170657820416A61782043616C6C0D0A2020202020202020617065782E736572';
wwv_flow_api.g_varchar2_table(18) := '7665722E706C7567696E286C416A61784964656E7469666965722C0D0A2020202020202020202020202020202020202020202020202020207B7830313A6C44796E616D696355726C0D0A2020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(19) := '20207D2C0D0A2020202020202020202020202020202020202020202020202020207B202F2F20535543434553532066756E6374696F6E0D0A2020202020202020202020202020202020202020202020202020202020737563636573733A2066756E637469';
wwv_flow_api.g_varchar2_table(20) := '6F6E28704461746129207B0D0A20202020202020202020202020202020202020202020202020202020202020206966202870446174612E73756363657373297B0D0A20202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(21) := '20206576616C2870446174612E6D657373616765293B0D0A20202020202020202020202020202020202020202020202020202020202020207D0D0A20202020202020202020202020202020202020202020202020202020207D2C0D0A2020202020202020';
wwv_flow_api.g_varchar2_table(22) := '2020202020202020202020202020202020202020202F2F204552524F522066756E6374696F6E0D0A20202020202020202020202020202020202020202020202020202020206572726F723A2066756E6374696F6E287868722C20704D6573736167652920';
wwv_flow_api.g_varchar2_table(23) := '7B0D0A20202020202020202020202020202020202020202020202020202020202020202F2F206C6F67206572726F7220696E20636F6E736F6C650D0A2020202020202020202020202020202020202020202020202020202020202020617065782E646562';
wwv_flow_api.g_varchar2_table(24) := '75672E747261636528276F70656E4469616C6F673A20617065782E7365727665722E706C7567696E204552524F523A272C20704D657373616765293B0D0A20202020202020202020202020202020202020202020202020202020207D0D0A202020202020';
wwv_flow_api.g_varchar2_table(25) := '202020202020202020202020202020202020202020207D293B0D0A202020207D0D0A7D3B';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(275510646792457750)
,p_plugin_id=>wwv_flow_api.id(275510363157454799)
,p_file_name=>'js/apexDialogOpen.js'
,p_mime_type=>'text/javascript'
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
