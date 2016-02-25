###A Lita handler that allows you manage a JSON link library.


####List of commands:

- `random read` => Returns a random entry from the lita link library.

- `give me a gooder` => Returns top 3 entries from the lita link library.

- `list library` => Returns the entire lita link library.

- `want to read TITLE` => Returns the entry with that TITLE from the lita link library.


######The link library itself can be managed by an authorized group of admins. This group is managed by a user defined via the `config.robot.admins` configuration attribute.

- `Lita auth add USER link_library_admins` => Adds USER as a link library admin.

- `Lita auth remove USER link_library_admins` => Removes USER from the link library admins group.

- `Lita auth list` => Displays all the current authorization groups and their members.


####Commands restricted to library admins:

- `add read LINK TITLE DESCRIPTION` => Adds a new entry with that LINK, TITLE and DESCRIPTION attributes in the lita link library.

- `remove read TITLE` => Removes the entry with that TITLE from the lita link library.


#### License

[MIT](http://opensource.org/licenses/MIT)
