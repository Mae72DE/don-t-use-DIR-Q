# don't use DIR /Q
… since the ownership info may be clipped - so let's use WMIC again in a CMD-Batch

This german CMD-Demo-Script should show how to do it: "OwnerOf [fileObject]"

For the moment this Script just output what DIR /Q cant't
- Everytime the full Owner-Name (Domain/User) and SID of a File or Folder
- Same output on every Windows-localisation

The User-Interface is german Text.

Next steps (?):
 - more Language Support?
 - Scanning/Listing Function like DIR-Command?
 - Other Output-Format?
 - Show ACEs/ACLs?
 - Integrate: icALSs/takeOwn?
