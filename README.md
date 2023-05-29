# NWinCall
NetWeaver (ABAP) BYOL-http-service

## Installation and prerequisites
1. Download package and install via abapGit
2. Also AnyTab Update Task should be installed (https://github.com/OlegBash599/AnyTabUpdateTask)
3. Assign authorization to user which create a http-request
4. Activate service **nwincall** via t-code SICF

## Features
1. Posting Message to Cluster Data Table and Starting in async mode processing
2. 

## Customization
1. Table **ZTMLT001_HNDL** is for adding extra handlers. The key is HTTP-method and url.
2. Table **ZTMLT001_MSGPARS** is for adding additional parser for apost message processing.
3. Table **ZTMLT001_EVENTS** is for adding event processor. Usually message parsing could generate some event.
