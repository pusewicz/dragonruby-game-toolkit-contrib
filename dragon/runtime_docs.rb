# coding: utf-8
# Copyright 2019 DragonRuby LLC
# MIT License
# runtime_docs.rb has been released under MIT (*only this file*).

# Contributors outside of DragonRuby who also hold Copyright:
# Ketan Patel: https://github.com/cookieoverflow

module RuntimeDocs
  def docs_method_sort_order
    [
      :docs_class_macros,

      :docs_indie_pro_functions,
      # indie/pro
      :docs_get_pixels,
      :docs_dlopen,

      # environment
      :docs_environment_functions,
      :docs_calcstringbox,

      :docs_request_quit,
      :docs_quit_requested?,
      :docs_set_window_fullscreen,
      :docs_window_fullscreen?,
      :docs_set_window_scale,

      :docs_platform?,
      :docs_production?,
      :docs_platform_mappings,
      :docs_open_url,
      :docs_system,
      :docs_exec,

      :docs_show_cursor,
      :docs_hide_cursor,
      :docs_cursor_shown?,

      :docs_set_mouse_grab,
      :docs_set_system_cursor,
      :docs_set_cursor,

      # file
      :docs_file_access_functions,
      :docs_list_files,
      :docs_stat_file,
      :docs_read_file,
      :docs_write_file,
      :docs_append_file,
      :docs_delete_file,
      :docs_delete_file_if_exist,

      # encodings
      :docs_encoding_functions,
      :docs_parse_json,
      :docs_parse_json_file,
      :docs_parse_xml,
      :docs_parse_xml_file,

      #network
      :docs_network_functions,
      :docs_http_get,
      :docs_http_post,
      :docs_http_post_body,
      :docs_start_server!,

      #dev support
      :docs_dev_support_functions,
      :docs_version,
      :docs_version_pro?,

      :docs_reset,
      :docs_reset_next_tick,
      :docs_reset_sprite,
      :docs_reset_sprites,
      :docs_calcspritebox,

      :docs_current_framerate,
      :docs_framerate_diagnostics_primitives,
      :docs_warn_array_primitives!,
      :docs_benchmark,

      :docs_notify!,
      :docs_notify_extended!,
      :docs_slowmo!,

      :docs_show_console,
      :docs_hide_console,
      :docs_enable_console,
      :docs_disable_console,
      :docs_disable_reset_via_ctrl_r,

      :docs_start_recording,
      :docs_stop_recording,
      :docs_cancel_recording,
      :docs_start_replay,
      :docs_stop_replay,

      :docs_get_base_dir,
      :docs_get_game_dir,
      :docs_get_game_dir_url,
      :docs_open_game_dir,

      :docs_write_file_root,
      :docs_append_file_root,

      :docs_argv,
      :docs_cli_arguments,

      :docs_download_stb_rb,

      :docs_reload_history,
      :docs_reload_history_pending,
      :docs_reload_if_needed,

      :docs_api_summary_state,
      :docs_add_caller_to_puts!
    ]
  end

  def docs_class_macros
    <<-S
** Class Macros
The following class macros are available within DragonRuby.

*** ~attr~
The ~attr~ class macro is an alias to ~attr_accessor~.

Instead of:

#+begin_src
  class Player
    attr_accessor :hp, :armor
  end
#+end_src

You can do:

#+begin_src
  class Player
    attr :hp, :armor
  end
#+end_src

*** ~attr_gtk~
As the size/complexity of your game increases. You may want to create classes to
organize everything. The ~attr_gtk~ class macro adds DragonRuby's environment
methods (such as ~args.state~, ~args.inputs~, ~args.outputs~, ~args.audio~, etc) to
your class so you don't have to pass ~args~ around everwhere.

Instead of:

#+begin_src
  class Game
    def tick args
      defaults args
      calc args
      render args
    end

    def defaults args
      args.state.space_pressed_at ||= 0
    end

    def calc args
      if args.inputs.keyboard.key_down.space
        args.state.space_pressed_at = args.state.tick_count
      end
    end

    def render args
      if args.state.space_pressed_at == 0
        args.outputs.labels << { x: 100, y: 100,
                                 text: "press space" }
      else
        args.outputs.labels << { x: 100, y: 100,
                                 text: "space was pressed at: \#{args.state.space_pressed_at}" }
      end
    end
  end

  def tick args
    $game ||= Game.new
    $game.tick args
  end
#+end_src

You can do:

#+begin_src
  class Game
    attr_gtk # attr_gtk class macro

    def tick
      defaults
      calc
      render
    end

    def defaults
      state.space_pressed_at ||= 0
    end

    def calc
      if inputs.keyboard.key_down.space
        state.space_pressed_at = state.tick_count
      end
    end

    def render
      if state.space_pressed_at == 0
        outputs.labels << { x: 100, y: 100,
                            text: "press space" }
      else
        outputs.labels << { x: 100, y: 100,
                            text: "space was pressed at: \#{state.space_pressed_at}" }
      end
    end
  end

  def tick args
    $game ||= Game.new
    $game.args = args # set args property on game
    $game.tick        # call tick without passing in args
  end

  $game = nil
#+end_src
S
  end

  def docs_indie_pro_functions
    <<-S
** Indie and Pro Functions
The following functions are only available at the Indie and Pro License tiers.
S
  end

  def docs_class
    <<-S
* ~Runtime~ (~args.gtk~)
The ~GTK::Runtime~ class is the core of DragonRuby. It is globally
accessible via ~$gtk~ or inside of the ~tick~ method through ~args~.

