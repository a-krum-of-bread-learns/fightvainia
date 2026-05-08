extends RichTextLabel

func _ready():
	bbcode_enabled = true
	meta_clicked.connect(_on_link_clicked)
	text = "please use the itch.io comments for feedback	\nThe WIP Github project: [url=https://github.com/a-krum-of-bread/fightvainia]GitHub[/url]\nTwitch: [url=https://www.twitch.tv/a_krum_of_bread_learns]Twitch[/url]\nYoutube: [url=https://www.youtube.com/@A_krum_of_bread_learns]Youtube[/url]\n\n\n"

func _on_link_clicked(meta):
	OS.shell_open(meta)
