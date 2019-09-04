# Roll & Music together

This is my entry in [Phoenix Phrenzy](https://phoenixphrenzy.com), showing off what [Phoenix](https://phoenixframework.org/) and [LiveView](https://github.com/phoenixframework/phoenix_live_view) can do.

![App Name Here preview](assets/static/images/preview.gif "App Name Here")

# What it is?
Do you like play Pen & Paper Rpg over the internet with your friends? Games like Dungeons & Dragons, Vampire, Call of Cthulhu.
Do you want a virtual place to roll the dices so your party can see it?
Do you want to listen to the same music together to make your campaign more epic?

Well this app can do it. It will generate a random room that you can join and share the link with your friends. Then you can chat, roll dices and add a youtube playlist with music that it will sync for everyone in the room.

Roll 2 dices of 6 using this command in the chat `/r 2d6`, add a new playlist pasting in the second input field, like this one (Phoenix and Elixir tutorials): https://www.youtube.com/playlist?list=PLtTtLKRL6UYGxOHToRYnXBynon5plZ7Jd


# Development

The idea is to show the power of Phoenix Live View so I tried to use almost no javascript. This currently allows you to add a new youtube playlist, play the playlist and stop the playlist. This is done changing the variables of the youtube playlist, like autostart=1 to start the video , autostart=0 to stop it. Phoenix will reload the video when the video string changes.

# Limitations

Currently just the stop, play, next, prev buttons works. 
Select a position in the video can't be done without using the youtube js api so it will not be part of this app at the moment, as I can show what it's possible with Live Reload.


## The Usual README Content

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