#+begin_src
  def tick args
    args.gtk # accessible like this
    $gtk # or like this
  end
#+end_src
S
  end

  def docs_get_pixels
    <<-S
*** ~get_pixels~
Given a ~file_path~ to a sprite, this function returns a ~Hash~ with ~w~, ~h~, and
~pixels~. The ~pixels~ key contains an array of hexadecimal values representing the
ABGR of each pixel in a sprite with item ~0~ representing the top left corner of the
~png~.

Here's an example of how to get the color data for a pixel:

#+begin_src
  def tick args
    # load the pixels from the image
    args.state.image ||= args.gtk.get_pixels "sprites/square/blue.png"

    # initialize state variables for the pixel coordinates
    args.state.x_px ||= 0
    args.state.y_px ||= 0

    sprite_pixels = args.state.image.pixels
    sprite_h = args.state.image.h
    sprite_w = args.state.image.w

    # move the pixel coordinates using keyboard
    args.state.x_px += args.inputs.left_right
    args.state.y_px += args.inputs.up_down

    # get pixel at the current coordinates
    args.state.x_px = args.state.x_px.clamp(0, sprite_w - 1)
    args.state.y_px = args.state.y_px.clamp(0, sprite_h - 1)
    row = sprite_h - args.state.y_px - 1
    col = args.state.x_px
    abgr = sprite_pixels[sprite_h * row + col]
    a = (abgr >> 24) & 0xff
    b = (abgr >> 16) & 0xff
    g = (abgr >> 8) & 0xff
    r = (abgr >> 0) & 0xff

    # render debug information
    args.outputs.debug << "row: \#{row} col: \#{col}"
    args.outputs.debug << "pixel entry 0: rgba \#{r} \#{g} \#{b} \#{a}"

    # render the sprite plus crosshairs
    args.outputs.sprites << { x: 0, y: 0, w: 80, h: 80, path: "sprites/square/blue.png" }
    args.outputs.lines << { x: args.state.x_px, y: 0, h: 720 }
    args.outputs.lines << { x: 0, y: args.state.y_px, w: 1280 }
  end
#+end_src

See the following sample apps for how to use pixel arrays:

- ~./samples/07_advanced_rendering/06_pixel_arrays~
- ~./samples/07_advanced_rendering/06_pixel_arrays_from_file~
S
  end

  def docs_dlopen
    <<-S
*** ~dlopen~
Loads a precompiled C Extension into your game.

See the sample apps at ~./samples/12_c_extensions~ for detailed
walkthroughs of creating C extensions.
S
  end

  def docs_environment_functions
    <<-S
** Environment and Utility Functions
The following functions will help in interacting with the OS and rendering pipeline.
S
  end

  def docs_calcstringbox
    <<-S
*** ~calcstringbox~
Returns the render width and render height as a tuple for a piece of text. The
parameters this method takes are:
- ~text~: the text you want to get the width and height of.
- ~size_enum~: number representing the render size for the text. This
  parameter is optional and defaults to ~0~ which represents a
  baseline font size in units specific to DragonRuby (a negative value
  denotes a size smaller than what would be comfortable to read on a
  handheld device postive values above ~0~ represent larger font sizes).
- ~font~: path to a font file that the width and height will be based
  off of. This field is optional and defaults to the DragonRuby's
  default font.

#+begin_src
  def tick args
    text = "a piece of text"
    size_enum = 5 # "large font size"

    # path is relative to your game directory (eg mygame/fonts/courier-new.ttf)
    font = "fonts/courier-new.ttf"

    # get the render width and height
    string_w, string_h = args.gtk.calcstringbox text, size_enum, font

    # render the label
    args.outputs.labels << {
      x: 100,
      y: 100,
      text: text,
      size_enum: size_enum,
      font: font
    }

    # render a border around the label based on the results from calcstringbox
    args.outputs.borders << {
      x: 100,
      y: 100,
      w: string_w,
      h: string_h,
      r: 0,
      g: 0,
      b: 0
    }
  end
#+end_src
S
  end

  def docs_request_quit
    <<-S
*** ~request_quit~
Call this function to exit your game. You will be given one additional tick
if you need to perform any housekeeping before that game closes.

#+begin_src
  def tick args
    # exit the game after 600 frames (10 seconds)
    if args.state.tick_count == 600
      args.gtk.request_quit
    end
  end
#+end_src
S
  end

  def docs_quit_requested?
    <<-S
*** ~quit_requested?~
This function will return ~true~ if the game is about to exit (either
from the user closing the game or if ~request_quit~ was invoked).
S
  end

  def docs_set_window_scale
    <<-S
*** ~set_window_scale~
This function takes in a float value and uses that to resize the game window
to a percentage of 1280x720 (or 720x1280 in portrait mode). The valid scale options
are 0.1, 0.25, 0.5, 0.75, 1.25, 1.5, 2.0, 2.5, 3.0, and 4.0. The float value you
pass in will be floored to the nearest valid scale option.
S
  end

  def docs_set_window_fullscreen
    <<-S
*** ~set_window_fullscreen~
This function takes in a single boolean parameter. ~true~ to make the
game fullscreen, ~false~ to return the game back to windowed mode.

#+begin_src
  def tick args
    # make the game full screen after 600 frames (10 seconds)
    if args.state.tick_count == 600
      args.gtk.set_window_fullscreen true
    end

    # return the game to windowed mode after 20 seconds
    if args.state.tick_count == 1200
      args.gtk.set_window_fullscreen false
    end
  end
