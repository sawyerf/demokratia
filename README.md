# README

## INBOX
## json
```
{
	"site_key": "0800fc577294c34e0b28ad2839435945",
	"item":	{
			"type": "vote",
			"voter_hash": "0800fc577294c34e0b28ad2839435945",
			"vote_id": 5,
			"vote": 1
		}
	"item": {
			"type": "createvote",
			"voter_hash": "0800fc577294c34e0b28ad2839435945",
			"quest": "Ca va ?",
			"description": "Une description.",
			"choices": [
				"Blanc",
				"oui",
				"non"
			]
		}
}
```

## OUTBOX
## json
```
{
	"items": [
		{
			"type": "votelog",
			"voter_hash": "0800fc577294c34e0b28ad2839435945",
			"vote_id": 5,
			"vote": 1
		},
		{
			"type": "vote",
			"vote_id": 5,
			"quest": "ca va ?",
			"site": "site.com",
			"description": "Une description.",
			"published": "date"
			"voter_count": 10,
			"status": -1/0/1/2/3,
			"winner": -1/0/1/2/3,
			"choices": [
				{"quest": "Blanc", "vote_count": 1}
				{"quest": "oui", "vote_count": 5}
				{"quest": "non", "vote_count": 4}
			]
		},
}
```
