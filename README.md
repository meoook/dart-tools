# dart-tools
Tools for any kind of project, like logger or yaml reader


## Marketplace

Rules:
- all actions in platform tokens AETH (AETH = ETH)
- users only from portal (login allowed from marketplace or redirect to platform and forget?)
- first login will init to get from portal or register wallet for user (send created wallet to user? crossplatfrom wallet - portal\market?)
- first login will save referal if it was
- first login users have zero AETH on wallet (even they have ETH on eth-chain)
- when wallet in eth-chain chainged (income) - same amount of AETH on users market balance
- game items income from game developers as ERC-721 tokens (in game user press on items that can be moved as ERC-721 token to eth-chain)

Problems:
- what to monitor in eth-chain (we need to monitor all wallets on ETH income) but we also need to monitor all other tokens? Or only ERC-721 our game developers.
- How game developers will register themselfs, game items?
- Will game developers place items in marketplace to sell or only users can?
- Can user chat with each other? Any global chats? Forums?
- Help page?

## Project parts

- [ ] Address\Tokens monitoring service - save eth-chain transactions (make events?)
- [ ] Django backend server to store users, items, inmarket transactions, get events from monitoring and save history for all actions.
- [ ] Django admin?
- [ ] Metric service?
- [ ] React frontend server (will be metamask integration?)

## Api lvl

Api only to read items. POST actions only for sell\buy orders.

## User can

- Be authed from portal
- Fill up wallet
- Lookup market items
- Filter items by game
- Sell items in his market 'backpack'
- buy items from other users
- send message to other user?

## Models