#+end_src
S
  end

  def docs_window_fullscreen?
    <<-S
*** ~window_fullscreen?~
Returns true if the window is currently in fullscreen mode.
S
  end

  def docs_open_url
    <<-S
*** ~open_url~
Given a uri represented as a string. This fuction will open the uri in the user's default browser.

#+begin_src
  def tick args
    # open a url after 600 frames (10 seconds)
    if args.state.tick_count == 600
      args.gtk.open_url "http://dragonruby.org"
    end
  end
#+end_src
S
  end

  def docs_system
    <<-S
*** ~system~
Given an OS dependent cli command represented as a string, this
function executes the command and ~puts~ the results to the DragonRuby
Console (returns ~nil~).

#+begin_src
  def tick args
    # execute ls on the current directory in 10 seconds
    if args.state.tick_count == 600
      args.gtk.system "ls ."
    end
  end
#+end_src
S
  end

  def docs_exec
    <<-S
*** ~exec~
Given an OS dependent cli command represented as a string, this
function executes the command and returns a ~string~ representing the results.

#+begin_src
  def tick args
    # execute ls on the current directory in 10 seconds
    if args.state.tick_count == 600
      results = args.gtk.exec "ls ."
      puts "The results of the command are:"
      puts results
    end
  end
#+end_src
S
  end

  def docs_show_cursor
    <<-S
*** ~show_cursor~
Shows the mouse cursor.
S
  end

  def docs_hide_cursor
 <<-S
*** ~hide_cursor~
Hides the mouse cursor.
S
  end

  def docs_cursor_shown?
 <<-S
*** ~cursor_shown?~
Returns ~true~ if the mouse cursor is visible.
S
  end

  def docs_set_mouse_grab
    <<-S
*** ~set_mouse_grab~
Takes in a numeric parameter representing the mouse grab mode.
- ~0~: Ungrabs the mouse.
- ~1~: Grabs the mouse.
- ~2~: Hides the cursor, grabs the mouse and puts it in relative position mode accessible via ~args.inputs.mouse.relative_(x|y)~.
S
  end

  def docs_set_system_cursor
    <<-S
*** ~set_system_cursor~
Takes in a string value of ~"arrow"~, ~"ibeam"~, ~"wait"~, or ~"hand"~
and sets the mouse curosor to the corresponding system cursor (if available on the OS).
S
  end

  def docs_set_cursor
    <<-S
*** ~set_cursor~
Replaces the mouse cursor with a sprite. Takes in a ~path~ to the sprite, and optionally an ~x~ and ~y~ value
representing the realtive positioning the sprite will have to the mouse cursor.

#+begin_src
  def tick args
    if args.state.tick_count == 0
      # assumes a sprite of size 80x80 and centers the sprite
      # relative to the cursor position.
      args.gtk.set_cursor "sprites/square/blue.png", 40, 40
    end
  end
#+end_src
S
  end

  def docs_read_file
    <<-S
*** ~read_file~
Given a file path, a string will be returned representing the contents
of the file. ~nil~ will be returned if the file does not exist. You
can use ~stat_file~ to get additional information of a
file.
S
  end

  def docs_delete_file_if_exist
    <<-S
*** ~delete_file_if_exist~
Has the same behavior as ~delete_file~ except this
function does not throw an exception.
S
  end

  def docs_encoding_functions
    <<-S
** XML and JSON
The following functions help with parsing xml and json.
S
  end

  def docs_parse_json
    <<-S
*** ~parse_json~
Given a json string, this function returns a hash representing the
json data.

#+begin_src
  hash = args.gtk.parse_json '{ "name": "John Doe", "aliases": ["JD"] }'
  # structure of hash: { "name"=>"John Doe", "aliases"=>["JD"] }
#+end_src
S
  end

  def docs_parse_json_file
    <<-S
*** ~parse_json_file~
Same behavior as ~parse_json_file~ except a file path is
read for the json string.
S
  end

  def docs_parse_xml
    <<-S
*** ~parse_xml~
Given xml data as a string, this function will return a hash that
represents the xml data in the following recursive structure:

#+begin_src
{
  type: :element,
  name: "Person",
  children: [...]
}
#+end_src
S
  end

  def docs_parse_xml_file
    <<-S
*** ~parse_xml_file~
Function has the same behavior as ~parse_xml~ except that
the parameter must be a file path that contains xml contents.
S
  end

  def docs_network_functions
    <<-S
** Network IO Functions
The following functions help with interacting with the network.
S
  end

  def docs_http_get
    <<-S
*** ~http_get~
Returns an object that represents an http response which will
eventually have a value. This http_get method is invoked
asynchronously. Check for completion before attempting to read results.

#+begin_src
  def tick args
    # perform an http get and print the response when available
    args.state.result ||= args.gtk.http_get "https://httpbin.org/html"

    if args.state.result && args.state.result[:complete] && !args.state.printed
      if args.state.result[:http_response_code] == 200
        puts "The response was successful. The body is:"
        puts args.state.result[:response_data]
      else
        puts "The response failed. Status code:"
        puts args.state.result[:http_response_code]
      end
      # set a flag denoting that the response has been printed
      args.state.printed = true

      # show the console
      args.gtk.show_console
    end
  end
#+end_src
S
  end

  def docs_http_post
    <<-S
*** ~http_post~
Returns an object that represents an http response which will
eventually have a value. This http_post method is invoked
asynchronously. Check for completion before attempting to read results.

