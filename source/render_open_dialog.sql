/*-------------------------------------
 * Apex Open Dialog Functions
 * Version: 1.0 (2016-06-16)
 * Author:  Maxime Tremblay
 *-------------------------------------
 */

--
-- Function that initialize the Open Dialog plugin
function render_open_dialog(p_dynamic_action in apex_plugin.t_dynamic_action,
                            p_plugin         in apex_plugin.t_plugin)
return apex_plugin.t_dynamic_action_render_result is
    l_result                   apex_plugin.t_dynamic_action_render_result;

    -- dynamic action attributes
    l_type              p_dynamic_action.attribute_01%type  := p_dynamic_action.attribute_01; --PAGE, URL or DYNAMIC

    -- Type = Page
    l_page              p_dynamic_action.attribute_02%type  := p_dynamic_action.attribute_02;
    l_request           p_dynamic_action.attribute_03%type  := p_dynamic_action.attribute_03;
    l_clear_cache       p_dynamic_action.attribute_04%type  := p_dynamic_action.attribute_04;
    l_reset_pagination  p_dynamic_action.attribute_05%type  := p_dynamic_action.attribute_05;
    l_item_names        p_dynamic_action.attribute_06%type  := p_dynamic_action.attribute_06;
    l_item_values       p_dynamic_action.attribute_07%type  := p_dynamic_action.attribute_07;

    -- Type = Url
    l_url               p_dynamic_action.attribute_08%type  := p_dynamic_action.attribute_08;

    -- Type = Dynamic
    l_based_on          p_dynamic_action.attribute_09%type  := p_dynamic_action.attribute_09;
    l_selector          p_dynamic_action.attribute_10%type  := p_dynamic_action.attribute_10;
    l_attribute         p_dynamic_action.attribute_11%type  := p_dynamic_action.attribute_11;

    l_min_file          varchar2(4)  := '.min';
    l_logging           varchar2(10) := 'false';
begin
    -- Debug
    if apex_application.g_debug then
        apex_plugin_util.debug_dynamic_action(p_plugin         => p_plugin,
                                              p_dynamic_action => p_dynamic_action);

        l_logging  := 'true';
        l_min_file := '';
    end if;

    -- add javascript files
    apex_javascript.add_library(p_name      => 'apexDialogOpen' || l_min_file,
                                p_directory => p_plugin.file_prefix || 'js/');

    l_result.javascript_function := 'apexDialogOpen.openDialog';
    l_result.attribute_01        := apex_plugin.get_ajax_identifier;
    l_result.attribute_02        := l_logging;
    l_result.attribute_03        := l_type;
    l_result.attribute_04        := l_page;
    l_result.attribute_05        := l_request;
    l_result.attribute_06        := l_clear_cache;
    l_result.attribute_07        := l_reset_pagination;
    l_result.attribute_08        := l_item_names;
    l_result.attribute_09        := l_item_values;
    l_result.attribute_10        := l_url;
    l_result.attribute_11        := l_based_on;
    l_result.attribute_12        := l_selector;
    l_result.attribute_13        := l_attribute;

    return l_result;
end render_open_dialog;

--
-- AJAX function that runs the PLSQL code which saves the cropped
-- image to database tables or collections.
function ajax_open_dialog(p_dynamic_action in apex_plugin.t_dynamic_action,
                          p_plugin         in apex_plugin.t_plugin)
return apex_plugin.t_dynamic_action_ajax_result is
    -- plugin attributes
    l_type              apex_application.g_x01%type := apex_application.g_x01;
    l_page              apex_application.g_x02%type := apex_application.g_x02;
    l_request           apex_application.g_x03%type := apex_application.g_x03;
    l_clear_cache       apex_application.g_x04%type := apex_application.g_x04;
    l_reset_pagination  apex_application.g_x05%type := apex_application.g_x05;
    l_item_names        apex_application.g_x06%type := apex_application.g_x06;
    l_item_values       apex_application.g_x07%type := apex_application.g_x07;

    l_url               apex_application.g_x08%type := apex_application.g_x08;

    l_dialog_url varchar2(32000);
begin
    if l_type = 'PAGE' then
        l_dialog_url := apex_page.get_url(p_page        => l_page,
                                          p_request     => l_request,
                                          p_debug       => case when apex_application.g_debug then 'YES' end,
                                          p_clear_cache => ltrim(l_clear_cache || ',' || l_reset_pagination, ','),
                                          p_items       => l_item_names,
                                          p_values      => l_item_values
                                          );
    else
        l_dialog_url := apex_util.prepare_url(p_url => l_url);
    end if;

    apex_json.open_object;
    apex_json.write('success', true);
    apex_json.write('message', l_dialog_url);
    apex_json.close_object;

    return null;
exception
    when others then
        apex_json.open_object;
        apex_json.write('success', false);
        apex_json.write('message', sqlerrm);
        apex_json.close_object;

        return null;
end ajax_open_dialog;