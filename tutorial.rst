Supercollider for Python developers
***********************************

.. role:: sc(code)
    :language: Supercollider

.. role:: py(code)
    :language: Python

Getting started
===============

Did you ever wanted to program sounds and use your skills as a developer to express yourself through sound?
This tutorial aims to show you how to translate your already learned skills in Python to Supercollider, a realtime programming language for sounds and beyond.
You can use this language to generate new sounds, modify existing sounds or replace it as your everyday programming language.


Setup
-----

For how to install and setup Supercollider please refer to the `official website <https://supercollider.github.io>`_.
For now, we assume you have started Supercollider.

Hello World
-----------

Like every introduction into a new programming language we shall start with *Hello World*

.. code-block:: Supercollider

    "Hello World".postln;

You can run this line of code by pressing `<Shfit> + Enter` while the cursor is in the same row as the code.
The *Post window* should look like this

.. code-block::

    Hello World
    -> Hello World

This snippet already tells us a bit of the philosophy behind Supercollider which in some points differs from Python but also has simmilarities:

- Supercollider is an `interpreted language <https://en.wikipedia.org/wiki/Interpreted_language>`_ which means that we do not need to compile our code before we execute it - so much like Python.
  This is really helpful for experimentation, creative coding and changing code that is already running.
  It is also a `dynamically typed language <https://en.wikipedia.org/wiki/Dynamically_typed>`_ which means you do not have to annotate (data)-types - so also like Python but different to e.g. Java.

- Instead of :py:`print("Hello World")` where we apply the function :py:`print` on the string :py:`"Hello World"` we call the method :sc:`postln` of the string :sc:`"Hello World"`.
  This will lead to some confusion if you are coming from Python but it actually serves the purpose of `method chaining <https://en.wikipedia.org/wiki/Method_chaining>`_.
  The reaseon why you see `Hello World` two times is because we printed `Hello World` to the console and the method `println` also returns the string with which it was called.
  Everything that is returned by a function is printed to the console when called, much like :py:`4+6` in Python would also print `10` when executed in a `REPL <https://en.wikipedia.org/wiki/Read%E2%80%93eval%E2%80%93print_loop>`_ without any variable assignement.
  So if we would wanted to write a more `code-golfed <https://en.wikipedia.org/wiki/Code_golf>`_ approach to *Hello World* in Supercollider we could also archieve this by executing

  .. code-block:: supercollider
    
    "Hello World"

But printing *Hello World* would not convince me to learn a new language so we will start to take a look at where Supercollider shines: generating audio signal in realtime.

Hello Sound
-----------

Before we start generating sounds one should know how to stop sounds.
You can always stop any audio in Supercollider by pressing ``<Comand> + .`` or ``<Alt> + .`` - **remember this** as you will come to the point where you need to pull the plug while experimenting with sonic signals.
Also please check your levels of your audio hardware before you proceed.
I would not recommend using headphones because they can damage your hearing if the volume exceeds caused by an error in the code.

Before we can start generating any sounds we need to start the server which will act as a sound engine for us but more on this later.
To start the server simply execute the following line.

.. code-block:: sc

    s.boot;

As with *Hello World*, execute the line of code by pressing ``<Command> + Enter`` while the cursor is in the same line as your code.

Now we can start generating sounds by executing

.. code-block:: sc

    {SinOsc.ar}.play;


You should hear a sine wave with constant pitch from your left speaker.
As discussed before we can stop this sound by pressing ``<Comand> + .`` or ``<Alt> + .``.

Lets dissect the line above to understand what happens.

- `SinOsc <https://doc.sccode.org/Classes/SinOsc.html>`_ is a Supercollider class which implements a `sine wave <https://en.wikipedia.org/wiki/Sine_wave>`_ oscillator.
  So what exactly is this :sc:`.ar` method of SinOsc?
  *ar* stands for *Audio Rate* which means that we want to have a sine oscillator which is so exact that it can produce audible signals.
  There is also the option of *kr* which stands for *Control Rate* which we can use for signals which are non audible, but control e.g. the frequency of our SinOsc which is running at *audio rate*.
  The distinction in granularity is done because of resource optimisation.
  One thing that is not obvious here for Python developers: `ar` is actually a method which is called - most of the time we can omit the function call ``()`` (which is available but often not necessary) in Supercollider.
  For now, `SinOsc.ar()` and `SinOsc.ar` are the same, although Supercollider also supports `first class functions <https://en.wikipedia.org/wiki/First-class_function>`_ like Python which provides the abillitly to write `functional code <https://en.wikipedia.org/wiki/Functional_programming>`_.
  But more on this later.