- First parameter: The url to send the request to.
- Second parameter: Hash that represents form fields to send.
- Third parameter: Headers. Note: Content-Type must be form encoded
                   flavor. If you are unsure of what to pass in, set the content type
                   to application/x-www-form-urlencoded

#+begin_src
  def tick args
    # perform an http get and print the response when available

    args.state.form_fields ||= { "userId" => "#{Time.now.to_i}" }
    args.state.result ||= args.gtk.http_post "http://httpbin.org/post",
                                             args.state.form_fields,
                                             ["Content-Type: application/x-www-form-urlencoded"]


    if args.state.result && args.state.result[:complete] && !args.state.printed
      if args.state.result[:http_response_code] == 200
        puts "The response was successful. The body is:"
        puts args.state.result[:response_data]
      else
        puts "The response failed. Status code:"
        puts args.state.result[:http_response_code]
      end
      # set a flag denoting that the response has been printed
      args.state.printed = true

      # show the console
      args.gtk.show_console
    end
  end
#+end_src
S
  end

  def docs_http_post_body
    <<-S
*** ~http_post_body~
Returns an object that represents an http response which will
eventually have a value. This http_post_body method is invoked
asynchronously. Check for completion before attempting to read results.

- First parameter: The url to send the request to.
- Second parameter: String that represents the body that will be sent
- Third parameter: Headers. Be sure to populate the Content-Type that
                   matches the data you are sending.

#+begin_src
  def tick args
    # perform an http get and print the response when available

    args.state.json ||= "{ \"userId\": \"\#{Time.now.to_i}\"}"
    args.state.result ||= args.gtk.http_post_body "http://httpbin.org/post",
                                                  args.state.json,
                                                  ["Content-Type: application/json", "Content-Length: \#{args.state.json.length}"]


    if args.state.result && args.state.result[:complete] && !args.state.printed
      if args.state.result[:http_response_code] == 200
        puts "The response was successful. The body is:"
        puts args.state.result[:response_data]
      else
        puts "The response failed. Status code:"
        puts args.state.result[:http_response_code]
      end
      # set a flag denoting that the response has been printed
      args.state.printed = true

      # show the console
      args.gtk.show_console
    end
  end
#+end_src
S
  end

  def docs_start_server!
    <<-S
*** ~start_server!~
Starts a in-game http server that can be process http requests. When
your game is running in development mode. A dev server is started at
~http://localhost:9001~

You can start an in-game http server in production via:

#+begin_src
  def tick args
    # server explicitly enabled in production
    args.gtk.start_server! port: 9001, enable_in_prod: true
  end
#+end_src

Here's how you would responde to http requests:

#+begin_src
  def tick args
    # server explicitly enabled in production
    args.gtk.start_server! port: 9001, enable_in_prod: true

    # loop through pending requests and respond to them
    args.inputs.http_requests.each do |request|
      puts "\#{request}"
      request.respond 200, "ok"
    end
  end
#+end_src
S
  end

  def docs_dev_support_functions
    <<-S
** Developer Support Functions
The following functions help support the development process. It is not recommended to use this functions in "production" game logic.
S
  end

  def docs_version
    <<-S
*** ~version~
Returns a string representing the version of DragonRuby you are running.
S
  end

  def docs_version_pro?
    <<-S
*** ~version_pro?~
Returns ~true~ if the version of DragonRuby is NOT Standard Edition.
S
  end

  def docs_reset
    <<-S
*** ~reset~
Resets DragonRuby's internal state as if it were just
started. ~args.state.tick_count~ is set to ~0~ and ~args.state~ is
cleared of any values. This function is helpful when you are
developing your game and want to reset everything as if the game just
booted up.

#+begin_src
  def tick args
  end

  # reset the game if this file is hotloaded/required
  # (removes the need to press "r" when I file is updated)
  $gtk.reset
#+end_src

**** Resetting iVars (advanced)

NOTE: ~args.gtk.reset~ does not reset global variables or instance of
classes you have have constructed. If you want to also reset global
variables or instances of classes when $gtk.reset is called. Define
a ~reset~ method. Here's an example:

#+begin_src
  class Game
    def initialize
      puts "Game initialize called"
    end
  end

  def tick args
    $game ||= Game.new

    if args.state.tick_count == 0
      puts "tick_count is 0"
    end

    # if r is pressed on the keyboard, reset the game
    if args.inputs.keyboard.key_down.r
      args.gtk.reset
    end
  end

  # custom reset function
  def reset
    puts "Custom reset function was called."
    $game = nil
  end
#+end_src

**** ~seed~ and RNG (advanced)

Optionally, ~$gtk.reset~ (~args.gtk.reset~) can take in a named parameter for
RNG called ~seed:~. Passing in ~seed:~ will reset RNG so that ~rand~ returns
a repeatable set of random numbers. This ~seed~ value is initialized with the
start time of your game (~$gtk.started_at~). Having this option is is helpful
for replays and unit tests.

Don't worry about this capability if you aren't using DragonRuby's unit testing,
or replay capabilities.

Here is the behavior of ~$gtk.reset~ when given a seed:

- RNG is seeded initially with the ~Time~ value of the launch of your game (retrievable via ~$gtk.started_at~).
- Calling $gtk.reset will reset your game and re-initialize your RNG with this initial seed value.
- Calling $gtk.reset with a ~:seed~ parameter will update the seed value for the current and subsequent resets.
- You can get the value used to seed RNG via ~$gtk.seed~.
- You can set your RNG seed back to its original value by using ~$gtk.started_at~.

