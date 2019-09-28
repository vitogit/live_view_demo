# Roll & Music together

This is my entry in [Phoenix Phrenzy](https://phoenixphrenzy.com), showing off what [Phoenix](https://phoenixframework.org/) and [LiveView](https://github.com/phoenixframework/phoenix_live_view) can do.

![App Name Here preview](http://g.recordit.co/awvCS6MLyA.gif)

# What it is?
Do you like play Pen & Paper Rpg over the internet with your friends? Games like Dungeons & Dragons, Vampire, Call of Cthulhu.
Do you want a virtual place to roll the dices so your party can see it?
Do you want to listen to the same music together to make your campaign more epic?

Well this app can do it. It will generate a random room that you can join and share the link with your friends. Then you can chat, roll dices and add a youtube playlist with music that it will sync for everyone in the room.

Roll 2 dices of 6 using this command in the chat `/r 2d6`, add a new playlist pasting in the second input field, like this one (Phoenix and Elixir tutorials): https://www.youtube.com/playlist?list=PLtTtLKRL6UYGxOHToRYnXBynon5plZ7Jd


# Development

The idea is to show the power of Phoenix Live View so I tried to use no javascript. This currently allows you to add a new youtube playlist, play the playlist, stop the playlist and move to the next or previous video. This is done changing the variables of the youtube playlist, like autostart=1 to start the video , autostart=0 to stop it, index=index+1 to advance to the next video. Phoenix will reload the video when the video string changes.

I have experience in Ruby on Rails but this is my first Phoenix project so probably a lot of the code needs improvements. If you have comments let me know I'm here to learn (Open an issue, create a new pr, etc).

# Limitations

Currently just the stop, play, next, prev buttons works. 
Select a position in the video can't be done without using the youtube js api so it will not be part of this app at the moment, as I can show what it's possible with Live Reload.

Also to be in sync all users must be in the room when the play, stop, next, prev actions take place. If a user enter after the video is playing it will no be in sync. To sync again, one of the player can paste the link again and use the start and index variable to select start time and video from the playlist
Like this:
https://www.youtube.com/playlist?list=PLtTtLKRL6UYGxOHToRYnXBynon5plZ7Jd&start=50&index=3


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
