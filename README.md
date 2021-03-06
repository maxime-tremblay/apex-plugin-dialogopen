# Oracle APEX Dynamic Action Plugin - Open Dialog
This dynamic action plugin is used to open a Dialog.

> :warning: Exposing the APEX_UTIL.PREPARE_URL API to the front-end can result in a security vulnerability. This is due to the fact that a user (or penetration tools) could then generate valid checksums for any page/item they want. To use the plugin you should be extra careful and use  additionnal security check on your pages so that you make sure that the user really has access to the page/record.

## Changelog
### 1.2
  - Removed the eval() function

### 1.1
  - New attributes
    - Javascript Expression
    - Dialog Triggering Element Selector
    - Page Checksum
  - Plugin code rework

### 1.0
  - Initial Release

## Install
- Import plugin file "dynamic_action_plugin_ca_maximet_apexdialogopen.sql" from source directory into your application
- (Optional) Deploy the JS files from "server" directory on your webserver and change the "File Prefix" to webservers folder.

## Plugin Settings
### Component Attribute
- **Type** - Type (Default: `Page in this application`)
  - Page in this application
  - Url
  - Dynamic
- **Page** - Page number or alphanumeric page alias (Only available when `Type = Page`)
- **Request** - Page request (Only available when `Type = Page`)
- **Clear Cache** - URL clear cache parameter (Only available when `Type = Page`)
- **Reset Pagination** - URL reset pagination parameter (Only available when `Type = Page`)
- **Item Names** - Comma-delimited list of item names to set session state (Only available when `Type = Page`)
- **Item Values** - Comma-delimited list of item values to set session state (Only available when `Type = Page`)
- **Url** - An f?p relative URL with all substitutions resolved. (Only available when `Type = Url`)
- **Based on** - Dynamic url based on. (Default: `Triggering Element`) (Only available when `Type = Dynamic`)
  - Triggering Element
  - jQuery Selector
  - Javascript Expression
- **jQuery Selector** - jQuery selector of the element from which the url is going to be retrieved. (Only available when `Based on = jQuery Selector`)
- **Attribute** - Element's attribute of the url. (Only available when `Based on = Triggering Element or jQuery Selector`)
- **Javascript Expression** - JavaScript expression returning the url. (Only available when `Based on = Javascript Expression`)
- **Dialog Triggering Element Selector** - jQuery selector of the element from which the dialog is going to be triggered.
- **Page Checksum** - Page checksum (Default: `Unrestricted`)
  - Unrestricted
  - Session Level
  - User Level
  - Application Level

## How to use
- Create a new "Open Dialog" Dynamic Action
- Set attributes to desired behaviour

## Preview
![](https://github.com/maxime-tremblay/apex-plugin-dialogopen/blob/master/preview.gif)
