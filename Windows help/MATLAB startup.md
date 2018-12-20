To issue command at MATLAB startup, first set userpath, e.g.

```
userpath('/home/dcui/');
```

At this `userpath`, create a `.m` file named `startup.m`

Put down as many command needed in this script.

The `userpath` will be stored in MATLAB's `prefdir`(type in `prefdir` in the command window without the quote to find out where the preference files are saved), in a file `matlab.settings`. Look under:

```
<key name="UserPath">
```

To change the `userpath` variable, either reset the `userpath` in the command window, or directly edit this file.
