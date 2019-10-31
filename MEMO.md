# MEMO

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
			"type": "vote",
			"id": 2,
			"quest": "ca va ?",
			"description": "yes ma men",
			"published": "2019-10-31T19:23:00.844Z",
			"status": 0,
			"voter_count": 1,
			"choice_count": 3
			"status": -1/0/1/2/3,
			"winner": -1/0/1/2/3,
		},
		{
			"type": "choice",
			"vote_id": 1,
			"index": 1,
			"text": "white",
			"vote_count": 0
		}
}
```

## Database
```
ActiveRecord::Schema.define(version: 2019_09_28_012006) do

  create_table "application_settings", force: :cascade do |t|
    t.integer "vote_timeline", default: 7
    t.integer "vote_min_valid", default: 50
  end

  create_table "choices", force: :cascade do |t|
    t.integer "vote_id"
    t.string "text"
    t.integer "vote_count"
    t.integer "index"
    t.integer "site_id" # id du vote
    t.datetime "updated"
  end

  create_table "sites", force: :cascade do |t|
    t.string "domain"
    t.string "mykey"
    t.string "itskey"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "passwd"
    t.string "voter_hash" # hash avec le quelle on vote
  end

  create_table "vote_logs", force: :cascade do |t|
    t.integer "vote_id"
    t.integer "vote"
    t.integer "site_id" # id du voteur
    t.string "voter_hash"
    t.datetime "updated"
  end

  create_table "votes", force: :cascade do |t|
    t.string "quest"
    t.text "description"
    t.datetime "published"
    t.integer "status", default: 0
    t.string "winner"
    t.integer "voter_count"
    t.integer "choice_count"
    t.integer "site_id", default: 1
    t.integer "real_id"
    t.datetime "updated"
  end

end
```
