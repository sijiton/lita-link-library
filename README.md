A Lita handler that allows you manage a JSON link library.


List of commands:

'random read' => 'Returns a random entry from the lita link library.'

'give me a gooder' => 'Returns top 3 entries from the lita link library.'

'list library' => 'Returns entire lita link library.'

'want to read TITLE' => 'Returns the entry from lita link library with that TITLE.'


The link library itself can be managed by an authorized group of admins. The group is managed by a user defined via the config.robot.admins configuration attribute.

'Lita auth add USER link_library_admins' => 'Adds USER as a library admin'

'Lita auth remove USER link_library_admins' => 'Removes USER from the library admins group'

'Lita auth list' => 'Displays all the current authorization groups and their members'


Commands restricted to library admins:

'add read LINK TITLE DESCRIPTION' => 'Adds a new entry in thelita link library with that LINK, TITLE and DESCRIPTION attributes.'

remove read TITLE' => 'Removes the entry from lita link library with that TITLE.'

