# TPZ-CORE Subscriptions

## Requirements

1. TPZ-Core: https://github.com/TPZ-CORE/tpz_core
2. TPZ-Characters: https://github.com/TPZ-CORE/tpz_characters
3. TPZ-Inventory: https://github.com/TPZ-CORE/tpz_inventory

# Installation

1. When opening the zip file, open `tpz_subscriptions-main` directory folder and inside there will be another directory folder which is called as `tpz_subscriptions`, this directory folder is the one that should be exported to your resources (The folder which contains `fxmanifest.lua`).

2. Add `ensure tpz_subscriptions` after the **REQUIREMENTS** in the resources.cfg or server.cfg, depends where your scripts are located.

## Commands 

- `@param steamId`  : Required the steam identifier (HEX): steam:xxxx0xxxxxxxxxx01xxxxxx01x
- `@param duration` : Requires a valid duration IN DAYS ONLY!

| Command                                 | Ace Permission                     | Description                                                              |
|-----------------------------------------|------------------------------------|--------------------------------------------------------------------------|
| addsubscription [steamId] [duration]    | tpzcore.subscriptions.add          | Execute this command to add a the selected user as a new subscription.                     |
| extendsubscription [steamId] [duration] | tpzcore.subscriptions.extend       | Execute this command to extend of the selected user the subscription expiration duration.  |
| setsubscription [steamId] [duration]    | tpzcore.subscriptions.set          | Execute this command to set of the selected user the subscription expiration duration.     |
| checksubscription [steamId]             | tpzcore.subscriptions.check        | Execute this command to check of the selected user the subscription expiration duration.   |

- The ace permission: `tpzcore.all` Gives permissioms to all commands and actions (FOR ALL OFFICIAL PUBLISHED FREE SCRIPTS).
- The ace permission: `tpzcore.subscriptions.all` Gives permissions to all commands related ONLY for this script.
