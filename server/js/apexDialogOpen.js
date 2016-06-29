// Apex Open Dialog Functions
// Author: Maxime Tremblay
// Version: 1.1

// global namespace
var apexDialogOpen = {
    // parse string to boolean
    parseBoolean: function(pString) {
        var lBoolean;

        switch(pString.toLowerCase()) {
            case 'true':
                lBoolean = true;
                break;
            case 'false':
                lBoolean = false;
                break;
            default:
                lBoolean = undefined;
        }

        return lBoolean;
    },
    // function that gets called from plugin
    openDialog: function() {
        // plugin attributes
        var daThis = this;

        var lAjaxIdentifier  = daThis.action.attribute01;
        var lLogging         = apexDialogOpen.parseBoolean(daThis.action.attribute02);
        var lDynamicUrl;
        var lType            = daThis.action.attribute03;

        if (lType == 'DYNAMIC'){
            lBasedOn   = daThis.action.attribute04;
            lSelector  = daThis.action.attribute05;
            lAttribute = daThis.action.attribute06;
            lJavascriptExpression = daThis.action.attribute07;

            if (lBasedOn == 'TRIG_ELEM'){
                lDynamicUrl = $(daThis.triggeringElement).attr(lAttribute);
            }
            else if (lBasedOn == 'JAVASCRIPT'){
                lDynamicUrl = eval(lJavascriptExpression);
            }
            else{
                lDynamicUrl = $(lSelector).attr(lAttribute);
            }
        }

        // Logging
        if (lLogging) {
            apex.debug.trace('openDialog: Url:', lDynamicUrl);
        }

        // Apex Ajax Call
        apex.server.plugin(lAjaxIdentifier,
                           {x01:lDynamicUrl
                            },
                           { // SUCCESS function
                             success: function(pData) {
                                if (pData.success){
                                    eval(pData.message);
                                }
                             },
                             // ERROR function
                             error: function(xhr, pMessage) {
                                // log error in console
                                apex.debug.trace('openDialog: apex.server.plugin ERROR:', pMessage);
                             }
                            });
    }
};