#+begin_src
  def tick args
    if args.state.tick_count == 0
      puts rand
      puts rand
      puts rand
      puts rand
    end
  end

  puts "Started at (RNG seed inital value)"
  puts $gtk.started_at # Time as an integer that your game was started at

  puts "Seed value that will be used on reset"
  puts $gtk.seed # current value that RNG was seeded with

  # reset the game and use the last seed to reset RNG
  $gtk.reset

  # === OR ===
  # sets the seed value to predefined value
  # subsequent resets will use the new predefined value
  # $gtk.reset seed: 100
  # (or shorthand)
  # $gtk.reset 100

  # sets the seed back to its original value
  # $gtk.reset seed: $gtk.started_at
#+end_src

If you want to set RNG without resetting your game state, you can use ~$gtk.set_rng VALUE~.
S
  end

  def docs_reset_next_tick
    <<-S
*** ~reset_next_tick~
Has the same behavior as ~reset~ except the reset occurs
before ~tick~ is executed again. ~reset~ resets the
environment immediately (while the ~tick~ method is inflight). It's
recommended that ~reset~ should be called outside of the tick method
(invoked when a file is saved/hotloaded), and ~reset_next_tick~ be
used inside of the ~tick~ method so you don't accidentally blow away state
the your game depends on to complete the current ~tick~ without exceptions.

#+begin_src
  def tick args
    # reset the game if "r" is pressed on the keyboard
    if args.inputs.keyboard.key_down.r
      args.gtk.reset_next_tick # use reset_next_tick instead of reset
    end
  end

  # reset the game if this file is hotloaded/required
  # (removes the need to press "r" when I file is updated)
  $gtk.reset
#+end_src
S
  end

  def docs_reset_sprite
    <<-S
*** ~reset_sprite~
Sprites when loaded are cached. Given a string parameter, this method invalidates the cache
record of a sprite so that updates on from the disk can be loaded.
S
  end

  def docs_reset_sprites
    <<-S
*** ~reset_sprites~
Sprites when loaded are cached. This method invalidates the cache
record of all sprites so that updates on from the disk can be loaded. This function is automatically
called when ~args.gtk.reset~ (~$gtk.reset~) is invoked.
S
  end

  def docs_calcspritebox
    <<-S
*** ~calcspritebox~
Given a path to a sprite, this method returns the ~width~ and ~height~ of a sprite as a tuple.

NOTE: This method should be used for development purposes only and is
      expensive to call every frame. Do not use this method to set the
      size of sprite when rendering (hard code those values since you
      know what they are beforehand).
S
  end

  def docs_current_framerate
    <<-S
*** ~current_framerate~
Returns a float value representing the framerate of your game. This is
an approximation/moving average of your framerate and should
eventually settle to 60fps.

#+begin_src
  def tick args
    # render a label to the screen that shows the current framerate
    # formatted as a floating point number with two decimal places
    args.outputs.labels << { x: 30, y: 30.from_top, text: "\#{args.gtk.current_framerate.to_sf}" }
  end
#+end_src
S
  end

  def docs_framerate_diagnostics_primitives
    <<-S
*** ~framerate_diagnostics_primitives~
Returns a set of primitives that can be rendered to the screen which
provide more detailed information about the speed of your simulation
(framerate, draw call count, mouse position, etc).

#+begin_src
  def tick args
    args.outputs.primitives << args.gtk.framerate_diagnostics_primitives
  end
#+end_src
S
  end

  def docs_warn_array_primitives!
    <<-S
*** ~warn_array_primitives!~
This function helps you audit your game of usages of array-based
primitives. While array-based primitives are simple to create and use,
they are slower to process than ~Hash~ or ~Class~ based primitives.

#+begin_src
  def tick args
    # enable array based primitives warnings
    args.gtk.warn_array_primitives!

    # array-based primitive elsewhere in code
    # an log message will be posted giving the location of the array
    # based primitive usage
    args.outputs.sprites << [100, 100, 200, 200, "sprites/square/blue.png"]

    # instead of using array based primitives, migrate to hashes as needed
    args.outputs.sprites << {
      x: 100,
      y: 100,
      w: 200,
      h: 200, path:
      "sprites/square/blue.png"
    }
  end
#+end_src
S
  end

  def docs_notify!
    <<-S
*** ~notify!~
Given a string, this function will present a message at the bottom of
your game. This method is only invoked in dev mode and is useful for debugging.

An optional parameter of duration (number value representing ticks)
can also be passed in. The default value if ~300~ ticks (5 seconds).

#+begin_src
  def tick args
    if args.inputs.mouse.click
      args.gtk.notify! "Mouse was clicked!"
    end

    if args.inputs.keyboard.key_down.r
      # optional duration parameter
      args.gtk.notify! "R key was pressed!", 600 # present message for 10 seconds/600 frames
    end
  end
#+end_src
S
  end

  def docs_notify_extended!
    <<-S
*** ~notify_extended!~
Has similar behavior as notify! except you have additional options to
show messages in a production environment.
#+begin_src
  def tick args
    if args.inputs.mouse.click
      args.gtk.notify_extended! message: "message",
                                duration: 300,
                                env: :prod
    end
  end
#+end_src
S
  end

  def docs_slowmo!
    <<-S
*** ~slowmo!~
Given a numeric value representing the factor of 60fps. This function
will bring your simulation loop down to slower rate. This method is
intended to be used for debugging purposes.

