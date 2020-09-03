Supercollider for Python developers
***********************************

.. role:: sc(code)
    :language: Supercollider

.. role:: py(code)
    :language: Python

Getting started
===============

Ever wanted to program sounds and use your skills as a developer to express yourself through sound?
This tutorial aims to show you how to translate your already learned skills in Python to Supercollider, a realtime programming language for sounds and beyond.
You can use this language to generate new sounds or modify existing sounds as an effect or replace it as your everyday programming language.


Setup
-----

For how to install and setup Supercollider please refer to the `official website <https://supercollider.github.io>`_.
We assume you have started Supercollider.

Hello World
-----------

Like every introduction into a new programming language we shall start with *Hello World*

.. code-block:: Supercollider

    "Hello World".postln;

You can run this line of code by pressing `<Shfit> + Enter` while the cursor is in the same row as the code.
The *Post window* will look something like this

.. code-block::

    Hello World
    -> Hello World

This snippet already tells us a bit of philosophy of Supercollider which in some points differs from Python:

- Supercollider is an `interpreted language <https://en.wikipedia.org/wiki/Interpreted_language>`_ which means that we do not need to compile our code before we run it - so much like Python.
  This is really helpful for experimentation for learning the language, creative coding and changing code that is already running.
  It is also a `dynamically typed language <https://en.wikipedia.org/wiki/Dynamically_typed>`_ which means you do not have to annotate (data)-types to what you are coding - so also like Python but different to e.g. Java.

- Instead of :py:`print("Hello World")` where we apply the function :py:`print` on the string :py:`Hello World` we call the method :sc:`postln` of the string :sc:`Hello World`.
  This will lead to some confusion if you are coming from Python but actually serves the purpose of function chaining.
  The reaseon why you see `Hello World` two times is because we printed `Hello World` to the console and the method `println` also returns the string with which it was called.
  Eeverything that is returned by a function is printed to the console when called, much like :py:`4+6` in Python which will also return `10`.
  So if we would wanted to write a more `code-golfed <https://en.wikipedia.org/wiki/Code_golf>`_ approach to a Hello World in Supercollider the following would also print *Hello World* into our console by executing

  .. code-block:: supercollider
    
    "Hello World"

But printing *Hello World* would not convince me to learn a new language so we will start to take a look at where Supercollider shines: expressing sonic ideas.

Hello Sound
-----------

Before we start generating sounds one should know how to stop sounds.
You can always stop any audio in Supercollider by pressing ``<Comand> + .`` or ``<Alt> + .`` - **remember this** as you will come to the point where you messed up some audio levels and need to pull the plug.
Also please check your levels before you proceed.

Before we can start generating any sounds we need to start the server which will act as a sound engine for us but more on this later.
To start the server simply execute the following line.

.. code-block:: sc

    s.boot;

As with *Hello World*, execute the line of code by pressing ``<Ctrl> + Enter`` while the cursor is in the same line as your code.

Now we can start generating sounds by executing

.. code-block:: sc

    {SinOsc.ar}.play;


You should hear a sine wave with constant pitch from your left speaker.
As discussed before we can stop this sound by pressing ``<Comand> + .`` or ``<Alt> + .``.

Lets dissect the line above to understand what happens.

- `SinOsc <https://doc.sccode.org/Classes/SinOsc.html>`_ is a class which implements a `sine <https://en.wikipedia.org/wiki/Sine_wave>`_ oscillator which will generate us a signal.
  So what exactly is this :sc:`.ar` method of SinOsc?
  *ar* stands for *Audio Rate* which means that we want to have a Sine Oscillator which is so exact that it can produce audible signals.
  There is also the option of *kr* which stands for *Control Rate* which we can use for signals which are non audible, but control e.g. the frequency of our SinOsc which is running at *audio rate*.
  One thing that is not obvious here for Python developers: `ar` is actually a method which is called - that is right, most of the time we can omit the function call ``()`` (which is available but often not necessary) in Supercollider.
  For now, `SinOsc.ar()` and `SinOsc.ar` are the same, although Supercollider also supports `first class functions <https://en.wikipedia.org/wiki/First-class_function>`_ like Python which provides the abillitly to write `functional code <https://en.wikipedia.org/wiki/Functional_programming>`_.
  But more on this later.

- :sc:`{ }` is actually encapsulating :sc:`SinOsc.ar` into a function, so what we are basically doing here in Python terms:
  
  .. code-block:: Python

    def sine():
     return SinOsc().ar()
  
    sine().play()

  One could ask why we need to need the cumberstone of creating an `anonymous function <https://en.wikipedia.org/wiki/Anonymous_function>`_  will be called when one could call :sc:`SinOsc.ar.play` directly.
  This will lead us to the basic architecture of Supercollider.

Server vs. Client
-----------------

Remember when we first executed :sc:`s.boot` to boot the server?


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

