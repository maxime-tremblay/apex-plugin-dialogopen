# Oracle APEX Dynamic Action Plugin - Open Dialog
This dynamic action plugin is used to open a Dialog.

## Changelog
### 1.0 - Initial Release

## Install
- Import plugin file "dynamic_action_plugin_ca_maximet_apexdialogopen.sql" from source directory into your application
- (Optional) Deploy the JS files from "server" directory on your webserver and change the "File Prefix" to webservers folder.

## Plugin Settings
### Component Attribute
- **Type** - Type  (Default: Close Notification)
  - Redirect to Page in this Application
  - Redirect to URL
  - Dynamic
- **Page** - Page number (Only available when `Type = Page`)
- **Request** - URL request parameter (Only available when `Type = Page`)
- **Clear Cache** - URL clear cache parameter (Only available when `Type = Page`)
- **Reset Pagination** - URL reset pagination parameter (Only available when `Type = Page`)
- **Item Names** - Comma-delimited list of item names to set session state (Only available when `Type = Page`)
- **Item Values** - Comma-delimited list of item values to set session state (Only available when `Type = Page`)
- **Url** - Close Notification Text (Default: Close Notification) (Only available when `Type = Url`)
- **Based on** - Close Notification Text (Default: Close Notification) (Only available when `Type = Dynamic`)
- **jQuery Selector** - Close Notification Text (Default: Close Notification, Only shown when  `Type = Dynamic`)
- **Attribute** - Close Notification Text (Default: Close Notification)

## How to use
- Create a new "Open Dialog" Dynamic Action
- Set attributes to desired behaviour

## Preview
![](https://github.com/maxime-tremblay/apex-plugin-dialogopen/blob/master/preview.gif)