#+begin_src
  def tick args
    # set your simulation speed to (15 fps): args.gtk.slowmo! 4
    # set your simulation speed to (1 fps): args.gtk.slowmo! 60
    # set your simulation speed to (30 fps):
    args.gtk.slowmo! 2
  end
#+end_src

Remove this line from your tick method will automatically set your
simulation speed back to 60 fps.
S
  end

  def docs_show_console
    <<-S
*** ~show_console~
Shows the DragonRuby console. Useful when debugging/customizing an
in-game dev workflow.
S
  end

  def docs_hide_console
    <<-S
*** ~hide_console~
Shows the DragonRuby console. Useful when debugging/customizing an
in-game dev workflow.
S
  end

  def docs_enable_console
    <<-S
*** ~enable_console~
Enables the DragonRuby Console so that it can be presented by pressing
the tilde key (the key next to the number 1 key).
S
  end

  def docs_disable_console
    <<-S
*** ~disable_console~
Disables the DragonRuby Console so that it won't show up even if you
press the tilde key or call ~args.gtk.show_console~.
S
  end

  def docs_disable_reset_via_ctrl_r
    <<-S
*** ~disable_reset_via_ctrl_r~
By default, pressing ~CTRL+R~ invokes ~$gtk.reset_next_tick~ (safely resetting your game with a convenient key combo).

If you want to disable this behavior, add the following to the ~main.rb~:

#+begin_src
  def tick args
    ...
  end

  $gtk.disable_reset_via_ctrl_r
#+end_src

NOTE: ~$gtk.disable_console~ will also disable the ~CTRL+R~ reset behavior.
S
  end

  def docs_start_recording
    <<-S
*** ~start_recording~
Resets the game to tick ~0~ and starts recording gameplay. Useful for
visual regression tests/verification.
S
  end

  def docs_stop_recording
    <<-S
*** ~stop_recording~
Function takes in a destination file for the currently recording
gameplay. This file can be used to replay a recording.
S
  end

  def docs_cancel_recording
    <<-S
*** ~cancel_recording~
Function cancels a gameplay recording session and discards the replay.
S
  end

  def docs_start_replay
    <<-S
*** ~start_replay~
Given a file that represents a recording, this method will run the
recording against the current codebase.

You can start a replay from the command line also:

#+begin_src bash
  # first argument: the game directory
  # --replay switch is the file path relative to the game directory
  # --speed switch is optional. a value of 4 will run the replay and game at 4x speed
  # cli command example is in the context of Linux and Mac, for Windows the binary would be ./dragonruby.exe
  ./dragonruby ./mygame --replay ./replay.txt --speed 4
#+end_src
S
  end

  def docs_stop_replay
    <<-S
*** ~stop_replay~
Function stops a replay that is currently executing.
S
  end

  def docs_get_base_dir
    <<-S
*** ~get_base_dir~
Returns the path to the location of the dragonruby binary. In
production mode, this value will be the same as the value returned by
~get_game_dir~. Function should only be used for
debugging/development workflows.
S
  end

  def docs_get_game_dir
    <<-S
*** ~get_game_dir~
Returns the location within sandbox storage that the game is
running. When developing your game, this value will be your ~mygame~
directory. In production, it'll return a value that is OS specific (eg
the Roaming directory on Windows or the Application Support directory
on Mac).

Invocations of ~(write|append)_file will write to this
sandboxed directory.
S
  end

  def docs_get_game_dir_url
    <<-S
*** ~get_game_dir_url~
Returns a url encoded string representing the sandbox location for
game data.
S
  end

  def docs_open_game_dir
    <<-S
*** ~open_game_dir~
Opens the game directory in the OS's file explorer. This should be
used for debugging purposes only.
S
  end

  def docs_write_file_root
    <<-S
*** ~write_file_root~
Given a file path and contents, the contents will be written to a
directory outside of the game directory. This method should be used
for development purposes only. In production this method will write to
the same sandboxed location as ~write_file~.
S
  end

  def docs_append_file_root
    <<-S
*** ~append_file_root~
Has the same behavior as ~write_file_root~ except that it
appends the contents as opposed to overwriting them.
S
  end

  def docs_argv
    <<-S
*** ~argv~
Returns a string representing the command line arguments passed to the
DragonRuby binary. This should be used for development/debugging purposes only.
S
  end

  def docs_cli_arguments
    <<-S
*** ~cli_arguments~
Returns a ~Hash~ for command line arguments in the format of ~--switch value~
(two hyphens preceding the switch flag with the value seperated by a
space). This should be used for development/debugging purposes only.
S
  end


  def docs_download_stb_rb
      <<-S
*** ~download_stb_rb(_raw)~
These two functions can help facilitate the integration of external code files. OSS contributors
are encouraged to create libraries that all fit in one file (lowering the barrier to
entry for adoption).

Examples:

#+begin_src
  def tick args
  end

  # option 1:
  # source code will be downloaded from the specified GitHub url, and saved locally with a
  # predefined folder convension.
  $gtk.download_stb_rb "https://github.com/xenobrain/ruby_vectormath/blob/main/vectormath_2d.rb"

  # option 2:
  # source code will be downloaded from the specified GitHub username, repository, and file.
  # code will be saved locally with a predefined folder convension.
  $gtk.download_stb_rb "xenobrain", "ruby_vectormath", "vectormath_2d.rb"

  # option 3:
  # source code will be downloaded from a direct/raw url and saved to a direct/raw local path.
  $gtk.download_stb_rb_raw "https://raw.githubusercontent.com/xenobrain/ruby_vectormath/main/vectormath_2d.rb",
                           "lib/xenobrain/ruby_vectionmath/vectormath_2d.rb"
