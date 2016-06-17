// Apex Open Dialog Functions
// Author: Maxime Tremblay
// Version: 1.0

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
        var lType            = daThis.action.attribute03;
        var lPage;
        var lRequest;
        var lClearCache;
        var lResetPagination;
        var lItemNames;
        var lItemValues;
        var lUrl;
        var lBasedOn;
        var lSelector;
        var lAttribute;

        if (lType == 'PAGE'){
            lPage            = daThis.action.attribute04;
            lRequest         = daThis.action.attribute05;
            lClearCache      = daThis.action.attribute06;
            lResetPagination = daThis.action.attribute07;
            lItemNames       = daThis.action.attribute08;
            lItemValues      = daThis.action.attribute09;
        }
        else if (lType == 'URL'){
            lUrl = daThis.action.attribute10;
        }
        else if (lType == 'DYNAMIC'){
            lBasedOn   = daThis.action.attribute11;
            lSelector  = daThis.action.attribute12;
            lAttribute = daThis.action.attribute13;

            if (lBasedOn == 'TRIG_ELEM'){
                lUrl = $(daThis.triggeringElement).attr(lAttribute);
            }
            else{
                lUrl = $(lSelector).attr(lAttribute);
            }
        }

        // Logging
        if (lLogging) {
            apex.debug.trace('openDialog: Attribute Type:', lType);
            apex.debug.trace('openDialog: Attribute Page:', lPage);
            apex.debug.trace('openDialog: Attribute Request:', lRequest);
            apex.debug.trace('openDialog: Attribute Clear Cache:', lClearCache);
            apex.debug.trace('openDialog: Attribute Reset Pagination:', lResetPagination);
            apex.debug.trace('openDialog: Attribute Item Names:', lItemNames);
            apex.debug.trace('openDialog: Attribute Item Values:', lItemValues);
            apex.debug.trace('openDialog: Attribute Clear Cache:', lUrl);
            apex.debug.trace('openDialog: Attribute Clear Cache:', lUrl);
            apex.debug.trace('openDialog: Attribute Clear Cache:', lUrl);
            apex.debug.trace('openDialog: Attribute Clear Cache:', lUrl);
        }

        // Apex Ajax Call
        apex.server.plugin(lAjaxIdentifier,
                           {x01:lType,
                            x02:lPage,
                            x03:lRequest,
                            x04:lClearCache,
                            x05:lResetPagination,
                            x06:lItemNames,
                            x07:lItemValues,
                            x08:lUrl
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