- :sc:`{ }` is actually encapsulating :sc:`SinOsc.ar` into a function.
  Translated in the Python world the code snippet above would result in this Python code:
  
  .. code-block:: Python

    def sine():
     return SinOsc().ar()
  
    sine().play()

  One could ask why we need to need the cumberstone of creating and calling an `anonymous function <https://en.wikipedia.org/wiki/Anonymous_function>`_  when one could call :sc:`SinOsc.ar.play` directly.
  This will lead us to the basic architecture of Supercollider.

Server vs. Client
-----------------

Remember when we first executed :sc:`s.boot` to boot the server?
The server is actually generating the sound for us and we send a message from our client (the Supercollider IDE) to the server which will then send the audio signal to the soundcard.
Lets visualise what is happening.

.. code-block:: plantuml

  Client -> Server: s.boot
  ...start server...
  Client -> Server: {SinOsc.ar}.play
  Server -> Soundcard: Sine Wave
  ...plays sound...
  Client -> Server: <Cmd> + .
  Server -> Soundcard: Stop Playback
  ...stop sound...

This circumstance will also explain why we created an anonymous function.
To know what the server has to output to the soundcard we transfer a function to the server which will return an audio signal.
The :sc:`play` method does a bit of magic: It transfers the the function to the server and tells the server to playback the function.

But the problem of an anonymous function is that we can not modify it - but we may want to modify the frequency, level or any other parameter of our sound so how do we fix this problem?

SynthDef
--------

Instead of sending anonymous functions to the server we can register functions which generate sounds on the server.
In Supercollider this is called a `SynthDef <https://doc.sccode.org/Classes/SynthDef.html>`_.
Lets write such a *Synth Def* for our example above.

.. code-block:: supercollider

  SynthDef(\sineWave, {SinOsc.ar;}).add;

Execute the lines above by pressing `<Command / Alt> + Enter` while the cursor is in the line of the statement.

- SynthDef registers a sound generating function under a name at the server.
  The first argument of the SynthDef is the name and shows that a string does not need to be encapsulated by :sc:`"` but can be also indicated with a prepended ``\``.
  The second argument is a signal generating function, in our case `SinOsc` at audio rate.

- After initiating the SynthDef we want to register the function at the server which we will do by executing the method :sc:`add`.
  We also indicate the end of the statement with a :sc:`;`.

We registered the function with name `sineWave` on the server, but how do we start generating sounds?

.. code-block:: supercollider

  x = Synth(\sineWave);

Once we execute this we will immediately hear a sound.
With *Synth* we can refer to a registered function at the server to invoke the server to play the signal of said function.

Because we now have a reference to the playback of said function we can also terminate the sound in a programmatic way:

.. code-block:: supercollider

  x.free;

To put it into perspective

.. code-block:: plantuml

  Client -> Server: SynthDef(\sineWave, {Out.ar(SinOsc.ar}).add;
  Server -> RegisteredFunctions: Stores sineWave function
  ...Register sine signal generating function under name "sineWave" at server...
  Client -> Server: x = Synth(\sineWave)
  ...Send invokation of sineWave function to server...
  Server -> RegisteredFunctions: looks for function "sineWave"
  RegisteredFunctions -> Server: Returns registered signal generating function
  Server -> PlaybackFunctions: Plays back signal from function "sineWave" and stores instance
  PlaybackFunctions -> Client: Returns reference to played instance of "sineWave" on server
  ...Playback sineWave on server...
  Client -> PlaybackFunctions: x.free
  ...Stops playback of sineWave on server from client...


It is important to understand that we send Supercollider code in form of functions to the server.
The server will evaluate those functions and transpile it to C++ code via so called `UGens <https://doc.sccode.org/Classes/UGen.html>`_ which stands for Unit Generator.
If you do something in a function which can not be translated to a UGen the server will not accept it.

This all is maybe a bit theoretical but will help us understand why Supercollider sometimes acts different than Python and how you have to code.


..

  -> Variables
  -> Scope
  -> Threads
  -> Plot
  -> GUI

Programming in Supercollider
----------------------------

Variables
^^^^^^^^^


Server vs. Client - Part 2
--------------------------

The NodeTree
------------

Bubbles
-------

As you dig deeper into Supercollider you will find that the actual *Hello World* of Supercollider is *Bubbles* (see e.g. Examples from `here <https://doc.sccode.org/Classes/DiskOut.html>`_).

.. code-block:: supercollider

    SynthDef("bubbles", { |out|
        var f, zout;
        f = LFSaw.kr(0.4, 0, 24, LFSaw.kr([8,7.23], 0, 3, 80)).midicps; // glissando function
        zout = CombN.ar(SinOsc.ar(f, 0, 0.04), 0.2, 0.2, 4); // echoing sine wave
        Out.ar(out, zout)
    }).add;

Some Supercollider Magic
------------------------

SinOsc.ar([440, 442])


Quarks
------


Under the Hood
--------------

Remember when I told you that the programming language is called Supercollider?
Actually Supercollider is more like a framework which includes a programming language called *sclang*.


What else?
----------


About me
--------