#+end_src
S
  end

  def docs_reload_history
    <<-S
*** ~reload_history~
Returns a ~Hash~ representing the code files that have be loaded for
your game along with timings for the events. This should be used for
development/debugging purposes only.
S
  end

  def docs_reload_history_pending
    <<-S
*** ~reload_history_pending~
Returns a ~Hash~ for files that have been queued for reload, but
haven't been processed yet. This should be used for
development/debugging purposes only.
S
  end

  def docs_reload_if_needed
    <<-S
*** ~reload_if_needed~
Given a file name, this function will queue the file for reload if
it's been modified. An optional second parameter can be passed in to
signify if the file should be forced loaded regardless of modified
time (~true~ means to force load, ~false~ means to load only if the
file has been modified). This function should be used for
development/debugging purposes only.
S
  end

  def docs_api_summary_state
    <<-S
* State (~args.state~)
Store your game state inside of this ~state~. Properties with arbitrary nesting is allowed and a backing Entity will be created on your behalf.
#+begin_src
  def tick args
    args.state.player.x ||= 0
    args.state.player.y ||= 0
  end
#+end_src
** ~entity_id~
Entities automatically receive an ~entity_id~ of type ~Fixnum~.
** ~entity_type~
Entities can have an ~entity_type~ which is represented as a ~Symbol~.
** ~created_at~
Entities have ~created_at~ set to ~args.state.tick_count~ when they are created.
** ~created_at_elapsed~
Returns the elapsed number of ticks since creation.
** ~global_created_at~
Entities have ~global_created_at~ set to ~Kernel.global_tick_count~ when they are created.
** ~global_created_at_elapsed~
Returns the elapsed number of global ticks since creation.
** ~as_hash~
Entity cast to a ~Hash~ so you can update values as if you were updating a ~Hash~.
** ~new_entity~
Creates a new Entity with a ~type~, and initial properties. An option block can be passed to change the newly created entity:
#+begin_src ruby
  def tick args
    args.state.player ||= args.state.new_entity :player, x: 0, y: 0 do |e|
      e.max_hp = 100
      e.hp     = e.max_hp * rand
    end
  end
#+end_src
** ~new_entity_strict~
Creates a new Strict Entity. While Entities created via ~args.state.new_entity~ can have new properties added later on, Entities created
using ~args.state.new_entity_strict~ must define all properties that are allowed during its initialization. Attempting to add new properties after
initialization will result in an exception.
** ~args.state.tick_count~
Returns the current tick of the game. ~args.state.tick_count~ is ~0~ when the game is first started or if the game is reset via ~$gtk.reset~.
S
  end

  def docs_add_caller_to_puts!
    <<-S
*** ~add_caller_to_puts!~
If you need to hund down rogue ~puts~ statements in your code do:
#+begin_src
  def tick args
    # adding the following line to the TOP of your tick method
    # will print ~caller~ along side each ~puts~ statement
    $gtk.add_caller_to_puts!
  end
#+end_src
S
  end

  def docs_production?
    <<-S
*** ~production?~
Returns true if the game is being run in a released/shipped state.

If you want to simulate a production build. Add an empty file called ~dragonruby_production_build~
inside of the ~metadata~ folder. This will turn of all logging and all creation of temp files used
for development purposes.
S
  end

  def docs_platform?
    <<-S
*** ~platform?~
You can ask DragonRuby which platform your game is currently being run on. This can be
useful if you want to perform different pieces of logic based on where the game is running.

The raw platform string value is available via ~args.gtk.platform~ which takes in a ~symbol~
representing the platform's categorization/mapping.

You can see all available platform categorizations via the ~args.gtk.platform_mappings~ function.

Here's an example of how to use ~args.gtk.platform? category_symbol~:
#+begin_src ruby
  def tick args
    label_style = { x: 640, y: 360, anchor_x: 0.5, anchor_y: 0.5 }
    if    args.gtk.platform? :macos
      args.outputs.labels << { text: "I am running on MacOS.", **label_style }
    elsif args.gtk.platform? :win
      args.outputs.labels << { text: "I am running on Windows.", **label_style }
    elsif args.gtk.platform? :linux
      args.outputs.labels << { text: "I am running on Linux.", **label_style }
    elsif args.gtk.platform? :web
      args.outputs.labels << { text: "I am running on a web page.", **label_style }
    elsif args.gtk.platform? :android
      args.outputs.labels << { text: "I am running on Android.", **label_style }
    elsif args.gtk.platform? :ios
      args.outputs.labels << { text: "I am running on iOS.", **label_style }
    elsif args.gtk.platform? :touch
      args.outputs.labels << { text: "I am running on a device that supports touch (either iOS/Android native or mobile web).", **label_style }
    elsif args.gtk.platform? :steam
      args.outputs.labels << { text: "I am running via steam (covers both desktop and steamdeck).", **label_style }
    elsif args.gtk.platform? :steam_deck
      args.outputs.labels << { text: "I am running via steam on the Steam Deck (not steam desktop).", **label_style }
    elsif args.gtk.platform? :steam_desktop
      args.outputs.labels << { text: "I am running via steam on desktop (not steam deck).", **label_style }
    end
  end
#+end_src
S
  end

  def docs_platform_mappings
    <<-S
*** ~platform_mappings~
These are the current platform categorizations (~args.gtk.platform_mappings~):
#+begin_src ruby
  {
    "Mac OS X"   => [:desktop, :macos, :osx, :mac, :macosx], # may also include :steam and :steam_desktop run via steam
    "Windows"    => [:desktop, :windows, :win],              # may also include :steam and :steam_desktop run via steam
    "Linux"      => [:desktop, :linux, :nix],                # may also include :steam and :steam_desktop run via steam
    "Emscripten" => [:web, :wasm, :html, :emscripten],       # may also include :touch if running in the web browser on mobile
    "iOS"        => [:mobile, :ios, :touch],
    "Android"    => [:mobile, :android, :touch],
    "Steam Deck" => [:steamdeck, :steam_deck, :steam],
  }
#+end_src

Given the mappings above, ~args.gtk.platform? :desktop~ would return ~true~ if the game is running
on a player's computer irrespective of OS (MacOS, Linux, and Windows are all categorized
as ~:desktop~ platforms).
S
  end


  def docs_stat_file
    <<-S
*** ~stat_file~
This function takes in one parameter. The parameter is the file path and assumes the the game
directory is the root. The method returns ~nil~ if the file doesn't exist otherwise it returns
a ~Hash~ with the following information:

#+begin_src ruby
  # {
  #   path: String,
  #   file_size: Int,
  #   mod_time: Int,
  #   create_time: Int,
  #   access_time: Int,
  #   readonly: Boolean,
  #   file_type: Symbol (:regular, :directory, :symlink, :other),
  # }

  def tick args
    if args.inputs.mouse.click
      args.gtk.write_file "last-mouse-click.txt", "Mouse was clicked at \#{args.state.tick_count}."
    end

    file_info = args.gtk.stat_file "last-mouse-click.txt"

    if file_info
      args.outputs.labels << {
        x: 30,
        y: 30.from_top,
        text: file_info.to_s,
        size_enum: -3
      }
    else
      args.outputs.labels << {
        x: 30,
        y: 30.from_top,
        text: "file does not exist, click to create file",
        size_enum: -3
      }
    end
  end
#+end_src
S
  end

  def docs_file_access_functions
    <<-S
** File IO Functions
The following functions give you the ability to interact with the file system.

IMPORTANT: File access functions are sandoxed and assume that the
~dragonruby~ binary lives alongside the game you are building. Do not
expect these functions to return correct values if you are attempting
to run the ~dragonruby~ binary from a shared location. It's
recommended that the directory structure contained in the zip is not
altered and games are built using that starter template.
S
  end

  def docs_list_files
    <<-S
*** ~list_files~
This function takes in one parameter. The parameter is the directory path and assumes the the game
directory is the root. The method returns an ~Array~ of ~String~ representing all files
within the directory. Use ~stat_file~ to determine whether a specific path is a file
or a directory.
S
  end

  def docs_write_file
    <<-S
*** ~write_file~
This function takes in two parameters. The first parameter is the file path and assumes the the game
directory is the root. The second parameter is the string that will be written. The method **overwrites**
whatever is currently in the file. Use ~append_file~ to append to the file as opposed to overwriting.

#+begin_src ruby
  def tick args
    if args.inputs.mouse.click
      args.gtk.write_file "last-mouse-click.txt", "Mouse was clicked at \#{args.state.tick_count}."
    end
  end
#+end_src
S
  end

  def docs_append_file
    <<-S
*** ~append_file~
This function takes in two parameters. The first parameter is the file path and assumes the the game
directory is the root. The second parameter is the string that will be written. The method appends to
whatever is currently in the file (a new file is created if one does not alread exist). Use
~write_file~ to overwrite the file's contents as opposed to appending.

#+begin_src ruby
  def tick args
    if args.inputs.mouse.click
      args.gtk.write_file "last-mouse-click.txt", "Mouse was clicked at \#{args.state.tick_count}."
    end
  end
#+end_src
S
  end

  def docs_delete_file
    <<-S
*** ~delete_file~
This function takes in a single parameters. The parameter is the file path that should be deleted. This
function will raise an exception if the path requesting to be deleted does not exist.

Notes:

- Use ~delete_if_exist~ to only delete the file if it exists.
- Use ~stat_file~ to determine if a path exists.
- Use ~list_files~ to determine if a directory is empty.
- You cannot delete files outside of your sandboxed game environment.

Here is a list of reasons an exception could be raised:

  - If the path is not found.
  - If the path is still open (for reading or writing).
  - If the path is not a file or directory.
  - If the path is a circular symlink.
  - If you do not have permissions to delete the path.
  - If the directory attempting to be deleted is not empty.

#+begin_src ruby
  def tick args
    if args.inputs.mouse.click
      args.gtk.write_file "last-mouse-click.txt", "Mouse was clicked at \#{args.state.tick_count}."
    end
  end
#+end_src
S
  end

  def docs_benchmark
<<-S
*** ~benchmark~
You can use this function to compare the relative performance of blocks of code.

#+begin_src ruby
  def tick args
    # press r to run benchmark
    if args.inputs.keyboard.key_down.r
      args.gtk.console.show
      args.gtk.benchmark iterations: 1000, # number of iterations
                         # label for experiment
                         using_numeric_map: -> () {
                           # experiment body
                           v = 100.map_with_index do |i|
                             i * 100
                           end
                         },
                         # label for experiment
                         using_numeric_times: -> () {
                           # experiment body
                           v = []
                           100.times do |i|
                             v << i * 100
                           end
                         }
    end
  end
#+end_src
S
  end
end

class GTK::Runtime
  extend Docs
  extend RuntimeDocs
end
